import 'dart:ui';

import 'package:forge2d/forge2d.dart' hide Timer;
import 'package:flame/game/base_game.dart';

import 'body_component.dart';
import 'contact_callbacks.dart';
import 'viewport.dart';

class Forge2DGame extends BaseGame {
  static final Vector2 defaultGravity = Vector2(0.0, -10.0);
  static const double defaultScale = 1.0;
  final int velocityIterations = 10;
  final int positionIterations = 10;

  World world;
  Viewport viewport;

  final ContactCallbacks _contactCallbacks = ContactCallbacks();

  Forge2DGame({
    dimensions,
    Vector2 gravity,
    double scale = defaultScale,
  }) {
    dimensions ??= window.physicalSize;
    gravity ??= defaultGravity;
    world = World(gravity);
    world.setContactListener(_contactCallbacks);
    viewport = Viewport(dimensions, scale);
  }

  @override
  void update(double dt) {
    super.update(dt);
    world.stepDt(dt, velocityIterations, positionIterations);
  }

  @override
  void resize(Vector2 size) {
    super.resize(size);
    viewport.resize(size);
  }

  @override
  void lifecycleStateChange(AppLifecycleState state) {
    super.lifecycleStateChange(state);

    switch (state) {
      case AppLifecycleState.resumed:
        resumeEngine();
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        pauseEngine();
        break;
    }
  }

  void remove(BodyComponent component) {
    world.destroyBody(component.body);
    component.remove();
  }

  void initializeWorld() {}

  void addContactCallback(ContactCallback callback) {
    _contactCallbacks.register(callback);
  }

  void removeContactCallback(ContactCallback callback) {
    _contactCallbacks.deregister(callback);
  }

  void clearContactCallbacks() {
    _contactCallbacks.clear();
  }

  void cameraFollow(
    BodyComponent component, {
    double horizontal,
    double vertical,
  }) {
    viewport.cameraFollow(
      component,
      horizontal: horizontal,
      vertical: vertical,
    );
  }
}
