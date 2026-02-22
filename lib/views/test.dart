import 'package:flutter/material.dart';
import 'package:postman_penugasan1/widgets/navBar.dart';
import 'package:postman_penugasan1/services/products.dart';
import 'package:postman_penugasan1/models/response_data_list.dart';
import 'package:postman_penugasan1/models/product_models.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPage();
}

class _TestPage extends State<TestPage> {
  List<ProductModel>? product;

  Future<void> getProduct() async {
    ResponseDataList getProduct = await ProductService().getProducts();
    setState(() {
      product = (getProduct.data ?? []).cast<ProductModel>();
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
            AspectRatio(
              aspectRatio: 1,
              child: (p.image != null && p.image!.isNotEmpty)
                  ? Image.network(
                      p.image!,
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    p.namaBarang ?? "Nama Product",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Popins",
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    p.deskripsi ?? "Deskripsi singkat panjang banget",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color.fromARGB(175, 0, 0, 0),
                      fontSize: 12,
                      fontFamily: "Popins",
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Rp. ${p.harga ?? 0}",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 60),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                      Text(
                        "Products",
                        style: const TextStyle(
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
                          child: Icon(
                            Icons.add,
                            size: 20,
                            color: Color.fromARGB(230, 0, 0, 0),
                          ),
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 26),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
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
              child: GridView.builder(
                itemCount: product?.length ?? 0,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  childAspectRatio: 0.66,
                ),
                itemBuilder: (context, index) {
                  final p = product![index];
                  return _buildProductCard(p, washedTheme);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
