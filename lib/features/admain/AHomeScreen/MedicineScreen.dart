import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gp/core/app_colors.dart';
import 'package:gp/features/admain/AHomeScreen/Widget/addMedicineClass.dart';
import 'package:gp/features/admain/AHomeScreen/Widget/cardInfoWidget.dart';
import 'package:gp/features/user/Home/widget/BgHomeWidget.dart';
import 'package:gp/features/widget/loadingWidget.dart';
import 'package:provider/provider.dart';
import 'package:gp/date/Provider/AdminProvider.dart';

class AddMedicineScreen extends StatefulWidget {
  final String id;
  final String name;
  AddMedicineScreen({required this.id, required this.name});
  @override
  _AddMedicineScreenState createState() => _AddMedicineScreenState();
}

class _AddMedicineScreenState extends State<AddMedicineScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    Provider.of<AdminProvider>(context, listen: false)
        .getProductsById(widget.id);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AdminProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              AddMedicineDialog.show(context, widget.id);
            },
            backgroundColor: Colors.white,
            elevation: 0,
            child:
                Icon(Icons.add_circle, size: 70.sp, color: AppColors.primary),
          ),
          body: Column(
            children: [
              BgHomeWidget(
                isTitle: true,
                title: widget.name,
                isArrow: true,
              ),
              SizedBox(height: 15.h),
              Align(
                alignment: Alignment.topRight,
                child: Text(
                  '    قم بإضافة الأدوية المتوفرة في هذا القسم  ',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              SizedBox(height: 5.h),
              _isLoading
                  ? Expanded(child: Center(child: loadingWidget()))
                  : Expanded(
                      child: GridView.builder(
                        itemCount: provider.products.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 5,
                          mainAxisSpacing: 5,
                          childAspectRatio: 8 / 9,
                        ),
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.symmetric(horizontal: 10.w),
                            child: CardInfoWidget(
                              image: provider.products[index].image,
                              name: provider.products[index].name,
                              onTap: () {
                                AddMedicineDialog.show(
                                  context,
                                  widget.id,
                                  isEdit: true,
                                  product: provider.products[index],
                                );
                              },
                              onDelete: () async {
                                setState(() {
                                  _isLoading = true;
                                });
                                await provider.deletProducts(
                                    widget.id, provider.products[index].id);
                                await provider.getProductsById(widget.id);
                                setState(() {
                                  _isLoading = false;
                                });
                              },
                            ),
                          );
                        },
                      ),
                    )
            ],
          ),
        );
      },
    );
  }
}
