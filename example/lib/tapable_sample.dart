import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:forge2d/forge2d.dart';
import 'package:flame_forge2d/forge2d_game.dart';
import 'package:flame/palette.dart';
import 'package:flame/components/mixins/tapable.dart';

import 'balls.dart';
import 'boundaries.dart';

class TapableSample extends Forge2DGame with HasTapableComponents {
  @override
  bool debugMode() => true;

  TapableSample(Vector2 viewportSize)
      : super(
          scale: 4.0,
          gravity: Vector2(0, -10.0),
        ) {
    viewport.resize(viewportSize);
    final boundaries = createBoundaries(viewport);
    boundaries.forEach(add);
    add(TapableBall(viewport.size / 2));
  }
}

class TapableBall extends Ball with Tapable {
  TapableBall(Vector2 position) : super(position) {
    originalPaint = BasicPalette.white.paint;
    paint = originalPaint;
  }

  @override
  bool onTapDown(TapDownDetails details) {
    body.applyLinearImpulse(Vector2.random() * 10000);
    paint = randomPaint();
    return false;
  }
}
