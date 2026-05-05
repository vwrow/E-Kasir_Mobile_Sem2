import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:postman_penugasan1/models/cart.dart';
import 'package:postman_penugasan1/provider/provider_Cart.dart';
import 'package:postman_penugasan1/services/dbHelper.dart';
import 'package:postman_penugasan1/services/checkout_service.dart';
import 'package:postman_penugasan1/widgets/alert.dart';
import 'package:postman_penugasan1/widgets/navBar.dart';

class TransactionView extends StatefulWidget {
  const TransactionView({super.key});

  @override
  State<TransactionView> createState() => _TransactionViewState();
}

class _TransactionViewState extends State<TransactionView> {
  final dBHelper = DBHelper();
  bool _checkoutBusy = false;

  static const _themeColor = Color.fromARGB(255, 230, 114, 41);
  static const _washedTheme = Color.fromARGB(255, 222, 208, 203);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      await context.read<CartProvider>().getData();
    });
  }

  Widget _roundedIconButton({
    required IconData icon,
    required VoidCallback? onPressed,
    String? tooltip,
  }) {
    return IconButton(
      tooltip: tooltip,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onPressed: onPressed,
      icon: Container(
        height: 32,
        width: 32,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.white,
        ),
        child: Icon(icon, size: 20, color: const Color.fromARGB(230, 0, 0, 0)),
      ),
    );
  }

  Widget _cartLineCard(BuildContext context, Cart item) {
    final poster = item.posterpath;
    final hasImage =
        poster != null && poster.isNotEmpty && poster.startsWith('http');
    final harga = item.voteaverage;
    final qty = item.quantity ?? 0;
    double? lineTotal;
    if (harga != null) lineTotal = harga * qty;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _washedTheme, width: 2),
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(18, 0, 0, 0),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: SizedBox(
                height: 84,
                width: 84,
                child: hasImage
                    ? Image.network(
                        poster,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: _washedTheme.withAlpha(120),
                            child: Icon(
                              Icons.inventory_2_outlined,
                              color: Colors.blueGrey.shade400,
                            ),
                          );
                        },
                      )
                    : Container(
                        color: _washedTheme.withAlpha(120),
                        child: Icon(
                          Icons.inventory_2_outlined,
                          color: Colors.blueGrey.shade400,
                        ),
                      ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title ?? '-',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'Popins',
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.black87,
                    ),
                  ),
                  if (harga != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      'Rp ${harga.toStringAsFixed(0)} × $qty',
                      style: TextStyle(
                        fontFamily: 'Popins',
                        fontSize: 13,
                        color: Colors.blueGrey.shade600,
                      ),
                    ),
                  ],
                  if (lineTotal != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Subtotal Rp ${lineTotal.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontFamily: 'Popins',
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        color: Color.fromARGB(255, 230, 114, 41),
                      ),
                    ),
                  ],
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      IconButton.filled(
                        style: IconButton.styleFrom(
                          backgroundColor:
                              _themeColor.withAlpha((255 * 0.15).round()),
                          foregroundColor: _themeColor,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          minimumSize: const Size(38, 38),
                          padding: EdgeInsets.zero,
                        ),
                        onPressed: item.id != null
                            ? () =>
                                context.read<CartProvider>().addQuantity(item.id!)
                            : null,
                        icon: const Icon(Icons.add, size: 20),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        child: Text(
                          '$qty',
                          style: const TextStyle(
                            fontFamily: 'Popins',
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      IconButton.filled(
                        style: IconButton.styleFrom(
                          backgroundColor:
                              _washedTheme.withAlpha((255 * 0.85).round()),
                          foregroundColor: Colors.blueGrey.shade800,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          minimumSize: const Size(38, 38),
                          padding: EdgeInsets.zero,
                        ),
                        onPressed: item.id != null
                            ? () => context.read<CartProvider>().deleteQuantity(
                                  item.id!,
                                )
                            : null,
                        icon: const Icon(Icons.remove, size: 20),
                      ),
                      const Spacer(),
                      IconButton(
                        tooltip: 'Hapus',
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onPressed: item.id != null
                            ? () async {
                                await dBHelper.deleteCartItem(item.id!);
                                if (!context.mounted) return;
                                context.read<CartProvider>().removeItem(item.id!);
                                context.read<CartProvider>().removeCounter();
                              }
                            : null,
                        icon: Icon(Icons.delete_outline_rounded,
                            color: Colors.red.shade400),
                      ),
                    ],
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
    final cartProvider = context.watch<CartProvider>();

    return Scaffold(
      backgroundColor: _themeColor,
      bottomNavigationBar: BottomNav(1),
      floatingActionButton: FloatingActionButton.extended(
        tooltip: 'Checkout',
        backgroundColor: _themeColor,
        foregroundColor: Colors.white,
        elevation: 4,
        extendedPadding: const EdgeInsets.symmetric(horizontal: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        onPressed: (_checkoutBusy || cartProvider.cart.isEmpty)
            ? null
            : () async {
                final cartItems = List<Cart>.from(cartProvider.cart);
                if (cartItems.isEmpty) return;

                setState(() => _checkoutBusy = true);
                try {
                  final result =
                      await CheckoutService().submitPurchase(cartItems);
                  if (!context.mounted) return;
                  if (!result.status) {
                    AlertMessage().showAlert(context, result.message, false);
                    return;
                  }

                  for (final item in cartItems) {
                    final id = item.id;
                    if (id != null) await dBHelper.deleteCartItem(id);
                  }

                  if (!context.mounted) return;
                  await context.read<CartProvider>().getData();
                  if (!context.mounted) return;
                  AlertMessage().showAlert(
                    context,
                    result.message.isNotEmpty
                        ? result.message
                        : 'Checkout berhasil',
                    true,
                  );
                } finally {
                  if (mounted) setState(() => _checkoutBusy = false);
                }
              },
        icon: _checkoutBusy
            ? const SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Icon(Icons.shopping_cart_checkout_rounded, color: Colors.white),
        label: Text(
          _checkoutBusy ? 'Memproses...' : 'Checkout',
          style: const TextStyle(
            fontFamily: 'Popins',
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 56),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 5),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Keranjang',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Popins',
                    ),
                  ),
                ),
                _roundedIconButton(
                  tooltip: 'Riwayat transaksi',
                  icon: Icons.history_rounded,
                  onPressed: () => Navigator.pushNamed(context, '/history'),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              cartProvider.cart.isEmpty
                  ? 'Mulai berbelanja dan checkout disini'
                  : 'Checkout ${cartProvider.cart.length} barang dalam keranjang!',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.95),
                fontSize: 14,
                height: 1.35,
                fontFamily: 'Popins',
              ),
            ),
          ),
          const SizedBox(height: 22),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 100),
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
              child: cartProvider.cart.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color:
                                  _washedTheme.withAlpha((255 * 0.45).round()),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.shopping_bag_outlined,
                              size: 48,
                              color: Colors.blueGrey.shade500,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Keranjang masih kosong',
                            style: TextStyle(
                              fontFamily: 'Popins',
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                              color: Colors.blueGrey.shade800,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Tambahkan produk dari beranda',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Popins',
                              fontSize: 14,
                              height: 1.45,
                              color: Colors.blueGrey.shade600,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: cartProvider.cart.length,
                      itemBuilder: (context, index) =>
                          _cartLineCard(context, cartProvider.cart[index]),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
