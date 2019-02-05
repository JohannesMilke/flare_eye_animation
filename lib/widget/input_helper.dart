import 'package:flutter/rendering.dart';

Offset getCaretPosition(RenderBox box) {
  final RenderEditable renderEditable = _findRenderEditable(box);
  if (!renderEditable.hasFocus) return null;

  final List<TextSelectionPoint> endpoints = _globalize(
    renderEditable.getEndpointsForSelection(renderEditable.selection),
    renderEditable,
  );
  return endpoints[0].point + const Offset(0.0, -2.0);
}

// Returns first render editable
RenderEditable _findRenderEditable(RenderObject root) {
  RenderEditable renderEditable;
  void recursiveFinder(RenderObject child) {
    if (child is RenderEditable) {
      renderEditable = child;
      return;
    }
    child.visitChildren(recursiveFinder);
  }

  root.visitChildren(recursiveFinder);
  return renderEditable;
}

List<TextSelectionPoint> _globalize(
    List<TextSelectionPoint> points, RenderBox box) {
  final globalize = (TextSelectionPoint point) => TextSelectionPoint(
        box.localToGlobal(point.point),
        point.direction,
      );

  return points.map<TextSelectionPoint>(globalize).toList();
}
