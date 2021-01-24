import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_forge2d/forge2d_game.dart';
import 'package:flame/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flame/extensions.dart';

import 'balls.dart';
import 'boundaries.dart';
import 'circle_stress_sample.dart';

class MouseJointSample extends Forge2DGame with MultiTouchDragDetector {
  @override
  bool debugMode = true;

  Ball ball;
  Body groundBody;
  MouseJoint mouseJoint;

  MouseJointSample(Vector2 viewportSize)
      : super(
          scale: 8.0,
          gravity: Vector2(0, -10.0),
        ) {
    viewport.resize(viewportSize);
    final boundaries = createBoundaries(viewport);
    boundaries.forEach(add);

    groundBody = world.createBody(BodyDef());
    ball = Ball(viewport.getWorldToScreen(Vector2(0, 0)), radius: 5);
    add(ball);
    add(CornerRamp());
    add(CornerRamp(isMirrored: true));
  }

  @override
  void onReceiveDrag(DragEvent drag) {
    drag.onUpdate = (DragUpdateDetails details) {
      MouseJointDef mouseJointDef = MouseJointDef()
        ..maxForce = 3000 * ball.body.mass * 10
        ..dampingRatio = 0.1
        ..frequencyHz = 5
        ..target.setFrom(ball.body.position)
        ..collideConnected = false
        ..bodyA = groundBody
        ..bodyB = ball.body;

      mouseJoint ??= world.createJoint(mouseJointDef);

      mouseJoint.setTarget(
          viewport.getScreenToWorld(details.globalPosition.toVector2()));
    };

    drag.onEnd = (DragEndDetails details) {
      world.destroyJoint(mouseJoint);
      mouseJoint = null;
    };

    super.onReceiveDrag(drag);
  }
}
