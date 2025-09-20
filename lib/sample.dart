import 'package:flutter/material.dart';
import 'package:vawc_alert_proj/login_page.dart';
import 'package:vawc_alert_proj/sample.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class SetUp extends StatefulWidget {
  const SetUp({super.key});

  @override
  State<SetUp> createState() => _SetUpState();
}

class _SetUpState extends State<SetUp> {
  bool _isObscured = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();
  final TextEditingController _cpwdController = TextEditingController();

  final FocusNode _emailFocus = FocusNode();
  final FocusNode _pwdFocus = FocusNode();
  final FocusNode _cpwdFocus = FocusNode();

  File? _file;
  bool _isVideo = false; // tracks whether the picked file is a video
  final ImagePicker _picker = ImagePicker();

  // ------- Pickers (gallery & camera) -------
  Future<void> _pickImageFromGallery() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery, maxWidth: 1920);
      if (pickedFile != null) {
        setState(() {
          _file = File(pickedFile.path);
          _isVideo = false;
        });
      }
    } catch (e) {
      // handle or log error
      debugPrint('pickImageFromGallery error: $e');
    }
  }

  Future<void> _pickImageFromCamera() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.camera, maxWidth: 1920);
      if (pickedFile != null) {
        setState(() {
          _file = File(pickedFile.path);
          _isVideo = false;
        });
      }
    } catch (e) {
      debugPrint('pickImageFromCamera error: $e');
    }
  }

  Future<void> _pickVideoFromGallery() async {
    try {
      final pickedFile = await _picker.pickVideo(source: ImageSource.gallery, maxDuration: const Duration(minutes: 5));
      if (pickedFile != null) {
        setState(() {
          _file = File(pickedFile.path);
          _isVideo = true;
        });
      }
    } catch (e) {
      debugPrint('pickVideoFromGallery error: $e');
    }
  }

  Future<void> _pickVideoFromCamera() async {
    try {
      final pickedFile = await _picker.pickVideo(source: ImageSource.camera, maxDuration: const Duration(minutes: 5));
      if (pickedFile != null) {
        setState(() {
          _file = File(pickedFile.path);
          _isVideo = true;
        });
      }
    } catch (e) {
      debugPrint('pickVideoFromCamera error: $e');
    }
  }

  // Shows a single modal with all upload options
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
              ListTile(
                leading: const Icon(Icons.videocam),
                title: const Text('Record Video'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickVideoFromCamera();
                },
              ),
              ListTile(
                leading: const Icon(Icons.video_library),
                title: const Text('Choose Video from Gallery'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickVideoFromGallery();
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
    // rebuild when password/confirm password focus/text changes
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
                          "SET UP YOUR VAWC ALERT\nACCOUNT",
                          style: TextStyle(
                            fontSize: 18.8,
                            fontFamily: "Inter",
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  Align(
                    alignment: const Alignment(-0.8, 0),
                    child: const Text(
                      "First Name",
                      style: TextStyle(fontSize: 20, color: Color(0xFF878181)),
                    ),
                  ),

                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: mediaSize.width * 0.68,
                      child: TextField(
                        controller: _emailController,
                        focusNode: _emailFocus,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        readOnly: false,
                        showCursor: true,
                        autofocus: false,
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

                  Align(
                    alignment: const Alignment(-0.8, 0),
                    child: const Text(
                      "Last Name",
                      style: TextStyle(fontSize: 20, color: Color(0xFF878181)),
                    ),
                  ),

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
                              ? IconButton(
                            onPressed: () => setState(() => _isObscured = !_isObscured),
                            icon: _isObscured ? const Icon(Icons.visibility_off) : const Icon(Icons.visibility),
                          )
                              : null,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Align(
                    alignment: const Alignment(-0.8, 0),
                    child: const Text(
                      "Address",
                      style: TextStyle(fontSize: 20, color: Color(0xFF878181)),
                    ),
                  ),

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
                              ? IconButton(
                            onPressed: () => setState(() => _isObscured = !_isObscured),
                            icon: _isObscured ? const Icon(Icons.visibility_off) : const Icon(Icons.visibility),
                          )
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
                      decoration: const BoxDecoration(
                        border: Border(bottom: BorderSide(color: Colors.white, width: 1)),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ===== Preview container (centralized, white background, black border, 3/4 screen) =====
                  Center(
                    child: Container(
                      width: mediaSize.width * 0.75,
                      height: mediaSize.height * 0.75,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black, width: 1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: _file == null
                          ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.cloud_upload, size: 60),
                            SizedBox(height: 8),
                            Text('No file selected', style: TextStyle(fontSize: 16)),
                          ],
                        ),
                      )
                          : _isVideo
                          ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.videocam, size: 60),
                            const SizedBox(height: 8),
                            Text('Video selected: ${""}'),
                            // Note: to play video in-app, add video_player package and implement a controller
                            Text(_file!.path.split('/').last),
                          ],
                        ),
                      )
                          : ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          _file!,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Single button for all upload options
                  ElevatedButton.icon(
                    onPressed: _showPickerOptions,
                    icon: const Icon(Icons.upload_file),
                    label: const Text('Upload Image / Video'),
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
