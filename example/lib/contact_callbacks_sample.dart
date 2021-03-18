import 'dart:math' as math;

import 'package:flame_forge2d/viewport.dart';
import 'package:forge2d/forge2d.dart';
import 'package:flame/gestures.dart';
import 'package:flame_forge2d/forge2d_game.dart';
import 'package:flutter/material.dart';

import 'balls.dart';
import 'boundaries.dart';

class ContactCallbacksSample extends Forge2DGame with TapDetector {
  @override
  bool debugMode = true;

  ContactCallbacksSample()
      : super(
          scale: 4.0,
          gravity: Vector2(0, -10.0),
        );

  @override
  Future<void> onLoad() async {
    final boundaries = createBoundaries(viewport as Forge2DViewport);
    boundaries.forEach(add);
    addContactCallback(BallContactCallback());
    addContactCallback(BallWallContactCallback());
    addContactCallback(WhiteBallContactCallback());
  }

  @override
  void onTapDown(TapDownDetails details) {
    super.onTapDown(details);
    final Vector2 position =
        Vector2(details.localPosition.dx, details.localPosition.dy);
    if (math.Random().nextInt(10) < 2) {
      add(WhiteBall(position));
    } else {
      add(Ball(position));
    }
  }
}
