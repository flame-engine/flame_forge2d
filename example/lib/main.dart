import 'package:dashbook/dashbook.dart';
import 'package:flame/game.dart';
import 'package:flame/extensions/size.dart';
import 'package:flame/extensions/vector2.dart';
import 'package:flutter/material.dart';
import 'package:forge2d_samples/draggable_sample.dart';
import 'package:forge2d_samples/tapable_sample.dart';

import './sprite_body_sample.dart';
import './contact_callbacks_sample.dart';
import './domino_sample.dart';
import 'blob_sample.dart';
import 'circle_stress_sample.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dashbook = Dashbook();

  Vector2 ctxSize(DashbookContext ctx) => ctx.constraints.biggest.toVector2();

  dashbook.storiesOf('Flame with Forge2D').decorator(TopDecorator())
    ..add(
      'Blob sample',
      (DashbookContext ctx) => GameWidget(game: BlobSample(ctxSize(ctx))),
    )
    ..add(
      'Domino sample',
      (DashbookContext ctx) => GameWidget(game: DominoSample(ctxSize(ctx))),
    )
    ..add(
      'Contact Callbacks',
      (DashbookContext ctx) =>
          GameWidget(game: ContactCallbacksSample(ctxSize(ctx))),
    )
    ..add(
      'Circle stress sample',
      (DashbookContext ctx) =>
          GameWidget(game: CircleStressSample(ctxSize(ctx))),
    )
    ..add(
      'Sprite Bodies',
      (DashbookContext ctx) => GameWidget(game: SpriteBodySample(ctxSize(ctx))),
    )
    ..add(
      'Tapable Body',
          (DashbookContext ctx) => GameWidget(game: TapableSample(ctxSize(ctx))),
    )
    ..add(
      'Draggable Body',
          (DashbookContext ctx) => GameWidget(game: DraggableSample(ctxSize(ctx))),
    );
  runApp(dashbook);
}

class TopDecorator extends Decorator {
  @override
  Widget decorate(Widget child) {
    return Align(
      child: child,
      alignment: Alignment.topCenter,
    );
  }
}
