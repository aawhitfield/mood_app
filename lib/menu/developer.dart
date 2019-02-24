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
        .map((item) => Center(
              child: Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(vertical: 10.0),
                child: Container(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Card(
                        child: Column(
                          children: <Widget>[
                            Stack(
                              alignment: Alignment.center,
                              children: <Widget>[
//                                Container(
//                                  decoration: BoxDecoration(
//                                    image: DecorationImage(
//                                      image: AssetImage('graphics/laptop.jpg'),
//                                    ),
//                                  ),
//
//                                ),
                                Image.asset('graphics/laptop.jpg',
                                  scale: 0.5,
                                ),
                                Column(
                                  children: <Widget>[
                                    ClipOval(
                                      child: Image(
                                        image: AssetImage(
                                            'graphics/developer.jpg'),
                                        fit: BoxFit.fill,
                                        width: 196.0,
                                        height: 196.0,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 40.0,
                                    ),
                                    Text(
                                      'Aaron Whitfield',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 28.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                  'I\'m a freelance mobile app developer with a wonderful wife and 3 adorable children and am just trying to make the world a better place. If you have found any value in this ad-free, fully functional app, please consider letting me know by tipping below.',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontFamily: 'RobotoLight',
                                  color: Colors.grey[700],
                                ),
                              ),
                            ),
                            FlatButton(
                              color: Theme.of(context).primaryColor,
                              onPressed: () {
                                this._buyProduct(item);
                              },
                              child: Text(
                                'Add ${item.localizedPrice} to my tip jar.',
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
      body: Center(
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(10.0),
          child: ListView(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: this._renderInapps(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
