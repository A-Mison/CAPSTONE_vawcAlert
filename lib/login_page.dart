import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:vawc_alert_proj/emergency.dart';
import 'package:vawc_alert_proj/sign_up.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isObscured = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();

  final FocusNode _emailFocus = FocusNode();
  final FocusNode _pwdFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _pwdFocus.addListener(() => setState(() {}));
    _pwdController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _emailController.dispose();
    _pwdController.dispose();
    _emailFocus.dispose();
    _pwdFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final w = mq.size.width;
    final h = mq.size.height;

    // responsive helpers
    double wp(double percent) => w * percent; // width percentage (0.0 - 1.0)
    double hp(double percent) => h * percent; // height percentage
    double rf(double factor) {
      // responsive font/clamped size (factor is fraction of width, e.g. 0.05)
      final val = w * factor;
      return math.max(12.0, math.min(val, 28.0));
    }

    final fieldMaxWidth = math.min(wp(0.9), 720.0);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,
        body: Container(
          width: w,
          height: h,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/login_bg.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(
                horizontal: wp(0.06),
                vertical: hp(0.03),
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: h - mq.padding.top - mq.padding.bottom,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Top spacer (relative)
                    SizedBox(height: hp(0)),

                    Container(
                      width: 600,
                      height: 250,
                      child: Center(
                        child: Image.asset(
                          "assets/vawca_logo.png",
                          width: 500,
                          height: 500,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    // Email field
                    Container(
                      width: fieldMaxWidth,
                      child: TextField(
                        controller: _emailController,
                        focusNode: _emailFocus,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          hintText: "Email",
                          hintStyle: TextStyle(
                            fontSize: rf(0.05),
                            color: Colors.grey,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(wp(0.02)),
                          ),
                          filled: true,
                          fillColor: Colors.white70,
                          contentPadding: EdgeInsets.symmetric(
                            vertical: hp(0.018),
                            horizontal: wp(0.03),
                          ),
                          prefixIcon: Icon(
                            Icons.person,
                            size: rf(0.06),
                          ),
                        ),
                        style: TextStyle(fontSize: rf(0.05)),
                        onSubmitted: (_) => FocusScope.of(context).nextFocus(),
                      ),
                    ),

                    SizedBox(height: hp(0.025)),

                    // Password field
                    Container(
                      width: fieldMaxWidth,
                      child: TextField(
                        controller: _pwdController,
                        focusNode: _pwdFocus,
                        obscureText: _isObscured,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          hintText: "Password",
                          hintStyle: TextStyle(fontSize: rf(0.05), color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(wp(0.02)),
                          ),
                          filled: true,
                          fillColor: Colors.white70,
                          contentPadding: EdgeInsets.symmetric(
                            vertical: hp(0.018),
                            horizontal: wp(0.03),
                          ),
                          prefixIcon: Icon(Icons.lock, size: rf(0.06)),
                          suffixIcon: (_pwdFocus.hasFocus && _pwdController.text.isNotEmpty)
                              ? IconButton(
                            onPressed: () => setState(() => _isObscured = !_isObscured),
                            icon: Icon(
                              _isObscured ? Icons.visibility_off : Icons.visibility,
                              size: rf(0.06),
                            ),
                          )
                              : null,
                        ),
                        style: TextStyle(fontSize: rf(0.05)),
                      ),
                    ),

                    // Forgot password aligned right
                    SizedBox(height: hp(0.015)),
                    Container(
                      width: fieldMaxWidth,
                      alignment: Alignment.center,
                      child: TextButton(
                        onPressed: () {
                          // handle forgot password
                        },
                        child: Text(
                          "Forgot Password?",
                          style: TextStyle(
                            fontSize: rf(0.04),
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.white,
                            color: Colors.white,
                          ),
                        ),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: wp(0.02)),
                          minimumSize: Size(0, 0),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                    ),

                    SizedBox(height: hp(0.03)),

                    // Login button (fills width of fields)
                    Container(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          minimumSize: Size(double.infinity, hp(0.07)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(wp(0.03)),
                          ),
                          elevation: 4,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const EmergencyPage()),
                          );
                        },
                        child: Text(
                          "LOGIN",
                          style: TextStyle(
                            fontSize: rf(0.05),
                            fontWeight: FontWeight.bold,
                            color: Colors.pinkAccent,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: hp(0.035)),

                    // OR with lines
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: wp(0.01)),
                      child: Row(
                        children: [
                          Expanded(child: Divider(color: Colors.white, thickness: 1)),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: wp(0.03)),
                            child: Text(
                              "OR",
                              style: TextStyle(
                                fontSize: rf(0.045),
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Expanded(child: Divider(color: Colors.white, thickness: 1)),
                        ],
                      ),
                    ),

                    SizedBox(height: hp(0.03)),

                    // Social buttons (responsive)
                    Container(
                      width: fieldMaxWidth,
                      child: Row(
                        children: [
                          // Facebook
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                // facebook login
                              },
                              child: Container(
                                height: hp(0.07),
                                margin: EdgeInsets.only(right: wp(0.02)),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(wp(0.02)),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      "assets/fb_icon.png",
                                      width: rf(0.06),
                                      height: rf(0.06),
                                      fit: BoxFit.contain,
                                    ),
                                    SizedBox(width: wp(0.03)),
                                    Text(
                                      "Facebook",
                                      style: TextStyle(fontSize: rf(0.045), color: Colors.black),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          // Google
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                // google login
                              },
                              child: Container(
                                height: hp(0.07),
                                margin: EdgeInsets.only(left: wp(0.02)),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(wp(0.02)),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      "assets/google_icon.png",
                                      width: rf(0.06),
                                      height: rf(0.06),
                                      fit: BoxFit.contain,
                                    ),
                                    SizedBox(width: wp(0.03)),
                                    Text(
                                      "Google",
                                      style: TextStyle(fontSize: rf(0.045), color: Colors.black),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: hp(0.045)),

                    // Sign up prompt - responsive and wraps if needed
                    Wrap(
                      alignment: WrapAlignment.center,
                      runSpacing: 4,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          "Don't have an account yet?",
                          style: TextStyle(fontSize: rf(0.04), color: Colors.white),
                        ),
                        const SizedBox(width: 6),
                        GestureDetector(
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const SignUp()),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: hp(0.012), horizontal: wp(0.02)),
                            child: Text(
                              "Sign Up",
                              style: TextStyle(
                                fontSize: rf(0.04),
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Fill remaining space to avoid content being glued to top on tall screens
                    SizedBox(height: hp(0.05)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
