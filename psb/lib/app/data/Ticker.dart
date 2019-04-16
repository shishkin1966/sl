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
    priceUsd = map["price_usd"];
    priceBtc = map["price_btc"];
    volumeUsd = map["24h_volume_usd"];
    marketCapUsd = map["market_cap_usd"];
    availableSupply = map["available_supply"];
    totalSupply = map["total_supply"];
    maxSupply = map["max_supply"];
    percentChange1h = map["percent_change_1h"];
    percentChange24h = map["percent_change_24h"];
    percentChange7d = map["percent_change_7d"];
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
