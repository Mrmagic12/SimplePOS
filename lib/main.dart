import 'package:flutter/material.dart';

void main() {
  runApp(ShoppingCartApp());
}

class ShoppingCartApp extends StatefulWidget {
  @override
  _ShoppingCartAppState createState() => _ShoppingCartAppState();
}

class _ShoppingCartAppState extends State<ShoppingCartApp> {
  List<String> shoppingCart = [];
  List<double> priceItem = [];
  String item = '';
  String price = '';
  bool modalVisible = false;

  void addItem() {
    if (item.isNotEmpty && price.isNotEmpty) {
      setState(() {
        shoppingCart.add(item);
        priceItem.add(double.parse(price));
        item = '';
        price = ''; // Reset item and price after adding
      });
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Please enter both item and price.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  void removeItem() {
    if (shoppingCart.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('The shopping cart is empty.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Remove Item'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: shoppingCart
              .asMap()
              .entries
              .map((entry) => ListTile(
                    title: Text(entry.value),
                    onTap: () {
                      handleRemoveItem(entry.key);
                      Navigator.pop(context);
                    },
                  ))
              .toList(),
        ),
      ),
    );
  }

  void handleRemoveItem(int indexToRemove) {
    setState(() {
      shoppingCart.removeAt(indexToRemove);
      priceItem.removeAt(indexToRemove);
    });
  }

  void computeTotal() {
    if (priceItem.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('The shopping cart is empty.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    double total = priceItem.fold(0, (sum, item) => sum + item);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Total Price'),
        content: Text(
            'The total price of the items in the shopping cart is \$ ${total.toStringAsFixed(2)}'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void showItems() {
    setState(() {
      modalVisible = true;
    });
  }

  void closeModal() {
    setState(() {
      modalVisible = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Shopping Cart'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Shopping Cart',
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                ),
                Card(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFormField(
                          decoration: InputDecoration(labelText: 'Item:'),
                          onChanged: (value) {
                            setState(() {
                              item = value;
                            });
                          },
                          initialValue: item,
                        ),
                        TextFormField(
                          decoration: InputDecoration(labelText: 'Price:'),
                          onChanged: (value) {
                            setState(() {
                              price = value;
                            });
                          },
                          keyboardType: TextInputType.number,
                          initialValue: price,
                        ),
                        SizedBox(height: 16.0),
                        ElevatedButton.icon(
                          onPressed: addItem,
                          icon: Icon(Icons.add_shopping_cart),
                          label: Text('Add Item'),
                        ),
                        ElevatedButton.icon(
                          onPressed: removeItem,
                          icon: Icon(Icons.remove_shopping_cart),
                          label: Text('Remove Item'),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                ElevatedButton.icon(
                  onPressed: computeTotal,
                  icon: Icon(Icons.calculate),
                  label: Text('Compute Total'),
                ),
                ElevatedButton.icon(
                  onPressed: showItems,
                  icon: Icon(Icons.list),
                  label: Text('Show Items'),
                ),
                modalVisible
                    ? Card(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                'Items in Cart',
                                style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 16.0),
                              Column(
                                children: shoppingCart
                                    .asMap()
                                    .entries
                                    .map(
                                      (entry) => Text(
                                        '${entry.value} - \$${priceItem[entry.key].toStringAsFixed(2)}',
                                      ),
                                    )
                                    .toList(),
                              ),
                              SizedBox(height: 16.0),
                              ElevatedButton(
                                onPressed: closeModal,
                                child: Text(
                                  'Close',
                                  style: TextStyle(color: Colors.white),
                                ),
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
