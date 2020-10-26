import 'package:dashbook/dashbook.dart';
import 'package:flame/extensions/size.dart';
import 'package:flame/extensions/vector2.dart';
import 'package:flutter/material.dart';
import 'package:forge2d_samples/circle_stress_sample.dart';

import './sprite_body_sample.dart';
import './contact_callbacks_sample.dart';
import './domino_sample.dart';
import 'blob_sample.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dashbook = Dashbook();

  Vector2 ctxSize(DashbookContext ctx) => ctx.constraints.biggest.toVector2();

  dashbook.storiesOf('Flame with Forge2D').decorator(TopDecorator())
    ..add(
      'Blob sample',
      (DashbookContext ctx) => BlobSample(ctxSize(ctx)).widget,
    )
    ..add(
      'Domino sample',
      (DashbookContext ctx) => DominoSample(ctxSize(ctx)).widget,
    )
    ..add(
      'Contact Callbacks',
      (DashbookContext ctx) => ContactCallbacksSample(ctxSize(ctx)).widget,
    )
    ..add(
      'Circle stress sample',
          (DashbookContext ctx) => CircleStressSample(ctxSize(ctx)).widget,
    )
    ..add(
      'Sprite Bodies',
      (DashbookContext ctx) => SpriteBodySample(ctxSize(ctx)).widget,
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
