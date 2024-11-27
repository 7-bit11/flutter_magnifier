// ignore_for_file: use_super_parameters, library_private_types_in_public_api

import 'dart:math';

import 'package:flutter/material.dart';

class CustomMagnifier extends StatefulWidget {
  final Widget child;
  final double magnification;
  final double maxWidth;
  final double maxHeight;
  final Size magnifierSize;
  const CustomMagnifier({
    Key? key,
    required this.child,
    this.magnification = 2.0,
    required this.maxWidth,
    required this.maxHeight,
    this.magnifierSize = const Size(100, 100),
  }) : super(key: key);

  @override
  _CustomMagnifierState createState() => _CustomMagnifierState();
}

class _CustomMagnifierState extends State<CustomMagnifier> {
  Offset? _offset;

  /// update pointer move event
  void updatePointerMoveEvent(PointerMoveEvent event) {
    setState(() {
      final offsetData = event.localPosition;
      var dy =
          offsetData.dy > widget.maxHeight ? widget.maxHeight : offsetData.dy;
      var dx =
          offsetData.dx > widget.maxWidth ? widget.maxWidth : offsetData.dx;
      dy = dy < 0 ? 0 : dy;
      dx = dx < 0 ? 0 : dx;
      _offset = Offset(dx, dy);
    });
  }

  Offset updateMagnifierOffset(double dx, double dy) {
    var dxOffset = dx - widget.magnifierSize.width;
    var dyOffset = dy - widget.magnifierSize.height;
    dyOffset = dyOffset < 0 ? 0 : dyOffset;
    dxOffset = dxOffset < 0 ? 0 : dxOffset;
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

  Widget _buildBox(double dx, double dy, Size childSize) {
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
                    offset: Offset(
                      childSize.width / 2 - dx,
                      childSize.height / 2 - dy,
                    ),
                    child: OverflowBox(
                      minWidth: childSize.width,
                      maxWidth: childSize.width,
                      minHeight: childSize.height,
                      maxHeight: childSize.height,
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
  }
}
