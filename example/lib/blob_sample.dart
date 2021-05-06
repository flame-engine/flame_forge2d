import 'dart:math' as math;
import 'package:flame_forge2d/body_component.dart';
import 'package:forge2d/forge2d.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flame/gestures.dart';
import 'package:flame_forge2d/forge2d_game.dart';
import 'package:flutter/material.dart';

import 'boundaries.dart';

class Ground extends BodyComponent {
  @override
  Body createBody() {
    PolygonShape shape = PolygonShape();
    shape.setAsBoxXY(20.0, 0.4);

    BodyDef bodyDef = BodyDef();
    bodyDef.position.setValues(0.0, -20.0);
    final ground = world.createBody(bodyDef);
    ground.createFixtureFromShape(shape);

    shape.setAsBox(0.4, 20.0, Vector2(-10.0, 0.0), 0.0);
    ground.createFixtureFromShape(shape);
    shape.setAsBox(0.4, 20.0, Vector2(10.0, 0.0), 0.0);
    ground.createFixtureFromShape(shape);
    return ground;
  }
}

class BlobPart extends BodyComponent {
  final ConstantVolumeJointDef jointDef;
  final int bodyNumber;

  BlobPart(
    this.bodyNumber,
    this.jointDef,
  );

  @override
  Body createBody() {
    final cx = 0.0;
    final cy = 10.0;
    final rx = 5.0;
    final ry = 5.0;
    final nBodies = 20.0;
    final bodyRadius = 0.5;
    final angle = (bodyNumber / nBodies) * math.pi * 2;

    BodyDef bodyDef = BodyDef();
    bodyDef.fixedRotation = true;

    final x = cx + rx * math.sin(angle);
    final y = cy + ry * math.cos(angle);
    bodyDef.position.setFrom(Vector2(x, y));
    bodyDef.type = BodyType.dynamic;
    Body body = world.createBody(bodyDef);

    CircleShape shape = CircleShape()..radius = bodyRadius;
    FixtureDef fixtureDef = FixtureDef(shape);
    fixtureDef.density = 1.0;
    fixtureDef.filter.groupIndex = -2;
    body.createFixture(fixtureDef);
    jointDef.addBody(body);
    return body;
  }
}

class FallingBox extends BodyComponent {
  final Vector2 position;

  FallingBox(this.position);

  @override
  Body createBody() {
    BodyDef bodyDef = BodyDef()
      ..type = BodyType.dynamic
      ..position = position;
    PolygonShape shape = PolygonShape()..setAsBoxXY(2, 4);
    Body body = world.createBody(bodyDef);
    body.createFixtureFromShape(shape, 1.0);
    return body;
  }
}

class BlobSample extends Forge2DGame with TapDetector {
  @override
  bool debugMode = true;

  BlobSample()
      : super(
          scale: 1.0,
          gravity: Vector2(0, -10.0),
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final boundaries = createBoundaries(this);
    boundaries.forEach(add);
    add(Ground());
    final jointDef = ConstantVolumeJointDef()
      ..frequencyHz = 10.0
      ..dampingRatio = 1.0
      ..collideConnected = false;

    double nBodies = 20.0;
    for (int i = 0; i < nBodies; ++i) {
      await add(BlobPart(i, jointDef));
    }
    world.createJoint(jointDef);
  }

  @override
  void onTapDown(TapDownInfo details) {
    super.onTapDown(details);
    final Vector2 screenPosition = details.eventPosition.widget;
    final Vector2 worldPosition = screenToWorld(screenPosition);
    add(FallingBox(worldPosition));
  }
}
