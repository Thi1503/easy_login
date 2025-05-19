import 'package:easy_invoice/widget/text_custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextFormField extends StatelessWidget {
  final String label; // Nhãn hiển thị phía trên
  final TextEditingController controller; // Controller quản lý giá trị
  final String hintText; // Placeholder khi chưa nhập
  final bool isError; // Cờ hiển thị error message
  final bool obscureText; // Ẩn ký tự (mật khẩu)
  final Widget? suffixIcon; // Icon hiển thị cuối ô
  final FormFieldValidator<String>? validator; // Hàm validate

  const CustomTextFormField({
    super.key,
    required this.label,
    required this.controller,
    required this.hintText,
    this.isError = false,
    this.obscureText = false,
    this.suffixIcon,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 106.h, // Chiều cao ô nhập
      width: 343.w, // Chiều rộng cố định
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(flex: 1, child: TextCustom(text: label)), // Hiển thị label
          Flexible(
            flex: 2,
            child: TextFormField(
              controller: controller,
              obscureText: obscureText,
              decoration: InputDecoration(
                hintText: hintText,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6.r),
                  borderSide: BorderSide(color: Color(0xFFEBECED), width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6.r),
                  borderSide: BorderSide(color: Color(0xFFF24E1E), width: 2),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6.r),
                  borderSide: BorderSide(color: Colors.red, width: 1),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6.r),
                  borderSide: BorderSide(color: Colors.red, width: 2),
                ),
                suffixIcon: suffixIcon,
              ),
              validator: validator,
            ),
          ),
        ],
      ),
    );
  }
}
