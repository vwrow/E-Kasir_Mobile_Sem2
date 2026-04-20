import 'package:flutter/material.dart';
import 'package:postman_penugasan1/models/product_models.dart';
import 'package:postman_penugasan1/models/response_data_list.dart';
import 'package:postman_penugasan1/models/user_login.dart';
import 'package:postman_penugasan1/services/products.dart';
import 'package:postman_penugasan1/views/product_detail_view.dart';
import 'package:postman_penugasan1/widgets/navBar.dart';
import 'package:postman_penugasan1/widgets/product_card.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  UserLogin userLogin = UserLogin();
  String? nama;
  String? role;
  List<ProductModel> _products = [];
  bool _isLoadingProducts = true;
  String? _productError;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  getUserLogin() async {
    var user = await userLogin.getUserLogin();
    if (user.status != false) {
      final currentRole = user.role?.toString().toLowerCase();
      setState(() {
        nama = user.nama_user;
        role = currentRole;
      });
      await _getProductsForDashboard(currentRole);
    }
  }

  Future<void> _getProductsForDashboard(String? currentRole) async {
    setState(() {
      _isLoadingProducts = true;
      _productError = null;
    });

    final ResponseDataList response = currentRole == "admin"
        ? await ProductService().getProducts()
        : await ProductService().getUserProducts();
    if (!mounted) return;
    setState(() {
      _products = (response.data ?? []).cast<ProductModel>();
      _productError = response.status ? null : response.message;
      _isLoadingProducts = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserLogin();
  }

  IconData get chatIcon {
    if (role == "admin") {
      return Icons.chat_bubble_outline_rounded;
    }
    return Icons.support_agent_outlined;
  }

  int get _totalVariety => _products.length;

  int get _totalStock =>
      _products.fold(0, (sum, item) => sum + (item.stok ?? 0));

  double get _totalInventoryValue => _products.fold(
    0,
    (sum, item) => sum + ((item.harga ?? 0) * (item.stok ?? 0)),
  );

  int get _lowStockItems => _products
      .where((item) => (item.stok ?? 0) > 0 && (item.stok ?? 0) <= 5)
      .length;

  Widget _adminStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color cardColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFF0E3DB)),
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(18, 0, 0, 0),
            blurRadius: 16,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 34,
            width: 34,
            decoration: const BoxDecoration(
              color: Color.fromARGB(40, 230, 114, 41),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 18,
              color: Color.fromARGB(255, 230, 114, 41),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              fontFamily: "Popins",
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black54,
              fontFamily: "Popins",
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdminDashboard(Color washedTheme) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = (constraints.maxWidth - 12) / 2;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color.fromARGB(255, 247, 138, 70),
                    Color.fromARGB(255, 230, 114, 41),
                  ],
                ),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Dashboard Admin",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      fontFamily: "Popins",
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    "Pantau kondisi stok, performa penjualan, dan pergerakan toko secara cepat.",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      height: 1.4,
                      fontFamily: "Popins",
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              "Ringkasan Toko",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                fontFamily: "Popins",
              ),
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                SizedBox(
                  width: cardWidth,
                  child: _adminStatCard(
                    title: "Varian item tersedia",
                    value: "$_totalVariety item",
                    icon: Icons.inventory_2_outlined,
                    cardColor: washedTheme,
                  ),
                ),
                SizedBox(
                  width: cardWidth,
                  child: _adminStatCard(
                    title: "Total stok barang",
                    value: "$_totalStock pcs",
                    icon: Icons.warehouse_outlined,
                    cardColor: washedTheme,
                  ),
                ),
                SizedBox(
                  width: cardWidth,
                  child: _adminStatCard(
                    title: "Total barang terjual (dummy)",
                    value: "128 pcs",
                    icon: Icons.shopping_bag_outlined,
                    cardColor: washedTheme,
                  ),
                ),
                SizedBox(
                  width: cardWidth,
                  child: _adminStatCard(
                    title: "Pesanan hari ini (dummy)",
                    value: "23 order",
                    icon: Icons.receipt_long_outlined,
                    cardColor: washedTheme,
                  ),
                ),
                SizedBox(
                  width: cardWidth,
                  child: _adminStatCard(
                    title: "Total nilai inventori",
                    value: "Rp ${_totalInventoryValue.toStringAsFixed(0)}",
                    icon: Icons.payments_outlined,
                    cardColor: washedTheme,
                  ),
                ),
                SizedBox(
                  width: cardWidth,
                  child: _adminStatCard(
                    title: "Stok menipis (<=5 item)",
                    value: "$_lowStockItems produk",
                    icon: Icons.warning_amber_rounded,
                    cardColor: washedTheme,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void chatLink() {
    if (role == "user") {
      Navigator.pushReplacementNamed(context, '/message');
    } else if (role == "admin") {
      Navigator.pushReplacementNamed(context, '/message');
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = const Color.fromARGB(255, 230, 114, 41);
    final washedTheme = const Color.fromARGB(255, 222, 208, 203);
    final displayName = (nama == null || nama!.trim().isEmpty) ? "User" : nama!;
    final isAdmin = role == "admin";
    final greetingTitle = isAdmin
        ? "Halo Admin $displayName"
        : "Halo $displayName";
    final greetingSubtitle = isAdmin
        ? "Siap bekerja hari ini?"
        : "Mau belanja apa hari ini?";
    // final gradient = LinearGradient(
    //   begin: Alignment.topLeft,
    //   end: Alignment.bottomRight,
    //   colors: [
    //     const Color.fromARGB(255, 247, 138, 70),
    //     themeColor,
    //     const Color.fromARGB(255, 192, 76, 13),
    //   ],
    // );
    return Scaffold(
      bottomNavigationBar: BottomNav(0),
      body: Container(
        decoration: BoxDecoration(color: themeColor),
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.only(top: 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32.0,
                      vertical: 24,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          greetingTitle,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Popins",
                          ),
                        ),
                        Text(
                          greetingSubtitle,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontFamily: "Popins",
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 26),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 32,
                    ),
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
                    child: _isLoadingProducts
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Color.fromARGB(255, 230, 114, 41),
                            ),
                          )
                        : _productError != null && _products.isEmpty
                        ? Center(
                            child: Text(
                              _productError!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.black54,
                                fontSize: 14,
                                fontFamily: "Popins",
                              ),
                            ),
                          )
                        : role == "admin"
                        ? _buildAdminDashboard(washedTheme)
                        : GridView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: _products.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 20,
                                  mainAxisSpacing: 20,
                                  childAspectRatio: 0.6,
                                ),
                            itemBuilder: (context, index) {
                              final p = _products[index];
                              return ProductCard(
                                product: p,
                                borderColor: washedTheme,
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
                ],
              ),
            ),
            Positioned(
              top: 50,
              left: 16,
              right: 16,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 0,
                        ),
                        height: 40,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromARGB(66, 0, 0, 0),
                              blurRadius: 25,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            prefixIcon: Padding(
                              padding: EdgeInsets.only(left: 7),
                              child: Icon(
                                Icons.search,
                                size: 20,
                                color: const Color.fromARGB(230, 0, 0, 0),
                              ),
                            ),
                            hintText: "Search...",
                            hintStyle: TextStyle(
                              color: Color.fromARGB(230, 0, 0, 0),
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                          ),
                          style: const TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    IconButton(
                      icon: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                        ),
                        child: Icon(
                          chatIcon,
                          size: 20,
                          color: Color.fromARGB(230, 0, 0, 0),
                        ),
                      ),
                      onPressed: chatLink,
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                        ),
                        child: Icon(
                          Icons.logout_outlined,
                          size: 20,
                          color: Color.fromARGB(230, 0, 0, 0),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/login');
                      },
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
