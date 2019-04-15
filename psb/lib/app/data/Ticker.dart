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

  Ticker.from(Map map) {
    id = map["id"];
    name = map["name"];
    symbol = map["symbol"];
    rank = map["rank"];
    priceUsd = map["priceUsd"];
    priceBtc = map["priceBtc"];
    volumeUsd = map["volumeUsd"];
    marketCapUsd = map["marketCapUsd"];
    availableSupply = map["availableSupply"];
    totalSupply = map["totalSupply"];
    maxSupply = map["maxSupply"];
    percentChange1h = map["percentChange1h"];
    percentChange24h = map["percentChange24h"];
    percentChange7d = map["percentChange7d"];
  }

  Map toMap() {
    Map map = new Map();
    map["id"] = id;
    map["name"] = name;
    map["symbol"] = symbol;
    map["rank"] = rank;
    map["priceUsd"] = priceUsd;
    map["priceBtc"] = priceBtc;
    map["volumeUsd"] = volumeUsd;
    map["marketCapUsd"] = marketCapUsd;
    map["availableSupply"] = availableSupply;
    map["totalSupply"] = totalSupply;
    map["maxSupply"] = maxSupply;
    map["percentChange1h"] = percentChange1h;
    map["percentChange24h"] = percentChange24h;
    map["percentChange7d"] = percentChange7d;
    return map;
  }
}
