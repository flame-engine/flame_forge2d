import 'dart:ui';

import 'package:flame/components/mixins/has_game_ref.dart';
import 'package:forge2d/forge2d.dart' hide Timer, Vector2;
import 'package:flame/components/component.dart';
import 'package:flame/extensions/vector2.dart';

import 'forge2d_game.dart';
import 'viewport.dart';

abstract class BodyComponent extends Component with HasGameRef<Forge2DGame> {
  static const maxPolygonVertices = 10;
  static const defaultColor = const Color.fromARGB(255, 255, 255, 255);

  Body body;
  Paint paint;

  BodyComponent({this.paint}) {
    paint ??= Paint()..color = defaultColor;
  }

  /// You should create the [Body] in this method when you extend
  /// the BodyComponent
  Body createBody();

  World get world => gameRef.world;
  Viewport get viewport => gameRef.viewport;

  @override
  bool get loaded => body.isActive();

  @override
  void update(double dt) {
    super.update(dt);
    // usually all update will be handled by the world physics
  }

  @override
  void render(Canvas canvas) {
    body.getFixtureList();
    for (Fixture fixture = body.getFixtureList();
        fixture != null;
        fixture = fixture.getNext()) {
      switch (fixture.getType()) {
        case ShapeType.CHAIN:
          _renderChain(canvas, fixture);
          break;
        case ShapeType.CIRCLE:
          _renderCircle(canvas, fixture);
          break;
        case ShapeType.EDGE:
          _renderEdge(canvas, fixture);
          break;
        case ShapeType.POLYGON:
          _renderPolygon(canvas, fixture);
          break;
      }
    }
  }

  Vector2 get center => body.worldCenter;

  void _renderChain(Canvas canvas, Fixture fixture) {
    assert(viewport != null, "Needs the viewport set to be able to render");
    final ChainShape chainShape = fixture.getShape();
    final List<Offset> points = [];
    for (int i = 0; i < chainShape.vertexCount; i++) {
      points.add(_vertexToScreen(chainShape.getVertex(i)));
    }
    renderChain(canvas, points);
  }

  void renderChain(Canvas canvas, List<Offset> points) {
    final path = Path()..addPolygon(points, true);
    canvas.drawPath(path, paint);
  }

  void _renderCircle(Canvas canvas, Fixture fixture) {
    assert(viewport != null, "Needs the viewport set to be able to render");
    final CircleShape circle = fixture.getShape();
    final center = _vertexToScreen(circle.position);
    renderCircle(canvas, center, circle.radius * viewport.scale);
  }

  void renderCircle(Canvas canvas, Offset center, double radius) {
    canvas.drawCircle(center, radius, paint);
  }

  void _renderPolygon(Canvas canvas, Fixture fixture) {
    assert(viewport != null, "Needs the viewport set to be able to render");
    final PolygonShape polygon = fixture.getShape();
    assert(polygon.count <= maxPolygonVertices);

    final List<Offset> points = [];
    for (int i = 0; i < polygon.count; i++) {
      points.add(_vertexToScreen(polygon.vertices[i]));
    }

    renderPolygon(canvas, points);
  }

  void renderPolygon(Canvas canvas, List<Offset> points) {
    final path = Path()..addPolygon(points, true);
    canvas.drawPath(path, paint);
  }

  void _renderEdge(Canvas canvas, Fixture fixture) {
    final edge = fixture.getShape() as EdgeShape;
    final p1 = _vertexToScreen(edge.vertex1);
    final p2 = _vertexToScreen(edge.vertex2);
    renderEdge(canvas, p1, p2);
  }

  void renderEdge(Canvas canvas, Offset p1, Offset p2) {
    canvas.drawLine(p1, p2, paint);
  }

  Offset _vertexToScreen(Vector2 vertex) {
    return viewport.getWorldToScreen(body.getWorldPoint(vertex)).toOffset();
  }
}
