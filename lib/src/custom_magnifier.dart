// ignore_for_file: use_super_parameters, library_private_types_in_public_api

import 'package:flutter/material.dart';

class CustomMagnifier extends StatefulWidget {
  final Widget child;
  final double magnification;
  final double maxWidth;
  final double maxHeight;
  const CustomMagnifier({
    Key? key,
    required this.child,
    this.magnification = 2.0,
    required this.maxWidth,
    required this.maxHeight,
  }) : super(key: key);

  @override
  _CustomMagnifierState createState() => _CustomMagnifierState();
}

class _CustomMagnifierState extends State<CustomMagnifier> {
  Offset? _offset;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        widget.child,
        Positioned.fill(
          child: LayoutBuilder(
            builder: (_, BoxConstraints constraints) {
              final childSize = constraints.biggest;
              return Listener(
                onPointerMove: (event) {
                  print("onPointerMove:${event.localPosition}");

                  setState(() {
                    final offsetData = event.localPosition;
                    final dy = offsetData.dy > widget.maxHeight
                        ? widget.maxHeight
                        : offsetData.dy;
                    final dx = offsetData.dx > widget.maxWidth
                        ? widget.maxWidth
                        : offsetData.dx;
                    _offset = Offset(dx, dy);
                  });
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
    );
  }

  Widget _buildBox(double dx, double dy, Size childSize) {
    final magnifierSize = childSize.shortestSide / 2;
    return Transform.translate(
      offset: Offset(dx - magnifierSize / 1, dy - magnifierSize),
      child: Align(
        alignment: Alignment.topLeft,
        child: Stack(
          children: [
            SizedBox(
              width: magnifierSize,
              height: magnifierSize,
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
                  color: Colors.green.withOpacity(0.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
