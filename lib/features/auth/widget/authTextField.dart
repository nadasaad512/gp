import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/app_colors.dart';

class CustomInputField extends StatefulWidget {
  final String label;
  final IconData icon;
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool obscureText;
  final bool isEnable;

  const CustomInputField(
      {super.key,
      required this.label,
      required this.icon,
      required this.controller,
      required this.focusNode,
      this.obscureText = false,
      this.isEnable = true});

  @override
  State<CustomInputField> createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  bool _obscure = true;

  @override
  void initState() {
    super.initState();
    _obscure = widget.obscureText;
    widget.controller.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    bool isFocused = widget.focusNode.hasFocus;
    bool hasText = widget.controller.text.isNotEmpty;
    return SizedBox(
      width: double.infinity,
      height: 45.h,
      child: TextFormField(
        enabled: widget.isEnable,
        cursorColor: AppColors.primary,
        cursorHeight: 20.h,
        controller: widget.controller,
        focusNode: widget.focusNode,
        obscureText: _obscure,
        obscuringCharacter: '*',
        decoration: InputDecoration(
          labelText: widget.label,
          floatingLabelBehavior: isFocused
              ? FloatingLabelBehavior.always
              : FloatingLabelBehavior.never,
          alignLabelWithHint: true,
          suffixIcon: widget.obscureText
              ? IconButton(
                  icon: Icon(
                    _obscure ? Icons.visibility_off : Icons.visibility,
                    size: 20.sp,
                    color: hasText || isFocused ? Colors.green : Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscure = !_obscure;
                    });
                  },
                )
              : Icon(
                  widget.icon,
                  size: 20.sp,
                  color: hasText || isFocused ? Colors.green : Colors.grey,
                ),
          filled: !hasText && !isFocused,
          fillColor: !hasText && !isFocused ? const Color(0xFFF3F3FB) : null,
          enabledBorder: !hasText && !isFocused
              ? OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(12),
                )
              : OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.green),
                  borderRadius: BorderRadius.circular(12),
                ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.green, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
          floatingLabelStyle: TextStyle(
              color: isFocused ? Colors.green : Colors.grey,
              fontSize: 16.sp,
              fontWeight: FontWeight.w400),
          labelStyle: TextStyle(
            color: Colors.grey,
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
