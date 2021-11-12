import 'package:theme/src/icons.dart';

/// {@template Avatar}
/// Icons build from svg using [PathIcon]
/// {@endtemplate}
abstract class Avatar {
  /// {@macro Avatar}
  const Avatar(this.name, this.icon);

  /// Anonymous icon
  factory Avatar.anonymous() = Anonymous;

  /// Bender icon
  factory Avatar.bender() = Bender;

  /// Brutus icon
  factory Avatar.brutus() = Brutus;

  /// BuzzLightyear icon
  factory Avatar.buzzLightyear() = BuzzLightyear;

  /// Frankensteins icon
  factory Avatar.frankensteins() = Frankensteins;

  /// Homer icon
  factory Avatar.homer() = Homer;

  /// Ninja icon
  factory Avatar.ninja() = Ninja;

  /// Stormtrooper icon
  factory Avatar.stormtrooper() = Stormtrooper;

  /// WalterWhite icon
  factory Avatar.walterWhite() = WalterWhite;

  /// Yoda icon
  factory Avatar.yoda() = Yoda;

  /// avatar's name
  final String name;

  /// avatar's svg
  final PathIconData icon;

  /// Iterable of all available icons
  static final all = <Avatar>[
    Avatar.anonymous(),
    Avatar.bender(),
    Avatar.brutus(),
    Avatar.buzzLightyear(),
    Avatar.frankensteins(),
    Avatar.homer(),
    Avatar.ninja(),
    Avatar.stormtrooper(),
    Avatar.walterWhite(),
    Avatar.yoda(),
  ];
}

/// {@nodoc}
class Anonymous extends Avatar {
  /// {@nodoc}
  Anonymous() : super('Anonymous', PathIcons.anonymous);
}

/// {@nodoc}
class Bender extends Avatar {
  /// {@nodoc}
  Bender() : super('Bender', PathIcons.bender);
}

/// {@nodoc}
class Brutus extends Avatar {
  /// {@nodoc}
  Brutus() : super('Brutus', PathIcons.brutus);
}

/// {@nodoc}
class BuzzLightyear extends Avatar {
  /// {@nodoc}
  BuzzLightyear() : super('Buzz Lightyear', PathIcons.buzzLightyear);
}

/// {@nodoc}
class Frankensteins extends Avatar {
  /// {@nodoc}
  Frankensteins() : super('Frankensteins', PathIcons.frankensteins);
}

/// {@nodoc}
class Homer extends Avatar {
  /// {@nodoc}
  Homer() : super('Homer', PathIcons.homer);
}

/// {@nodoc}
class Ninja extends Avatar {
  /// {@nodoc}
  Ninja() : super('Ninja', PathIcons.ninja);
}

/// {@nodoc}
class Stormtrooper extends Avatar {
  /// {@nodoc}
  Stormtrooper() : super('Stormtrooper', PathIcons.stormtrooper);
}

/// {@nodoc}
class WalterWhite extends Avatar {
  /// {@nodoc}
  WalterWhite() : super('Walter White', PathIcons.walterWhite);
}

/// {@nodoc}
class Yoda extends Avatar {
  /// {@nodoc}
  Yoda() : super('Yoda', PathIcons.yoda);
}
