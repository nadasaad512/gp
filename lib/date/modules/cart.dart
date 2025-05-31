import 'package:flutter/material.dart';
import 'package:gp/date/modules/products.dart';

class CartModel {
  final ProductModel product;
  final int quantity;
  String idcart;
  String namecart;

  CartModel(
      {required this.product,
      required this.quantity,
      required this.idcart,
      required this.namecart});

  Map<String, dynamic> toMap() {
    final map = product.toMap();
    map['quantity'] = quantity;
    map['idcart'] = idcart;
    map['namecart'] = namecart;
    return map;
  }

  factory CartModel.fromMap(Map<String, dynamic> map) {
    return CartModel(
      product: ProductModel.fromMap(map),
      quantity: map['quantity'] ?? 1,
      idcart: map['idcart'] ?? '',
      namecart: map['namecart'] ?? '',
    );
  }
}
