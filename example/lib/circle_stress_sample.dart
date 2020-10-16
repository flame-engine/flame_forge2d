import 'dart:math';

import 'package:flame_forge2d/body_component.dart';
import 'package:forge2d/forge2d.dart';
import 'package:flame/gestures.dart';
import 'package:flame_forge2d/forge2d_game.dart';
import 'package:flutter/material.dart' hide Image;

import 'balls.dart';
import 'boundaries.dart';

class CirlcleShuffler extends BodyComponent {
  CirlcleShuffler(Forge2DGame game) : super(game);

  @override
  Body createBody() {
    var bd = BodyDef()
      ..type = BodyType.DYNAMIC
      ..position = Vector2(0.0, -30.0);
    int numPieces = 5;
    double radius = 6.0;
    var body = world.createBody(bd);

    for (int i = 0; i < numPieces; i++) {
      double xPos = radius * cos(2 * pi * (i / numPieces.toDouble()));
      double yPos = radius * sin(2 * pi * (i / numPieces.toDouble()));

      var cd = CircleShape()
        ..radius = 1.2
        ..position.setValues(xPos, yPos);

      final fd = FixtureDef()
        ..shape = cd
        ..density = 50.0
        ..friction = .1
        ..restitution = .9;

      body.createFixtureFromFixtureDef(fd);
    }
    // Create an empty ground body.
    var bodyDef = BodyDef();
    var groundBody = world.createBody(bodyDef);

    RevoluteJointDef rjd = RevoluteJointDef()
      ..initialize(body, groundBody, body.position)
      ..motorSpeed = pi
      ..maxMotorTorque = 1000000.0
      ..enableMotor = true;

    world.createJoint(rjd);
    return body;
  }
}

class CircleStressSample extends Forge2DGame with TapDetector {
  CircleStressSample(Vector2 viewportSize)
      : super(
          scale: 8.0,
          gravity: Vector2(0, -10.0),
        ) {
    viewport.resize(viewportSize);
    // TODO: Fix bug with sleeping bodies midair
    world.setAllowSleep(false);
    final boundaries = createBoundaries(this);
    boundaries.forEach(add);

    add(CirlcleShuffler(this));

    final Random random = Random();
    for (int j = 0; j < 8; j++) {
      for (int i = 0; i < 20; i++) {
        Vector2 position = Vector2(20.0 * i, 30.0 * j);
        Ball ball = Ball(position, this, radius: random.nextDouble());
        add(ball);
      }
    }
  }

  @override
  void onTapDown(TapDownDetails details) {
    super.onTapDown(details);
    final Vector2 screenPosition =
    Vector2(details.globalPosition.dx, details.globalPosition.dy);
    add(Ball(screenPosition, this, radius: 1.0));
  }
}
