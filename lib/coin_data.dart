import 'dart:convert';
import 'package:http/http.dart';

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

const coinAPIURL = 'https://rest.coinapi.io/v1/exchangerate';
const apiKey = '4BCC7058-7098-4F04-A4A0-4620E341A42D';

class CoinData {
  Future getCoinData(String selectedCurrency) async {
    Map<String, String> priceList = {};

    for (String crypto in cryptoList) {
      Response response = await get(
          Uri.parse('$coinAPIURL/$crypto/$selectedCurrency?apikey=$apiKey'));

      if (response.statusCode == 200) {
        var decode = jsonDecode(response.body);

        double price = decode['rate'];
        priceList[crypto] = price.toStringAsFixed(0);
      } else {}
    }
    return priceList;
  }
}
