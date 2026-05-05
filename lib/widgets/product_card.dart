import 'package:flutter/material.dart';
import 'package:postman_penugasan1/models/product_models.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;
  final Color borderColor;
  final bool showAdminActions;
  final List<String> adminActions;
  final Future<void> Function(String action, ProductModel product)?
  onAdminAction;
  final VoidCallback? onTap;

  const ProductCard({
    super.key,
    required this.product,
    required this.borderColor,
    this.showAdminActions = false,
    this.adminActions = const ["Update", "Hapus"],
    this.onAdminAction,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: borderColor, width: 2.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Stack(
                  children: [
                    AspectRatio(
                      aspectRatio: 1,
                      child:
                          (product.image != null && product.image!.isNotEmpty)
                          ? Image.network(
                              product.image!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey,
                                  child: const Icon(
                                    Icons.image,
                                    color: Colors.black,
                                  ),
                                );
                              },
                            )
                          : Container(
                              color: Colors.grey,
                              child: const Icon(
                                Icons.image,
                                color: Colors.black,
                              ),
                            ),
                    ),
                    if (showAdminActions)
                      Positioned(
                        top: 5,
                        right: 5,
                        child: PopupMenuButton<String>(
                          icon: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.more_vert,
                              color: Colors.white,
                            ),
                          ),
                          onSelected: (action) async {
                            if (onAdminAction != null) {
                              await onAdminAction!(action, product);
                            }
                          },
                          itemBuilder: (BuildContext context) {
                            return adminActions
                                .map(
                                  (action) => PopupMenuItem<String>(
                                    value: action,
                                    child: Text(action),
                                  ),
                                )
                                .toList();
                          },
                        ),
                      ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 12,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        product.namaBarang ?? "Nama Barang",
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
                        product.deskripsi ?? "Deskripsi tidak tersedia",
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
                        "Stok: ${product.stok ?? 0}",
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 11,
                          fontFamily: "Popins",
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        "Rp. ${product.harga ?? 0.0}",
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
        ),
      ),
    );
  }
}
