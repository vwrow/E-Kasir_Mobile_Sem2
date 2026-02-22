import 'package:postman_penugasan1/services/url.dart' as url; 

class ProductModel {
  int? id;
  String? namaBarang;
  String? deskripsi;
  int? stok;
  double? harga;
  String? image;

  ProductModel({
    this.id,
    this.namaBarang,
    this.deskripsi,
    this.stok,
    this.harga,
    this.image,
  });
  ProductModel.fromJson(Map<String, dynamic> parsedJson) {
    id = parsedJson['id'];
    namaBarang = parsedJson['nama_barang'];
    deskripsi = parsedJson['deskripsi'];
    stok = parsedJson['stok'];
    harga = parsedJson['harga'] != null
        ? double.tryParse(parsedJson['harga'].toString()) ?? 0
        : null;
    final raw = parsedJson['image']?.toString();
    image = raw;
    if (raw != null &&
        raw.isNotEmpty &&
        !raw.startsWith('http') &&
        url.baseUrlTanpaAPI.isNotEmpty) {
      image = '${url.baseUrlTanpaAPI}${raw.startsWith('/') ? '' : '/'}$raw';
    }
  }
}
