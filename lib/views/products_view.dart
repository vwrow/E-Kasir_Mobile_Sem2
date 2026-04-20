import 'package:flutter/material.dart';
import 'package:postman_penugasan1/widgets/navBar.dart';
import 'package:postman_penugasan1/services/products.dart';
import 'package:postman_penugasan1/models/response_data_list.dart';
import 'package:postman_penugasan1/models/product_models.dart';
import 'package:postman_penugasan1/models/user_login.dart';
import 'package:postman_penugasan1/views/add-edit_product_view.dart';
import 'package:postman_penugasan1/views/product_detail_view.dart';
import 'package:postman_penugasan1/widgets/alert.dart';
import 'package:postman_penugasan1/widgets/product_card.dart';

class ItemsView extends StatefulWidget {
  const ItemsView({super.key});

  @override
  State<ItemsView> createState() => _ItemsView();
}

class _ItemsView extends State<ItemsView> {
  List<ProductModel>? product;
  bool _isLoading = true;
  String? _errorMessage;
  String? _role;
  final List<String> action = ["Update", "Hapus"];

  Future<void> getProduct() async {
    setState(() => _isLoading = true);
    ResponseDataList getProduct = await ProductService().getProducts();
    if (!mounted) return;
    setState(() {
      product = (getProduct.data ?? []).cast<ProductModel>();
      _errorMessage = getProduct.status ? null : getProduct.message;
      _isLoading = false;
    });
  }

  Future<void> getCurrentRole() async {
    final user = await UserLogin().getUserLogin();
    if (!mounted) return;
    setState(() => _role = user.role?.toString().toLowerCase());
  }

  @override
  void initState() {
    super.initState();
    getCurrentRole();
    getProduct();
  }

  Future<void> _handleAdminAction(String r, ProductModel p) async {
    if (r == "Update") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TambahProductView(
            title: "Update Product",
            item: p,
          ),
        ),
      );
      return;
    }

    var results = await AlertMessage().showAlertDialog(context);
    if (results != null && results.containsKey('status')) {
      if (results['status'] == true) {
        var res = await ProductService().hapusProduct(
          context,
          p.id,
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
                    if (_role == "admin")
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
                              builder: (context) => TambahProductView(
                                title: "Tambah Product",
                                item: null,
                              ),
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
                  : _errorMessage != null && (product?.isEmpty ?? true)
                  ? Center(
                      child: Text(
                        _errorMessage!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 14,
                          fontFamily: "Popins",
                        ),
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
                        return ProductCard(
                          product: p,
                          borderColor: washedTheme,
                          showAdminActions: _role == "admin",
                          adminActions: action,
                          onAdminAction: _handleAdminAction,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ProductDetailView(product: p),
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
