import 'package:flame/game.dart';
import 'package:forge2d/forge2d.dart';

class Forge2DCamera extends Camera {
  late ViewportTransform viewportTransform;
  double get scale => viewportTransform.scale;

  /// Converts a vector in the screen space to the world space.
  @override
  Vector2 screenToWorld(Vector2 screenCoordinates) {
    return viewportTransform.screenToWorld(screenCoordinates);
  }

  /// Converts a vector in the world space to the screen space.
  @override
  Vector2 worldToScreen(Vector2 worldCoordinates) {
    return viewportTransform.worldToScreen(worldCoordinates);
  }
}
