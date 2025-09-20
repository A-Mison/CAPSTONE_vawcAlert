import 'dart:io';
import 'package:flutter/material.dart';
import 'package:vawc_alert_proj/emergency2.dart';
import 'package:vawc_alert_proj/home.dart';
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
  // form controllers & focus nodes (renamed for clarity)
  bool isChecked = false;

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  final FocusNode _firstNameFocus = FocusNode();
  final FocusNode _lastNameFocus = FocusNode();
  final FocusNode _addressFocus = FocusNode();

  // image state
  File? _file;
  final ImagePicker _picker = ImagePicker();

  // ------- image pickers (gallery & camera) -------
  Future<void> _pickImageFromGallery() async {
    try {
      final picked =
      await _picker.pickImage(source: ImageSource.gallery, maxWidth: 1920);
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
      final picked =
      await _picker.pickImage(source: ImageSource.camera, maxWidth: 1920);
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
    // no password obscure listeners needed anymore
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _addressController.dispose();
    _firstNameFocus.dispose();
    _lastNameFocus.dispose();
    _addressFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaSize = MediaQuery.of(context).size;
    final double screenWidth = mediaSize.width;

    // baseline width 390 (rough typical phone). Clamp scale so things stay sensible.
    final double scaleFactor = ((screenWidth / 390).clamp(0.85, 1.4)) as double;

    // NAV logo responsive sizing:
    final double navHeight = 56 * scaleFactor; // preferred nav height
    final double logoMaxWidth = (screenWidth * 0.22).clamp(48.0, 140.0);
    // note: clamp keeps logo within reasonable min/max on tiny/large screens

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
                left: 16 * scaleFactor,
                right: 16 * scaleFactor,
                top: 0,
                bottom:
                MediaQuery.of(context).viewInsets.bottom + (24 * scaleFactor),
              ),
              child: Column(
                children: [
                  SizedBox(height: 16 * scaleFactor),
                  Align(
                    alignment: const Alignment(-.98, 0),
                    child: InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Image.asset("assets/arrow-left.png",
                          width: 45 * scaleFactor),
                    ),
                  ),

                  // ---- NAV ROW: responsive logo + title ----
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // ConstrainedBox ensures logo stays within reasonable bounds and scales
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: logoMaxWidth,
                          maxHeight: navHeight,
                          minHeight: navHeight * 0.6,
                        ),
                        child: SizedBox(
                          height: navHeight,
                          // use FittedBox so the image respects constraints and keeps aspect ratio
                          child: FittedBox(
                            fit: BoxFit.contain,
                            alignment: Alignment.centerLeft,
                            child: Image.asset(
                              "assets/vawca_logo.png",
                              // width is driven by parent constraints via FittedBox/ConstrainedBox
                              height: navHeight,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                // harmless fallback if the asset is missing
                                return Container(
                                  width: logoMaxWidth,
                                  height: navHeight,
                                  color: Colors.transparent,
                                  alignment: Alignment.center,
                                  child: Icon(
                                    Icons.image_not_supported,
                                    size: navHeight * 0.5,
                                    color: Colors.grey,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),

                      SizedBox(width: 8 * scaleFactor),

                      Expanded(
                        child: Text(
                          "SET UP YOUR VAWC ALERT ACCOUNT",
                          style: TextStyle(
                            fontSize: 18.8 * scaleFactor,
                            fontFamily: "Inter",
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 10 * scaleFactor),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "First Name",
                      style: TextStyle(
                        fontSize: 20 * scaleFactor,
                        color: const Color(0xFF878181),
                      ),
                    ),
                  ),

                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: mediaSize.width * 0.85,
                      child: TextField(
                        controller: _firstNameController,
                        focusNode: _firstNameFocus,
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          hintText: "First Name",
                          hintStyle:
                          TextStyle(fontSize: 16 * scaleFactor, color: Colors.grey),
                          border: const OutlineInputBorder(),
                          fillColor: const Color(0xFFF0E1EC),
                          filled: true,
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 12 * scaleFactor, horizontal: 12 * scaleFactor),
                        ),
                        style: TextStyle(fontSize: 16 * scaleFactor),
                      ),
                    ),
                  ),

                  SizedBox(height: 10 * scaleFactor),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Last Name",
                      style: TextStyle(
                        fontSize: 20 * scaleFactor,
                        color: const Color(0xFF878181),
                      ),
                    ),
                  ),

                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: mediaSize.width * 0.85,
                      child: TextField(
                        controller: _lastNameController,
                        focusNode: _lastNameFocus,
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          hintText: "Last Name",
                          hintStyle:
                          TextStyle(fontSize: 16 * scaleFactor, color: Colors.grey),
                          border: const OutlineInputBorder(),
                          fillColor: const Color(0xFFF0E1EC),
                          filled: true,
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 12 * scaleFactor, horizontal: 12 * scaleFactor),
                        ),
                        style: TextStyle(fontSize: 16 * scaleFactor),
                      ),
                    ),
                  ),

                  SizedBox(height: 10 * scaleFactor),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Address",
                      style: TextStyle(
                        fontSize: 20 * scaleFactor,
                        color: const Color(0xFF878181),
                      ),
                    ),
                  ),

                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: mediaSize.width * 0.85,
                      child: TextField(
                        controller: _addressController,
                        focusNode: _addressFocus,
                        keyboardType: TextInputType.streetAddress,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          hintText: "Address",
                          hintStyle:
                          TextStyle(fontSize: 16 * scaleFactor, color: Colors.grey),
                          border: const OutlineInputBorder(),
                          fillColor: const Color(0xFFF0E1EC),
                          filled: true,
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 12 * scaleFactor, horizontal: 12 * scaleFactor),
                        ),
                        style: TextStyle(fontSize: 16 * scaleFactor),
                        maxLines: 2,
                      ),
                    ),
                  ),

                  SizedBox(height: 20 * scaleFactor),

                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: mediaSize.width * 0.85,
                      child: Text(
                        "Upload any government-issued ID (e.g., Driver’s License, National ID, etc.)",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 15 * scaleFactor, color: const Color(0xFF878181)),
                      ),
                    ),
                  ),

                  Transform.translate(
                    offset: Offset(0, 12 * scaleFactor),
                    child: Container(
                      width: mediaSize.width * 0.31,
                      decoration: const BoxDecoration(
                          border: Border(bottom: BorderSide(color: Colors.white, width: 1))),
                    ),
                  ),

                  SizedBox(height: 12 * scaleFactor),

                  // ===== preview: **only shown when _file != null** =====
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: _file == null
                        ? const SizedBox.shrink()
                        : Center(
                      key: ValueKey('preview_${_file!.path}'),
                      child: GestureDetector(
                        onTap: _showPickerOptions,
                        child: Container(
                          width: mediaSize.width * 0.75,
                          height: mediaSize.height * 0.20,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.black, width: 1),
                              borderRadius: BorderRadius.circular(8)),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              _file!,
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  if (_file != null) SizedBox(height: 20 * scaleFactor),

                  // Single button for image upload only
                  ElevatedButton.icon(
                    onPressed: _showPickerOptions,
                    icon: const Icon(Icons.camera_alt),
                    label: Text('Upload Image', style: TextStyle(fontSize: 16 * scaleFactor)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD4229F),
                      foregroundColor: Colors.white,
                      minimumSize: Size(mediaSize.width * 0.6, 48 * scaleFactor),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),

                  SizedBox(height: 16 * scaleFactor),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Transform.scale(
                        scale: scaleFactor, // Checkbox scales with screen width
                        child: Checkbox(
                          value: isChecked,
                          onChanged: (bool? value) {
                            setState(() {
                              isChecked = value ?? false;
                            });
                          },
                        ),
                      ),
                      SizedBox(width: 6 * scaleFactor), // small gap between checkbox and text
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "I agree to the ",
                                  style: TextStyle(fontSize: 13 * scaleFactor),
                                ),
                                MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(builder: (_) => const HomePage()),
                                        );
                                      },
                                      child: Text(
                                        "Terms and Conditions",
                                        style: TextStyle(
                                          fontSize: 13 * scaleFactor,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 2 * scaleFactor), // less vertical space
                            Text(
                              "as set out in the user agreement",
                              style: TextStyle(fontSize: 13 * scaleFactor),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: 25 * scaleFactor, bottom: 23 * scaleFactor),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        minimumSize: Size(mediaSize.width * 0.65, 40 * scaleFactor),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const eEmergencyPage()));
                      },
                      child: Text("SAVE",
                          style: TextStyle(
                              fontSize: 20 * scaleFactor, fontWeight: FontWeight.bold, color: Color(0xFFD4229F))),
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
