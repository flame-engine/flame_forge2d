import 'package:flutter/material.dart';
import 'package:dashbook/dashbook.dart';

import './sprite_body_sample.dart';
import './contact_callbacks_sample.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dashbook = Dashbook();

  dashbook.storiesOf('Flame and Forge2D').decorator(CenterDecorator())
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
