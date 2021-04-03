import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flame_forge2d/body_component.dart';
import 'package:forge2d/forge2d.dart';

class Forge2DCamera extends Camera {
  final ViewportTransform viewportTransform;
  double get scale => viewportTransform.scale;

  Forge2DCamera(this.viewportTransform) : super();

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

  void followBodyComponent(
    BodyComponent component, {
    Vector2? relativeOffset,
    Rect? worldBounds,
  }) {
    followVector2(
      component.body.position,
      relativeOffset: relativeOffset,
      worldBounds: worldBounds,
    );
  }

  @override
  void followVector2(
    Vector2 vector2, {
    Vector2? relativeOffset,
    Rect? worldBounds,
  }) {
    super.followVector2(
      vector2,
      relativeOffset: relativeOffset,
      worldBounds: worldBounds,
    );
    viewportTransform.setCamera(
      position.x,
      position.y,
      scale,
    );
  }
}
