import 'dart:math' as math;
import 'package:flame_forge2d/body_component.dart';
import 'package:forge2d/forge2d.dart';
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
    double cx = 0.0;
    double cy = 10.0;
    double rx = 5.0;
    double ry = 5.0;
    double nBodies = 20.0;
    double bodyRadius = 0.5;
    double angle = (bodyNumber / nBodies) * math.pi * 2;

    BodyDef bodyDef = BodyDef();
    bodyDef.fixedRotation = true;

    double x = cx + rx * math.sin(angle);
    double y = cy + ry * math.cos(angle);
    bodyDef.position.setFrom(Vector2(x, y));
    bodyDef.type = BodyType.DYNAMIC;
    Body body = world.createBody(bodyDef);

    FixtureDef fixtureDef = FixtureDef();
    CircleShape shape = CircleShape()..radius = bodyRadius;
    fixtureDef.shape = shape;
    fixtureDef.density = 1.0;
    fixtureDef.filter.groupIndex = -2;
    body.createFixture(fixtureDef);
    jointDef.addBody(body);
    return body;
  }
}

class FallingBox extends BodyComponent {
  final Vector2 position;

  FallingBox(
    Forge2DGame game,
    this.position,
  );

  @override
  Body createBody() {
    BodyDef bodyDef = BodyDef()
      ..type = BodyType.DYNAMIC
      ..position = position;
    PolygonShape shape = PolygonShape()..setAsBoxXY(2, 4);
    Body body = world.createBody(bodyDef);
    body.createFixtureFromShape(shape, 1.0);
    return body;
  }
}

class BlobSample extends Forge2DGame with TapDetector {
  BlobSample(Vector2 viewportSize)
      : super(
          scale: 8.0,
          gravity: Vector2(0, -10.0),
        ) {
    viewport.resize(viewportSize);
    final boundaries = createBoundaries(viewport);
    boundaries.forEach(add);
    add(Ground());
    final jointDef = ConstantVolumeJointDef()
      ..frequencyHz = 10.0
      ..dampingRatio = 1.0
      ..collideConnected = false;

    double nBodies = 20.0;
    for (int i = 0; i < nBodies; ++i) {
      add(BlobPart(i, jointDef));
    }
    world.createJoint(jointDef);
  }

  @override
  void onTapDown(TapDownDetails details) {
    super.onTapDown(details);
    final Vector2 screenPosition =
        Vector2(details.localPosition.dx, details.localPosition.dy);
    final Vector2 worldPosition = viewport.getScreenToWorld(screenPosition);
    add(FallingBox(this, worldPosition));
  }
}
