class ProductItemModel {
  final String nameProduct;
  final String countProduct;
  final String price;

  ProductItemModel(
      {required this.nameProduct,
      required this.countProduct,
      required this.price});

  factory ProductItemModel.fromMap(Map<String, dynamic> map) {
    return ProductItemModel(
      nameProduct: map['nameProduct'] ?? '',
      countProduct: map['countProduct'] ?? '',
      price: map['price'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nameProduct': nameProduct,
      'countProduct': countProduct,
      'price': price,
    };
  }
}
