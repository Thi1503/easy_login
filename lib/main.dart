import 'package:easy_invoice/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // Thư viện để responsive theo kích thước màn hình
import 'package:google_fonts/google_fonts.dart';

/// Điểm khởi đầu của ứng dụng
void main() {
  runApp(
    ScreenUtilInit(
      designSize: Size(375, 812), // Kích thước thiết kế Figma/iPhone
      minTextAdapt: true, // Tự động điều chỉnh cỡ chữ
      builder: (context, child) {
        return MaterialApp(
          title: 'Log In',
          theme: ThemeData(
            textTheme: GoogleFonts.nunitoSansTextTheme(), // Font mặc định
          ),
          home: const LoginScreen(), // Màn hình đăng nhập
        );
      },
    ),
  );
}

/// Widget tái sử dụng cho ô input có label, hint, validation và icon
