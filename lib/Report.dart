import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// Optional: keep your project imports if needed
// import 'package:vawc_alert_proj/login_page.dart';
// import 'package:vawc_alert_proj/sample.dart';

class SetUp extends StatefulWidget {
  const SetUp({super.key});

  @override
  State<SetUp> createState() => _SetUpState();
}

class _SetUpState extends State<SetUp> {
  // form controllers & focus nodes
  bool _isObscured = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();
  final TextEditingController _cpwdController = TextEditingController();

  final FocusNode _emailFocus = FocusNode();
  final FocusNode _pwdFocus = FocusNode();
  final FocusNode _cpwdFocus = FocusNode();

  // image state
  File? _file;
  final ImagePicker _picker = ImagePicker();

  // ------- image pickers (gallery & camera) -------
  Future<void> _pickImageFromGallery() async {
    try {
      final picked = await _picker.pickImage(source: ImageSource.gallery, maxWidth: 1920);
      if (picked != null) {
        if (!mounted) return;
        setState(() {
          _file = File(picked.path);
        });
      }
    } catch (e) {
      debugPrint('pickImageFromGallery error: $e');
    }
  }

  Future<void> _pickImageFromCamera() async {
    try {
      final picked = await _picker.pickImage(source: ImageSource.camera, maxWidth: 1920);
      if (picked != null) {
        if (!mounted) return;
        setState(() {
          _file = File(picked.path);
        });
      }
    } catch (e) {
      debugPrint('pickImageFromCamera error: $e');
    }
  }

  // Shows a single modal with image-only upload options
  void _showPickerOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take Photo'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImageFromCamera();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose Photo from Gallery'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImageFromGallery();
                },
              ),
            ],
          ),
        );
      },
    );
  }

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
    final mediaSize = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/setup_bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 0,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  Align(
                    alignment: const Alignment(-.98, 0),
                    child: InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Image.asset("assets/arrow-left.png", width: 45),
                    ),
                  ),

                  Row(
                    children: [
                      Image.asset("assets/vawca_logo.png", width: 97),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          "SET UP YOUR VAWC ALERT ACCOUNT",
                          style: TextStyle(fontSize: 18.8, fontFamily: "Inter", fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  const Align(alignment: Alignment(-0.8, 0), child: Text("First Name", style: TextStyle(fontSize: 20, color: Color(0xFF878181)))),

                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: mediaSize.width * 0.68,
                      child: TextField(
                        controller: _emailController,
                        focusNode: _emailFocus,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          hintText: "Email",
                          hintStyle: TextStyle(fontSize: 20, color: Colors.grey),
                          border: OutlineInputBorder(),
                          fillColor: Color(0xFFF0E1EC),
                          filled: true,
                          prefixIcon: Icon(Icons.person),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Align(alignment: Alignment(-0.8, 0), child: Text("Last Name", style: TextStyle(fontSize: 20, color: Color(0xFF878181)))),

                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: mediaSize.width * 0.68,
                      child: TextField(
                        controller: _pwdController,
                        focusNode: _pwdFocus,
                        obscureText: _isObscured,
                        decoration: InputDecoration(
                          hintText: "Password",
                          hintStyle: const TextStyle(fontSize: 20, color: Colors.grey),
                          border: const OutlineInputBorder(),
                          fillColor: const Color(0xFFF0E1EC),
                          filled: true,
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: (_pwdFocus.hasFocus && _pwdController.text.isNotEmpty)
                              ? IconButton(onPressed: () => setState(() => _isObscured = !_isObscured), icon: _isObscured ? const Icon(Icons.visibility_off) : const Icon(Icons.visibility))
                              : null,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Align(alignment: Alignment(-0.8, 0), child: Text("Address", style: TextStyle(fontSize: 20, color: Color(0xFF878181)))),

                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: mediaSize.width * 0.68,
                      child: TextField(
                        controller: _cpwdController,
                        focusNode: _cpwdFocus,
                        obscureText: _isObscured,
                        decoration: InputDecoration(
                          hintText: "Confirm Password",
                          hintStyle: const TextStyle(fontSize: 20, color: Colors.grey),
                          border: const OutlineInputBorder(),
                          fillColor: const Color(0xFFF0E1EC),
                          filled: true,
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: (_cpwdFocus.hasFocus && _cpwdController.text.isNotEmpty)
                              ? IconButton(onPressed: () => setState(() => _isObscured = !_isObscured), icon: _isObscured ? const Icon(Icons.visibility_off) : const Icon(Icons.visibility))
                              : null,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: 270,
                      child: Text(
                        "Upload any government-issued ID (e.g., Driver’s License, National ID, etc.)",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 15, color: Color(0xFF878181)),
                      ),
                    ),
                  ),

                  Transform.translate(
                    offset: const Offset(0, 12),
                    child: Container(
                      width: mediaSize.width * 0.31,
                      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.white, width: 1))),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ===== Preview container (centralized, white background, black border, 3/4 screen) =====
                  Center(
                    child: Container(
                      width: mediaSize.width * 0.75,
                      height: mediaSize.height * 0.75,
                      decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.black, width: 1), borderRadius: BorderRadius.circular(8)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: _file == null
                            ? Center(
                          child: Column(mainAxisSize: MainAxisSize.min, children: const [Icon(Icons.cloud_upload, size: 60), SizedBox(height: 8), Text('No file selected', style: TextStyle(fontSize: 16))]),
                        )
                            : Image.file(_file!, width: double.infinity, height: double.infinity, fit: BoxFit.cover),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Single button for image upload only
                  ElevatedButton.icon(
                    onPressed: _showPickerOptions,
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Upload Image'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD4229F),
                      minimumSize: Size(mediaSize.width * 0.6, 48),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),

                  const SizedBox(height: 16),

                  Padding(
                    padding: const EdgeInsets.only(top: 25, bottom: 23),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD4229F),
                        minimumSize: Size(mediaSize.width * 0.65, 40),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const UploadField()));
                      },
                      child: const Text("Sign Up", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Simple stub page to avoid unresolved reference to UploadField.
// Replace or expand this with your real UploadField implementation if you have one.
class UploadField extends StatelessWidget {
  const UploadField({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upload Field')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.cloud_upload, size: 64),
            SizedBox(height: 12),
            Text('UploadField placeholder'),
          ],
        ),
      ),
    );
  }
}
