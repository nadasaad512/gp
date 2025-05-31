import 'package:gp/date/modules/orders.dart';

class NotificationModel {
  final String nameUser;
  final String addressUser;
  final String phoneUser;
  final String idAdmin;
  final List<ProductItemModel> products;

  NotificationModel({
    required this.nameUser,
    required this.addressUser,
    required this.phoneUser,
    required this.idAdmin,
    required this.products,
  });

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      nameUser: map['nameUser'] ?? '',
      addressUser: map['addressUser'] ?? '',
      phoneUser: map['phoneUser'] ?? '',
      idAdmin: map['idAdmin'] ?? '',
      products: (map['products'] as List<dynamic>?)
              ?.map((item) => ProductItemModel.fromMap(item))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nameUser': nameUser,
      'addressUser': addressUser,
      'phoneUser': phoneUser,
      'idAdmin': idAdmin,
      'products': products.map((e) => e.toMap()).toList(),
    };
  }
}
