import 'package:flutter/widgets.dart';

class CustomMagnifierController extends ChangeNotifier {
  CustomMagnifierController();

  ValueNotifier<Offset> offset = ValueNotifier(Offset.zero);

  /// update pointer move event
  void updatePointerMoveEvent(
      PointerMoveEvent event, double maxHeight, double maxWidth) {
    final offsetData = event.localPosition;
    var dy = offsetData.dy > maxHeight ? maxHeight : offsetData.dy;
    var dx = offsetData.dx > maxWidth ? maxWidth : offsetData.dx;
    dy = dy < 0 ? 0 : dy;
    dx = dx < 0 ? 0 : dx;
    offset.value = Offset(dx, dy);
    notifyListeners();
  }

  /// update magnifier offset
  Offset updateMagnifierOffset(double dx, double dy, Size magnifierSize) {
    var dxOffset = dx - magnifierSize.width;
    var dyOffset = dy - magnifierSize.height;
    dyOffset = dyOffset < 0 ? 0 : dyOffset;
    dxOffset = dxOffset < 0 ? 0 : dxOffset;
    return Offset(dxOffset, dyOffset);
  }

  ///
  Offset updateTransformTranslateOffset(
      {required double dx, required double dy, required Size childSize}) {
    var offsetDx = childSize.width / 2 - dx;
    var offsetDy = childSize.height / 2 - dy;
    return Offset(offsetDx, offsetDy);
  }

  void reset() {
    offset.value = Offset.zero;
    notifyListeners();
  }
}
