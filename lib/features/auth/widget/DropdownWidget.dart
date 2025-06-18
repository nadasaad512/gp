import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gp/core/app_colors.dart';
import 'package:gp/date/Provider/auth_provider.dart';
import 'package:provider/provider.dart';

class DropdownWidget extends StatefulWidget {
  final String title;
  final int listIndex;
  final String? selectedProvince;
  final Function(String)? onChanged;

  DropdownWidget({
    required this.title,
    required this.listIndex,
    this.selectedProvince,
    this.onChanged,
  });

  @override
  _DropdownWidgetState createState() => _DropdownWidgetState();
}

class _DropdownWidgetState extends State<DropdownWidget> {
  String? _selectedItem;
  bool _isDropdownTapped = false;

  final List<String> provinces = ['جنوب غزة', 'الوسطى', 'شمال غزة'];

  final Map<String, List<String>> provinceAreas = {
    'جنوب غزة': ['خان يونس', 'رفح'],
    'الوسطى': [
      'دير البلح',
      'المغازي',
      'الزيتون',
      'النصيرات',
      'البريج',
      'الزوايدة'
    ],
    'شمال غزة': [
      'الشجاعية',
      'جباليا',
      'بيت حانون',
      'الزيتون',
      'النصر',
      'الجلاء',
      'شارع الوحدة',
      'مفترق الاتصالات',
      'الساحة',
      'الرمال'
    ],
  };

  List<String> get currentList {
    if (widget.listIndex == 1) {
      return provinces;
    } else if (widget.listIndex == 2) {
      if (widget.selectedProvince != null &&
          provinceAreas.containsKey(widget.selectedProvince)) {
        return provinceAreas[widget.selectedProvince]!;
      } else {
        return [];
      }
    } else {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isDropdownTapped = !_isDropdownTapped;
        });
      },
      child: Container(
        height: 45.h,
        width: 150.w,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Color(0xFFF3F3FB),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: _isDropdownTapped ? AppColors.primary : Colors.transparent,
            width: 1,
          ),
        ),
        child: DropdownButton<String>(
          hint: Text(
            widget.title,
            style: TextStyle(
              color: _isDropdownTapped ? AppColors.primary : Colors.grey,
            ),
          ),
          value: currentList.contains(_selectedItem)
              ? _selectedItem
              : null, // ✅ هنا الحل
          onChanged: (String? newValue) {
            setState(() {
              _selectedItem = newValue;
              _isDropdownTapped = false;
            });

            if (widget.onChanged != null && newValue != null) {
              widget.onChanged!(newValue);
            }
            print('اختيار: $newValue');
          },
          isExpanded: true,
          items: currentList.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          underline: SizedBox.shrink(),
          icon: Icon(
            _isDropdownTapped
                ? Icons.keyboard_arrow_up
                : Icons.keyboard_arrow_down,
            color: _isDropdownTapped ? AppColors.primary : Colors.grey,
            size: 20.sp,
          ),
        ),
      ),
    );
  }
}
