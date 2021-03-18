import 'dart:ui';

import 'package:flame_forge2d/position_body_component.dart';
import 'package:flame_forge2d/viewport.dart';
import 'package:forge2d/forge2d.dart';
import 'package:flame/components.dart';
import 'package:flame/gestures.dart';
import 'package:flame_forge2d/forge2d_game.dart';
import 'package:flutter/material.dart' hide Image;

import 'boundaries.dart';

class ChopperBody extends PositionBodyComponent {
  ChopperBody(PositionComponent component) : super(component, component.size);

  @override
  Body createBody() {
    final shape = CircleShape()..radius = size.x / 4;
    final fixtureDef = FixtureDef(shape)
      ..userData = this // To be able to determine object in collision
      ..restitution = 0.3
      ..density = 1.0
      ..friction = 0.2;

    final bodyDef = BodyDef()
      ..position = camera.screenToWorld(positionComponent.position)
      ..angle = positionComponent.x / 2 * 3.14
      ..linearVelocity = (Vector2.all(0.5) - Vector2.random()) * 200
      ..type = BodyType.dynamic;
    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}

class PositionBodySample extends Forge2DGame with TapDetector {
  Image chopper;
  SpriteAnimation animation;

  PositionBodySample() : super(scale: 10.0, gravity: Vector2.zero());

  @override
  Future<void> onLoad() async {
    chopper = await images.load('chopper.png');

    animation = SpriteAnimation.fromFrameData(
      chopper,
      SpriteAnimationData.sequenced(
        amount: 4,
        textureSize: Vector2.all(48),
        stepTime: 0.15,
        loop: true,
      ),
    );

    final boundaries = createBoundaries(viewport as Forge2DViewport);
    boundaries.forEach(add);
  }

  @override
  void onTapDown(TapDownDetails details) {
    super.onTapDown(details);
    final Vector2 position =
        Vector2(details.localPosition.dx, details.localPosition.dy);
    final spriteSize = Vector2.all(10);
    final animationComponent = SpriteAnimationComponent(
      animation: animation,
      size: spriteSize,
    );
    animationComponent.position = position;
    add(ChopperBody(animationComponent));
  }
}
