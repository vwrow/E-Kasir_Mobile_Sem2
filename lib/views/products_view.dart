import 'package:flutter/material.dart';
import 'package:postman_penugasan1/widgets/navBar.dart';
import 'package:postman_penugasan1/services/products.dart';
import 'package:postman_penugasan1/models/response_data_list.dart';
import 'package:postman_penugasan1/models/product_models.dart';
import 'package:postman_penugasan1/views/add-edit_product_view.dart';
import 'package:postman_penugasan1/widgets/alert.dart';

class ItemsView extends StatefulWidget {
  const ItemsView({super.key});

  @override
  State<ItemsView> createState() => _ItemsView();
}

class _ItemsView extends State<ItemsView> {
  List<ProductModel>? product;
  bool _isLoading = true;
  List action = ["Update", "Hapus"];

  Future<void> getProduct() async {
    setState(() => _isLoading = true);
    ResponseDataList getProduct = await ProductService().getProducts();
    setState(() {
      product = (getProduct.data ?? []).cast<ProductModel>();
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getProduct();
  }

  Widget _buildProductCard(ProductModel p, Color washedTheme) {
    return ClipRRect(
  borderRadius: BorderRadius.circular(20),
  child: Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(
        color: washedTheme,
        width: 2.0,
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Stack(
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: (p.image != null && p.image!.isNotEmpty)
                  ? Image.network(
                      p.image!, // Mapping to String? image
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey,
                          child: const Icon(Icons.image, color: Colors.black),
                        );
                      },
                    )
                  : Container(
                      color: Colors.grey,
                      child: const Icon(Icons.image, color: Colors.black),
                    ),
            ),
            // Positioned PopupMenuButton
            Positioned(
              top: 5,
              right: 5,
              child: PopupMenuButton(
                icon: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.more_vert, color: Colors.white),
                ),
                itemBuilder: (BuildContext context) {
                  return action.map((r) {
                    return PopupMenuItem(
                      onTap: () async {
                        if (r == "Update") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TambahProductView(
                                title: "Update Product",
                                item: p, // Passing the current object 'p'
                              ),
                            ),
                          );
                        } else {
                          var results = await AlertMessage().showAlertDialog(context);
                          if (results != null && results.containsKey('status')) {
                            if (results['status'] == true) {
                              var res = await ProductService().hapusProduct(
                                context,
                                p.id, // Mapping to int? id
                              );
                              if (res.status == true) {
                                AlertMessage().showAlert(context, res.message, true);
                                getProduct();
                              } else {
                                AlertMessage().showAlert(context, res.message, false);
                              }
                            }
                          }
                        }
                      },
                      value: r,
                      child: Text(r),
                    );
                  }).toList();
                },
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                p.namaBarang ?? "Nama Barang", // Mapping to String? namaBarang
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Popins",
                ),
              ),
              const SizedBox(height: 4),
              Text(
                p.deskripsi ?? "Deskripsi tidak tersedia", // Mapping to String? deskripsi
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 12,
                  fontFamily: "Popins",
                ),
              ),
              const SizedBox(height: 3),
              Text(
                "Stok: ${p.stok ?? 0}", // Mapping to int? stok
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 11,
                  fontFamily: "Popins",
                ),
              ),
              const SizedBox(height: 3),
              Text(
                "Rp. ${p.harga ?? 0.0}", // Mapping to double? harga
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Popins",
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  ),
);
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = const Color.fromARGB(255, 230, 114, 41);
    final washedTheme = const Color.fromARGB(255, 222, 208, 203);
    return Scaffold(
      backgroundColor: themeColor,
      bottomNavigationBar: BottomNav(1),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 60),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 32.0,
              vertical: 5,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const Text(
                      "Products",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Popins",
                      ),
                    ),
                    IconButton(
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      icon: Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.white,
                        ),
                        child: const Icon(
                          Icons.add,
                          size: 20,
                          color: Color.fromARGB(230, 0, 0, 0),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      TambahProductView(title: "Tambah Product", item: null),
                ),
              );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromARGB(36, 16, 42, 88),
                    blurRadius: 24,
                    offset: Offset(0, 20),
                  ),
                ],
              ),
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Color.fromARGB(255, 230, 114, 41),
                      ),
                    )
                  : GridView.builder(
                      itemCount: product?.length ?? 0,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                        childAspectRatio: 0.6,
                      ),
                      itemBuilder: (context, index) {
                        final p = product![index];
                        return _buildProductCard(p, washedTheme);
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
