import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gp/core/text_styles.dart';
import 'package:gp/date/Provider/UserProvider.dart';
import 'package:gp/date/modules/cart.dart';
import 'package:gp/features/user/products/ProductDetails.dart';
import 'package:gp/features/user/showProfileAdmin.dart';
import 'package:gp/features/widget/button.dart';
import 'package:gp/features/widget/loadingWidget.dart';
import 'package:provider/provider.dart';
import '../../../core/app_colors.dart';
import '../Home/widget/BgHomeWidget.dart';

class RequestScreen extends StatefulWidget {
  @override
  State<RequestScreen> createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await Provider.of<UserProvider>(context, listen: false).getRequest();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, provider, child) {
      return Scaffold(
        backgroundColor: AppColors.white,
        body: Column(
          children: [
            BgHomeWidget(
              isTitle: true,
              title: "طلباتي السابقة",
            ),
            _isLoading
                ? Expanded(child: Center(child: loadingWidget()))
                : provider.request.isEmpty
                    ? Center(
                        child: Text(
                          "\n \n \n \n   \nلم تقم بطلب أي طلب من قبل",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 24.sp,
                          ),
                        ),
                      )
                    : Expanded(
                        child: ListView.separated(
                          scrollDirection: Axis.vertical,
                          itemCount: provider.request.length,
                          itemBuilder: (BuildContext, index) {
                            return requestItem(provider.request[index]);
                          },
                          separatorBuilder: (BuildContext, index) {
                            return SizedBox(width: 20.w);
                          },
                        ),
                      ),
          ],
        ),
      );
    });
  }

  Widget requestItem(CartModel request) {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.green),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: 100.w,
                  height: 100.h,
                  alignment: Alignment.topRight,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(request.product.image))),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      request.product.name + '  ' + request.product.focus,
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                      "الكمية: ${request.quantity}   السعر: ${int.parse(request.product.price) * request.quantity} شيكل",
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => showProfileAdmin(
                                    idAdmin: request.product.idAdmin,
                                  )),
                        );
                      },
                      child: Text(
                        " صيدلية ${request.product.nameAdmin} ",
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          decorationColor: AppColors.primary,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 10.h,
            ),
            SizedBox(
              height: 30.h,
              child: ElevatedButton(
                onPressed: () async {
                  await Provider.of<UserProvider>(context, listen: false)
                      .getOneProduct(request);
                  CartModel? cart =
                      Provider.of<UserProvider>(context, listen: false)
                          .oneProduct;

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProductDetails(
                              name: request.namecart,
                              product: cart!.product,
                            )),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                child: Text(
                  "اطلبه مرة اخرى ",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
          ],
        ));
  }
}
