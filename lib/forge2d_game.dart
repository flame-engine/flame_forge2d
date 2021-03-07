import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:forge2d/forge2d.dart' hide Timer;

import 'body_component.dart';
import 'contact_callbacks.dart';
import 'viewport.dart';

class Forge2DGame extends BaseGame {
  static final Vector2 defaultGravity = Vector2(0.0, -10.0);
  static const double defaultScale = 1.0;
  final int velocityIterations = 10;
  final int positionIterations = 10;

  late World world;
  late Viewport viewport;

  WorldViewport get worldViewport => viewport as WorldViewport;

  final ContactCallbacks _contactCallbacks = ContactCallbacks();

  Forge2DGame({
    Vector2? gravity,
    double scale = defaultScale,
    WorldViewport? viewport,
  }) : this.viewport = viewport ?? Forge2DDefaultViewport(scale) {
    gravity ??= defaultGravity;
    world = World(gravity);
    world.setContactListener(_contactCallbacks);
  }

  @override
  Future<void> add(Component component) async {
    await super.add(component);
    if (component is BodyComponent) {
      component.debugMode = debugMode;
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    world.stepDt(dt, velocityIterations, positionIterations);
  }

  @override
  void onResize(Vector2 size) {
    super.onResize(size);
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

  @override
  void remove(Component component) {
    super.remove(component);
    if (component is BodyComponent) {
      world.destroyBody(component.body);
      component.remove();
    }
  }

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
    double horizontal = -1,
    double vertical = -1,
  }) {
    (viewport as WorldViewport).cameraFollow(
      component,
      horizontal: horizontal,
      vertical: vertical,
    );
  }
}
