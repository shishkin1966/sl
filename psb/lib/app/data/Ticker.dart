import 'package:psb/app/data/Entity.dart';

class Ticker extends Entity {
  static const String Table = "Ticker";

  String get id => get(Columns.id);
  set id(String value) {
    set(Columns.id, value);
  }

  String get name => get(Columns.name);
  set name(String value) {
    set(Columns.name, value);
  }

  String get symbol => get(Columns.symbol);
  set symbol(String value) {
    set(Columns.symbol, value);
  }

  String get rank => get(Columns.rank);
  set rank(String value) {
    set(Columns.rank, value);
  }

  String get priceUsd => get(Columns.priceUsd);
  set priceUsd(String value) {
    set(Columns.priceUsd, value);
  }

  String get priceBtc => get(Columns.priceBtc);
  set priceBtc(String value) {
    set(Columns.priceBtc, value);
  }

  String get volumeUsd => get(Columns.volumeUsd);
  set volumeUsd(String value) {
    set(Columns.volumeUsd, value);
  }

  String get marketCapUsd => get(Columns.marketCapUsd);
  set marketCapUsd(String value) {
    set(Columns.marketCapUsd, value);
  }

  String get availableSupply => get(Columns.availableSupply);
  set availableSupply(String value) {
    set(Columns.availableSupply, value);
  }

  String get totalSupply => get(Columns.totalSupply);
  set totalSupply(String value) {
    set(Columns.totalSupply, value);
  }

  String get maxSupply => get(Columns.maxSupply);
  set maxSupply(String value) {
    set(Columns.maxSupply, value);
  }

  String get percentChange1h => get(Columns.percentChange1h);
  set percentChange1h(String value) {
    set(Columns.percentChange1h, value);
  }

  String get percentChange24h => get(Columns.percentChange24h);
  set percentChange24h(String value) {
    set(Columns.percentChange24h, value);
  }

  String get percentChange7d => get(Columns.percentChange7d);
  set percentChange7d(String value) {
    set(Columns.percentChange7d, value);
  }

  Ticker();

  factory Ticker.fromMap(Map<String, dynamic> map) {
    Ticker ticker = new Ticker();
    for (String key in map.keys) {
      switch (key) {
        case Columns.id:
        case Columns.name:
        case Columns.symbol:
        case Columns.rank:
        case Columns.priceUsd:
        case Columns.priceBtc:
        case Columns.volumeUsd:
        case Columns.marketCapUsd:
        case Columns.availableSupply:
        case Columns.totalSupply:
        case Columns.maxSupply:
        case Columns.percentChange1h:
        case Columns.percentChange24h:
        case Columns.percentChange7d:
          ticker.set(key, map[key]);
          break;

        case "price_usd":
          ticker.set(Columns.priceUsd, map[key]);
          break;

        case "price_btc":
          ticker.set(Columns.priceBtc, map[key]);
          break;

        case "24h_volume_usd":
          ticker.set(Columns.volumeUsd, map[key]);
          break;

        case "market_cap_usd":
          ticker.set(Columns.marketCapUsd, map[key]);
          break;

        case "available_supply":
          ticker.set(Columns.availableSupply, map[key]);
          break;

        case "total_supply":
          ticker.set(Columns.totalSupply, map[key]);
          break;

        case "max_supply":
          ticker.set(Columns.maxSupply, map[key]);
          break;

        case "percent_change_1h":
          ticker.set(Columns.percentChange1h, map[key]);
          break;

        case "percent_change_24h":
          ticker.set(Columns.percentChange24h, map[key]);
          break;

        case "percent_change_7d":
          ticker.set(Columns.percentChange7d, map[key]);
          break;
      }
    }
    return ticker;
  }
}

class Columns {
  static const String id = "id";
  static const String name = "name";
  static const String symbol = "symbol";
  static const String rank = "rank";
  static const String priceUsd = "priceUsd";
  static const String priceBtc = "priceBtc";
  static const String volumeUsd = "volumeUsd";
  static const String marketCapUsd = "marketCapUsd";
  static const String availableSupply = "availableSupply";
  static const String totalSupply = "totalSupply";
  static const String maxSupply = "maxSupply";
  static const String percentChange1h = "percentChange1h";
  static const String percentChange24h = "percentChange24h";
  static const String percentChange7d = "percentChange7d";
}
