import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:forge2d/forge2d.dart' hide Timer;

import 'body_component.dart';
import 'camera.dart';
import 'contact_callbacks.dart';

class Forge2DGame extends BaseGame {
  static final Vector2 defaultGravity = Vector2(0.0, -10.0);
  static const double defaultZoom = 1.0;
  final int velocityIterations = 10;
  final int positionIterations = 10;

  late World world;

  @override
  final Forge2DCamera camera = Forge2DCamera();

  final ContactCallbacks _contactCallbacks = ContactCallbacks();

  Forge2DGame({
    Vector2? gravity,
    double scale = defaultZoom,
  }) {
    gravity ??= defaultGravity;
    camera.zoom = defaultZoom;
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

  bool once = true;
  @override
  void update(double dt) {
    super.update(dt);
    world.stepDt(dt, velocityIterations, positionIterations);
    if(once) {
      camera.zoom = 1.0;
      //camera.moveTo(-viewport.effectiveSize/4/camera.zoom);
      camera.snapTo(-viewport.effectiveSize/4);
      once = false;
    }
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
}
