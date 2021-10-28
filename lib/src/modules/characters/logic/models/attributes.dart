import 'dart:math';

abstract class Attribute {
  const Attribute(this.points);

  final int points;

  int get skillsPointCosts => max(1, (points / 5).ceil());

  int operator -(int by) => points - by;
  int operator +(int by) => points + by;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Attribute && other.points == points;
  }

  @override
  int get hashCode => points.hashCode;
}

class Health extends Attribute {
  const Health(int points) : super(points);

  @override
  int get skillsPointCosts => 1;

  @override
  String toString() => 'Health($points)';
}

class Attack extends Attribute {
  const Attack(int points) : super(points);

  @override
  String toString() => 'Attack($points)';
}

class Defense extends Attribute {
  const Defense(int points) : super(points);

  @override
  String toString() => 'Defense($points)';
}

class Magik extends Attribute {
  const Magik(int points) : super(points);

  @override
  String toString() => 'Magik($points)';
}
