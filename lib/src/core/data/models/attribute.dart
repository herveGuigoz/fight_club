import 'dart:math';

import 'package:meta/meta.dart';

/// Character's trait interface.
@immutable
abstract class Attribute {
  /// Initialize [points]
  const Attribute(this.points);

  /// Current value of this attribute.
  /// Must be a positive number.
  final int points;

  /// Clone attribute with different value.
  Attribute copyWith({int? points});

  /// Text representation for this attribute.
  String label();

  /// Compute numbers of skills the character must substract for upgrading this
  /// attribute by one.
  int get skillsCost => max(1, (points / 5).ceil());

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Attribute && other.points == points;
  }

  @override
  int get hashCode => points.hashCode;
}

/// Character's health trait. Will be regenerated after each fight.
class Health extends Attribute {
  /// Initialize health [points]
  const Health(int points) : super(points);

  @override
  int get skillsCost => 1;

  @override
  Health copyWith({int? points}) => Health(points ?? this.points);

  @override
  String label() => 'Health';

  @override
  String toString() => 'Health($points)';
}

/// A character's trait to compute the damage during a fight.
class Attack extends Attribute {
  /// Initialize attack [points]
  const Attack(int points) : super(points);

  @override
  Attack copyWith({int? points}) => Attack(points ?? this.points);

  @override
  String label() => 'Attack';

  @override
  String toString() => 'Attack($points)';
}

/// A character's trait to reduce the damage during a fight.
class Defense extends Attribute {
  /// Initialize defense [points]
  const Defense(int points) : super(points);

  @override
  Defense copyWith({int? points}) => Defense(points ?? this.points);

  @override
  String label() => 'Defense';

  @override
  String toString() => 'Defense($points)';
}

/// A character trait that can increase the damage during a fight
class Magik extends Attribute {
  /// Initialize magik [points]
  const Magik(int points) : super(points);

  @override
  Magik copyWith({int? points}) => Magik(points ?? this.points);

  @override
  String label() => 'Magik';

  @override
  String toString() => 'Magik($points)';
}
