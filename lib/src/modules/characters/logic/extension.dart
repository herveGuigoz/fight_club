extension AttributePointSpending on int {
  int skillsPointCosts() => (this / 5).ceil();
}
