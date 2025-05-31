import 'package:flutter/material.dart';

class ProductModel {
  final String id;
  final String idAdmin;
  final String nameAdmin;
  final String name;
  final String image;
  final String dec;
  final String price;
  final String count;

  ProductModel({
    required this.id,
    required this.idAdmin,
    required this.nameAdmin,
    required this.name,
    required this.image,
    required this.dec,
    required this.price,
    required this.count,
  });

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'] ?? '',
      idAdmin: map['idAdmin'] ?? '',
      nameAdmin: map['nameAdmin'] ?? '',
      name: map['name'] ?? '',
      image: map['image'] ?? '',
      dec: map['dec'] ?? '',
      price: map['price'] ?? '',
      count: map['count'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'idAdmin': idAdmin,
      'nameAdmin': nameAdmin,
      'name': name,
      'image': image,
      'dec': dec,
      'price': price,
      'count': count,
    };
  }
}
