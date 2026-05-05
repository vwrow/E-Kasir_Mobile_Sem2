import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:postman_penugasan1/models/cart.dart';
import 'package:postman_penugasan1/models/product_models.dart';
import 'package:postman_penugasan1/services/dbHelper.dart';
import 'package:postman_penugasan1/provider/provider_Cart.dart';
import 'package:postman_penugasan1/widgets/alert.dart';

class ProductDetailView extends StatefulWidget {
  final ProductModel product;

  const ProductDetailView({super.key, required this.product});

  @override
  State<ProductDetailView> createState() => _ProductDetailViewState();
}

class _ProductDetailViewState extends State<ProductDetailView> {
  final dBHelper = DBHelper();
  bool _isAdding = false;

  Future<void> _addToCartAndGoToTransaksi() async {
    final productId = widget.product.id;
    if (productId == null) {
      AlertMessage().showAlert(context, "Produk tidak valid", false);
      return;
    }

    final cartProvider = context.read<CartProvider>();
    setState(() => _isAdding = true);
    try {
      await dBHelper.addOrIncrementCart(
        Cart(
          id: productId,
          id_product: productId.toString(),
          title: widget.product.namaBarang,
          voteaverage: widget.product.harga,
          overview: widget.product.deskripsi,
          quantity: 1,
          posterpath: widget.product.image ?? '',
        ),
      );

      // Refresh global cart state so widgets listening to CartProvider update.
      await cartProvider.getData();

      if (!mounted) return;
      AlertMessage().showAlert(context, "Produk ditambahkan ke cart", true);
    } catch (e) {
      if (!mounted) return;
      AlertMessage().showAlert(
        context,
        "Gagal menambahkan ke cart: ${e.toString()}",
        false,
      );
    } finally {
      if (mounted) setState(() => _isAdding = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = const Color.fromARGB(255, 230, 114, 41);
    final productName = widget.product.namaBarang ?? "Nama Barang";
    final productDesc = widget.product.deskripsi ?? "Deskripsi tidak tersedia";
    final stock = widget.product.stok ?? 0;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: themeColor,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Detail Item",
          style: TextStyle(
            fontFamily: "Popins",
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1.1,
              child: (widget.product.image != null && widget.product.image!.isNotEmpty)
                  ? Image.network(
                      widget.product.image!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey.shade300,
                          child: const Icon(
                            Icons.image_not_supported,
                            size: 44,
                          ),
                        );
                      },
                    )
                  : Container(
                      color: Colors.grey.shade300,
                      child: const Icon(Icons.image_not_supported, size: 44),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    productName,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      fontFamily: "Popins",
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(32, 230, 114, 41),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      "Stok tersisa: $stock",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color.fromARGB(255, 230, 114, 41),
                        fontFamily: "Popins",
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    "Deskripsi",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      fontFamily: "Popins",
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    productDesc,
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: Colors.black87,
                      fontFamily: "Popins",
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            height: 52,
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: themeColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: _isAdding ? null : _addToCartAndGoToTransaksi,
              child: _isAdding
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text(
                      "Add to Cart",
                      style: TextStyle(
                        fontFamily: "Popins",
                        fontWeight: FontWeight.w700,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
