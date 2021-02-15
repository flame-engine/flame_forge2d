import 'package:dashbook/dashbook.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:forge2d_samples/draggable_sample.dart';
import 'package:forge2d_samples/mouse_joint_sample.dart';
import 'package:forge2d_samples/position_body_sample.dart';
import 'package:forge2d_samples/tapable_sample.dart';

import './sprite_body_sample.dart';
import './contact_callbacks_sample.dart';
import './domino_sample.dart';
import 'blob_sample.dart';
import 'circle_stress_sample.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dashbook = Dashbook();

  dashbook.storiesOf('Flame with Forge2D').decorator(TopDecorator())
    ..add(
      'Blob sample',
      (DashbookContext ctx) => GameWidget(game: BlobSample()),
    )
    ..add(
      'Domino sample',
      (DashbookContext ctx) => GameWidget(game: DominoSample()),
    )
    ..add(
      'Contact Callbacks',
      (DashbookContext ctx) => GameWidget(game: ContactCallbacksSample()),
    )
    ..add(
      'Circle stress sample',
      (DashbookContext ctx) => GameWidget(game: CircleStressSample()),
    )
    ..add(
      'Sprite Bodies',
      (DashbookContext ctx) => GameWidget(game: SpriteBodySample()),
    )
    ..add(
      'PositionBodyComponent',
      (DashbookContext ctx) => GameWidget(game: PositionBodySample()),
    )
    ..add(
      'Tapable Body',
      (DashbookContext ctx) => GameWidget(game: TapableSample()),
    )
    ..add(
      'Draggable Body',
      (DashbookContext ctx) => GameWidget(game: DraggableSample()),
    )
    ..add(
      'Mouse Joint',
      (DashbookContext ctx) => GameWidget(game: MouseJointSample()),
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
