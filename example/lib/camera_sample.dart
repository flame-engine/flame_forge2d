import 'dart:ui';

import 'package:flame_forge2d/body_component.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_forge2d/sprite_body_component.dart';
import 'package:forge2d/forge2d.dart';
import 'package:flame/components.dart';
import 'package:flame/gestures.dart';
import 'package:flame_forge2d/forge2d_game.dart';
import 'package:forge2d_samples/domino_sample.dart';

import 'boundaries.dart';

class CameraSample extends DominoSample {
  bool isClicked = false;
  PositionComponent? component;

  @override
  void onTapDown(TapDownInfo details) {
    final Vector2 position = details.eventPosition.game;
    final pizza = Pizza(position, pizzaImage);
    add(pizza);
    //print(size);
    //print(screenToWorld(size));
    component = pizza.positionComponent;
    isClicked = true;
    //camera.followComponent(pizza.positionComponent, worldBounds: size.toRect());
    //camera.moveTo(Vector2(50, 0));
    //print(camera.position);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (isClicked) {
      isClicked = !isClicked;
      camera.followComponent(component!);
      print(component!.position);
    }
  }
}
