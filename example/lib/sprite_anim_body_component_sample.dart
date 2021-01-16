import 'package:flame/extensions/vector2.dart';
import 'package:flame/gestures.dart';
import 'package:flame_forge2d/forge2d_game.dart';
import 'package:flame/spritesheet.dart';
import 'package:flame_forge2d/sprite_animation_body_component.dart';
import 'package:forge2d/forge2d.dart';
import 'package:vector_math/vector_math_64.dart';

class LamaComponent extends SpriteAnimationBodyComponent {
  final Vector2 startPosition;
  bool isJumping = false;

  LamaComponent(SpriteSheet sheet, this.startPosition)
      : super.rest(sheet, Vector2.all(24));

  @override
  Body createBody() {
    final def = BodyDef()
      ..userData = this
      ..position = startPosition
      ..type = BodyType.STATIC;
    return world.createBody(def);
  }

  void jump() {
    if (!isJumping) {
      isJumping = true;
      startAnimation(
        0,
        Duration(milliseconds: 80),
        loop: false,
        completeCallback: () {
          isJumping = false;
          stay();
        },
      );
    }
  }

  void stay() {
    stopAnimation();
  }
}

class LamaGame extends Forge2DGame with TapDetector {
  LamaComponent _lama;

  LamaGame() : super(scale: 4.0);

  @override
  Future<void> onLoad() async {
    final i = await images.load('lama.png');
    _lama = LamaComponent(
      SpriteSheet(image: i, srcSize: Vector2.all(48)),
      Vector2(0, 0),
    );
    add(_lama);
  }

  @override
  void onTapUp(v) {
    _lama.jump();
  }
}
