import 'package:flutter/material.dart';
import 'api_service.dart';
import 'Produk.dart';
import 'produk_detail.dart';
import 'favorite_screen.dart'; // Import favorite_screen.dart
import 'cart_screen.dart'; // Import cart_screen.dart
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Saka Store',
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
        scaffoldBackgroundColor: Color(0xFFE1F5FE),
        textTheme: GoogleFonts.openSansTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: ProdukListScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ProdukListScreen extends StatefulWidget {
  @override
  _ProdukListScreenState createState() => _ProdukListScreenState();
}

class _ProdukListScreenState extends State<ProdukListScreen> {
  late Future<List<Produk>> futureProduk;
  late PageController _pageController;
  int _currentPage = 0;

  List<Produk> cart = [];
  List<Produk> favorites = [];

  @override
  void initState() {
    super.initState();
    futureProduk = ApiService.fetchProduk();
    _pageController = PageController(initialPage: 0);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAutoPageChange();
    });
  }

  void _startAutoPageChange() {
    Future.delayed(Duration(seconds: 5), () {
      if (_pageController.hasClients) {
        int nextPage = (_currentPage + 1) % 3; // Assuming 3 banners
        _pageController.animateToPage(
          nextPage,
          duration: Duration(seconds: 1),
          curve: Curves.easeInOut,
        );
        setState(() {
          _currentPage = nextPage;
        });
        _startAutoPageChange();
      }
    });
  }

  void _addToCart(Produk produk) {
    setState(() {
      cart.add(produk);
    });
    _showCartNotification(produk.nama_barang);
  }

  void _addToFavorites(Produk produk) {
    setState(() {
      favorites.add(produk);
    });
    _showFavoriteNotification(produk.nama_barang);
  }

  void _showCartNotification(String productName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Future.delayed(Duration(milliseconds: 500), () {
          Navigator.of(context).pop(true);
        });
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.shopping_cart, color: Colors.green),
              SizedBox(width: 10),
              Text('Berhasil!'),
            ],
          ),
          content: Text('$productName telah ditambahkan ke keranjang'),
        );
      },
    );
  }

  void _showFavoriteNotification(String productName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Future.delayed(Duration(milliseconds: 500), () {
          Navigator.of(context).pop(true);
        });
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.favorite, color: Colors.red),
              SizedBox(width: 10),
              Text('Berhasil!'),
            ],
          ),
          content: Text('$productName telah ditambahkan ke favorit'),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              'Saka Store',
              style: GoogleFonts.greatVibes(
                textStyle: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            Spacer(),
            IconButton(
              icon: Icon(Icons.favorite),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FavoriteScreen(favorites: favorites),
                  ),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CartScreen(cart: cart),
                  ),
                );
              },
            ),
          ],
        ),
        backgroundColor: Color(0xFF03A9F4),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Banner Section
            Container(
              height: 250,
              width: 1000, // Set the width to 1000
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                border: Border.all(
                  color: const Color.fromARGB(255, 0, 0, 0),
                  width: 2.0,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: PageView(
                  controller: _pageController,
                  children: [
                    Image.network(
                      'https://i.imgur.com/Sypfg7i.png',
                      fit: BoxFit.cover,
                    ),
                    Image.network(
                      'https://i.imgur.com/ot9Rc2A.png',
                      fit: BoxFit.cover,
                    ),
                    Image.network(
                      'https://i.imgur.com/IbMKDKh.png',
                      fit: BoxFit.cover,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            // Produk List Section
            FutureBuilder<List<Produk>>(
              future: futureProduk,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: (snapshot.data!.length / 6).ceil(),
                    itemBuilder: (context, rowIndex) {
                      return Row(
                        children: List.generate(6, (columnIndex) {
                          int index = rowIndex * 6 + columnIndex;
                          if (index < snapshot.data!.length) {
                            return SizedBox(
                              width: MediaQuery.of(context).size.width / 6,
                              child: Card(
                                color: Colors.white,
                                margin: EdgeInsets.all(10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  side: BorderSide(
                                    color: Colors
                                        .lightBlue[100]!, // Light blue border
                                    width: 2.0,
                                  ),
                                ),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ProdukDetailScreen(
                                          produk: snapshot.data![index],
                                        ),
                                      ),
                                    );
                                  },
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        height: 250,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(15.0),
                                            topRight: Radius.circular(15.0),
                                          ),
                                          image: DecorationImage(
                                            image: NetworkImage(
                                              snapshot.data![index].imageUrl,
                                            ),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              snapshot.data![index].nama_barang,
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                            Text(
                                              'Harga: ${snapshot.data![index].harga_barang}',
                                              style: TextStyle(
                                                color: Colors.black,
                                              ),
                                            ),
                                            Text(
                                              'Jumlah: ${snapshot.data![index].jumlah_barang}',
                                              style: TextStyle(
                                                color: Colors.black,
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                IconButton(
                                                  icon: Icon(
                                                      Icons.favorite_border),
                                                  color: Colors.red,
                                                  onPressed: () =>
                                                      _addToFavorites(snapshot
                                                          .data![index]),
                                                ),
                                                IconButton(
                                                  icon: Icon(Icons
                                                      .shopping_cart_outlined),
                                                  color: Colors.blue,
                                                  onPressed: () => _addToCart(
                                                      snapshot.data![index]),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return SizedBox();
                          }
                        }),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
                return Center(child: CircularProgressIndicator());
              },
            ),
          ],
        ),
      ),
    );
  }
}
