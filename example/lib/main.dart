import 'package:flame/game.dart';
import 'package:flutter/widgets.dart' hide Animation;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final Box2DGame game = Box2DGame();
  runApp(game.widget);
}

class Box2DGame extends BaseGame {}
