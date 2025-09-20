// responsive_emergency_page.dart
import 'dart:math' as math;
import 'dart:io';
import 'dart:ui' show ImageFilter;
import 'dart:typed_data';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:vawc_alert_proj/home.dart';
import 'package:vawc_alert_proj/setupaccount.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class eEmergencyPage extends StatefulWidget {
  const eEmergencyPage({super.key});

  @override
  State<eEmergencyPage> createState() => _eEmergencyPageState();
}

class _eEmergencyPageState extends State<eEmergencyPage> {
  void _openSendAlertForm() {
    showGeneralDialog(
      context: context,
      barrierLabel: 'Send Alert',
      barrierDismissible: false, // require explicit Cancel/Send to close
      barrierColor: Colors.black.withOpacity(0.20), // subtle dark tint
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, anim1, anim2) {
        // Full-screen stack so we can blur everything behind the form
        return SafeArea(
          child: Stack(
            children: [
              // Blur the entire background
              // Centered small form
              Center(
                child: _SendAlertForm(
                  onClose: () => Navigator.of(context).pop(),
                  onSend: (message, location) {
                    // TODO: integrate your actual "send alert" logic here.
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Alert sent')),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
      transitionBuilder: (context, anim, secondaryAnim, child) {
        final curved =
        CurvedAnimation(parent: anim, curve: Curves.easeOutCubic, reverseCurve: Curves.easeInCubic);
        return FadeTransition(
          opacity: curved,
          child: ScaleTransition(
            scale: Tween(begin: 0.95, end: 1.0).animate(curved),
            child: child,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaSize = MediaQuery.of(context).size;
    final responsiveFont = mediaSize.width * 0.045;
    // Responsive avatar/text sizes for the nav bar (unchanged from what you had)
    final double avatarBase = mediaSize.width * 0.12;
    final double avatarSize = avatarBase < 36 ? 36 : (avatarBase > 72 ? 72 : avatarBase);
    final double guestFontBase = mediaSize.width * 0.045;
    final double guestFontSize = guestFontBase < 12 ? 12 : (guestFontBase > 20 ? 20 : guestFontBase);

    final double tileHeight = ((mediaSize.height * 0.215).clamp(140.0, 260.0)) as double;
    // image inside each tile: follow the earlier 'bigTileHeight * 0.62' rule, but cap at original 250
    final double imageSize = math.min(250.0, tileHeight * 0.62);
    // title font sized relative to tile height and clamped
    final double tileTitleFont = ((tileHeight / 170.0) * 19.0).clamp(14.0, 22.0) as double;
    // smaller font for multi-line SOS label
    final double sosTitleFont = ((tileHeight / 170.0) * 18.0).clamp(13.0, 20.0) as double;

    // NAV BAR logo sizing: keep it tied to avatar size and screen width so it scales nicely
    final double navLogoMaxWidth = mediaSize.width * 0.22; // cap logo width to ~22% of screen
    final double navLogoHeight = (avatarSize * 0.9); // slightly smaller than avatar height

    // --- Responsive sizes for the Emergency Hotlines card ---
    final double hotlineCardWidth = (mediaSize.width * 0.94).clamp(280.0, mediaSize.width) as double;
    final double hotlinePaddingH = (mediaSize.width * 0.04).clamp(12.0, 28.0) as double;
    final double hotlinePaddingV = (mediaSize.height * 0.015).clamp(8.0, 20.0) as double;
    final double hotlineTitleFont = ((mediaSize.width * 0.048).clamp(16.0, 22.0)) as double;
    final double hotlineLabelFont = ((mediaSize.width * 0.042).clamp(14.0, 18.0)) as double;
    final double hotlineNumberFont = ((mediaSize.width * 0.04).clamp(14.0, 18.0)) as double;
    final double hotlineIconSize = ((mediaSize.width * 0.06).clamp(18.0, 32.0)) as double;

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/login_bg.png"),
          fit: BoxFit.cover,
        ),
      ),
      // Use a Stack so we can overlay the nav bar (user image + Guest) in the top-right
      child: Stack(
        children: [
          // ===== Main content (unchanged layout except responsive tiles) =====
          Column(
            children: [
              Container(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.topCenter, // position near the top
                      child: Padding(
                        padding: const EdgeInsets.only(top: 107), // distance from top
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(mediaSize.width * 0.47, 60),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                              side: const BorderSide(
                                color: Colors.black,
                                width: 3,
                              ),
                            ),
                            backgroundColor: const Color(0xD6E8E8EF),
                            foregroundColor: Colors.black,
                          ),
                          onPressed: () {},
                          child: const Text(
                            "EMERGENCY",
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 1),
                    Align(
                      alignment: Alignment.topCenter, // position near the top
                      child: Padding(
                        padding: const EdgeInsets.only(top: 107), // distance from top
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(mediaSize.width * 0.47, 60),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                              side: const BorderSide(color: Colors.black, width: 1),
                            ),
                            backgroundColor: const Color(0xD6E8E8EF),
                            foregroundColor: Colors.black,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const HomePage()),
                            );
                          },
                          child: const Text(
                            "HOME",
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "PRESS IN CASE OF EMERGENCY!",
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.bold,
                      fontSize: 19,
                      decoration: TextDecoration.none,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 5),
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: Image.asset(
                      "assets/warningsign.png",
                      width: 10,
                      height: 10,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),

              // Row with Send Alert and Actions (we keep the same width fraction but tile contents are responsive)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Send Alert tile
                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          fixedSize: Size(mediaSize.width * 0.47, tileHeight), // responsive tile size
                          padding: EdgeInsets.zero,
                          alignment: Alignment.topCenter,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                            side: const BorderSide(color: Color(0xD64747F3), width: 2),
                          ),
                          backgroundColor: const Color(0xD6E8E8EF),
                          foregroundColor: Colors.black,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        // trigger for the pop-up form
                        onPressed: _openSendAlertForm,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Title (responsive font)
                              Text(
                                "Send Alert",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: tileTitleFont,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: tileHeight * 0.06),
                              // Image sized relative to tileHeight (and capped by original 250)
                              SizedBox(
                                height: imageSize,
                                child: Image.asset(
                                  'assets/send_alert.png',
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 1),

                  // Actions tile
                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          fixedSize: Size(mediaSize.width * 0.47, tileHeight), // responsive tile size
                          padding: EdgeInsets.zero,
                          alignment: Alignment.topCenter,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                            side: const BorderSide(color: Color(0xD64747F3), width: 2),
                          ),
                          backgroundColor: const Color(0xD6E8E8EF),
                          foregroundColor: Colors.black,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        onPressed: () {
                          _openArrivalCodePopup(context); // `context` is automatically available in the State class
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Actions",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: tileTitleFont,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: tileHeight * 0.06),
                              SizedBox(
                                height: imageSize,
                                child: Image.asset(
                                  'assets/actions.png',
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // Emergency Call tile (single full-width centered button in your layout)
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(mediaSize.width * 0.47, tileHeight), // same width as the tiles above
                      padding: EdgeInsets.zero,
                      alignment: Alignment.topCenter,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                        side: const BorderSide(color: Color(0xD64747F3), width: 2),
                      ),
                      backgroundColor: const Color(0xD6E8E8EF),
                      foregroundColor: Colors.black,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: () {
                      FlutterPhoneDirectCaller.callNumber('09555800023');
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Emergency Call \n Button",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: sosTitleFont,
                              fontWeight: FontWeight.bold,
                              height: 1.0,
                            ),
                          ),
                          SizedBox(height: tileHeight * 0.06),
                          SizedBox(
                            height: imageSize,
                            child: Image.asset(
                              'assets/sos.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: MediaQuery.of(context).size.height * 0.01),

              // ===== NEW: Emergency Hotlines card with white background (responsive) =====
              // Emergency Hotlines Section with background + adjustable height
              Container(
                width: mediaSize.width * 0.95,
                height: mediaSize.height * 0.24, // adjust % as needed (0.20 → 20% of screen height)
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16), // 👈 rounded corners
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1), // subtle shadow
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'EMERGENCY HOTLINES',
                      style: TextStyle(
                        fontSize: responsiveFont, // ✅ responsive font size
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Inter',
                        color: Colors.black,
                        decoration: TextDecoration.none,
                      ),
                    ),
                    const SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          'VAW DESK MABOLO',
                          style: TextStyle(
                            fontSize: responsiveFont * 0.95, // slightly smaller
                            fontFamily: 'Inter',
                            color: Colors.black,
                            decoration: TextDecoration.none,
                          ),
                        ),
                        SizedBox(width: 20),
                        Text(
                          'PNP MOBILE#',
                          style: TextStyle(
                            fontSize: responsiveFont * 0.95,
                            fontFamily: 'Inter',
                            color: Colors.black,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              'assets/phone.png',
                              width: 22,
                              height: 22,
                              fit: BoxFit.contain,
                            ),
                            const SizedBox(width: 15),
                            Text(
                              '23-1453\n \n09555800023',
                              style: TextStyle(
                                fontSize: responsiveFont,
                                fontFamily: 'Inter normal',
                                color: Colors.black,
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 20),
                        Row(
                          children: [
                            Image.asset(
                              'assets/phone.png',
                              width: 22,
                              height: 22,
                              fit: BoxFit.contain,
                            ),
                            const SizedBox(width: 15),
                            Text(
                              '911 - Cebu\n \n811 - Mabolo',
                              style: TextStyle(
                                fontSize: responsiveFont,
                                fontFamily: 'Inter normal',
                                color: Colors.black,
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),


              // ... end of main column children
            ],
          ),

          // ===== Nav bar: Left logo + Right user avatar + "Guest" (responsive) =====
          SafeArea(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: mediaSize.width * 0.04,
                vertical: mediaSize.height * 0,
              ),
              color: const Color(0xFF991F59),
              // Keep nav content spaced: logo on left, avatar + guest on right
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Left: VAWCA logo (resizable)
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: mediaSize.width * 0.40,
                      maxHeight: mediaSize.height * 0.09,
                    ),
                    child: Image.asset(
                      'assets/vawca_logo.png',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        // if asset missing, leave an empty sized box with same constraints so layout doesn't jump
                        return SizedBox(
                          width: mediaSize.width * 0.40, // 25% of screen width
                          height: mediaSize.height * 0.1,
                        );
                      },
                    ),
                  ),

                  // Right: avatar + guest label
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Avatar (circular). Uses Image.asset inside ClipOval so we can show fallback if asset missing.
                      ClipOval(
                        child: SizedBox(
                          width: avatarSize,
                          height: avatarSize,
                          child: Image.asset(
                            'assets/image_user.png',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey.shade200,
                                child: Icon(
                                  Icons.person,
                                  size: avatarSize * 0.6,
                                  color: Colors.grey.shade700,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      SizedBox(width: mediaSize.width * 0.02),
                      // Guest label (responsive)
                      GestureDetector(
                        onTap: () {
                          // optional: navigate to setup if user taps guest label
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const SetUp()),
                          );
                        },
                        child: Text(
                          'Guest',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: guestFontSize,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                      SizedBox(width: mediaSize.width * 0.03),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SendAlertForm extends StatefulWidget {
  final VoidCallback onClose; final void Function(String message, String? location) onSend;
  const _SendAlertForm({ required this.onClose, required this.onSend, });

  @override State<_SendAlertForm> createState() => _SendAlertFormState(); }

class _SendAlertFormState extends State<_SendAlertForm> {
  final _formKey = GlobalKey<FormState>();
  final _locationCtrl = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  // Use PickedFile to match image_picker 1.x API
  XFile? _mediaFile;
  Uint8List? _videoThumbnail;// small thumbnail for selected video
  double? _latitude;
  double? _longitude;

  int _selectedOption = 0; // 0: Immediate help, 1: Report incident

  @override
  void dispose() {
    _locationCtrl.dispose();
    super.dispose();
  }

  // Helper to check video by file extension (works for picked files)
  bool _isVideoFile(XFile? file) {
    if (file == null) return false;
    final p = file.path.toLowerCase();
    return p.endsWith('.mp4') ||
        p.endsWith('.mov') ||
        p.endsWith('.mkv') ||
        p.endsWith('.avi') ||
        p.endsWith('.webm');
  }

  // Generate small thumbnail for video (uses video_thumbnail package)
  Future<void> _generateVideoThumbnail(String videoPath) async {
    try {
      final uint8list = await VideoThumbnail.thumbnailData(
        video: videoPath,
        imageFormat: ImageFormat.JPEG,
        maxWidth: 160,
        quality: 75,
      );
      setState(() => _videoThumbnail = uint8list);
    } catch (e) {
      // silently ignore thumbnail generation failures
      setState(() => _videoThumbnail = null);
    }
  }

  // Bottom sheet to choose camera/gallery photo/video
  Future<void> _pickMedia() async {
    try {
      final choice = await showModalBottomSheet<String>(
        context: context,
        builder: (ctx) => SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Take Photo'),
                onTap: () => Navigator.of(ctx).pop('camera_photo'),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose Photo from Gallery'),
                onTap: () => Navigator.of(ctx).pop('gallery_photo'),
              ),
              ListTile(
                leading: const Icon(Icons.videocam),
                title: const Text('Record Video'),
                onTap: () => Navigator.of(ctx).pop('camera_video'),
              ),
              ListTile(
                leading: const Icon(Icons.video_library),
                title: const Text('Choose Video from Gallery'),
                onTap: () => Navigator.of(ctx).pop('gallery_video'),
              ),
            ],
          ),
        ),
      );

      if (choice == null) return;

      XFile? picked;

      if (choice == 'camera_photo') {
        picked = await _picker.pickImage(
          source: ImageSource.camera,
          maxWidth: 2048,
        );
      } else if (choice == 'gallery_photo') {
        picked = await _picker.pickImage(
          source: ImageSource.gallery,
          maxWidth: 2048,
        );
      } else if (choice == 'camera_video') {
        picked = await _picker.pickVideo(
          source: ImageSource.camera,
          maxDuration: const Duration(seconds: 60),
        );
      } else if (choice == 'gallery_video') {
        picked = await _picker.pickVideo(
          source: ImageSource.gallery,
        );
      }

      if (picked != null) {
        // if it's a video, generate thumbnail (if you have video_thumbnail package)
        if (_isVideoFile(picked)) {
          await _generateVideoThumbnail(picked.path);
        } else {
          setState(() => _videoThumbnail = null);
        }

        setState(() => _mediaFile = picked);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to pick media')),
      );
    }
  }
  // ----- keep your existing _getLocation() unchanged -----
  Future<void> _getLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() => _locationCtrl.text = 'Location services disabled');
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      setState(() => _locationCtrl.text = 'Location permission denied');
      return;
    }

    try {
      final pos = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      _latitude = pos.latitude;
      _longitude = pos.longitude;
      setState(() {
        _locationCtrl.text =
        '${_latitude!.toStringAsFixed(6)}, ${_longitude!.toStringAsFixed(6)}';
      });
    } catch (e) {
      setState(() => _locationCtrl.text = 'Unable to get location');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // blurred backdrop
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
            child: Container(color: Colors.black.withOpacity(0.25)),
          ),
        ),

        // The centered form card
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 360, minHeight: 320),
            child: Material(
              color: Colors.transparent,
              child: Card(
                color: Colors.white.withOpacity(0.95),
                elevation: 16,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(18, 18, 18, 14),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 6),
                        const Text(
                          'How can we assist you?',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 12),

                        // radio options stacked in a column
                        RadioListTile<int>(
                          value: 0,
                          groupValue: _selectedOption,
                          onChanged: (v) =>
                              setState(() => _selectedOption = v ?? 0),
                          title: const Text('I need Help Immediately'),
                        ),
                        RadioListTile<int>(
                          value: 1,
                          groupValue: _selectedOption,
                          onChanged: (v) =>
                              setState(() => _selectedOption = v ?? 1),
                          title: const Text('Report an Incident'),
                        ),

                        const SizedBox(height: 8),

                        // Upload section
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Upload a picture or a video',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: _pickMedia,
                          child: Container(
                            width: double.infinity,
                            height: 110,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade400),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: _mediaFile == null
                                ? Center(
                              child: Text('Tap to upload photo/video',
                                  style:
                                  TextStyle(color: Colors.grey[700])),
                            )
                                : _isVideoFile(_mediaFile)
                                ? Row(
                              children: [
                                if (_videoThumbnail != null)
                                  ClipRRect(
                                    borderRadius:
                                    BorderRadius.circular(6),
                                    child: Image.memory(
                                      _videoThumbnail!,
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                else
                                  const Icon(Icons.videocam, size: 36),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    _mediaFile!.path.split('/').last,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            )
                                : ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(
                                File(_mediaFile!.path),
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Location share
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Share Location',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _locationCtrl,
                          readOnly: true,
                          onTap: _getLocation,
                          decoration: InputDecoration(
                            hintText: 'Tap to get current location',
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.my_location),
                              onPressed: _getLocation,
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8)),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 14),
                          ),
                        ),

                        if (_latitude != null && _longitude != null) ...[
                          const SizedBox(height: 10),
                          SizedBox(
                            height: 200,
                            child: FlutterMap(
                              options: MapOptions(
                                initialCenter: LatLng(_latitude!, _longitude!),
                                initialZoom: 15,
                                interactionOptions: const InteractionOptions(
                                    flags: InteractiveFlag.none),
                              ),
                              children: [
                                TileLayer(
                                  urlTemplate:
                                  'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                  userAgentPackageName: 'com.example.yourapp',
                                ),
                                MarkerLayer(
                                  markers: [
                                    Marker(
                                      point:
                                      LatLng(_latitude!, _longitude!),
                                      width: 40,
                                      height: 40,
                                      child: const Icon(Icons.location_on,
                                          color: Colors.red, size: 40),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],

                        const SizedBox(height: 16),

                        // Send button (unchanged)
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              final optionText = _selectedOption == 0
                                  ? 'I need Help Immediately'
                                  : 'Report an Incident';
                              final locationText = _locationCtrl.text.isEmpty
                                  ? null
                                  : _locationCtrl.text;

                              widget.onSend(optionText, locationText);

                              await showDialog<bool>(
                                context: context,
                                barrierDismissible: false,
                                builder: (ctx) => AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20), // rounded corners
                                    side: const BorderSide(color: Colors.black, width: 2), // border color & width
                                  ),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min, // shrink to fit content
                                    children: [
                                      Image.asset('assets/check_sendAlert.png',
                                        fit: BoxFit.cover,
                                        width: MediaQuery.of(context).size.width *0.35,
                                        height: MediaQuery.of(context).size.height *0.2,
                                      ),
                                       Text(
                                        'Your alert has been sent. Help is on the way.',
                                        style: TextStyle(
                                          fontSize: MediaQuery.of(context).size.width * 0.045,
                                        ), // center text horizontally
                                      ),
                                      const SizedBox(height: 20),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(0xFFD622A0), // button background color
                                          foregroundColor: Colors.white,            // text color
                                          minimumSize: Size( MediaQuery.of(context).size.width * 0.4, 48), // resizable width, fixed height
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(13), // optional rounded corners
                                          ),
                                        ),
                                        onPressed: () => Navigator.of(ctx).pop(true),
                                        child: const Text(
                                          'OK',
                                          style: TextStyle(fontSize: 16,
                                          fontFamily: 'inter',
                                            fontWeight: FontWeight.bold
                                          ), // adjustable text size
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );

                              widget.onClose();
                              Navigator.of(context).maybePop();
                            },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              child:
                              Text('Send', style: TextStyle(fontSize: 16)),
                            ),
                          ),
                        ),

                        const SizedBox(height: 8),

                        // Cancel button
                        SizedBox(
                          width: double.infinity,
                          child: TextButton(
                            onPressed: widget.onClose,
                            child: const Text('Cancel'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

void _openArrivalCodePopup(BuildContext context) {
  showGeneralDialog(
    context: context,
    barrierLabel: 'Arrival Code',
    barrierDismissible: false,
    barrierColor: Colors.black.withOpacity(0.20),
    transitionDuration: const Duration(milliseconds: 200),
    pageBuilder: (context, anim1, anim2) {
      return SafeArea(
        child: Stack(
          children: [
            // Blur background
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                child: Container(color: Colors.black.withOpacity(0.25)),
              ),
            ),
            // Centered form
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 360, minHeight: 180),
                child: Material(
                  color: Colors.transparent,
                  child: Card(
                    color: Colors.white.withOpacity(0.95),
                    elevation: 16,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(18, 18, 18, 14),
                      child: _ArrivalCodeForm(
                        onClose: () => Navigator.of(context).pop(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
    transitionBuilder: (context, anim, secondaryAnim, child) {
      final curved =
      CurvedAnimation(parent: anim, curve: Curves.easeOutCubic, reverseCurve: Curves.easeInCubic);
      return FadeTransition(
        opacity: curved,
        child: ScaleTransition(
          scale: Tween(begin: 0.95, end: 1.0).animate(curved),
          child: child,
        ),
      );
    },
  );
}

class _ArrivalCodeForm extends StatefulWidget {
  final VoidCallback onClose;
  const _ArrivalCodeForm({required this.onClose});

  @override
  State<_ArrivalCodeForm> createState() => _ArrivalCodeFormState();
}

class _ArrivalCodeFormState extends State<_ArrivalCodeForm> {
  final TextEditingController _codeCtrl = TextEditingController();

  @override
  void dispose() {
    _codeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 6),
        const Text(
          'Enter the arrival code provided to you.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: _codeCtrl,
          decoration: const InputDecoration(
            hintText: 'Arrival Code',
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(width: 1, color: Colors.grey),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(width: 1, color: Colors.black),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 12),
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFD622A0),
            foregroundColor: Colors.white,
            minimumSize: Size(MediaQuery.of(context).size.width * 0.4, 48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(13),
            ),
          ),
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(
            'OK',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'Inter',
            ),
          ),
        ),
      ],
    );
  }
}
