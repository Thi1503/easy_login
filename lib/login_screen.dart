import 'package:easy_invoice/app_images.dart';
import 'package:easy_invoice/home.dart';
import 'package:easy_invoice/service/auth_service.dart';
import 'package:easy_invoice/service/auth_storage.dart';
import 'package:easy_invoice/widget/bottom_button.dart';
import 'package:easy_invoice/widget/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

/// Màn hình đăng nhập chính
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _taxIdController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isValidInput = false;
  bool _isObscure = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _taxIdController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> submitForm() async {
    // bật validate ngay khi bấm submit
    setState(() => _isValidInput = true);

    // nếu form hợp lệ mới thực hiện login
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);

      try {
        // Gọi API login thẳng, bỏ qua "ping Google"
        final result = await AuthService.login(
          taxCode: _taxIdController.text.trim(),
          username: _usernameController.text.trim(),
          password: _passwordController.text.trim(),
        );

        if (!mounted) return;

        if (result['success'] == true) {
          final token =
              (result['data'] as Map<String, dynamic>)['token'] as String;
          await AuthStorage.saveToken(token);

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const Home()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(result['message'] ?? 'Đăng nhập thất bại')),
          );
        }
      } catch (e) {
        // Nếu có lỗi (mạng/server), hiện snackbar
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Lỗi mạng hoặc server')));
        }
      } finally {
        // luôn tắt loading nếu widget vẫn mounted
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 76.h),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: SizedBox(
                        height: 37.h,
                        width: 158.w,
                        child: SvgPicture.asset(
                          AppImages.logo.path,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    SizedBox(height: 24.h),
                    Form(
                      key: _formKey,
                      autovalidateMode:
                          _isValidInput
                              ? AutovalidateMode.onUserInteraction
                              : AutovalidateMode.disabled,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomTextFormField(
                            label: 'Mã số thuế',
                            controller: _taxIdController,
                            hintText: 'Mã số thuế',
                            obscureText: false,
                            suffixIcon: IconButton(
                              icon: SvgPicture.asset(
                                AppImages.closeCircle.path,
                                width: 24.w,
                                height: 24.w,
                              ),
                              onPressed: _taxIdController.clear,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Mã số thuế không được để trống';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 4.h),
                          CustomTextFormField(
                            label: 'Tài khoản',
                            controller: _usernameController,
                            hintText: 'Tài khoản',
                            obscureText: false,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Tài khoản không được để trống';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 4.h),
                          CustomTextFormField(
                            label: 'Mật khẩu',
                            controller: _passwordController,
                            hintText: 'Mật khẩu',
                            obscureText: _isObscure,
                            suffixIcon: IconButton(
                              icon: SvgPicture.asset(
                                _isObscure
                                    ? AppImages.eyeSlash.path
                                    : AppImages.eye.path,
                                width: 24.w,
                                height: 24.w,
                              ),
                              onPressed:
                                  () =>
                                      setState(() => _isObscure = !_isObscure),
                            ),
                            validator: (value) {
                              if (value == null ||
                                  value.length < 6 ||
                                  value.length > 50) {
                                return 'Mật khẩu phải từ 6 đến 50 ký tự';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20.h),
                          SizedBox(
                            width: double.infinity,
                            height: 54.h,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : submitForm,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFF24E1E),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6.r),
                                ),
                                elevation: 0,
                              ),
                              child:
                                  _isLoading
                                      ? const SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                      : Text(
                                        'Đăng nhập',
                                        style: GoogleFonts.nunitoSans(
                                          textStyle: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w700,
                                            height: 1.5,
                                          ),
                                        ),
                                      ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BottomButton(
                    text: "Trợ giúp",
                    onPressed: () {},
                    imagePath: AppImages.headphone.path,
                  ),
                  BottomButton(
                    text: "Group",
                    onPressed: () {},
                    imagePath: AppImages.group.path,
                  ),
                  BottomButton(
                    text: "Tra cứu",
                    onPressed: () {},
                    imagePath: AppImages.searchNormal.path,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
