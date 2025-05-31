import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gp/core/app_colors.dart';
import 'package:gp/date/Provider/UserProvider.dart';
import 'package:gp/date/modules/products.dart';
import 'package:gp/features/auth/widget/DropdownWidget.dart';
import 'package:gp/features/user/Home/widget/BgHomeWidget.dart';
import 'package:gp/features/user/products/ProductDetails.dart';
import 'package:gp/features/widget/loadingWidget.dart';
import 'package:provider/provider.dart';

class ProductScreen extends StatefulWidget {
  String name;
  ProductScreen(this.name);
  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  bool _isLoading = true;
  String? selectedProvince;
  String? selectedArea;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await Provider.of<UserProvider>(context, listen: false)
        .fetchProducts(name: widget.name);

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          backgroundColor: AppColors.white,
          body: Column(
            children: [
              BgHomeWidget(
                isArrow: true,
                isTitle: true,
                title: widget.name,
              ),
              SizedBox(height: 10.h),

              // 🟢 هنا تم إضافة الـ Dropdown Row
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () async {
                          setState(() {
                            _isLoading = true;
                            selectedArea = null;
                            selectedProvince = null;
                          });
                          await _loadData();
                        },
                        icon: Image.asset(
                          "assets/images/filter.png",
                          color: AppColors.primary,
                        )),
                    DropdownWidget(
                      title: 'اختر المحافظة',
                      listIndex: 1,
                      onChanged: (value) {
                        setState(() {
                          selectedArea = null;

                          selectedProvince = value;
                          // ممكن تستدعي دالة فلترة هنا
                        });
                      },
                    ),
                    SizedBox(width: 10.w),
                    DropdownWidget(
                      title: 'اختر المنطقة',
                      listIndex: 2,
                      selectedProvince: selectedProvince,
                      onChanged: (value) async {
                        setState(() {
                          selectedArea = value;
                          _isLoading = true;
                        });
                        if (selectedArea != null && selectedProvince != null)
                          await provider.filterfetchProducts(
                              name: widget.name,
                              selectedArea: selectedArea!,
                              selectedProvince: selectedProvince!);
                        setState(() {
                          _isLoading = false;
                        });
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.h),

              _isLoading
                  ? Expanded(child: Center(child: loadingWidget()))
                  : Expanded(
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 20.w,
                          mainAxisSpacing: 20.h,
                        ),
                        itemCount: provider.products.length,
                        itemBuilder: (context, index) =>
                            productItem(context, provider.products[index]),
                      ),
                    ),
            ],
          ),
        );
      },
    );
  }

  Widget productItem(BuildContext context, ProductModel product) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ProductDetails(
                    name: widget.name,
                    product: product,
                  )),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10.w),
        height: 100.h,
        width: 50.w,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppColors.primary, width: 1),
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              spreadRadius: 1,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 10.h,
            ),
            Container(
              height: 100.h,
              width: 100.w,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(product.image), fit: BoxFit.cover),
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Text(product.name,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.black,
                )),
            SizedBox(
              height: 10.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(" صيدلية ${product.nameAdmin}",
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.black,
                    )),
                SizedBox(
                  width: 10.w,
                ),
                Text("${product.price} شيكل",
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.black,
                    )),
              ],
            )
          ],
        ),
      ),
    );
  }
}
