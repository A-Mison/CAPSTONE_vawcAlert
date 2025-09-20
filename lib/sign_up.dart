// responsive_sign_up.dart
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:vawc_alert_proj/login_page.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool _isObscured = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();
  final TextEditingController _cpwdController = TextEditingController();

  final FocusNode _emailFocus = FocusNode();
  final FocusNode _pwdFocus = FocusNode();
  final FocusNode _cpwdFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _pwdFocus.addListener(() => setState(() {}));
    _pwdController.addListener(() => setState(() {}));
    _cpwdController.addListener(() => setState(() {}));
    _cpwdFocus.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _emailController.dispose();
    _pwdController.dispose();
    _cpwdController.dispose();
    _emailFocus.dispose();
    _pwdFocus.dispose();
    _cpwdFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final w = mq.size.width;
    final h = mq.size.height;

    // Helpers: percentage of width/height and responsive font
    double wp(double percent) => w * percent; // 0.0 - 1.0
    double hp(double percent) => h * percent;
    double rf(double factor) {
      // responsive font/clamped size (factor is fraction of width)
      final val = w * factor;
      return math.max(12.0, math.min(val, 28.0));
    }

    final fieldMaxWidth = math.min(wp(0.9), 720.0);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: true,
        body: Container(
          width: w,
          height: h,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/signup_bg.png"), // keep your asset name
              fit: BoxFit.cover,
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(
                horizontal: wp(0.06),
                vertical: hp(0.03),
              ).copyWith(bottom: mq.viewInsets.bottom + hp(0.02)),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: h - mq.padding.top - mq.padding.bottom),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Top spacing (scales)
                    SizedBox(height: hp(0)),
                    Container(
                      width: 300,
                      height: 230,
                      child: Center(
                        child: Image.asset('assets/vawca_logo.png',
                          width:500,
                          height: 500,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    // Email field
                    SizedBox(
                      width: fieldMaxWidth,
                      child: TextField(
                        controller: _emailController,
                        focusNode: _emailFocus,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          hintText: "Email",
                          hintStyle: TextStyle(fontSize: rf(0.05), color: Colors.grey),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(wp(0.02))),
                          filled: true,
                          fillColor: Colors.white70,
                          contentPadding: EdgeInsets.symmetric(vertical: hp(0.018), horizontal: wp(0.03)),
                          prefixIcon: Icon(Icons.person, size: rf(0.06)),
                        ),
                        style: TextStyle(fontSize: rf(0.05)),
                        onSubmitted: (_) => FocusScope.of(context).nextFocus(),
                      ),
                    ),

                    SizedBox(height: hp(0.025)),

                    // Password field
                    SizedBox(
                      width: fieldMaxWidth,
                      child: TextField(
                        controller: _pwdController,
                        focusNode: _pwdFocus,
                        obscureText: _isObscured,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          hintText: "Password",
                          hintStyle: TextStyle(fontSize: rf(0.05), color: Colors.grey),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(wp(0.02))),
                          filled: true,
                          fillColor: Colors.white70,
                          contentPadding: EdgeInsets.symmetric(vertical: hp(0.018), horizontal: wp(0.03)),
                          prefixIcon: Icon(Icons.lock, size: rf(0.06)),
                          suffixIcon: (_pwdFocus.hasFocus && _pwdController.text.isNotEmpty)
                              ? IconButton(
                            onPressed: () => setState(() => _isObscured = !_isObscured),
                            icon: Icon(_isObscured ? Icons.visibility_off : Icons.visibility, size: rf(0.06)),
                          )
                              : null,
                        ),
                        style: TextStyle(fontSize: rf(0.05)),
                      ),
                    ),

                    SizedBox(height: hp(0.02)),

                    // Confirm password
                    SizedBox(
                      width: fieldMaxWidth,
                      child: TextField(
                        controller: _cpwdController,
                        focusNode: _cpwdFocus,
                        obscureText: _isObscured,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          hintText: "Confirm Password",
                          hintStyle: TextStyle(fontSize: rf(0.05), color: Colors.grey),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(wp(0.02))),
                          filled: true,
                          fillColor: Colors.white70,
                          contentPadding: EdgeInsets.symmetric(vertical: hp(0.018), horizontal: wp(0.03)),
                          prefixIcon: Icon(Icons.lock, size: rf(0.06)),
                          suffixIcon: (_cpwdFocus.hasFocus && _cpwdController.text.isNotEmpty)
                              ? IconButton(
                            onPressed: () => setState(() => _isObscured = !_isObscured),
                            icon: Icon(_isObscured ? Icons.visibility_off : Icons.visibility, size: rf(0.06)),
                          )
                              : null,
                        ),
                        style: TextStyle(fontSize: rf(0.05)),
                      ),
                    ),

                    // thin divider (scales)
                    SizedBox(height: hp(0.0)),
                    Container(
                      width: fieldMaxWidth * 0.36,
                      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.white, width: 1))),
                    ),

                    // Sign Up button
                    Padding(
                      padding: EdgeInsets.only(top: hp(0.025), bottom: hp(0.02)),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFD4229F),
                            minimumSize: Size(double.infinity, hp(0.07)),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(wp(0.03))),
                          ),
                          onPressed: () {
                            debugPrint("Sign Up pressed");
                          },
                          child: Text(
                            "Sign Up",
                            style: TextStyle(fontSize: rf(0.052), fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ),
                      ),
                    ),

                    // OR with lines
                    SizedBox(height: hp(0.02)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: wp(0.01)),
                      child: Row(
                        children: [
                          Expanded(child: Divider(color: Colors.white, thickness: 1)),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: wp(0.03)),
                            child: Text(
                              "OR",
                              style: TextStyle(fontSize: rf(0.045), fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                          ),
                          Expanded(child: Divider(color: Colors.white, thickness: 1)),
                        ],
                      ),
                    ),

                    SizedBox(height: hp(0.03)),

                    // Social login row (responsive)
                    SizedBox(
                      width: fieldMaxWidth,
                      child: Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                // facebook login
                              },
                              child: Container(
                                height: hp(0.07),
                                margin: EdgeInsets.only(right: wp(0.02)),
                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(wp(0.02))),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset("assets/fb_icon.png", width: rf(0.06), height: rf(0.06), fit: BoxFit.contain),
                                    SizedBox(width: wp(0.03)),
                                    Text("Facebook", style: TextStyle(fontSize: rf(0.045), color: Colors.black)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                // google login
                              },
                              child: Container(
                                height: hp(0.07),
                                margin: EdgeInsets.only(left: wp(0.02)),
                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(wp(0.02))),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset("assets/google_icon.png", width: rf(0.06), height: rf(0.06), fit: BoxFit.contain),
                                    SizedBox(width: wp(0.03)),
                                    Text("Google", style: TextStyle(fontSize: rf(0.045), color: Colors.black)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: hp(0.03)),

                    // Already have an account? Login
                    Wrap(
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      runSpacing: 4,
                      children: [
                        Text("Already have an account?", style: TextStyle(fontSize: rf(0.04), color: Colors.white)),
                        const SizedBox(width: 6),
                        GestureDetector(
                          onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const LoginPage())),
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: hp(0.012), horizontal: wp(0.02)),
                            child: Text("Log In", style: TextStyle(fontSize: rf(0.04), fontWeight: FontWeight.bold, color: Colors.white)),
                          ),
                        ),
                      ],
                    ),

                    // bottom spacer to prevent crowding on tall screens
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
