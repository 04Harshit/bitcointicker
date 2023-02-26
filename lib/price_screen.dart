import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'coin_data.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  const PriceScreen({super.key});
  @override
  PriceScreenState createState() => PriceScreenState();
}

class PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD';

  DropdownButton<String> androidDropdown() {
    List<DropdownMenuItem<String>> dropdownItems = [];
    for (String currency in currenciesList) {
      var newItem = DropdownMenuItem(
        value: currency,
        child: Text(currency),
      );
      dropdownItems.add(newItem);
    }

    return DropdownButton<String>(
      value: selectedCurrency,
      items: dropdownItems,
      onChanged: (value) {
        setState(() {
          selectedCurrency = value!;
        });
      },
    );
  }

  CupertinoPicker iOSPicker() {
    List<Text> pickerItems = [];
    for (String currency in currenciesList) {
      pickerItems.add(Text(currency));
    }

    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        setState(() {
          selectedCurrency = currenciesList[selectedIndex];
          getdata();
        });
      },
      children: pickerItems,
    );
  }

  CoinData coinData = CoinData();
  bool isWaiting = false;
  Map<String, String> coinPrice = {};

  void getdata() async {
    isWaiting = true;
    try {
      var priceRate = await CoinData().getCoinData(selectedCurrency);
      isWaiting = false;
      setState(() {
        coinPrice = priceRate;
      });
    } catch (e) {
      isWaiting = true;
    }
  }

  @override
  void initState() {
    super.initState();
    getdata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              PriceTicker(
                  price: isWaiting ? '?' : coinPrice['BTC'] ?? 'no',
                  selectedCurrency: selectedCurrency,
                  conversion: cryptoList[0]),
              PriceTicker(
                  price: isWaiting ? '?' : coinPrice['ETH'] ?? 'no',
                  selectedCurrency: selectedCurrency,
                  conversion: cryptoList[1]),
              PriceTicker(
                  price: isWaiting ? '?' : coinPrice['LTC'] ?? 'no',
                  selectedCurrency: selectedCurrency,
                  conversion: cryptoList[2]),
            ],
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: const EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? iOSPicker() : androidDropdown(),
          ),
        ],
      ),
    );
  }
}

class PriceTicker extends StatelessWidget {
  const PriceTicker({
    Key? key,
    required this.price,
    required this.selectedCurrency,
    required this.conversion,
  }) : super(key: key);

  final String price;
  final String selectedCurrency;
  final String conversion;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $conversion = $price $selectedCurrency',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
