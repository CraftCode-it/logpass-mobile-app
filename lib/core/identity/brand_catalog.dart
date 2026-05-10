import 'package:logpass_me/domain/identity/identity_field.dart';

class BrandCatalog {
  static const customValue = 'Inna wartość...';

  static const alcoholCategories = [
    'piwo',
    'wino',
    'whisky',
    'wódka',
    'rum',
    'gin',
    'likier',
    'bez preferencji',
    customValue,
  ];

  static const alcoholBrandsByCategory = <String, List<String>>{
    'piwo': ['Tyskie', 'Żywiec', 'Lech', 'Heineken', customValue],
    'wino': ['Carlo Rossi', "Jacob's Creek", 'Martini', customValue],
    'whisky': [
      "Jack Daniel's",
      'Jameson',
      'Glenfiddich',
      "Ballantine's",
      'Johnnie Walker',
      customValue,
    ],
    'wódka': ['Soplica', 'Wyborowa', customValue],
    'rum': ['Bacardi', 'Captain Morgan', customValue],
    'gin': ['Bombay Sapphire', "Gordon's", customValue],
    'likier': ['Baileys', 'Jägermeister', customValue],
  };

  static const alcoholBrands = [
    'Tyskie',
    'Żywiec',
    'Lech',
    'Heineken',
    'Carlo Rossi',
    "Jacob's Creek",
    'Martini',
    'Soplica',
    'Wyborowa',
    "Jack Daniel's",
    'Jameson',
    'Glenfiddich',
    "Ballantine's",
    'Johnnie Walker',
    customValue,
  ];

  static const tobaccoCategories = [
    'papierosy',
    'podgrzewacze',
    'e-papierosy',
    'cygara',
    'tytoń',
    'bez preferencji',
    customValue,
  ];

  static const cigaretteBrands = [
    'Marlboro',
    'L&M',
    'Camel',
    'Lucky Strike',
    'Chesterfield',
    'Davidoff',
    'Winston',
    'IQOS',
    'Ploom',
    'Glo',
    'bez preferencji',
    customValue,
  ];

  static const tobaccoBrandsByCategory = <String, List<String>>{
    'papierosy': [
      'Marlboro',
      'L&M',
      'Camel',
      'Lucky Strike',
      'Chesterfield',
      'Davidoff',
      'Winston',
      customValue,
    ],
    'podgrzewacze': ['IQOS', 'Ploom', 'Glo', customValue],
    'e-papierosy': ['Vuse', 'RELX', customValue],
    'cygara': ['Cohiba', 'Montecristo', customValue],
    'tytoń': ['Mac Baren', 'Amber Leaf', customValue],
  };

  static const optInValues = ['zgoda', 'odmowa'];

  static List<String>? valuesFor(String fieldKey) {
    switch (fieldKey) {
      case IdentityFieldKey.adultContentOptIn:
        return optInValues;
      case IdentityFieldKey.alcoholCategory:
        return alcoholCategories;
      case IdentityFieldKey.alcoholBrand:
        return alcoholBrands;
      case IdentityFieldKey.cigaretteBrand:
        return cigaretteBrands;
      case IdentityFieldKey.tobaccoCategory:
        return tobaccoCategories;
      default:
        return null;
    }
  }

  static List<String> alcoholBrandsForCategory(String category) {
    return alcoholBrandsByCategory[category] ?? alcoholBrands;
  }

  static List<String> tobaccoBrandsForCategory(String category) {
    return tobaccoBrandsByCategory[category] ?? cigaretteBrands;
  }

  static String alcoholCategoryForBrand(String brand) {
    for (final entry in alcoholBrandsByCategory.entries) {
      if (entry.value.contains(brand)) return entry.key;
    }
    return alcoholCategories.first;
  }

  static String tobaccoCategoryForBrand(String brand) {
    for (final entry in tobaccoBrandsByCategory.entries) {
      if (entry.value.contains(brand)) return entry.key;
    }
    return tobaccoCategories.first;
  }
}
