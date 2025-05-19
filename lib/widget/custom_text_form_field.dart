import 'package:easy_invoice/widget/text_custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextFormField extends StatelessWidget {
  final String label; // Nhãn hiển thị phía trên
  final TextEditingController controller; // Controller quản lý giá trị
  final String hintText; // Placeholder khi chưa nhập
  final bool isError; // Cờ hiển thị error message
  final String errorMessage; // Nội dung lỗi
  final bool obscureText; // Ẩn ký tự (mật khẩu)
  final Widget? suffixIcon; // Icon hiển thị cuối ô
  final FormFieldValidator<String>? validator; // Hàm validate
  final ValueChanged<String>? onChanged; // Callback khi giá trị thay đổi
  final FormFieldSetter<String>? onSaved; // Callback khi lưu form

  const CustomTextFormField({
    Key? key,
    required this.label,
    required this.controller,
    required this.hintText,
    this.isError = false,
    this.errorMessage = '',
    this.obscureText = false,
    this.suffixIcon,
    this.validator,
    this.onChanged,
    this.onSaved,
  }) : super(key: key);

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
              onChanged: onChanged,
              onSaved: onSaved,
            ),
          ),
          if (isError) // Hiển thị text lỗi khi cờ isError = true
            Flexible(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.only(top: 4.h),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    errorMessage,
                    style: TextStyle(
                      color: Color(0xFFFF0000),
                      fontWeight: FontWeight.w400,
                      fontSize: 12.sp,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
