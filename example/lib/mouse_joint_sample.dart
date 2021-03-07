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

  late Ball ball;
  late Body groundBody;
  MouseJoint? mouseJoint;

  MouseJointSample()
      : super(
          scale: 8.0,
          gravity: Vector2(0, -10.0),
        );

  @override
  Future<void> onLoad() async {
    final boundaries = createBoundaries(worldViewport);
    boundaries.forEach(add);

    groundBody = world.createBody(BodyDef());
    ball = Ball(worldViewport.worldToScreen(Vector2(0, 0)), radius: 5);
    add(ball);
    add(CornerRamp());
    add(CornerRamp(isMirrored: true));
  }

  @override
  bool onDragUpdate(int pointerId, DragUpdateDetails details) {
    MouseJointDef mouseJointDef = MouseJointDef()
      ..maxForce = 3000 * ball.body.mass * 10
      ..dampingRatio = 0.1
      ..frequencyHz = 5
      ..target.setFrom(ball.body.position)
      ..collideConnected = false
      ..bodyA = groundBody
      ..bodyB = ball.body;

    mouseJoint ??= world.createJoint(mouseJointDef) as MouseJoint;

    mouseJoint?.setTarget(
      worldViewport.screenToWorld(
        details.globalPosition.toVector2(),
      ),
    );
    return false;
  }

  bool onDragEnd(int pointerId, DragEndDetails details) {
    if (mouseJoint == null) {
      return true;
    }
    world.destroyJoint(mouseJoint!);
    mouseJoint = null;
    return false;
  }
}
