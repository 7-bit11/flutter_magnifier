// ignore_for_file: use_super_parameters, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_magnifier/src/magnifier_controller.dart';

class CustomMagnifier extends StatefulWidget {
  /// 子组件
  final Widget child;

  /// 放大倍数
  final double magnification;

  /// 宽度
  final double maxWidth;

  /// 高度
  final double maxHeight;

  /// 放大镜大小
  final Size magnifierSize;

  final CustomMagnifierController controller;
  const CustomMagnifier({
    Key? key,
    required this.child,
    this.magnification = 2.0,
    required this.maxWidth,
    required this.maxHeight,
    this.magnifierSize = const Size(100, 100),
    required this.controller,
  }) : super(key: key);

  @override
  _CustomMagnifierState createState() => _CustomMagnifierState();
}

class _CustomMagnifierState extends State<CustomMagnifier> {
  Offset? _offset;
  late CustomMagnifierController _controller;
  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
  }

  /// update pointer move event
  void updatePointerMoveEvent(PointerMoveEvent event) {
    _controller.updatePointerMoveEvent(
        event, widget.maxHeight, widget.maxWidth);
    // setState(() {
    //   final offsetData = event.localPosition;
    //   var dy =
    //       offsetData.dy > widget.maxHeight ? widget.maxHeight : offsetData.dy;
    //   var dx =
    //       offsetData.dx > widget.maxWidth ? widget.maxWidth : offsetData.dx;
    //   dy = dy < 0 ? 0 : dy;
    //   dx = dx < 0 ? 0 : dx;
    //   _offset = Offset(dx, dy);
    // });
  }

  Offset updateMagnifierOffset(double dx, double dy) {
    var dxOffset = dx - widget.magnifierSize.width;
    var dyOffset = dy - widget.magnifierSize.height;
    dyOffset = dyOffset < 0 ? 0 : dyOffset;
    dxOffset = dxOffset < 0 ? 0 : dxOffset;
    print("dxOffset:$dxOffset  dyOffset：$dyOffset");
    return Offset(dxOffset, dyOffset);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.maxWidth,
      height: widget.maxHeight,
      child: Stack(
        alignment: Alignment.center,
        children: [
          widget.child,
          Positioned.fill(
            child: LayoutBuilder(
              builder: (_, BoxConstraints constraints) {
                final childSize = constraints.biggest;
                return Listener(
                  onPointerMove: (event) {
                    updatePointerMoveEvent(event);
                  },
                  child: MouseRegion(
                    onHover: (event) {
                      // setState(() => _offset = event.localPosition);
                      // print("onHover:${_offset}");
                    },
                    onExit: (_) => setState(() => _offset = null),
                    child: _offset != null
                        ? _buildBox(_offset!.dx, _offset!.dy, childSize)
                        : null,
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Offset updateTransformTranslateOffset(
      {required double dx,
      required double dy,
      required Size childSize,
      required Size magnifierSize}) {
    var offsetDx = childSize.width / 2 - dx;
    var offsetDy = childSize.height / 2 - dy;
    // if (dx >= childSize.width / 2) {
    //   offsetDx += magnifierSize.width / 2;
    // } else {
    //   offsetDx -= magnifierSize.width / 2;
    // }
    // if (dy >= childSize.height - magnifierSize.height / 2) {
    //   offsetDy += magnifierSize.height / 2;
    // } else {
    //   offsetDy -= magnifierSize.height / 2;
    // }
    print("offsetDx:$offsetDx  offsetDy$offsetDy");
    return Offset(offsetDx, offsetDy);
  }

  Widget _buildBox(double dx, double dy, Size childSize) {
    return ListenableBuilder(
      listenable: _controller.offset ?? ValueNotifier(Offset.zero),
      builder: (BuildContext context, Widget? child) {
        return Transform.translate(
          offset: updateMagnifierOffset(dx, dy),
          child: Align(
            alignment: Alignment.topLeft,
            child: Stack(
              children: [
                SizedBox(
                  width: widget.magnifierSize.width,
                  height: widget.magnifierSize.height,
                  child: ClipRect(
                    child: Transform.scale(
                      scale: widget.magnification,
                      child: Transform.translate(
                        offset: updateTransformTranslateOffset(
                            dx: dx,
                            dy: dy,
                            childSize: childSize,
                            magnifierSize: widget.magnifierSize),
                        child: OverflowBox(
                          minWidth:
                              childSize.width + widget.magnifierSize.width / 2,
                          maxWidth:
                              childSize.width + widget.magnifierSize.width / 2,
                          minHeight:
                              childSize.height + widget.magnifierSize.width / 2,
                          maxHeight:
                              childSize.height + widget.magnifierSize.width / 2,
                          child: widget.child,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 2),
                      color: Colors.transparent,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
