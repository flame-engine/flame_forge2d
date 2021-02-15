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
    body = createBody();
    updatePositionComponent();
    positionComponent..anchor = Anchor.center;
    gameRef.add(positionComponent);
  }

  void updatePositionComponent() {
    positionComponent
      ..position = viewport.getWorldToScreen(body.position)
      ..angle = -body.getAngle()
      ..size = size * viewport.scale;
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
}
