import 'package:flutter/material.dart';
import 'package:dashbook/dashbook.dart';

import './sprite_body_sample.dart';
import './contact_callbacks_sample.dart';
import './domino_sample.dart';
import 'blob_sample.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dashbook = Dashbook();

  dashbook.storiesOf('Flame with Forge2D').decorator(TopDecorator())
    ..add(
      'Blob sample',
      (DashbookContext ctx) => BlobSample().widget,
    )
    ..add(
      'Domino sample',
      (DashbookContext ctx) => DominoSample().widget,
    )
    ..add(
      'Contact Callbacks',
      (DashbookContext ctx) => ContactCallbacksSample().widget,
    )
    ..add(
      'Sprite Bodies',
      (DashbookContext ctx) => SpriteBodySample().widget,
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