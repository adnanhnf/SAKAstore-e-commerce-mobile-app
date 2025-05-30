import 'package:flutter/material.dart';
import 'Produk.dart';

class ProdukDetailScreen extends StatelessWidget {
  final Produk produk;

  ProdukDetailScreen({required this.produk});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text('Detail Produk',
          style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Poster image on the left
            Expanded(
              flex: 2,
              child: Card(
                margin: EdgeInsets.all(10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  side: BorderSide(
                    color: Colors.blueAccent,
                    width: 2.0,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: Image.network(
                    produk.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.error);
                    },
                  ),
                ),
              ),
            ),
            SizedBox(width: 16),
            // Produk details on the right
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    produk.nama_barang,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Harga: ${produk.harga_barang}',
                    style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Jumlah: ${produk.jumlah_barang}',
                    style: TextStyle(color: Color.fromARGB(255, 2, 2, 2)),
                  ),
                  SizedBox(height: 16),
                  // Display a larger overview or description of the product
                  Text(
                    produk.deskripsi,
                    style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
