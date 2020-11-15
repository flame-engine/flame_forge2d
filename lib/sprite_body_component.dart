import 'dart:ui';

import 'package:flame/anchor.dart';
import 'package:flame/components/sprite_component.dart';
import 'package:flame/extensions/vector2.dart';
import 'package:flame/sprite.dart';

import 'body_component.dart';

abstract class SpriteBodyComponent extends BodyComponent {
  SpriteComponent spriteComponent;
  Vector2 size;

  /// Make sure that the [size] of the sprite matches the bounding shape of the
  /// body that is create in createBody()
  SpriteBodyComponent(
    Sprite sprite,
    this.size,
  ) {
    spriteComponent = SpriteComponent.fromSprite(size, sprite)
      ..anchor = Anchor.center;
  }

  @override
  bool get loaded => body.isActive() && spriteComponent.loaded;

  @override
  void render(Canvas c) {
    super.render(c);
    if (spriteComponent.loaded) {
      final screenPosition = viewport.getWorldToScreen(body.position);
      spriteComponent
        ..angle = -body.getAngle()
        ..size = size * viewport.scale
        ..x = screenPosition.x
        ..y = screenPosition.y;

      spriteComponent.render(c);
    }
  }
}
