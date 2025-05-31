import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gp/core/app_colors.dart';
import 'package:gp/date/Provider/UserProvider.dart';
import 'package:gp/date/modules/cart.dart';
import 'package:gp/date/modules/products.dart';
import 'package:gp/features/admain/Profile/ProfileScreen.dart';
import 'package:gp/features/user/Home/widget/BgHomeWidget.dart';
import 'package:gp/features/user/showProfileAdmin.dart';
import 'package:gp/features/widget/button.dart';
import 'package:gp/features/widget/loadingWidget.dart';
import 'package:provider/provider.dart';

class ProductDetails extends StatefulWidget {
  String name;
  ProductModel product;
  ProductDetails({required this.name, required this.product});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  int count = 1;
  bool isload = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.white,
        body: Column(children: [
          BgHomeWidget(
            isArrow: true,
            isTitle: true,
            title: widget.name,
          ),
          SizedBox(
            height: 20.h,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20.w),
            height: 150.h,
            width: double.infinity,
            child: Image.network(widget.product.image),
          ),
          SizedBox(
            height: 50.h,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(widget.product.name,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.black,
                        )),
                    Text("${widget.product.price} شيكل",
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.black,
                        )),
                  ],
                ),
                SizedBox(
                  height: 20.h,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => showProfileAdmin(
                                idAdmin: widget.product.idAdmin,
                              )),
                    );
                  },
                  child: Text(
                    " صيدلية ${widget.product.nameAdmin}",
                    style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primary,
                        decorationColor: AppColors.primary,
                        decoration: TextDecoration.underline),
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Text(
                  "وصف المنتج ",
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.black,
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Text(
                  widget.product.dec,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.black,
                  ),
                ),
                SizedBox(
                  height: 30.h,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: 200.w,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColors.primary,
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildCircleButton(Icons.remove, () {
                          if (count > 1) {
                            setState(() => count--);
                          }
                        }),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 30.w),
                          child: Text(
                            '$count',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        _buildCircleButton(Icons.add, () {
                          setState(() => count++);
                        }),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 30.h,
                ),
                Align(
                  alignment: Alignment.center,
                  child: isload
                      ? loadingWidget()
                      : CustomButton(
                          text: 'أضف الى السلة',
                          onTap: () async {
                            setState(() {
                              isload = true;
                            });
                            CartModel cartModel = CartModel(
                                product: widget.product,
                                quantity: count,
                                namecart: widget.name,
                                idcart: "");
                            await Provider.of<UserProvider>(context,
                                    listen: false)
                                .addProductToCart(context, cartData: cartModel);
                            setState(() {
                              isload = false;
                            });
                          },
                          type: CustomButtonType.buttonRectangular,
                        ),
                ),
              ],
            ),
          )
        ]));
  }

  Widget _buildCircleButton(IconData icon, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.primary,
          shape: BoxShape.circle,
        ),
        padding: EdgeInsets.all(8),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}
