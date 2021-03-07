import 'package:flame/game.dart';
import 'package:forge2d/forge2d.dart';

import 'body_component.dart';

mixin WorldViewport on Viewport {
  late ViewportTransform viewportTransform;

  double get scale => viewportTransform.scale;

  /// Takes the world coordinates and return the corresponding screen coordinates
  Vector2 worldToScreen(Vector2 argWorld) {
    return viewportTransform.worldToScreen(argWorld);
  }

  /// Takes the screen coordinates and return the corresponding world coordinates
  Vector2 screenToWorld(Vector2 argScreen) {
    return viewportTransform.screenToWorld(argScreen);
  }

  /// Follows the specified body component using a sliding focus window defined as a percentage of the total viewport.
  ///
  /// @param component to follow.
  /// @param horizontal percentage of the horizontal viewport. Negative values means no horizontal following.
  /// @param vertical percentage of the vertical viewport. Negative values means no vertical following.
  void cameraFollow(
    BodyComponent component, {
    double horizontal = -1,
    double vertical = -1,
  }) {
    final Vector2 position = component.center;
    final center = viewportTransform.center;
    double x = center.x;
    double y = center.y;

    if (horizontal >= 0) {
      final temp = viewportTransform.worldToScreen(position);

      final margin = horizontal / 2 * canvasSize.x / 2;
      final focus = canvasSize.x / 2 - temp.x;

      if (focus.abs() > margin) {
        x = canvasSize.x / 2 +
            (position.x * scale) +
            (focus > 0 ? margin : -margin);
      }
    }

    if (vertical >= 0) {
      final temp = viewportTransform.worldToScreen(position);

      final margin = vertical / 2 * canvasSize.y / 2;
      final focus = canvasSize.y / 2 - temp.y;

      if (focus.abs() > margin) {
        y = canvasSize.y / 2 +
            (viewportTransform.yFlip ? -1 : 1) *
                ((position.y * scale) + (focus < 0 ? margin : -margin));
      }
    }

    if (x != center.x || y != center.y) {
      viewportTransform.setCamera(x, y, scale);
    }
  }
}

class Forge2DDefaultViewport extends DefaultViewport with WorldViewport {
  Forge2DDefaultViewport(double scale) {
    viewportTransform = ViewportTransform(
      Vector2.zero(),
      Vector2.zero(),
      scale,
    );
  }

  /// Resizes the current viewport.
  @override
  void resize(Vector2 size) {
    super.resize(size);
    viewportTransform.extents = size / 2;
    viewportTransform.center = size / 2;
  }
}

class Forge2DFixedResolutionViewport extends FixedResolutionViewport
    with WorldViewport {
  Forge2DFixedResolutionViewport(Vector2 size, double scale) : super(size) {
    viewportTransform = ViewportTransform(
      Vector2.zero(),
      Vector2.zero(),
      scale,
    );
  }

  /// Resizes the current viewport.
  @override
  void resize(Vector2 size) {
    super.resize(size);
    viewportTransform.extents = size / 2;
    viewportTransform.center = size / 2;
  }
}
