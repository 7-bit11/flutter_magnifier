// ignore_for_file: use_super_parameters, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_magnifier/src/magnifier_controller.dart';

enum MagnifierType { magnifierRectangle, magnifierWithCircle }

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

  final MagnifierType magnifierType;
  const CustomMagnifier({
    Key? key,
    required this.child,
    this.magnification = 2.0,
    required this.maxWidth,
    required this.maxHeight,
    this.magnifierSize = const Size(100, 100),
    required this.controller,
    this.magnifierType = MagnifierType.magnifierRectangle,
  }) : super(key: key);

  @override
  _CustomMagnifierState createState() => _CustomMagnifierState();
}

class _CustomMagnifierState extends State<CustomMagnifier> {
  late CustomMagnifierController _controller;
  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
  }

  /// update pointer move event
  void _updatePointerMoveEvent(PointerMoveEvent event) {
    _controller.updatePointerMoveEvent(
        event, widget.maxHeight, widget.maxWidth);
  }

  Offset _updateMagnifierOffset(double dx, double dy) {
    return _controller.updateMagnifierOffset(dx, dy, widget.magnifierSize);
  }

  Offset _updateTransformTranslateOffset(
      {required double dx, required double dy, required Size childSize}) {
    return _controller.updateTransformTranslateOffset(
        dx: dx, dy: dy, childSize: childSize);
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
          ListenableBuilder(
            listenable: _controller.offset,
            builder: (BuildContext context, Widget? child) {
              return Positioned.fill(
                child: LayoutBuilder(
                  builder: (_, BoxConstraints constraints) {
                    final childSize = constraints.biggest;
                    return Listener(
                      onPointerMove: (event) {
                        _updatePointerMoveEvent(event);
                      },
                      child: MouseRegion(
                        child: _controller.offset.value != Offset.zero
                            ? _buildBox(_controller.offset.value.dx,
                                _controller.offset.value.dy, childSize)
                            : null,
                      ),
                    );
                  },
                ),
              );
            },
          )
        ],
      ),
    );
  }

  Widget _buildBox(double dx, double dy, Size childSize) {
    return Transform.translate(
      offset: _updateMagnifierOffset(dx, dy),
      child: Align(
        alignment: Alignment.topLeft,
        child: Stack(
          children: [
            SizedBox(
              width: widget.magnifierSize.width,
              height: widget.magnifierSize.height,
              child: ClipRRect(
                borderRadius:
                    widget.magnifierType == MagnifierType.magnifierWithCircle
                        ? BorderRadius.circular(childSize.width / 2)
                        : BorderRadius.zero,
                child: Transform.scale(
                  scale: widget.magnification,
                  child: Transform.translate(
                    offset: _updateTransformTranslateOffset(
                        dx: dx, dy: dy, childSize: childSize),
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
                  shape:
                      widget.magnifierType == MagnifierType.magnifierWithCircle
                          ? BoxShape.circle
                          : BoxShape.rectangle,
                  border: Border.all(color: Colors.black, width: 2),
                  color: Colors.transparent,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
