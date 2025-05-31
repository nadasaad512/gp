import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gp/date/Provider/UserProvider.dart';
import 'package:gp/date/modules/cart.dart';
import 'package:gp/features/user/showProfileAdmin.dart';
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
                          "لم تقم بطلب أي طلب من قبل",
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
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => showProfileAdmin(
                    idAdmin: request.product.idAdmin,
                  )),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.green),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
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
                  request.product.name,
                ),
                SizedBox(
                  height: 10.h,
                ),
                Text(
                  "الكمية: ${request.product.count}   السعر: ${request.product.price} شيكل",
                ),
                SizedBox(
                  height: 10.h,
                ),
                Text(
                  " صيدلية ${request.product.nameAdmin} ",
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    decorationColor: AppColors.primary,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
