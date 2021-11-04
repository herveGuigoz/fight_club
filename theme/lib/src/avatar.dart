import 'package:theme/src/icons.dart';

abstract class Avatar {
  const Avatar(this.name, this.icon);

  factory Avatar.anonymous() = Anonymous;
  factory Avatar.bender() = Bender;
  factory Avatar.brutus() = Brutus;
  factory Avatar.buzzLightyear() = BuzzLightyear;
  factory Avatar.frankensteins() = Frankensteins;
  factory Avatar.homer() = Homer;
  factory Avatar.ninja() = Ninja;
  factory Avatar.stormtrooper() = Stormtrooper;
  factory Avatar.walterWhite() = WalterWhite;
  factory Avatar.yoda() = Yoda;

  final String name;
  final PathIconData icon;

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

class Anonymous extends Avatar {
  Anonymous() : super('Anonymous', PathIcons.anonymous);
}

class Bender extends Avatar {
  Bender() : super('Bender', PathIcons.bender);
}

class Brutus extends Avatar {
  Brutus() : super('Brutus', PathIcons.brutus);
}

class BuzzLightyear extends Avatar {
  BuzzLightyear() : super('Buzz Lightyear', PathIcons.buzzLightyear);
}

class Frankensteins extends Avatar {
  Frankensteins() : super('Frankensteins', PathIcons.frankensteins);
}

class Homer extends Avatar {
  Homer() : super('Homer', PathIcons.homer);
}

class Ninja extends Avatar {
  Ninja() : super('Ninja', PathIcons.ninja);
}

class Stormtrooper extends Avatar {
  Stormtrooper() : super('Stormtrooper', PathIcons.stormtrooper);
}

class WalterWhite extends Avatar {
  WalterWhite() : super('Walter White', PathIcons.walterWhite);
}

class Yoda extends Avatar {
  Yoda() : super('Yoda', PathIcons.yoda);
}
