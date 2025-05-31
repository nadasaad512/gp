import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gp/core/app_colors.dart';
import 'package:gp/date/Provider/AdminProvider.dart';
import 'package:gp/date/modules/category.dart';
import 'package:gp/features/admain/AHomeScreen/MedicineScreen.dart';
import 'package:gp/features/admain/AHomeScreen/Widget/cardInfoWidget.dart';
import 'package:gp/features/admain/AHomeScreen/Widget/titleWidget.dart';
import 'package:gp/features/widget/loadingWidget.dart';
import 'package:provider/provider.dart';
import '../../user/Home/widget/BgHomeWidget.dart';

class AHomeScreen extends StatefulWidget {
  @override
  State<AHomeScreen> createState() => _AHomeScreenState();
}

class _AHomeScreenState extends State<AHomeScreen> {
  bool _isLoading = true;
  CategoryModel? selectedCategory;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    await Provider.of<AdminProvider>(context, listen: false).fetchCategories();
    await Provider.of<AdminProvider>(context, listen: false)
        .fetchAdminCategories();

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AdminProvider>(
      builder: (context, adminProvider, child) {
        return Scaffold(
          backgroundColor: AppColors.white,
          body: Column(
            children: [
              BgHomeWidget(),
              titleWidget(),
              _isLoading
                  ? Expanded(child: Center(child: loadingWidget()))
                  : Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: DropdownButtonFormField<CategoryModel>(
                        isExpanded: true,
                        focusColor: AppColors.primary,
                        decoration: InputDecoration(
                          labelText: "اختر القسم",
                          border: OutlineInputBorder(),
                        ),
                        value: selectedCategory,
                        items: adminProvider.category.map((category) {
                          return DropdownMenuItem<CategoryModel>(
                            value: category,
                            child: Text(category.name,
                                textDirection: TextDirection.rtl),
                          );
                        }).toList(),
                        onChanged: (value) async {
                          setState(() {
                            selectedCategory = value;
                            _isLoading = true;
                          });

                          await adminProvider
                              .addCategoryToUserData(selectedCategory!);
                          setState(() {
                            _isLoading = false;
                          });
                        },
                      ),
                    ),
              if (adminProvider.adminCategory.isNotEmpty)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                    ),
                    child: GridView.builder(
                      itemCount: adminProvider.adminCategory.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 5,
                        childAspectRatio: 8 / 9,
                      ),
                      itemBuilder: (context, index) {
                        final category = adminProvider.adminCategory[index];
                        return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddMedicineScreen(
                                          id: category.id,
                                          name: category.name,
                                        )),
                              );
                            },
                            child: CardInfoWidget(
                              image: category.image,
                              name: category.name,
                            ));
                      },
                    ),
                  ),
                )
            ],
          ),
        );
      },
    );
  }
}
