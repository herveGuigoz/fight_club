abstract class Attribute {
  const Attribute(this.value);

  final int value;

  int get skillsPointCosts => (value / 5).ceil();

  bool canBeIncremented(int skills) => skills > skillsPointCosts;

  // ?
  int operator -(int count) => value - count;
  int operator +(int count) => value + count;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Attribute && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;
}

class Health extends Attribute {
  const Health(int value) : super(value);

  @override
  int get skillsPointCosts => 1;

  @override
  String toString() => 'Health($value)';
}

class Attack extends Attribute {
  const Attack(int value) : super(value);

  @override
  String toString() => 'Attack($value)';
}

class Defense extends Attribute {
  const Defense(int value) : super(value);

  @override
  String toString() => 'Defense($value)';
}

class Magik extends Attribute {
  const Magik(int value) : super(value);

  @override
  String toString() => 'Magik($value)';
}
