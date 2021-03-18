import 'package:flame/game.dart';
import 'package:forge2d/forge2d.dart';

mixin Forge2DViewport on Viewport {
  late ViewportTransform viewportTransform;

  double get scale => viewportTransform.scale;
}

class Forge2DDefaultViewport extends DefaultViewport with Forge2DViewport {
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
    viewportTransform.extents.setFrom(effectiveSize / 2);
    viewportTransform.center.setFrom(effectiveSize / 2);
  }
}

class Forge2DFixedResolutionViewport extends FixedResolutionViewport
    with Forge2DViewport {
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
    viewportTransform.extents.setFrom(effectiveSize / 2);
    viewportTransform.center.setFrom(effectiveSize / 2);
  }
}
