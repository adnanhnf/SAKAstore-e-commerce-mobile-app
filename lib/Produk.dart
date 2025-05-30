class Produk {
  final String id;
  final String nama_barang;
  final double harga_barang;
  final int jumlah_barang;
  final String imageUrl;
  final String deskripsi;

  Produk({
    required this.id,
    required this.nama_barang,
    required this.harga_barang,
    required this.jumlah_barang,
    required this.imageUrl,
    required this.deskripsi,
  });

  factory Produk.fromJson(Map<String, dynamic> json) {
    return Produk(
      id: json['id'],
      nama_barang: json['nama_barang'],
      harga_barang: double.parse(json['harga_barang'].toString()),  
      jumlah_barang: int.parse(json['jumlah_barang'].toString()),  
      imageUrl: json['imageUrl'],
      deskripsi: json['deskripsi'],
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Produk &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
