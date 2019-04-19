import 'package:psb/app/data/Entity.dart';

class Ticker extends Entity {
  static const String Table = "Ticker";

  String id;
  String name;
  String symbol;
  String rank;
  String priceUsd;
  String priceBtc;
  String volumeUsd;
  String marketCapUsd;
  String availableSupply;
  String totalSupply;
  String maxSupply;
  String percentChange1h;
  String percentChange24h;
  String percentChange7d;

  Ticker();

  factory Ticker.fromMap(Map<String, dynamic> map) {
    Ticker ticker = new Ticker();
    ticker.id = map["id"];
    ticker.name = map["name"];
    ticker.symbol = map["symbol"];
    ticker.rank = map["rank"];
    ticker.priceUsd = map["price_usd"];
    ticker.priceBtc = map["price_btc"];
    ticker.volumeUsd = map["24h_volume_usd"];
    ticker.marketCapUsd = map["market_cap_usd"];
    ticker.availableSupply = map["available_supply"];
    ticker.totalSupply = map["total_supply"];
    ticker.maxSupply = map["max_supply"];
    ticker.percentChange1h = map["percent_change_1h"];
    ticker.percentChange24h = map["percent_change_24h"];
    ticker.percentChange7d = map["percent_change_7d"];
    return ticker;
  }

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = new Map<String, dynamic>();
    map[Columns.id] = id;
    map[Columns.name] = name;
    map[Columns.symbol] = symbol;
    map[Columns.rank] = rank;
    map[Columns.priceUsd] = priceUsd;
    map[Columns.priceBtc] = priceBtc;
    map[Columns.volumeUsd] = volumeUsd;
    map[Columns.marketCapUsd] = marketCapUsd;
    map[Columns.availableSupply] = availableSupply;
    map[Columns.totalSupply] = totalSupply;
    map[Columns.maxSupply] = maxSupply;
    map[Columns.percentChange1h] = percentChange1h;
    map[Columns.percentChange24h] = percentChange24h;
    map[Columns.percentChange7d] = percentChange7d;
    return map;
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
