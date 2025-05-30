import 'package:flutter/material.dart';
import 'api_service.dart';
import 'Produk.dart';
import 'produk_detail.dart';  // Ensure this file exists and has the ProdukDetailScreen class
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Toko Saka',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Color(0xFF002550),
        textTheme: GoogleFonts.openSansTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: ProdukListScreen(),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Toko Saka',
            style: GoogleFonts.greatVibes(
              textStyle: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        backgroundColor: Color(0xFF002550),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Banner Section
            Container(
              height: 250,
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
                      'https://res.cloudinary.com/upwork-cloud/image/upload/c_scale,w_1000/v1700796426/catalog/1600659718750367744/iqmiudmmo6s7zcofwmpf.jpg',
                      fit: BoxFit.cover,
                    ),
                    Image.network(
                      'https://i.imgur.com/WWeAvBB.jpeg',
                      fit: BoxFit.cover,
                    ),
                    Image.network(
                      'https://i.imgur.com/nSdOmRj.jpeg',
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
                    itemCount: (snapshot.data!.length / 4).ceil(),
                    itemBuilder: (context, rowIndex) {
                      return Row(
                        children: List.generate(4, (columnIndex) {
                          int index = rowIndex * 4 + columnIndex;
                          if (index < snapshot.data!.length) {
                            return SizedBox(
                              width: MediaQuery.of(context).size.width / 4,
                              child: Card(
                                color: Colors.blue[700],
                                margin: EdgeInsets.all(10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  side: BorderSide(
                                    color: Colors.blueAccent,
                                    width: 2.0,
                                  ),
                                ),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ProdukDetailScreen(
                                          produk: snapshot.data![index],
                                        ),
                                      ),
                                    );
                                  },
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        height: 150,
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
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              snapshot.data![index].nama_barang,
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                            Text(
                                              'Harga: ${snapshot.data![index].harga_barang}',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                            Text(
                                              'Jumlah: ${snapshot.data![index].jumlah_barang}',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
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