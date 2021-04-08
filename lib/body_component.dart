import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:forge2d/forge2d.dart' hide Timer, Vector2;

import 'camera.dart';
import 'forge2d_game.dart';

/// Since a pure BodyComponent doesn't have anything drawn on top of it,
/// it is a good idea to turn on [debugMode] for it so that the bodies can be
/// seen
abstract class BodyComponent<T extends Forge2DGame> extends BaseComponent
    with HasGameRef<T> {
  static const maxPolygonVertices = 8;
  static const defaultColor = const Color.fromARGB(255, 255, 255, 255);

  late Body body;
  late Paint paint;

  BodyComponent({Paint? paint}) {
    this.paint = paint ?? Paint()
      ..color = defaultColor;
  }

  /// You should create the [Body] in this method when you extend
  /// the BodyComponent
  Body createBody();

  @mustCallSuper
  @override
  Future<void> onLoad() async {
    body = createBody();
  }

  World get world => gameRef.world;
  Forge2DCamera get camera => gameRef.camera;

  @override
  void renderDebugMode(Canvas canvas) {
    for (Fixture fixture in body.fixtures) {
      switch (fixture.type) {
        case ShapeType.chain:
          _renderChain(canvas, fixture);
          break;
        case ShapeType.circle:
          _renderCircle(canvas, fixture);
          break;
        case ShapeType.edge:
          _renderEdge(canvas, fixture);
          break;
        case ShapeType.polygon:
          _renderPolygon(canvas, fixture);
          break;
      }
    }
  }

  Vector2 get center => body.worldCenter;

  void _renderChain(Canvas canvas, Fixture fixture) {
    final ChainShape chainShape = fixture.shape as ChainShape;
    final List<Offset> points = [];
    for (final vertex in chainShape.vertices) {
      points.add(_vertexToScreen(vertex));
    }
    renderChain(canvas, points);
  }

  void renderChain(Canvas canvas, List<Offset> points) {
    final path = Path()..addPolygon(points, true);
    canvas.drawPath(path, paint);
  }

  void _renderCircle(Canvas canvas, Fixture fixture) {
    final CircleShape circle = fixture.shape as CircleShape;
    final center = _vertexToScreen(circle.position);
    renderCircle(canvas, center, circle.radius * camera.zoom);
  }

  void renderCircle(Canvas canvas, Offset center, double radius) {
    canvas.drawCircle(center, radius, paint);
  }

  void _renderPolygon(Canvas canvas, Fixture fixture) {
    final PolygonShape polygon = fixture.shape as PolygonShape;
    assert(polygon.vertices.length <= maxPolygonVertices);

    final List<Offset> points = [];
    for (final vertex in polygon.vertices) {
      points.add(_vertexToScreen(vertex));
    }

    renderPolygon(canvas, points);
  }

  void renderPolygon(Canvas canvas, List<Offset> points) {
    final path = Path()..addPolygon(points, true);

    canvas.drawPath(path, paint);
  }

  void _renderEdge(Canvas canvas, Fixture fixture) {
    final edge = fixture.shape as EdgeShape;
    final p1 = _vertexToScreen(edge.vertex1);
    final p2 = _vertexToScreen(edge.vertex2);
    renderEdge(canvas, p1, p2);
  }

  void renderEdge(Canvas canvas, Offset p1, Offset p2) {
    canvas.drawLine(p1, p2, paint);
  }

  Offset _vertexToScreen(Vector2 vertex) {
    return camera
        .worldToScreen(
          body.getWorldPoint(vertex),
        )
        .toOffset();
  }

  @override
  bool containsPoint(Vector2 point) {
    final worldPoint = camera.screenToWorld(point);
    for (Fixture fixture in body.fixtures) {
      if (fixture.testPoint(worldPoint)) {
        return true;
      }
    }
    return false;
  }
}
