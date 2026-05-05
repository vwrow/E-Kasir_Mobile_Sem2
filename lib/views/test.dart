import 'package:flutter/material.dart';
import 'package:postman_penugasan1/models/product_models.dart';
import 'package:postman_penugasan1/provider/provider_Cart.dart';
import 'package:postman_penugasan1/models/cart.dart';
import 'package:postman_penugasan1/services/dbHelper.dart';
import 'package:postman_penugasan1/services/products.dart';
import 'package:badges/badges.dart' as badges;
import 'package:postman_penugasan1/widgets/navBar.dart';

class PesanView extends StatefulWidget {
  const PesanView({super.key});

  @override
  State<PesanView> createState() => _PesanViewState();
}

class _PesanViewState extends State<PesanView> {
  var dBHelper = DBHelper();
  final cartProvider = CartProvider();
  List<ProductModel>? products;

  Future<void> getProductUser() async {
    var result = await ProductService().getUserProducts();
    if (!mounted) return;
    setState(() {
      products = (result.data ?? []).cast<ProductModel>();
    });
  }

  void updateCount() async {
    await cartProvider.getData();
    setState(() {
      cartProvider.counter = cartProvider.cart.length;
    });
  }

  void saveData(int index) async {
    if (products == null || index >= products!.length) return;
    final product = products![index];
    var detail = await dBHelper.getCartListDetail(product.id);
    var qty = 0;
    if (detail != null && detail.length > 0) {
      qty = detail[0].quantity;
    }

    dBHelper
        .insert(
          Cart(
            id: product.id,
            id_product: product.id.toString(),
            title: product.namaBarang,
            voteaverage: product.harga,
            overview: product.deskripsi,
            quantity: qty + 1,
            posterpath: product.image,
          ),
        )
        .then((value) {
          updateCount();
          print('Product Added to cart');
        })
    // .onError((error, stackTrace) {
    //   print(error.toString());
    // })
    ;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProductUser();
    updateCount();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        title: const Text('Product List'),
        actions: [
          badges.Badge(
            badgeContent: ListenableBuilder(
              listenable: cartProvider,
              builder: (context, child) {
                if (cartProvider.cart.isEmpty) {
                  return Text(
                    '0',
                    style: const TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontWeight: FontWeight.bold,
                    ),
                  );
                } else {
                  return Text(
                    '${cartProvider.counter}',
                    style: const TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }
              },
            ),

            position: badges.BadgePosition.topEnd(top: 0, end: 2),

            child: IconButton(
              onPressed: () {
                Navigator.pushNamed(context, "/trans");
              },
              icon: const Icon(Icons.shopping_cart),
            ),
          ),
          const SizedBox(width: 20.0),
        ],
      ),
      body: products != null
          ? ListView.builder(
              padding: const EdgeInsets.symmetric(
                vertical: 10.0,
                horizontal: 8.0,
              ),
              shrinkWrap: true,
              itemCount: products!.length,
              itemBuilder: (context, index) {
                final item = products![index];
                return Card(
                  color: Colors.blueGrey.shade200,
                  elevation: 5.0,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Image(
                          height: 80,
                          width: 80,
                          image: NetworkImage(item.image ?? ""),
                        ),
                        SizedBox(
                          width: 130,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 5.0),
                              RichText(
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                text: TextSpan(
                                  text: 'Name: ',
                                  style: TextStyle(
                                    color: Colors.blueGrey.shade800,
                                    fontSize: 16.0,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: '${item.namaBarang.toString()}\n',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              RichText(
                                maxLines: 1,
                                text: TextSpan(
                                  text: 'overview: ',
                                  style: TextStyle(
                                    color: Colors.blueGrey.shade800,
                                    fontSize: 16.0,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: '${item.deskripsi.toString()}\n',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              RichText(
                                maxLines: 1, 
                                text: TextSpan(
                                  text:
                                      'Price: '
                                      r"$",
                                  style: TextStyle(
                                    color: Colors.blueGrey.shade800,
                                    fontSize: 16.0,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: '${item.harga ?? 0}\n',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            iconColor: Colors.blueGrey.shade900,
                          ),
                          onPressed: () {
                            saveData(index);
                            // daga(index);
                          },
                          child: const Text('Add to Cart'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
          : Center(child: Text("data kosong")),
      bottomNavigationBar: BottomNav(1),
    );
  }
}
