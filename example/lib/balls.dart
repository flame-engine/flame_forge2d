import 'dart:math' as math;

import 'package:forge2d/forge2d.dart';
import 'package:flame/palette.dart';
import 'package:flame_forge2d/body_component.dart';
import 'package:flame_forge2d/contact_callbacks.dart';
import 'package:flutter/material.dart';

import 'boundaries.dart';

class Ball extends BodyComponent {
  Paint originalPaint;
  bool giveNudge = false;
  final double radius;
  Vector2 _position;

  Ball(this._position, {this.radius = 5.0}) {
    originalPaint = _randomPaint();
    this.paint = originalPaint;
  }

  Paint _randomPaint() {
    final rng = math.Random();
    return PaletteEntry(
      Color.fromARGB(
        100 + rng.nextInt(155),
        100 + rng.nextInt(155),
        100 + rng.nextInt(155),
        255,
      ),
    ).paint;
  }

  @override
  Body createBody() {
    final CircleShape shape = CircleShape();
    shape.radius = radius;
    Vector2 worldPosition = viewport.getScreenToWorld(_position);

    final fixtureDef = FixtureDef()
      ..shape = shape
      ..restitution = 0.8
      ..density = 1.0
      ..friction = 0.1;

    final bodyDef = BodyDef()
      // To be able to determine object in collision
      ..setUserData(this)
      ..position = worldPosition
      ..type = BodyType.DYNAMIC;

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }

  @override
  void renderCircle(Canvas c, Offset center, double radius) {
    super.renderCircle(c, center, radius);
    final angle = body.getAngle();
    final lineRotation =
        Offset(math.sin(angle) * radius, math.cos(angle) * radius);
    final blue = const PaletteEntry(Colors.blue).paint;
    c.drawLine(center, center + lineRotation, blue);
  }

  @override
  void update(double t) {
    super.update(t);
    if (giveNudge) {
      body.applyLinearImpulse(Vector2(0, 10000), body.getLocalCenter(), true);
      giveNudge = false;
    }
  }
}

class WhiteBall extends Ball {
  WhiteBall(Vector2 position) : super(position) {
    originalPaint = BasicPalette.white.paint;
    paint = originalPaint;
  }
}

class BallContactCallback extends ContactCallback<Ball, Ball> {
  @override
  void begin(Ball ball1, Ball ball2, Contact contact) {
    if (ball1 is WhiteBall || ball2 is WhiteBall) {
      return;
    }
    if (ball1.paint != ball1.originalPaint) {
      ball1.paint = ball2.paint;
    } else {
      ball2.paint = ball1.paint;
    }
  }

  @override
  void end(Ball ball1, Ball ball2, Contact contact) {}
}

class WhiteBallContactCallback extends ContactCallback<Ball, WhiteBall> {
  @override
  void begin(Ball ball, WhiteBall whiteBall, Contact contact) {
    ball.giveNudge = true;
  }

  @override
  void end(Ball ball, WhiteBall whiteBall, Contact contact) {}
}

class BallWallContactCallback extends ContactCallback<Ball, Wall> {
  @override
  void begin(Ball ball, Wall wall, Contact contact) {
    wall.paint = ball.paint;
  }

  @override
  void end(Ball ball, Wall wall, Contact contact) {}
}
