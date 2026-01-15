import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AppDatabase {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

static Future<Database> _initDB() async {
  final dbPath = await getDatabasesPath();
  final path = join(dbPath, 'caja.db');

  final db = await openDatabase(
    path,
    version: 1,
    onConfigure: _onConfigure,
    onCreate: _onCreate,
    onOpen: _onOpen,
  );

  return db;
}


  /// PRAGMAS van acá
static Future<void> _onConfigure(Database db) async {
  await db.execute('PRAGMA foreign_keys = ON;');

  // Estos DEVUELVEN RESULTADOS → rawQuery
  await db.rawQuery('PRAGMA journal_mode = WAL;');
  await db.rawQuery('PRAGMA synchronous = NORMAL;');
}

static Future<void> _onOpen(Database db) async {
  await _seedProducts(db);
  await _seedExpenseCategories(db);
  await _seedWithdrawalReasons(db);
}

  static Future<void> _onCreate(Database db, int version) async {

    // =====================================================
    // 1. USERS
    // =====================================================
    await db.execute('''
    CREATE TABLE users (
      id TEXT PRIMARY KEY,
      name TEXT NOT NULL,
      role TEXT NOT NULL CHECK (role IN ('CASHIER','ADMIN')),
      active INTEGER NOT NULL DEFAULT 1 CHECK (active IN (0,1)),
      created_at TEXT NOT NULL DEFAULT (datetime('now'))
    );
    ''');
    await db.execute('''
    INSERT INTO users (id, name, role, active)
    VALUES ('USER_DEMO', 'Usuario demo', 'ADMIN', 1);
    ''');

    // =====================================================
    // 2. CATALOGS
    // =====================================================
    await db.execute('''
    CREATE TABLE products (
      id TEXT PRIMARY KEY,
      name TEXT NOT NULL UNIQUE,
      price INTEGER NOT NULL CHECK (price >= 0),
      active INTEGER NOT NULL DEFAULT 1 CHECK (active IN (0,1)),
      sort_order INTEGER NOT NULL DEFAULT 0
    );
    ''');

    await db.execute('''
    CREATE TABLE expense_categories (
      id TEXT PRIMARY KEY,
      name TEXT NOT NULL UNIQUE,
      active INTEGER NOT NULL DEFAULT 1 CHECK (active IN (0,1)),
      sensitive INTEGER NOT NULL DEFAULT 0 CHECK (sensitive IN (0,1))
    );
    ''');

    await db.execute('''
    CREATE TABLE withdrawal_reasons (
      id TEXT PRIMARY KEY,
      name TEXT NOT NULL UNIQUE,
      active INTEGER NOT NULL DEFAULT 1 CHECK (active IN (0,1))
    );
    ''');

    // =====================================================
    // 3. DAILY OPENINGS
    // =====================================================
    await db.execute('''
    CREATE TABLE daily_openings (
      business_day TEXT PRIMARY KEY,
      opening_cash INTEGER NOT NULL CHECK (opening_cash >= 0),
      opened_by_user_id TEXT NOT NULL,
      opened_at TEXT NOT NULL DEFAULT (datetime('now')),
      note TEXT,
      FOREIGN KEY (opened_by_user_id) REFERENCES users(id)
    );
    ''');

    // =====================================================
    // 4. DAILY CLOSURES
    // =====================================================
    await db.execute('''
    CREATE TABLE daily_closures (
      business_day TEXT PRIMARY KEY,

      opening_cash INTEGER NOT NULL,

      sales_cash INTEGER NOT NULL,
      sales_transfer INTEGER NOT NULL,

      expenses_cash INTEGER NOT NULL,
      expenses_transfer INTEGER NOT NULL,

      withdrawals_cash INTEGER NOT NULL,
      withdrawals_transfer INTEGER NOT NULL,

      cash_expected INTEGER NOT NULL,
      cash_counted INTEGER NOT NULL,
      difference INTEGER NOT NULL,

      closed_by_user_id TEXT NOT NULL,
      closed_at TEXT NOT NULL DEFAULT (datetime('now')),

      FOREIGN KEY (closed_by_user_id) REFERENCES users(id)
    );
    ''');

    // =====================================================
    // 5. SALES
    // =====================================================
    await db.execute('''
    CREATE TABLE sales (
      id TEXT PRIMARY KEY,
      business_day TEXT NOT NULL,
      payment_method TEXT NOT NULL CHECK (payment_method IN ('CASH','TRANSFER')),
      total INTEGER NOT NULL CHECK (total >= 0),
      created_at TEXT NOT NULL DEFAULT (datetime('now')),
      created_by_user_id TEXT NOT NULL,
      FOREIGN KEY (created_by_user_id) REFERENCES users(id)
    );
    ''');

    await db.execute('''
    CREATE TABLE sale_items (
      id TEXT PRIMARY KEY,
      sale_id TEXT NOT NULL,
      product_id TEXT NOT NULL,
      quantity INTEGER NOT NULL CHECK (quantity > 0),
      unit_price INTEGER NOT NULL CHECK (unit_price >= 0),
      subtotal INTEGER NOT NULL CHECK (subtotal = quantity * unit_price),
      FOREIGN KEY (sale_id) REFERENCES sales(id) ON DELETE CASCADE,
      FOREIGN KEY (product_id) REFERENCES products(id)
    );
    ''');

    // =====================================================
    // 6. EXPENSES
    // =====================================================
    await db.execute('''
    CREATE TABLE expenses (
      id TEXT PRIMARY KEY,
      business_day TEXT NOT NULL,
      category_id TEXT NOT NULL,
      amount INTEGER NOT NULL CHECK (amount > 0),
      payment_method TEXT NOT NULL CHECK (payment_method IN ('CASH','TRANSFER')),
      note TEXT,
      created_at TEXT NOT NULL DEFAULT (datetime('now')),
      created_by_user_id TEXT NOT NULL,
      FOREIGN KEY (category_id) REFERENCES expense_categories(id),
      FOREIGN KEY (created_by_user_id) REFERENCES users(id)
    );
    ''');

    // =====================================================
    // 7. WITHDRAWALS
    // =====================================================
    await db.execute('''
    CREATE TABLE withdrawals (
      id TEXT PRIMARY KEY,
      business_day TEXT NOT NULL,
      reason_id TEXT NOT NULL,
      amount INTEGER NOT NULL CHECK (amount > 0),
      payment_method TEXT NOT NULL CHECK (payment_method IN ('CASH','TRANSFER')),
      note TEXT,
      created_at TEXT NOT NULL DEFAULT (datetime('now')),
      created_by_user_id TEXT NOT NULL,
      FOREIGN KEY (reason_id) REFERENCES withdrawal_reasons(id),
      FOREIGN KEY (created_by_user_id) REFERENCES users(id)
    );
    ''');

    // =====================================================
    // 8. TRIGGERS
    // =====================================================
    await db.execute('''
    CREATE TRIGGER trg_require_opening_sales
    BEFORE INSERT ON sales
    BEGIN
      SELECT CASE
        WHEN NOT EXISTS (
          SELECT 1 FROM daily_openings WHERE business_day = NEW.business_day
        )
        THEN RAISE(ABORT, 'Debe abrir caja antes de operar')
      END;
    END;
    ''');

    await db.execute('''
    CREATE TRIGGER trg_require_opening_expenses
    BEFORE INSERT ON expenses
    BEGIN
      SELECT CASE
        WHEN NOT EXISTS (
          SELECT 1 FROM daily_openings WHERE business_day = NEW.business_day
        )
        THEN RAISE(ABORT, 'Debe abrir caja antes de operar')
      END;
    END;
    ''');

    await db.execute('''
    CREATE TRIGGER trg_require_opening_withdrawals
    BEFORE INSERT ON withdrawals
    BEGIN
      SELECT CASE
        WHEN NOT EXISTS (
          SELECT 1 FROM daily_openings WHERE business_day = NEW.business_day
        )
        THEN RAISE(ABORT, 'Debe abrir caja antes de operar')
      END;
    END;
    ''');

    await db.execute('''
    CREATE TRIGGER trg_block_if_closed_sales
    BEFORE INSERT ON sales
    BEGIN
      SELECT CASE
        WHEN EXISTS (
          SELECT 1 FROM daily_closures WHERE business_day = NEW.business_day
        )
        THEN RAISE(ABORT, 'Día cerrado')
      END;
    END;
    ''');

    await db.execute('''
    CREATE TRIGGER trg_block_if_closed_expenses
    BEFORE INSERT ON expenses
    BEGIN
      SELECT CASE
        WHEN EXISTS (
          SELECT 1 FROM daily_closures WHERE business_day = NEW.business_day
        )
        THEN RAISE(ABORT, 'Día cerrado')
      END;
    END;
    ''');

    await db.execute('''
    CREATE TRIGGER trg_block_if_closed_withdrawals
    BEFORE INSERT ON withdrawals
    BEGIN
      SELECT CASE
        WHEN EXISTS (
          SELECT 1 FROM daily_closures WHERE business_day = NEW.business_day
        )
        THEN RAISE(ABORT, 'Día cerrado')
      END;
    END;
    ''');

    // =====================================================
    // 9. VIEWS
    // =====================================================
    await db.execute('''
    CREATE VIEW v_sales_totals AS
    SELECT
      business_day,
      SUM(CASE WHEN payment_method = 'CASH' THEN total ELSE 0 END) AS sales_cash,
      SUM(CASE WHEN payment_method = 'TRANSFER' THEN total ELSE 0 END) AS sales_transfer
    FROM sales
    GROUP BY business_day;
    ''');

    await db.execute('''
    CREATE VIEW v_expenses_totals AS
    SELECT
      business_day,
      SUM(CASE WHEN payment_method = 'CASH' THEN amount ELSE 0 END) AS expenses_cash,
      SUM(CASE WHEN payment_method = 'TRANSFER' THEN amount ELSE 0 END) AS expenses_transfer
    FROM expenses
    GROUP BY business_day;
    ''');

    await db.execute('''
    CREATE VIEW v_withdrawals_totals AS
    SELECT
      business_day,
      SUM(CASE WHEN payment_method = 'CASH' THEN amount ELSE 0 END) AS withdrawals_cash,
      SUM(CASE WHEN payment_method = 'TRANSFER' THEN amount ELSE 0 END) AS withdrawals_transfer
    FROM withdrawals
    GROUP BY business_day;
    ''');

    await db.execute('''
    CREATE VIEW v_daily_summary AS
    SELECT
      o.business_day,
      o.opening_cash,

      COALESCE(s.sales_cash,0) AS sales_cash,
      COALESCE(s.sales_transfer,0) AS sales_transfer,

      COALESCE(e.expenses_cash,0) AS expenses_cash,
      COALESCE(e.expenses_transfer,0) AS expenses_transfer,

      COALESCE(w.withdrawals_cash,0) AS withdrawals_cash,
      COALESCE(w.withdrawals_transfer,0) AS withdrawals_transfer,

      (
        o.opening_cash
        + COALESCE(s.sales_cash,0)
        - COALESCE(e.expenses_cash,0)
        - COALESCE(w.withdrawals_cash,0)
      ) AS cash_expected

    FROM daily_openings o
    LEFT JOIN v_sales_totals s ON s.business_day = o.business_day
    LEFT JOIN v_expenses_totals e ON e.business_day = o.business_day
    LEFT JOIN v_withdrawals_totals w ON w.business_day = o.business_day;
    ''');

    await _seedProducts(db);
    await _seedExpenseCategories(db);
    await _seedWithdrawalReasons(db);
  }

  static Future<void> _seedProducts(Database db) async {
    final result = await db.rawQuery('SELECT COUNT(*) AS count FROM products');
    final count = Sqflite.firstIntValue(result) ?? 0;
    if (count > 0) return;

    await db.insert(
      'products',
      {
        'id': 'PROD_001',
        'name': 'Roscas',
        'price': 1500,
        'active': 1,
        'sort_order': 1,
      },
    );
    await db.insert(
      'products',
      {
        'id': 'PROD_002',
        'name': 'Pizza',
        'price': 2000,
        'active': 1,
        'sort_order': 2,
      },
    );
    await db.insert(
      'products',
      {
        'id': 'PROD_003',
        'name': 'Pan',
        'price': 300,
        'active': 1,
        'sort_order': 3,
      },
    );
  }

  static Future<void> _seedExpenseCategories(Database db) async {
    final result =
        await db.rawQuery('SELECT COUNT(*) AS count FROM expense_categories');
    final count = Sqflite.firstIntValue(result) ?? 0;
    if (count > 0) return;

    const categories = [
      {'id': 'EXP_001', 'name': 'Insumos', 'sensitive': 0},
      {'id': 'EXP_002', 'name': 'Servicios', 'sensitive': 0},
      {'id': 'EXP_003', 'name': 'Transporte', 'sensitive': 0},
      {'id': 'EXP_004', 'name': 'Mantenimiento', 'sensitive': 0},
      {'id': 'EXP_005', 'name': 'Varios', 'sensitive': 0},
    ];

    for (final c in categories) {
      await db.insert(
        'expense_categories',
        {
          'id': c['id'],
          'name': c['name'],
          'active': 1,
          'sensitive': c['sensitive'],
        },
      );
    }
  }

  static Future<void> _seedWithdrawalReasons(Database db) async {
    final result =
        await db.rawQuery('SELECT COUNT(*) AS count FROM withdrawal_reasons');
    final count = Sqflite.firstIntValue(result) ?? 0;
    if (count > 0) return;

    const reasons = [
      {'id': 'WDR_001', 'name': 'Deposito'},
      {'id': 'WDR_002', 'name': 'Pago proveedores'},
      {'id': 'WDR_003', 'name': 'Caja chica'},
      {'id': 'WDR_004', 'name': 'Reparto'},
      {'id': 'WDR_005', 'name': 'Varios'},
    ];

    for (final r in reasons) {
      await db.insert(
        'withdrawal_reasons',
        {
          'id': r['id'],
          'name': r['name'],
          'active': 1,
        },
      );
    }
  }
}
