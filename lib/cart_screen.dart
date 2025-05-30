import 'package:flutter/material.dart';
import 'Produk.dart';
import 'checkout_screen.dart';

class CartScreen extends StatefulWidget {
  final List<Produk> cart;

  CartScreen({required this.cart});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  Map<Produk, int> productQuantities = {};

  @override
  void initState() {
    super.initState();
    widget.cart.forEach((product) {
      productQuantities[product] = 1;
    });
  }

  void _incrementQuantity(Produk product) {
    setState(() {
      productQuantities[product] = (productQuantities[product] ?? 0) + 1;
    });
  }

  void _decrementQuantity(Produk product) {
    setState(() {
      if (productQuantities[product]! > 1) {
        productQuantities[product] = productQuantities[product]! - 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Keranjang'),
        backgroundColor: Color(0xFF03A9F4),
      ),
      body: ListView.builder(
        itemCount: widget.cart.length,
        itemBuilder: (context, index) {
          final product = widget.cart[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                children: [
                  Image.network(
                    product.imageUrl,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.nama_barang,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text('Harga: ${product.harga_barang}'),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () => _incrementQuantity(product),
                      ),
                      Text(
                        '${productQuantities[product]}',
                        style: TextStyle(fontSize: 16),
                      ),
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () => _decrementQuantity(product),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CheckoutScreen(
                  cart: widget.cart,
                  productQuantities: productQuantities,
                ),
              ),
            );
          },
          child: Text('Checkout'),
        ),
      ),
    );
  }
}
