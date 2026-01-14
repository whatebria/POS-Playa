sealed class UiEvent {
  const UiEvent();
}

enum SnackType { success, error, info }

class ShowSnack extends UiEvent {
  final String message;
  final SnackType type;
  const ShowSnack(this.message, this.type);
}

class ShowDialogEvent extends UiEvent {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  const ShowDialogEvent({
    required this.title,
    required this.message,
    this.confirmText = 'Confirmar',
    this.cancelText = 'Cancelar',
  });
}

class Navigate extends UiEvent {
  final String route;
  const Navigate(this.route);
}
