import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gp/date/Provider/UserProvider.dart';
import 'package:gp/features/user/Home/widget/BgHomeWidget.dart';
import 'package:gp/features/user/Home/widget/CategoriesWidget.dart';
import 'package:gp/features/user/Home/widget/NearbyPharmaciesWidget.dart';
import 'package:gp/features/user/Home/widget/RecommendedWidget.dart';
import 'package:gp/features/user/Home/widget/TitleTextHomeWidget.dart';
import 'package:gp/features/widget/loadingWidget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../TextFieldSearchWidget.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final String? area = prefs.getString('area');
    await Provider.of<UserProvider>(context, listen: false).fetchCategories();
    await Provider.of<UserProvider>(context, listen: false).getRecommended();

    await Provider.of<UserProvider>(context, listen: false)
        .fetchNearbyPharmac(area: area.toString());

    _isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, provider, child) {
        return Column(
          children: [
            BgHomeWidget(),
            _isLoading
                ? Expanded(child: Center(child: loadingWidget()))
                : Expanded(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 20.w),
                      child: ListView(
                        scrollDirection: Axis.vertical,
                        physics: BouncingScrollPhysics(),
                        children: [
                          TextFieldSearchWidget(),
                          SizedBox(height: 20.h),
                          provider.recommended == [] ||
                                  provider.recommended.isEmpty
                              ? SizedBox.shrink()
                              : TitleTextHomeWidget(title: "منتجات موصى بها"),
                          provider.recommended == [] ||
                                  provider.recommended.isEmpty
                              ? SizedBox.shrink()
                              : SizedBox(height: 20.h),
                          provider.recommended == [] ||
                                  provider.recommended.isEmpty
                              ? SizedBox.shrink()
                              : RecommendedWidget(
                                  recommended: provider.recommended,
                                ),
                          SizedBox(height: 20.h),
                          TitleTextHomeWidget(title: "صيدليات قريبة منك"),
                          SizedBox(height: 20.h),
                          NearbyPharmaciesWidget(
                            nearbyPharmac: provider.nearbyPharmac,
                          ),
                          TitleTextHomeWidget(title: "الأقسام"),
                          SizedBox(height: 20.h),
                          CategoriesWidget(
                            category: provider.category,
                          ),
                          SizedBox(height: 100.h),
                        ],
                      ),
                    ),
                  ),
          ],
        );
      },
    );
  }
}
