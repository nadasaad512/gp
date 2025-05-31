import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gp/date/Provider/UserProvider.dart';
import 'package:gp/date/modules/cart.dart';
import 'package:gp/features/widget/button.dart';
import 'package:gp/features/widget/loadingWidget.dart';
import 'package:provider/provider.dart';
import '../../../core/app_colors.dart';
import '../Home/widget/BgHomeWidget.dart';

class CartScreen extends StatefulWidget {
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool _isLoading = true;
  bool isConfirm = false;
  int count = 1;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await Provider.of<UserProvider>(context, listen: false).fetchCart();
    setState(() {
      _isLoading = false;
    });
  }

  double getTotalPrice(List<CartModel> cartList) {
    double total = 0;
    for (var cart in cartList) {
      total += int.parse(cart.product.price) * cart.quantity;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, provider, child) {
        double totalPrice = getTotalPrice(provider.cart);

        return Scaffold(
          backgroundColor: AppColors.white,
          body: Column(
            children: [
              BgHomeWidget(
                isTitle: true,
                title: "عربة التسوق",
              ),
              _isLoading
                  ? Expanded(child: Center(child: loadingWidget()))
                  : provider.cart.isEmpty
                      ? Expanded(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "assets/images/empty_cart.png",
                                  scale: 3,
                                ),
                                SizedBox(height: 20.h),
                                Text(
                                  "لم تقم بإضافة أي منتجات إلى عربة التسوق الخاصة بك حتى الآن",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 24.sp,
                                  ),
                                ),
                                SizedBox(height: 30.h),
                              ],
                            ),
                          ),
                        )
                      : Expanded(
                          child: ListView.builder(
                            itemCount: provider.cart.length + 1,
                            itemBuilder: (context, index) {
                              if (index < provider.cart.length) {
                                return cetItem(provider.cart[index]);
                              } else {
                                return Column(
                                  children: [
                                    // عرض السعر الإجمالي
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 24.w, vertical: 8.h),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "المجموع الكلي:",
                                            style: TextStyle(
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.w300),
                                          ),
                                          Text(
                                            "${totalPrice.toStringAsFixed(2)} شيكل",
                                            style: TextStyle(
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.w300,
                                                color: AppColors.primary),
                                          ),
                                        ],
                                      ),
                                    ),

                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 24.w, vertical: 16.h),
                                      child: isConfirm
                                          ? loadingWidget()
                                          : CustomButton(
                                              text: 'تأكيد',
                                              onTap: () async {
                                                setState(
                                                    () => isConfirm = true);
                                                await Provider.of<UserProvider>(
                                                        context,
                                                        listen: false)
                                                    .confirmCart(context,
                                                        cartList:
                                                            provider.cart);
                                                setState(
                                                    () => isConfirm = false);
                                              },
                                              type: CustomButtonType
                                                  .buttonRectangular,
                                            ),
                                    ),
                                  ],
                                );
                              }
                            },
                          ),
                        ),
            ],
          ),
        );
      },
    );
  }

  Widget cetItem(CartModel cart) {
    count = cart.quantity;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.green),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 100.w,
            height: 100.h,
            alignment: Alignment.topRight,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(cart.product.image),
              ),
            ),
            child: CircleAvatar(
              maxRadius: 13.sp,
              backgroundColor: Colors.red,
              child: IconButton(
                onPressed: () async {
                  await Provider.of<UserProvider>(context, listen: false)
                      .deletProductToCart(idProduct: cart.idcart);
                },
                icon: Icon(
                  Icons.close_sharp,
                  size: 13.sp,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(cart.product.name),
              SizedBox(height: 10.h),
              Text(" ${cart.product.price} شيكل"),
              SizedBox(height: 10.h),
              Text(" صيدلية ${cart.product.nameAdmin} "),
            ],
          ),
          Container(
            alignment: Alignment.centerLeft,
            width: 50.w,
            padding: EdgeInsets.symmetric(vertical: 8.h),
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.primary,
              ),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildCircleButton(Icons.remove, () async {
                  if (count > 1) {
                    setState(() => count--);
                  }
                  await Provider.of<UserProvider>(context, listen: false)
                      .editProductToCart(context,
                          docId: cart.idcart, newQuantity: count);
                }),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30.w),
                  child: Text(
                    '${cart.quantity}',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                _buildCircleButton(Icons.add, () async {
                  setState(() => count++);
                  await Provider.of<UserProvider>(context, listen: false)
                      .editProductToCart(context,
                          docId: cart.idcart, newQuantity: count);
                }),
              ],
            ),
          ),
        ],
      ),
    );
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
