import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/cupertino.dart';
import 'package:forge2d/forge2d.dart';
import 'package:flame_forge2d/forge2d_game.dart';
import 'package:flame/palette.dart';
import 'package:flame/gestures.dart';
import 'package:flame/extensions/offset.dart';
import 'package:flame/components/mixins/dragable.dart';

import 'balls.dart';
import 'boundaries.dart';

class DraggableSample extends Forge2DGame with HasDragableComponents {
  DraggableSample(Vector2 viewportSize)
      : super(
          scale: 4.0,
          gravity: Vector2(0, 0.0),
        ) {
    viewport.resize(viewportSize);
    final boundaries = createBoundaries(viewport);
    boundaries.forEach(add);
    add(DraggableBall(viewport.size / 2));
  }
}

class DraggableBall extends Ball with Dragable {
  DraggableBall(Vector2 position) : super(position, radius: 20) {
    originalPaint = BasicPalette.white.paint;
    paint = originalPaint;
  }

  // TODO: Remove this override once the initial position in draggable is solved
  // on the flame side
  @override
  bool handleReceiveDrag(DragEvent event) {
    // In v1.0.0-rc3 initialPosition doesn't take padding outside
    // the widget into consideration, so the hitbox will be off.
    if (checkOverlap(event.initialPosition.toVector2())) {
      return onReceiveDrag(event);
    }
    return false;
  }

  @override
  bool onReceiveDrag(DragEvent event) {
    paint = randomPaint();
    event.onUpdate = (DragUpdateDetails details) {
      // This is needed since the y-axis is flipped for gravity to make sense
      final worldDelta = details.delta.toVector2()
        ..multiply(Vector2(1.0, -1.0));
      body.applyLinearImpulse(
        worldDelta * 1000,
        body.getLocalCenter(),
        true,
      );
    };
    return true;
  }
}
