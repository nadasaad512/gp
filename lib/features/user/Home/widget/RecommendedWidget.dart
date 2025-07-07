import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:gp/date/modules/products.dart';
import 'package:gp/features/user/products/ProductDetails.dart';
import '../../../../core/app_colors.dart';

class RecommendedWidget extends StatefulWidget {
  List<ProductModel> recommended;
  RecommendedWidget({required this.recommended});
  @override
  _RecommendedWidgetState createState() => _RecommendedWidgetState();
}

class _RecommendedWidgetState extends State<RecommendedWidget> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: widget.recommended.length,
          options: CarouselOptions(
            height: 120.h,
            viewportFraction: 0.5,
            enableInfiniteScroll: false, // ✅ منع التكرار
            autoPlay: true,
            enlargeCenterPage: true, // يكبر العنصر بالنص
            autoPlayInterval: Duration(seconds: 3),
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
          itemBuilder: (context, index, realIdx) {
            bool isCenter = index == _currentIndex;
            return GestureDetector(
              onTap: () {
                ProductModel product = ProductModel(
                  dec: widget.recommended[index].dec,
                  focus: widget.recommended[index].focus,
                  id: widget.recommended[index].id,
                  idAdmin: widget.recommended[index].idAdmin,
                  image: widget.recommended[index].image,
                  name: widget.recommended[index].name,
                  nameAdmin: widget.recommended[index].nameAdmin,
                  price: widget.recommended[index].price,
                );
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProductDetails(
                            name: "",
                            product: product,
                          )),
                );
              },
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                decoration: BoxDecoration(
                  //  color: AppColors.primary,
                  image: widget.recommended == [] || widget.recommended.isEmpty
                      ? null
                      : DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(widget.recommended[index].image)),
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: AppColors.primary),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.4),
                      spreadRadius: 2,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                width: isCenter ? 500.w : 140.w, // تكبير الكارد اللي بالنص
              ),
            );
          },
        ),
      ],
    );
  }
}
