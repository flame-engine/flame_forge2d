import 'dart:ui';

import 'package:box2d_flame/box2d.dart' hide Timer, Vector2;
import 'package:flame/components/component.dart';
import 'package:flame/extensions/vector2.dart';

import 'box2d_game.dart';
import 'viewport.dart';

abstract class BodyComponent extends Component {
  static const maxPolygonVertices = 10;

  final Box2DGame game;
  Body body;
  bool _shouldRemove = false;

  BodyComponent(this.game) {
    body = createBody();
  }

  Body createBody();

  World get world => game.world;
  Viewport get viewport => game.viewport;

  void remove() => _shouldRemove = true;

  @override
  bool loaded() => body.isActive();

  @override
  bool destroy() => _shouldRemove;

  @override
  void update(double t) {
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
          throw Exception('not implemented');
          break;
        case ShapeType.POLYGON:
          _renderPolygon(canvas, fixture);
          break;
      }
    }
  }

  Vector2 get center => body.worldCenter;

  void _renderChain(Canvas canvas, Fixture fixture) {
    final ChainShape chainShape = fixture.getShape();
    final List<Vector2> vertices = List<Vector2>(chainShape.getVertexCount());

    for (int i = 0; i < chainShape.getVertexCount(); ++i) {
      vertices[i] = body.getWorldPoint(chainShape.getVertex(i));
      vertices[i] = viewport.getWorldToScreen(vertices[i]);
    }

    final List<Offset> points = [];
    for (int i = 0; i < chainShape.getVertexCount(); i++) {
      points.add(Offset(vertices[i].x, vertices[i].y));
    }

    renderChain(canvas, points);
  }

  void renderChain(Canvas canvas, List<Offset> points) {
    final Paint paint = Paint()
      ..color = const Color.fromARGB(255, 255, 255, 255);
    final path = Path()..addPolygon(points, true);
    canvas.drawPath(path, paint);
  }

  void _renderCircle(Canvas canvas, Fixture fixture) {
    var center = Vector2.zero();
    final CircleShape circle = fixture.getShape();
    center = body.getWorldPoint(circle.position);
    center = viewport.getWorldToScreen(center);
    renderCircle(
        canvas, center.toOffset(), circle.radius * viewport.scale);
  }

  void renderCircle(Canvas canvas, Offset center, double radius) {
    final Paint paint = Paint()
      ..color = const Color.fromARGB(255, 255, 255, 255);
    canvas.drawCircle(center, radius, paint);
  }

  void _renderPolygon(Canvas canvas, Fixture fixture) {
    final PolygonShape polygon = fixture.getShape();
    assert(polygon.count <= maxPolygonVertices);
    final List<Vector2> vertices = List<Vector2>(polygon.count);

    for (int i = 0; i < polygon.count; ++i) {
      vertices[i] = body.getWorldPoint(polygon.vertices[i]);
      vertices[i] = viewport.getWorldToScreen(vertices[i]);
    }

    final List<Offset> points = [];
    for (int i = 0; i < polygon.count; i++) {
      points.add(Offset(vertices[i].x, vertices[i].y));
    }

    renderPolygon(canvas, points);
  }

  void renderPolygon(Canvas canvas, List<Offset> points) {
    final path = Path()..addPolygon(points, true);
    final Paint paint = Paint()
      ..color = const Color.fromARGB(255, 255, 255, 255);
    canvas.drawPath(path, paint);
  }
}
