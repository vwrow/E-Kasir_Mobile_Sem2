import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:postman_penugasan1/models/product_models.dart';
import 'package:postman_penugasan1/services/products.dart';
import 'package:postman_penugasan1/widgets/alert.dart';

class TambahProductView extends StatefulWidget {
  final String title;
  final ProductModel? item;
  TambahProductView({required this.title, this.item});

  @override
  State<TambahProductView> createState() => _TambahProductViewState();
}

class _TambahProductViewState extends State<TambahProductView> {
  ProductService productService = ProductService();
  final formKey = GlobalKey<FormState>();

  // New Controllers
  TextEditingController namaBarang = TextEditingController();
  TextEditingController deskripsi = TextEditingController();
  TextEditingController stok = TextEditingController();
  TextEditingController harga = TextEditingController();

  File? selectedImage;
  bool isLoading = false;

  Future getImage() async {
    setState(() {
      isLoading = true;
    });
    var img = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (img != null) {
      setState(() {
        selectedImage = File(img.path);
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      namaBarang.text = widget.item!.namaBarang ?? "";
      deskripsi.text = widget.item!.deskripsi ?? "";
      stok.text = widget.item!.stok?.toString() ?? "";
      harga.text = widget.item!.harga?.toString() ?? "";
    }
  }

  @override
  final themeColor = const Color.fromARGB(255, 230, 114, 41);
    final washedTheme = const Color.fromARGB(255, 222, 208, 203);
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: themeColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(10),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                TextFormField(
                    controller: namaBarang,
                    decoration: InputDecoration(label: Text("Nama Barang")),
                    validator: (value) => value!.isEmpty ? 'harus diisi' : null),
                TextFormField(
                    controller: deskripsi,
                    decoration: InputDecoration(label: Text("Deskripsi")),
                    maxLines: 3,
                    validator: (value) => value!.isEmpty ? 'harus diisi' : null),
                TextFormField(
                    controller: stok,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(label: Text("Stok")),
                    validator: (value) => value!.isEmpty ? 'harus diisi' : null),
                TextFormField(
                    controller: harga,
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(label: Text("Harga")),
                    validator: (value) => value!.isEmpty ? 'harus diisi' : null),
                
                SizedBox(height: 10),
                TextButton(
                    onPressed: getImage, 
                    child: Text("Select Picture")),
                
                selectedImage != null
                    ? Container(
                        height: 200,
                        width: double.infinity,
                        child: Image.file(selectedImage!, fit: BoxFit.cover),
                      )
                    : isLoading
                        ? CircularProgressIndicator()
                        : Center(child: Text("Please Get the Images")),
                
                SizedBox(height: 20),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: themeColor,
                        foregroundColor: Colors.white,
                        minimumSize: Size(double.infinity, 45)),
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        var data = {
                          "nama_barang": namaBarang.text,
                          "deskripsi": deskripsi.text,
                          "stok": stok.text,
                          "harga": harga.text,
                        };

                        var result;
                        if (widget.item != null) {
                          // Update existing product
                          result = await productService.insertProduct(
                              data, selectedImage, widget.item!.id!);
                        } else {
                          // Insert new product
                          result = await productService.insertProduct(
                              data, selectedImage, null);
                        }

                        if (result.status == true) {
                          AlertMessage().showAlert(context, result.message, true);
                          Navigator.pop(context);
                          // Assuming you have a route named '/product' instead of '/movie'
                          Navigator.pushReplacementNamed(context, '/product');
                        } else {
                          AlertMessage().showAlert(context, result.message, false);
                        }
                      }
                    },
                    child: Text("Simpan"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}