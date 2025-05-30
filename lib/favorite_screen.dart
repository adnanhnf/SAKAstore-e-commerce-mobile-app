import 'package:flutter/material.dart';
import 'Produk.dart';
import 'produk_detail.dart';

class FavoriteScreen extends StatelessWidget {
  final List<Produk> favorites;

  FavoriteScreen({required this.favorites});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorit'),
        backgroundColor: Color(0xFF03A9F4),
      ),
      body: ListView.builder(
        itemCount: favorites.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Image.network(favorites[index].imageUrl),
            title: Text(favorites[index].nama_barang),
            subtitle: Text('Harga: ${favorites[index].harga_barang}'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProdukDetailScreen(produk: favorites[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
