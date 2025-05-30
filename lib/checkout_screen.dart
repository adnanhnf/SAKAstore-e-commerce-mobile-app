import 'package:flutter/material.dart';
import 'Produk.dart';
import 'receipt_screen.dart'; // Import the receipt_screen.dart

class CheckoutScreen extends StatelessWidget {
  final List<Produk> cart;
  final Map<Produk, int> productQuantities;

  CheckoutScreen({required this.cart, required this.productQuantities});

  @override
  Widget build(BuildContext context) {
    double totalPrice = 0;
    cart.forEach((product) {
      totalPrice += product.harga_barang * (productQuantities[product] ?? 1);
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout'),
        backgroundColor: Color(0xFF03A9F4),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: cart.length,
                itemBuilder: (context, index) {
                  final product = cart[index];
                  return ListTile(
                    leading: Image.network(product.imageUrl),
                    title: Text(product.nama_barang),
                    subtitle: Text(
                      'Jumlah: ${productQuantities[product]} x ${product.harga_barang}',
                    ),
                  );
                },
              ),
            ),
            Text('Total Harga: $totalPrice'),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReceiptScreen(
                        purchasedProducts: cart,
                        productQuantities: productQuantities,
                        totalPrice: totalPrice,
                      ),
                    ),
                  );
                },
                child: Text('Bayar Sekarang'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
