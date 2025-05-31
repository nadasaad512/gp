// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:provider/provider.dart';
// import '../../../core/app_colors.dart';
// import '../../../date/user_provider.dart';
//
// class TypeDropDownWidget extends StatefulWidget {
//   String isAdmin;
//
//   TypeDropDownWidget({required this.isAdmin});
//
//   @override
//   _TypeDropDownWidgetState createState() => _TypeDropDownWidgetState();
// }
//
// class _TypeDropDownWidgetState extends State<TypeDropDownWidget> {
//   String? _selectedItem;
//   bool _isDropdownTapped = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           _isDropdownTapped = !_isDropdownTapped;
//         });
//       },
//       child: Container(
//         height: 45.h,
//         width: 150.w,
//         padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//         decoration: BoxDecoration(
//           color: Color(0xFFF3F3FB),
//           borderRadius: BorderRadius.circular(8),
//           border: Border.all(
//             color: _isDropdownTapped ? AppColors.primary : Colors.transparent,
//             width: 2,
//           ),
//         ),
//         child: DropdownButton<String>(
//           hint: Text(
//             widget.isAdmin,
//             style: TextStyle(
//               color:
//                   _isDropdownTapped
//                       ? Colors.green
//                       : Colors.grey, // Change hint color
//             ),
//           ),
//           value: _selectedItem,
//           onChanged: (String? newValue) {
//             setState(() {
//               _selectedItem = newValue;
//               _isDropdownTapped = false;
//             });
//             Provider.of<UserProvider>(context, listen: false).type =
//                 _selectedItem.toString();
//           },
//           isExpanded: true,
//           // Make the dropdown take up full width
//           items:
//               <String>["مشتري", "صيدلي"].map<DropdownMenuItem<String>>((
//                 String value,
//               ) {
//                 return DropdownMenuItem<String>(
//                   value: value,
//                   child: Text(value),
//                 );
//               }).toList(),
//           underline: Container(),
//           icon: Icon(
//             _isDropdownTapped
//                 ? Icons.keyboard_arrow_up
//                 : Icons.keyboard_arrow_down,
//             color: _isDropdownTapped ? Colors.green : Colors.grey,
//             size: 20.sp,
//           ),
//         ),
//       ),
//     );
//   }
// }
