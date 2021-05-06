import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart' hide Draggable;
import 'package:forge2d/forge2d.dart';
import 'package:flame_forge2d/forge2d_game.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/gestures.dart';

import 'balls.dart';
import 'boundaries.dart';

class DraggableSample extends Forge2DGame with HasDraggableComponents {
  @override
  bool debugMode = true;

  DraggableSample()
      : super(
          scale: 4.0,
          gravity: Vector2(0, 0.0),
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final boundaries = createBoundaries(this);
    boundaries.forEach(add);
    add(DraggableBall(viewport.effectiveSize / 2));
  }
}

class DraggableBall extends Ball with Draggable {
  DraggableBall(Vector2 position) : super(position, radius: 20) {
    originalPaint = Paint()..color = Colors.amber;
    paint = originalPaint;
  }

  @override
  bool onDragStart(int pointerId, DragStartInfo details) {
    paint = randomPaint();
    return true;
  }

  @override
  bool onDragUpdate(int pointerId, DragUpdateInfo details) {
    final worldDelta = details.delta.global..multiply(Vector2(1.0, -1.0));
    body.applyLinearImpulse(worldDelta * 1000);
    return true;
  }

  @override
  bool onDragEnd(int pointerId, DragEndInfo details) {
    paint = originalPaint;
    return true;
  }
}
