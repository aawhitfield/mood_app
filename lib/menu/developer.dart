import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';

class DeveloperPage extends StatefulWidget {
  @override
  _DeveloperPageState createState() => new _DeveloperPageState();
}

class _DeveloperPageState extends State<DeveloperPage> {
  final List<String> _productLists = Platform.isAndroid
      ? ['us.binarychaos.moodapp.tip']
      : ['us.binarychaos.moodApp.tip'];

  String _platformVersion = 'Unknown';
  List<IAPItem> _items = [];

  @override
  void initState() {
    super.initState();
    initPlatformState();

    FlutterInappPurchase.initConnection.then((result) {
      this._getProduct();
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await FlutterInappPurchase.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // initConnection
    var result = await FlutterInappPurchase.initConnection;
    print('result: $result');

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });

    // refresh items for android
    String msg = await FlutterInappPurchase.consumeAllItems;
    print('consumeAllItems: $msg');
  }

  Future<Null> _buyProduct(IAPItem item) async {
    try {
      PurchasedItem purchased =
          await FlutterInappPurchase.buyProduct(item.productId);
      print('purcuased - ${purchased.toString()}');
    } catch (error) {
      print('$error');
    }
  }

  Future<Null> _getProduct() async {
    List<IAPItem> items = await FlutterInappPurchase.getProducts(_productLists);
    for (var item in items) {
      print('${item.toString()}');
      this._items.add(item);
    }

    setState(() {
      this._items = items;
    });
  }

  _renderInapps() {
    List<Widget> widgets = this
        ._items
        .map((item) => Container(
              margin: EdgeInsets.symmetric(vertical: 10.0),
              child: Container(
                child: Column(
                  children: <Widget>[
                    Card(
                      child: Column(
                        children: <Widget>[
                          Stack(
                            alignment: Alignment.center,
                            children: <Widget>[
                              Container(
                                color: Theme.of(context).primaryColor,
                                height: 300,
                              ),
                              Column(
                                children: <Widget>[
                                  CircleAvatar(
                                    radius: 64.0,
                                    child: Icon(
                                        Icons.account_circle,
                                        size: 128.0,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 32.0,
                                  ),
                                  Text('Aaron Whitfield',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 28.0,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Text('Hello World'),
                          FlatButton(
                            color: Theme.of(context).primaryColor,
                            onPressed: () {
                              this._buyProduct(item);
                            },
                            child: Text(
                              'Add a ${item.localizedPrice} tip my tip jar.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ))
        .toList();
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meet the Developer'),
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: ListView(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Text(
                    'Running on: $_platformVersion\n',
                    style: TextStyle(fontSize: 18.0),
                  ),
                ),
                Column(
                  children: this._renderInapps(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
