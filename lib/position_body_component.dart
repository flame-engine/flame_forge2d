import 'package:flame/components.dart';
import 'package:flutter/cupertino.dart';

import 'body_component.dart';

/// A [PositionBodyComponent] handles a [PositionComponent] on top of a
/// [BodyComponent]. You have to keep track of the size of the
/// [PositionComponent] and it can only have its anchor in the center.
abstract class PositionBodyComponent extends BodyComponent {
  PositionComponent positionComponent;
  Vector2 size;

  /// Make sure that the [size] of the position component matches the bounding
  /// shape of the body that is create in createBody()
  PositionBodyComponent(
    this.positionComponent,
    this.size,
  );

  @mustCallSuper
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    updatePositionComponent();
    positionComponent..anchor = Anchor.center;
    gameRef.add(positionComponent);
  }

  @override
  void update(double dt) {
    super.update(dt);
    updatePositionComponent();
  }

  @override
  void onRemove() {
    super.onRemove();
    // Since the PositionComponent was added to the game in this class it should
    // also be removed by this class when the BodyComponent is removed.
    positionComponent.remove();
  }

  final Vector2 _lastPosition = Vector2.zero();
  final Vector2 _lastScreenPosition = Vector2.zero();
  final Vector2 _lastSize = Vector2.zero();
  double _lastAngle = 0;
  final Vector2 _lastZoomedSize = Vector2.zero();
  double _lastZoom = 0;

  bool maybeUpdateState() {
    bool stateUpdated = false;
    if (body.position != _lastPosition) {
      _lastPosition.setFrom(body.position);
      _lastScreenPosition.setFrom(
        gameRef.worldToScreen(body.position),
      );
      stateUpdated = true;
    }
    if (_lastZoom != gameRef.camera.zoom || size != _lastSize) {
      _lastZoom = gameRef.camera.zoom;
      _lastZoomedSize.setFrom(size * _lastZoom);
      _lastSize.setFrom(size);
      stateUpdated = true;
    }
    if (-body.getAngle() != _lastAngle) {
      _lastAngle = -body.getAngle();
      stateUpdated = true;
    }
    return stateUpdated;
  }

  void updatePositionComponent() {
    if (maybeUpdateState()) {
      positionComponent
        ..position = _lastScreenPosition
        ..angle = _lastAngle
        ..size = _lastZoomedSize;
    }
  }
}
