import 'dart:ui';

import 'package:forge2d/forge2d.dart';

import 'body_component.dart';

class Viewport extends ViewportTransform {
  Vector2 size;

  @override
  double scale;

  Viewport(this.size, this.scale) : super(size / 2, size / 2, scale);

  double worldAlignBottom(double height) => -(size.x / 2 / scale) + height;

  /// Resizes the current viewport.
  void resize(Vector2 size) {
    this.size = size;
    extents = size / 2;
    center = size / 2;
  }

  /// Computes the number of horizontal world meters of this viewport considering a percentage of its width.
  ///
  /// @param percent percentage of the width in [0, 1] range.
  double worldWidth(double percent) {
    return percent * (size.x / scale);
  }

  double get width => size.x / scale / window.devicePixelRatio;

  double get height => size.y / scale / window.devicePixelRatio;

  /// Computes the scroll percentage of total screen width of the current viewport center position.
  ///
  /// @param screens multiplies the visible screen with to create a bigger virtual screen.
  /// @return the percentage in the range of [0, 1]
  double getCenterHorizontalScreenPercentage({double screens = 1.0}) {
    final width = size.x * screens;
    final x = center.x + ((screens - 1) * size.x / 2);
    final double rest = x.abs() % width;
    final double scroll = rest / width;
    return x > 0 ? scroll : 1 - scroll;
  }

  /// Follows the specified body component using a sliding focus window defined as a percentage of the total viewport.
  ///
  /// @param component to follow.
  /// @param horizontal percentage of the horizontal viewport. Null means no horizontal following.
  /// @param vertical percentage of the vertical viewport. Null means no vertical following.
  void cameraFollow(BodyComponent component,
      {double horizontal, double vertical}) {
    final Vector2 position = component.center;

    double x = center.x;
    double y = center.y;

    if (horizontal != null) {
      final temp = getWorldToScreen(position);

      final margin = horizontal / 2 * size.x / 2;
      final focus = size.x / 2 - temp.x;

      if (focus.abs() > margin) {
        x = size.x / 2 + (position.x * scale) + (focus > 0 ? margin : -margin);
      }
    }

    if (vertical != null) {
      final temp = getWorldToScreen(position);

      final margin = vertical / 2 * size.y / 2;
      final focus = size.y / 2 - temp.y;

      if (focus.abs() > margin) {
        y = size.y / 2 + (position.y * scale) + (focus < 0 ? margin : -margin);
      }
    }

    if (x != center.x || y != center.y) {
      setCamera(x, y, scale);
    }
  }
}
