import 'package:flutter/material.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';

class DeveloperPage extends StatefulWidget
{


  @override
  DeveloperPageState createState() {
    return new DeveloperPageState();
  }
}

class DeveloperPageState extends State<DeveloperPage> {
  static const String iapId = 'android.test.purchased';
  List<IAPItem> _items = [];


  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    // prepare
    var result = await FlutterInappPurchase.initConnection;
    print('result: $result');

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    // refresh items for android
    String msg = await FlutterInappPurchase.consumeAllItems;
    print('consumeAllItems: $msg');
    await _getProduct();
  }


  Future<Null> _getProduct() async {
    List<IAPItem> items = await FlutterInappPurchase.getProducts([iapId]);
    for (var item in items) {
      print('${item.toString()}');
      this._items.add(item);
    }

    setState(() {
      this._items = items;
    });
  }


  Future<Null> _buyProduct(IAPItem item) async {
    try {
      PurchasedItem purchased = await FlutterInappPurchase.buyProduct(item.productId);
      print(purchased);
      String msg = await FlutterInappPurchase.consumeAllItems;
      print('consumeAllItems: $msg');
    } catch (error) {
      print('$error');
    }
  }


  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      appBar: AppBar(
        title: Text('Meet the Developer'),
      ),
      body: Column(
        children:
          _renderButton(),
      ),
    );
  }

  List<Widget> _renderButton() {
    List<Widget> widgets = _items.map((item) =>
      Container(
        height: 250.0,
        width: double.infinity,
        child: Card(
          child: Column(
            children: <Widget>[
              SizedBox(height: 28.0),
              Align(
                alignment: Alignment.center,
                child: Text('Banana',
                  style: Theme.of(context).textTheme.display1,
                ),
              ),
              SizedBox(
                height: 24.0,
              ),
              Align(
                alignment: Alignment.center,
                child: Text(
                  'This is a consumable item',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.grey[700],
                  ),
                ),
              ),
              SizedBox(
                height: 24.0,
              ),
              SizedBox(
                width: 340.0,
                height: 50.0,
                child: RaisedButton(
                    color: Colors.blue,
                    onPressed: () => _buyProduct(item),
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ).toList();

    return widgets;
  }

}