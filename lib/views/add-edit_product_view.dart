import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:postman_penugasan1/models/product_models.dart';
import 'package:postman_penugasan1/services/products.dart';
import 'package:postman_penugasan1/widgets/alert.dart';

class TambahProductView extends StatefulWidget {
  final String title;
  final ProductModel? item;

  const TambahProductView({
    super.key,
    required this.title,
    this.item,
  });

  @override
  State<TambahProductView> createState() => _TambahProductViewState();
}

class _TambahProductViewState extends State<TambahProductView> {
  final ProductService productService = ProductService();
  final formKey = GlobalKey<FormState>();

  final TextEditingController namaBarang = TextEditingController();
  final TextEditingController deskripsi = TextEditingController();
  final TextEditingController stok = TextEditingController();
  final TextEditingController harga = TextEditingController();

  File? selectedImage;
  bool pickingImage = false;
  bool isSubmitting = false;

  Future<void> getImage() async {
    setState(() => pickingImage = true);
    final img = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      if (img != null) {
        selectedImage = File(img.path);
      }
      pickingImage = false;
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      namaBarang.text = widget.item!.namaBarang ?? '';
      deskripsi.text = widget.item!.deskripsi ?? '';
      stok.text = widget.item!.stok?.toString() ?? '';
      harga.text = widget.item!.harga?.toString() ?? '';
    }
  }

  @override
  void dispose() {
    namaBarang.dispose();
    deskripsi.dispose();
    stok.dispose();
    harga.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = const Color.fromARGB(255, 230, 114, 41);
    final washedTheme = const Color.fromARGB(255, 222, 208, 203);

    InputDecoration inputDecoration(String label) {
      return InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Color(0xFFD5DAE3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Color(0xFFD5DAE3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: themeColor, width: 1.5),
        ),
      );
    }

    return Scaffold(
      backgroundColor: washedTheme,
      body:SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 60,),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 24, 0),
                child: Row(
                  children: [
                    IconButton(
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      icon: const Icon(Icons.arrow_back_ios_new_rounded),
                      color: Colors.black87,
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    Expanded(
                      child: Text(
                        widget.title,
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 0),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(36, 16, 42, 88),
                      blurRadius: 24,
                      offset: Offset(0, 20),
                    ),
                  ],
                ),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: namaBarang,
                        decoration: inputDecoration('Nama Barang'),
                        validator: (value) =>
                            value == null || value.isEmpty ? 'Harus diisi' : null,
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: deskripsi,
                        decoration: inputDecoration('Deskripsi'),
                        maxLines: 3,
                        validator: (value) =>
                            value == null || value.isEmpty ? 'Harus diisi' : null,
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: stok,
                        keyboardType: TextInputType.number,
                        decoration: inputDecoration('Stok'),
                        validator: (value) =>
                            value == null || value.isEmpty ? 'Harus diisi' : null,
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: harga,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: inputDecoration('Harga'),
                        validator: (value) =>
                            value == null || value.isEmpty ? 'Harus diisi' : null,
                      ),
                      const SizedBox(height: 20),
                      OutlinedButton.icon(
                        onPressed: pickingImage ? null : getImage,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: themeColor,
                          side: BorderSide(color: themeColor.withValues(alpha: 0.6)),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        icon: const Icon(Icons.photo_library_outlined, size: 22),
                        label: Text(
                          pickingImage ? 'Memuat…' : 'Pilih gambar',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: Container(
                          height: 200,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F6F8),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: const Color(0xFFD5DAE3)),
                          ),
                          child: pickingImage
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    color: Color.fromARGB(255, 230, 114, 41),
                                  ),
                                )
                              : selectedImage != null
                                  ? Image.file(
                                      selectedImage!,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: 200,
                                    )
                                  : Center(
                                      child: Text(
                                        'Belum ada gambar',
                                        style: TextStyle(
                                          color: Colors.grey.shade600,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: themeColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          onPressed: isSubmitting
                              ? null
                              : () async {
                                  if (!formKey.currentState!.validate()) {
                                    return;
                                  }
                                  setState(() => isSubmitting = true);
                                  final data = {
                                    'nama_barang': namaBarang.text,
                                    'deskripsi': deskripsi.text,
                                    'stok': stok.text,
                                    'harga': harga.text,
                                  };
                                  final dynamic result = widget.item != null
                                      ? await productService.insertProduct(
                                          data,
                                          selectedImage,
                                          widget.item!.id,
                                        )
                                      : await productService.insertProduct(
                                          data,
                                          selectedImage,
                                          null,
                                        );
                                  if (!mounted) return;
                                  setState(() => isSubmitting = false);
                                  if (result.status == true) {
                                    AlertMessage().showAlert(
                                      context,
                                      result.message,
                                      true,
                                    );
                                    Navigator.of(context).pop();
                                    Navigator.pushReplacementNamed(
                                      context,
                                      '/items',
                                    );
                                  } else {
                                    AlertMessage().showAlert(
                                      context,
                                      result.message,
                                      false,
                                    );
                                  }
                                },
                          child: isSubmitting
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                                  'Simpan',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      
    );
  }
}
