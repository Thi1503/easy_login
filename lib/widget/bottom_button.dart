import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

/// Nút outline có icon và text, tự động điều chỉnh chiều rộng vừa khít nội dung
///
/// Thường dùng ở thanh cuối màn hình để hiển thị các chức năng phụ trợ như "Trợ giúp", "Group", "Tra cứu".
class BottomButton extends StatelessWidget {
  /// Nhãn văn bản của nút
  final String text;

  /// Callback khi người dùng nhấn nút
  final VoidCallback onPressed;

  /// Đường dẫn asset hình ảnh icon
  final String imagePath;

  /// Khởi tạo BottomButton với text, sự kiện nhấn và đường dẫn icon
  const BottomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    required this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54.h, // chiều cao cố định
      width: 109.w, // chiều rộng cố định
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: SvgPicture.asset(
          imagePath,
          width: 24.w, // kích thước icon theo tỉ lệ màn hình
          height: 24.w,
          fit: BoxFit.cover,
        ),
        label: Padding(
          padding: EdgeInsets.only(left: 4.w), // khoảng cách icon - text
          child: Text(
            text,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              height: 16.sp / 12.sp,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        style: OutlinedButton.styleFrom(
          // minimumSize: Size(10, 54.h), // cố định chiều cao, width hug content
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          side: BorderSide(color: Color(0xFFEBECED)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.r), // bo góc 6
          ),
        ),
      ),
    );
  }
}
