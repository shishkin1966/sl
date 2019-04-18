const String Table = "Ticker";

class Ticker {
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

  factory Ticker.from(Map<String, dynamic> map) {
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

  Map toMap() {
    Map map = new Map();
    map["id"] = id;
    map["name"] = name;
    map["symbol"] = symbol;
    map["rank"] = rank;
    map["price_usd"] = priceUsd;
    map["price_btc"] = priceBtc;
    map["24h_volume_usd"] = volumeUsd;
    map["market_cap_usd"] = marketCapUsd;
    map["available_supply"] = availableSupply;
    map["total_supply"] = totalSupply;
    map["max_supply"] = maxSupply;
    map["percent_change_1h"] = percentChange1h;
    map["percent_change_24h"] = percentChange24h;
    map["percent_change_7d"] = percentChange7d;
    return map;
  }

  List toList() {
    List list = List();
    list.add(id);
    list.add(name);
    list.add(symbol);
    list.add(rank);
    list.add(priceUsd);
    list.add(priceBtc);
    list.add(volumeUsd);
    list.add(marketCapUsd);
    list.add(availableSupply);
    list.add(totalSupply);
    list.add(maxSupply);
    list.add(percentChange1h);
    list.add(percentChange24h);
    list.add(percentChange7d);
    return list;
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
