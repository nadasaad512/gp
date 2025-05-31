import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/app_colors.dart';

class EditDropdownWidget extends StatefulWidget {
  final String title;
  final bool isEnabled;

  EditDropdownWidget({required this.title, this.isEnabled = true});

  @override
  _EditDropdownWidgetState createState() => _EditDropdownWidgetState();
}

class _EditDropdownWidgetState extends State<EditDropdownWidget> {
  String? _selectedItem;

  @override
  Widget build(BuildContext context) {
    Color borderColor =
        widget.isEnabled ? AppColors.primary : Colors.grey.shade300;

    Color textColor = widget.isEnabled ? AppColors.black : Colors.grey;

    return Container(
      height: 45.h,
      width: 170.w,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: borderColor,
          width: 1,
        ),
      ),
      child: DropdownButton<String>(
        hint: Text(
          widget.title,
          style: TextStyle(
            color: textColor,
            fontSize: 14.sp,
          ),
        ),
        value: _selectedItem,
        onChanged: widget.isEnabled
            ? (String? newValue) {
                setState(() {
                  _selectedItem = newValue;
                });
              }
            : null,
        isExpanded: true,
        items: widget.isEnabled
            ? <String>['Item 1', 'Item 2', 'Item 3', 'Item 4']
                .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList()
            : null,
        underline: Container(),
        icon: widget.isEnabled
            ? Icon(
                Icons.keyboard_arrow_down,
                color: AppColors.primary,
                size: 20.sp,
              )
            : Icon(
                Icons.keyboard_arrow_down,
                color: AppColors.primary.withOpacity(0.3), // سهم باهت
                size: 20.sp,
              ),
        disabledHint: Text(
          widget.title,
          style: TextStyle(
            color: textColor,
            fontSize: 14.sp,
          ),
        ),
      ),
    );
  }
}
