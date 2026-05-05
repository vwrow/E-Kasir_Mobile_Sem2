class Cart {
  late final int? id;
  final String? id_product;
  final String? title;
  final double? voteaverage;
  final String? overview;
  int? quantity = 0;
  final String? posterpath;

  Cart({
    required this.id,
    required this.id_product,
    required this.title,
    required this.voteaverage,
    required this.overview,
    required this.quantity,
    required this.posterpath,
  });

  factory Cart.fromMap(Map<dynamic, dynamic> data) {
    return Cart(
      id: data['id'],
      id_product: data['id'].toString(),
      title: data['title'],
      // Be tolerant: cart rows may contain null/invalid voteaverage values.
      voteaverage: data['voteaverage'] == null
          ? null
          : double.tryParse(data['voteaverage'].toString()),
      overview: data['overview'],
      quantity: data['quantity'] == null ? null : (data['quantity'] as num).toInt(),
      posterpath: data['posterpath'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      // Match DB schema column name.
      'id_movie': id_product,
      'title': title,
      'voteaverage': voteaverage,
      'overview': overview,
      'quantity': quantity,
      'posterpath': posterpath,
    };
  }
}
