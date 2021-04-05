import 'dart:ui';

import 'package:flame_forge2d/body_component.dart';
import 'package:flame_forge2d/sprite_body_component.dart';
import 'package:flame_forge2d/viewport.dart';
import 'package:forge2d/forge2d.dart';
import 'package:flame/components.dart';
import 'package:flame/gestures.dart';
import 'package:flame_forge2d/forge2d_game.dart';
import 'package:flutter/material.dart' hide Image;

import 'boundaries.dart';

class Pizza extends SpriteBodyComponent {
  final Vector2 _position;

  Pizza(this._position, Image image) : super(Sprite(image), Vector2(2, 3));

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    debugMode = false;
  }

  @override
  void renderDebugMode(Canvas canvas) {}

  @override
  Body createBody() {
    final PolygonShape shape = PolygonShape();

    final vertices = [
      Vector2(-size.x / 2, -size.y / 2),
      Vector2(size.x / 2, -size.y / 2),
      Vector2(0, size.y / 2),
    ];
    shape.set(vertices);

    final fixtureDef = FixtureDef(shape)
      ..userData = this // To be able to determine object in collision
      ..restitution = 0.4
      ..density = 1.0
      ..friction = 0.3;

    final bodyDef = BodyDef()
      ..position = camera.screenToWorld(_position)
      ..angle = (_position.x + _position.y) / 2 * 3.14
      ..type = BodyType.dynamic;
    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}

class Platform extends BodyComponent {
  final Vector2 position;

  Platform(this.position);

  @override
  Body createBody() {
    PolygonShape shape = PolygonShape()..setAsBoxXY(14.8, 0.125);
    FixtureDef fd = FixtureDef(shape);

    BodyDef bd = BodyDef();
    bd.position = position;
    final body = world.createBody(bd);
    return body..createFixture(fd);
  }
}

class DominoBrick extends BodyComponent {
  final Vector2 position;

  DominoBrick(this.position);

  @override
  Body createBody() {
    final shape = PolygonShape()..setAsBoxXY(0.125, 2.0);
    FixtureDef fixtureDef = FixtureDef(shape)
      ..density = 25.0
      ..friction = .5;

    BodyDef bodyDef = BodyDef()
      ..type = BodyType.dynamic
      ..position = position;

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}

class DominoSample extends Forge2DGame with TapDetector {
  @override
  bool debugMode = true;

  late Image _pizzaImage;

  DominoSample()
      : super(
          scale: 20.0,
          gravity: Vector2(0, -10.0),
        );

  @override
  Future<void> onLoad() async {
    final boundaries = createBoundaries(viewport as Forge2DViewport);
    boundaries.forEach(add);
    _pizzaImage = await images.load('pizza.png');

    for (int i = 0; i < 8; i++) {
      final position = Vector2(0.0, -30.0 + 5 * i);
      add(Platform(position));
    }

    final numberOfRows = 10;
    final numberPerRow = 25;
    for (int i = 0; i < numberOfRows; ++i) {
      for (int j = 0; j < numberPerRow; j++) {
        final position =
            Vector2(-14.75 + j * (29.5 / (numberPerRow - 1)), -27.7 + 5 * i);
        add(DominoBrick(position));
      }
    }
  }

  @override
  void onTapDown(TapDownDetails details) {
    super.onTapDown(details);
    final Vector2 screenPosition =
        Vector2(details.localPosition.dx, details.localPosition.dy);
    final pizza = Pizza(screenPosition, _pizzaImage);
    add(pizza);
    camera.followComponent(pizza.positionComponent);
  }
}
