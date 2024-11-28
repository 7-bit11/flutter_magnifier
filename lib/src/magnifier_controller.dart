import 'package:flutter/widgets.dart';

class CustomMagnifierController extends ChangeNotifier {
  CustomMagnifierController();

  ValueNotifier<Offset>? offset = ValueNotifier(Offset.zero);

  /// update pointer move event
  void updatePointerMoveEvent(
      PointerMoveEvent event, double maxHeight, double maxWidth) {
    final offsetData = event.localPosition;
    var dy = offsetData.dy > maxHeight ? maxHeight : offsetData.dy;
    var dx = offsetData.dx > maxWidth ? maxWidth : offsetData.dx;
    dy = dy < 0 ? 0 : dy;
    dx = dx < 0 ? 0 : dx;
    offset?.value = Offset(dx, dy);
    notifyListeners();
  }
}
