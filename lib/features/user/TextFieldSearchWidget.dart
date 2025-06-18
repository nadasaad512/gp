import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gp/date/modules/products.dart';
import 'package:gp/features/user/products/ProductDetails.dart';
import '../../core/app_colors.dart';

class TextFieldSearchWidget extends StatefulWidget {
  const TextFieldSearchWidget({Key? key}) : super(key: key);

  @override
  State<TextFieldSearchWidget> createState() => _TextFieldSearchWidgetState();
}

class _TextFieldSearchWidgetState extends State<TextFieldSearchWidget> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];
  Timer? _debounce;

  void _searchMedicine(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 300), () async {
      if (query.isEmpty) {
        setState(() => _searchResults = []);
        return;
      }

      try {
        final snapshot = await FirebaseFirestore.instance
            .collectionGroup('products')
            .orderBy('name')
            .startAt([query]).endAt([query + '\uf8ff']).get();

        setState(() {
          _searchResults = snapshot.docs.map((doc) {
            final data = doc.data();
            return {
              'name': data['name'],
              'nameAdmin': data['nameAdmin'] ?? 'غير معروف',
              'dec': data['dec'],
              'focus': data['focus'] ?? "",
              'id': data['id'],
              'idAdmin': data['idAdmin'],
              'image': data['image'],
              'price': data['price']
            };
          }).toList();
        });
      } catch (e) {
        print("خطأ في البحث: $e");
      }
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).unfocus(); // 👈 يخفي الكيبورد بعد عرض الشاشة
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 38.h,
          child: TextField(
            autofocus: false,
            controller: _searchController,
            cursorColor: AppColors.primary,
            onChanged: _searchMedicine,
            decoration: InputDecoration(
              hintText: 'بحث عن اسم الدواء...',
              hintStyle: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 13.sp,
                color: AppColors.primary,
              ),
              suffixIcon:
                  Icon(Icons.search, size: 20.sp, color: AppColors.primary),
              border: InputBorder.none,
              focusedBorder: OutlineInputBorder(
                borderSide:
                    const BorderSide(color: AppColors.primary, width: 1),
                borderRadius: BorderRadius.circular(19),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide:
                    const BorderSide(color: AppColors.primary, width: 1),
                borderRadius: BorderRadius.circular(19),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        if (_searchController.text.isNotEmpty && _searchResults.isEmpty)
          Text(
            'لا توجد نتائج مطابقة.',
            style: TextStyle(fontSize: 12.sp, color: Colors.grey),
          ),
        if (_searchResults.isNotEmpty)
          SizedBox(
            height: 200.h,
            child: ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                final medicine = _searchResults[index];
                print(medicine);
                ProductModel product = ProductModel(
                    dec: medicine['dec'],
                    focus: medicine['focus'],
                    id: medicine['id'],
                    idAdmin: medicine['idAdmin'],
                    image: medicine['image'],
                    name: medicine['name'],
                    nameAdmin: medicine['nameAdmin'],
                    price: medicine['price']);
                return GestureDetector(
                  onTap: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProductDetails(
                                name: "",
                                product: product,
                              )),
                    );
                  },
                  child: ListTile(
                    leading: Icon(Icons.medication, color: AppColors.primary),
                    title: Text(medicine['name'] ?? 'بدون اسم'),
                    subtitle: Text(
                      '${medicine['nameAdmin'] ?? ''}',
                      style: TextStyle(height: 1.4),
                    ),
                  ),
                );
              },
            ),
          )
      ],
    );
  }
}
