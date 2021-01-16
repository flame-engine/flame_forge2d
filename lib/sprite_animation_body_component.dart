import 'dart:ui';

import 'package:flame/anchor.dart';
import 'package:flame/components/position_component.dart';
import 'package:flame/components/sprite_animation_component.dart';
import 'package:flame/components/sprite_component.dart';
import 'package:flame/spritesheet.dart';
import 'package:flame_forge2d/body_component.dart';
import 'package:forge2d/forge2d.dart';

/// Abstraction of body component to use it with Forge2D with animated sprite.
/// Looks like [SpriteBodyComponent] but with SpriteAnimationComponent inside.
/// You can use animations with [startAnimation] method or you can set up
/// static sprite with [stopAnimation] to display rest state if need.
abstract class SpriteAnimationBodyComponent extends BodyComponent {
  /// Child component that draws ui. It's a [SpriteComponent] or [SpriteAnimationComponent].
  PositionComponent spriteComponent;

  /// Sprite sheet which uses to display image
  SpriteSheet sheet;

  /// Size of sprite component
  Vector2 size;

  /// Anchor point for this component. This is where flame "grabs it".
  Anchor anchor = Anchor.center;

  @override
  bool debugMode = false;

  /// Make sure that the [size] of the sprite matches the bounding shape of the
  /// body that is create in createBody().
  ///
  /// If you use default constructor, don't forget to call [startAnimation] or
  /// [stopAnimation] to set up the sprite and component, otherwise you will not
  /// see anything.
  /// '''
  /// SpriteAnimationBodyComponent(sheet, size)..stopAnimation(0, 0);
  /// or
  /// SpriteAnimationBodyComponent(sheet, size)..startAnimation(0, duration);
  /// '''dart
  SpriteAnimationBodyComponent(this.sheet, this.size, {Anchor anchor}) {
    if (anchor != null) this.anchor = anchor;
  }

  /// Create component with animation at the start.
  /// Animation specified with [startAnimRow] of sprite and [stepTime].
  ///
  /// If need, you can call basic constructor and call [startAnimation] like
  /// '''
  /// SpriteAnimationBodyComponent(sheet, size)..startAnimation(0, duration);
  /// '''dart
  SpriteAnimationBodyComponent.animated(
      this.sheet,
      this.size,
      int startAnimRow,
      Duration stepTime, {
        Anchor anchor,
        bool loop = true,
        bool removeOnFinish = false,
        Function completeCallback,
      }) {
    if (anchor != null) this.anchor = anchor;
    startAnimation(
      startAnimRow,
      stepTime,
      loop: loop,
      removeOnFinish: removeOnFinish,
      completeCallback: completeCallback,
    );
  }

  /// Create component without animation at the start with sprite specified with
  /// [row] and [column].
  ///
  /// If need, you can call basic constructor and call [stopAnimation] like
  /// '''
  /// SpriteAnimationBodyComponent(sheet, size)..stopAnimation(0, 0);
  /// '''dart
  SpriteAnimationBodyComponent.rest(this.sheet, this.size,
      {int row = 0, int column = 0, Anchor anchor}) {
    if (anchor != null) this.anchor = anchor;
    stopAnimation(row, column);
  }

  @override
  void update(double dt) {
    super.update(dt);
    spriteComponent?.update(dt);
  }

  @override
  void render(Canvas c) {
    super.render(c);
    final screenPosition = viewport.getWorldToScreen(body.position);

    if (spriteComponent == null) return;
    spriteComponent
      ..angle = -body.getAngle()
      ..size = size * viewport.scale
      ..x = screenPosition.x
      ..y = screenPosition.y;

    spriteComponent.render(c);
  }

  /// Start animation with removing old component and run sprite animation.
  /// [row] is the row of sprite which should be animated.
  /// [stepTime] is time between two frames.
  /// [loop] - flag for animation is this should be played without pause
  /// [removeOnFinish] - flag for sprite animation component which will remove
  ///   component from the tree after animation completes.
  /// [completeCallback] - callback that will be called after animation completes
  /// if it's not looped. Callback WILL NOT BE called if [loop] is true.
  ///
  /// If [loop] is false, then animation will be stopped on last frame. To change
  /// it to rest state, add [completeCallback] where you will call [stopAnimation]
  /// or [startAnimation].
  /// '''
  /// component.startAnimation(0, duration, loop: false, completeCallback:
  ///   () => component.stopAnimation()
  /// );
  /// '''dart
  void startAnimation(
      int row,
      Duration stepTime, {
        bool loop = true,
        bool removeOnFinish = false,
        Function completeCallback,
      }) {
    spriteComponent?.remove();

    final a = sheet.createAnimation(
      row: row,
      stepTime: stepTime.inMilliseconds / Duration.millisecondsPerSecond,
      loop: loop,
    );
    if (!loop && completeCallback != null) {
      a.onComplete = () => completeCallback();
    }

    spriteComponent =
    SpriteAnimationComponent(size, a, removeOnFinish: removeOnFinish)
      ..anchor = anchor;
  }

  /// Stop animation with removing old component and set up simple sprite that
  /// specified with [row] and  [column].
  /// After call this method, sprite will display simple sprite with rest state.
  void stopAnimation([int row = 0, int column = 0]) {
    spriteComponent?.remove();
    spriteComponent =
    SpriteComponent.fromSprite(size, sheet.getSprite(row, column))
      ..anchor = anchor;
  }
}
