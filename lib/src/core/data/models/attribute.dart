import 'dart:math';

abstract class Attribute {
  const Attribute(this.points);

  final int points;

  Attribute copyWith({int? points});

  String label();

  int get skillsPointCosts => max(1, (points / 5).ceil());

  int operator -(int by) => points - by;
  int operator +(int by) => points + by;
  bool operator >(Attribute other) => points > other.points;
  bool operator >=(Attribute other) => points >= other.points;
  bool operator <(Attribute other) => points < other.points;
  bool operator <=(Attribute other) => points <= other.points;

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
  Health copyWith({int? points}) => Health(points ?? this.points);

  @override
  String label() => 'Health';

  @override
  String toString() => 'Health($points)';
}

class Attack extends Attribute {
  const Attack(int points) : super(points);

  @override
  Attack copyWith({int? points}) => Attack(points ?? this.points);

  @override
  String label() => 'Attack';

  @override
  String toString() => 'Attack($points)';
}

class Defense extends Attribute {
  const Defense(int points) : super(points);

  @override
  Defense copyWith({int? points}) => Defense(points ?? this.points);

  @override
  String label() => 'Defense';

  @override
  String toString() => 'Defense($points)';
}

class Magik extends Attribute {
  const Magik(int points) : super(points);

  @override
  Magik copyWith({int? points}) => Magik(points ?? this.points);

  @override
  String label() => 'Magik';

  @override
  String toString() => 'Magik($points)';
}
