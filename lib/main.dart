import 'package:easy_invoice/home.dart';
import 'package:easy_invoice/service/auth_service.dart';
import 'package:easy_invoice/service/auth_storage.dart';
import 'package:easy_invoice/widget/bottom_button.dart';
import 'package:easy_invoice/widget/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // Thư viện để responsive theo kích thước màn hình
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'app_images.dart'; // Enum chứa đường dẫn asset ảnh
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
          home: const LogIn(), // Màn hình đăng nhập
        );
      },
    ),
  );
}

/// Widget tái sử dụng cho ô input có label, hint, validation và icon

/// Màn hình đăng nhập chính
class LogIn extends StatefulWidget {
  const LogIn({Key? key}) : super(key: key);

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final TextEditingController taxIdController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isValidInput = false; // Cờ đã submit form
  bool isTaxIdError = false; // Lỗi mã thuế
  bool isUsernameError = false; // Lỗi tài khoản
  bool isPasswordError = false; // Lỗi mật khẩu
  bool isObscure = true; // Ẩn hiện mật khẩu

  bool isLoading = false; // Cờ đang tải dữ liệu
  late final SvgPicture eye; // Biểu tượng mắt mở
  late final SvgPicture eyeSlash; // Biểu tượng mắt gạch

  @override
  void initState() {
    super.initState();
    eye = SvgPicture.asset(AppImages.eye.path, width: 24.w, height: 24.w);
    eyeSlash = SvgPicture.asset(
      AppImages.eyeSlash.path,
      width: 24.w,
      height: 24.w,
    );
  }

  /// Xử lý khi nhấn nút Đăng nhập
  Future<void> submitForm() async {
    try {
      final ping = await http.get(Uri.parse('https://google.com'));
      debugPrint('Ping google: ${ping.statusCode}');
    } catch (e) {
      debugPrint('Lỗi ping: $e');
    }

    // validate như trước
    final isValid = _formKey.currentState!.validate();
    setState(() => isValidInput = true);
    setState(() {
      isTaxIdError = taxIdController.text.trim().isEmpty;
      isUsernameError = usernameController.text.trim().isEmpty;
      final pwd = passwordController.text.trim();
      // do api có 6 ký tự passowrd
      isPasswordError = pwd.isEmpty || pwd.length < 6 || pwd.length > 50;
    });
    if (!isValid || isTaxIdError || isUsernameError || isPasswordError) return;

    setState(() => isLoading = true);
    try {
      final result = await AuthService.login(
        taxCode: taxIdController.text.trim(),
        username: usernameController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (result['success'] == true) {
        // Lấy token từ data
        final token =
            (result['data'] as Map<String, dynamic>)['token'] as String;

        // Lưu token
        await AuthStorage.saveToken(token);

        // Chuyển screen
        Navigator.push(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(builder: (ctx) => const Home()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'] ?? 'Đăng nhập thất bại')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Lỗi mạng hoặc server')));
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false, // Không bị đẩy khi bàn phím hiện
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 76.h), // Khoảng cách trên cùng
                      // Logo
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

                      // Form nhập liệu
                      Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Mã số thuế
                            CustomTextFormField(
                              label: 'Mã số thuế',
                              controller: taxIdController,
                              hintText: 'Mã số thuế',
                              isError: isTaxIdError,
                              errorMessage: 'Mã số thuế không được để trống',
                              obscureText: false,
                              suffixIcon: IconButton(
                                icon: SvgPicture.asset(
                                  AppImages.closeCircle.path,
                                  width: 24.w,
                                  height: 24.w,
                                ),
                                onPressed: () {
                                  taxIdController.clear();
                                  if (isValidInput) {
                                    setState(() => isTaxIdError = true);
                                  }
                                },
                              ),
                              validator: (_) => null,
                              onChanged: (v) {
                                if (isValidInput) {
                                  setState(
                                    () => isTaxIdError = v.trim().isEmpty,
                                  );
                                }
                              },
                              onSaved: (v) => taxIdController.text = v!,
                            ),

                            SizedBox(height: 4.h),

                            // Tài khoản
                            CustomTextFormField(
                              label: 'Tài khoản',
                              controller: usernameController,
                              hintText: 'Tài khoản',
                              isError: isUsernameError,
                              errorMessage: 'Tài khoản không được để trống',
                              obscureText: false,
                              validator: (_) => null,
                              onChanged: (v) {
                                if (isValidInput) {
                                  setState(
                                    () => isUsernameError = v.trim().isEmpty,
                                  );
                                }
                              },
                              onSaved: (v) => usernameController.text = v!,
                            ),

                            SizedBox(height: 4.h),

                            // Mật khẩu
                            CustomTextFormField(
                              label: 'Mật khẩu',
                              controller: passwordController,
                              hintText: 'Mật khẩu',
                              isError: isPasswordError,
                              errorMessage: 'Mật khẩu phải từ 6 đến 50 ký tự',
                              obscureText: isObscure,
                              suffixIcon: IconButton(
                                icon: isObscure ? eyeSlash : eye,
                                onPressed:
                                    () =>
                                        setState(() => isObscure = !isObscure),
                              ),
                              validator: (_) => null,
                              onChanged: (v) {
                                if (isValidInput) {
                                  final len = v.trim().length;
                                  setState(
                                    () =>
                                        isPasswordError =
                                            v.trim().isEmpty ||
                                            len < 6 ||
                                            len > 50,
                                  );
                                }
                              },
                              onSaved: (v) => passwordController.text = v!,
                            ),

                            SizedBox(height: 20.h),

                            // Nút đăng nhập
                            SizedBox(
                              width: 343.w,
                              height: 54.h,
                              child: ElevatedButton(
                                onPressed: isLoading ? null : submitForm,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFFF24E1E),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6.r),
                                  ),
                                  elevation: 0,
                                ),
                                child:
                                    isLoading
                                        ? CircularProgressIndicator(
                                          color: Colors.white,
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
            ),

            // Thanh nút dưới cùng
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
