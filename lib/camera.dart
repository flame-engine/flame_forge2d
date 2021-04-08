import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:forge2d/forge2d.dart';

// TODO(spydon): Remove this class
class Forge2DCamera extends Camera {
  /// Converts a vector in the screen space to the world space.
  Vector2 screenToWorld(Vector2 screenCoordinates) {
    return super.screenToWorld(screenCoordinates)..y *= -1;
  }
  
  /// Converts a vector in the physics world space to the screen space.
  @override
  Vector2 worldToScreen(Vector2 worldCoordinates) {
    return super.worldToScreen(worldCoordinates..y *= -1);
  }
}
