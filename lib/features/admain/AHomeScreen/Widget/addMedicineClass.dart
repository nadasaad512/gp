import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gp/core/app_colors.dart';
import 'package:gp/date/Provider/AdminProvider.dart';
import 'package:gp/date/modules/products.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddMedicineDialog {
  static final TextEditingController nameController = TextEditingController();
  static final TextEditingController countController = TextEditingController();
  static final TextEditingController priceController = TextEditingController();
  static final TextEditingController decController = TextEditingController();

  static void show(BuildContext context, String id,
      {bool isEdit = false, ProductModel? product}) {
    if (isEdit && product != null) {
      nameController.text = product.name;
      countController.text = product.focus;
      priceController.text = product.price;
      decController.text = product.dec;
    }

    showDialog(
      context: context,
      builder: (context) {
        File? selectedImage;
        bool load = false;

        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: const Text("إضافة دواء", textDirection: TextDirection.rtl),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildTextField(nameController, "اسم الدواء"),
                  _buildTextField(countController, "التركيز"),
                  _buildTextField(priceController, "السعر",
                      keyboardType: TextInputType.number),
                  _buildTextField(decController, "تفاصيل الاستخدام",
                      maxLines: 3),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () async {
                      final picker = ImagePicker();
                      final pickedFile =
                          await picker.pickImage(source: ImageSource.gallery);
                      if (pickedFile != null && pickedFile.path.isNotEmpty) {
                        setState(() {
                          selectedImage = File(pickedFile.path);
                        });
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                        image: selectedImage != null
                            ? DecorationImage(
                                image: FileImage(selectedImage!),
                                fit: BoxFit.cover,
                              )
                            : (isEdit && product != null)
                                ? DecorationImage(
                                    image: NetworkImage(product.image),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                      ),
                      child: selectedImage == null
                          ? const Center(child: Text("اضغط لإضافة صورة"))
                          : null,
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _clearFields();
                },
                child: const Text("إلغاء", style: TextStyle(color: Colors.red)),
              ),
              ElevatedButton(
                onPressed: load
                    ? null
                    : () async {
                        setState(() => load = true);
                        await submitForm(context, selectedImage, id,
                            isEdit: isEdit, product: product);
                        setState(() => load = false);
                      },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: load
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2),
                      )
                    : Text(
                        isEdit ? "تعديل" : "إضافة",
                        style: TextStyle(color: Colors.white),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  static Widget _buildTextField(TextEditingController controller, String label,
      {int maxLines = 1, TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextField(
        cursorColor: AppColors.primary,
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        textDirection: TextDirection.rtl,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: AppColors.primary,
          ),
          focusColor: AppColors.primary,
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(
            color: AppColors.primary,
          )),
          border: const OutlineInputBorder(
              borderSide: BorderSide(
            color: AppColors.primary,
          )),
        ),
      ),
    );
  }

  static Future<void> submitForm(
      BuildContext context, File? selectedImage, String id,
      {bool isEdit = false, ProductModel? product}) async {
    if (nameController.text.isNotEmpty &&
        priceController.text.isNotEmpty &&
        decController.text.isNotEmpty &&
        (selectedImage != null || (isEdit && product != null))) {
      ProductModel productModel = ProductModel(
          id: isEdit ? product!.id : "",
          name: nameController.text,
          image: product?.image ?? "",
          dec: decController.text,
          price: priceController.text,
          focus: countController.text.isEmpty ? "" : countController.text,
          idAdmin: '',
          nameAdmin: '');

      if (isEdit) {
        await Provider.of<AdminProvider>(context, listen: false).editProducts(
          selectedImage,
          updatedProduct: productModel,
          catId: id,
        );
      } else {
        await Provider.of<AdminProvider>(context, listen: false)
            .addProducts(productModel, id, selectedImage!);
      }

      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isEdit ? "تم التعديل بنجاح" : "تمت إضافة المنتج بنجاح"),
          backgroundColor: Colors.green,
        ),
      );

      _clearFields();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("يرجى تعبئة جميع الحقول وإضافة صورة"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  static void _clearFields() {
    nameController.clear();
    countController.clear();
    priceController.clear();
    decController.clear();
  }
}
