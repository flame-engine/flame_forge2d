import 'dart:ui';

import 'package:forge2d/forge2d.dart';
import 'package:flame/gestures.dart';
import 'package:flame/sprite.dart';
import 'package:flame_forge2d/forge2d_game.dart';
import 'package:flame_forge2d/sprite_body_component.dart';
import 'package:flutter/material.dart' hide Image;

import 'boundaries.dart';

class Pizza extends SpriteBodyComponent {
  final Vector2 _position;

  Pizza(this._position, Image image, Forge2DGame game)
      : super(Sprite(image), Vector2(10, 15), game);

  @override
  Body createBody() {
    final PolygonShape shape = PolygonShape();

    final v1 = Vector2(0, size.y / 2);
    final v2 = Vector2(size.x / 2, -size.y / 2);
    final v3 = Vector2(-size.x / 2, -size.y / 2);
    final vertices = [v1, v2, v3];
    shape.set(vertices, vertices.length);

    final fixtureDef = FixtureDef();
    fixtureDef.setUserData(this); // To be able to determine object in collision
    fixtureDef.shape = shape;
    fixtureDef.restitution = 0.3;
    fixtureDef.density = 1.0;
    fixtureDef.friction = 0.2;

    final bodyDef = BodyDef();
    bodyDef.position = viewport.getScreenToWorld(_position);
    bodyDef.angle = (_position.x + _position.y) / 2 * 3.14;
    bodyDef.type = BodyType.DYNAMIC;
    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}

class SpriteBodySample extends Forge2DGame with TapDetector {
  Image _pizzaImage;

  SpriteBodySample(Vector2 viewportSize)
      : super(
          scale: 4.0,
          gravity: Vector2(0, -10.0),
        ) {
    viewport.resize(viewportSize);
    final boundaries = createBoundaries(this);
    boundaries.forEach(add);
  }

  @override
  Future<void> onLoad() async {
    _pizzaImage = await images.load('pizza.png');
  }

  @override
  void onTapDown(TapDownDetails details) {
    super.onTapDown(details);
    final Vector2 position =
        Vector2(details.globalPosition.dx, details.globalPosition.dy);
    add(Pizza(position, _pizzaImage, this));
  }
}
