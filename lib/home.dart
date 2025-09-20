// responsive_home_page.dart
import 'dart:math' as math;
import 'dart:ui' show ImageFilter;
import 'package:flutter/material.dart';
import 'package:vawc_alert_proj/Assessment.dart';
import 'package:vawc_alert_proj/Awareness.dart';
import 'package:vawc_alert_proj/emergency.dart';
import 'package:vawc_alert_proj/setupaccount.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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

    // --- Responsive sizes specifically for the two buttons and the center logo (changes made) ---
    // Image inside Assessment/Awareness buttons: capped at original 100 but scale down on small screens
    final double buttonInnerImageSize = math.min(100.0, mediaSize.width * 0.22);
    // Font for the labels inside the two buttons
    final double buttonLabelFont = ((mediaSize.width * 0.04).clamp(12.0, 18.0)) as double;
    // Center VAWCA logo previously 300x300 — keep that as max but scale down on narrower screens
    final double centerLogoSize = math.min(315.0, mediaSize.width * 0.68);

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
                              side: const BorderSide(color: Colors.black, width: 1),
                            ),
                            backgroundColor: const Color(0xD6E8E8EF),
                            foregroundColor: Colors.black,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const EmergencyPage()),
                            );
                          },
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

              const SizedBox(height: 15),

              // Row with Send Alert and Actions (we keep the same width fraction but tile contents are responsive)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          fixedSize: Size(mediaSize.width * 0.40, 145), // lock size
                          padding: EdgeInsets.zero,
                          alignment: Alignment.topCenter,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                            side: const BorderSide(color: Colors.black, width: 6),
                          ),
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const AssessmentPage()),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 2), // smaller gap under text
                                child: Image.asset(
                                  'assets/image 4.png',
                                  width: buttonInnerImageSize,
                                  height: buttonInnerImageSize,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "Assessment",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: buttonLabelFont,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.bold,
                                  height: 1.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 18),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          fixedSize: Size(mediaSize.width * 0.40, 145), // lock size
                          padding: EdgeInsets.zero,
                          alignment: Alignment.topCenter,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                            side: const BorderSide(color: Colors.black, width: 6),
                          ),
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const  AwarenessPage()),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 6, top: 6), // smaller gap under text
                                child: Image.asset(
                                  'assets/image 3.png',
                                  width: buttonInnerImageSize,
                                  height: buttonInnerImageSize,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              Text(
                                "Awareness",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: buttonLabelFont,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.bold,
                                  height: 1.0,
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

              // Center VAWCA logo (now responsive but capped at original 300)
              SizedBox(
                  height: (MediaQuery.of(context).size.height * 0)
              ),
              Image.asset(
                'assets/vawca_logo.png',
                width: centerLogoSize,
                height: centerLogoSize,
                fit: BoxFit.contain,
              ),

              SizedBox(height: MediaQuery.of(context).size.height * 0),

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

/// Small, white, centered pop-up form used by "Send Alert".
class _SendAlertForm extends StatefulWidget {
  final VoidCallback onClose;
  final void Function(String message, String? location) onSend;

  const _SendAlertForm({
    required this.onClose,
    required this.onSend,
  });

  @override
  State<_SendAlertForm> createState() => _SendAlertFormState();
}

class _SendAlertFormState extends State<_SendAlertForm> {
  final _formKey = GlobalKey<FormState>();
  final _messageCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();

  @override
  void dispose() {
    _messageCtrl.dispose();
    _locationCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Keep the form compact & centered
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 290, minHeight: 240),
      child: Material(
        color: Colors.transparent, // let the Card handle background
        child: Card(
          color: Colors.white,
          elevation: 16,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
            child: Form(
              key: _formKey,
              child: IntrinsicWidth(
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                    const SizedBox(height: 30),
                const Text(
                  'Setup your account first to access "Send Alert" and "Actions".',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 40),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                TextButton(
                style: TextButton.styleFrom(
                backgroundColor: const Color(0xFFD4229F),
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SetUp()),
                );
              },
              child: const Text('Setup Account'),
            ),
            const SizedBox(width: 8),
                      SizedBox(
                        width: 110,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: const Color(0xFFD4229F),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40),
                              side: const BorderSide(color: Colors.black, width: 1),
                            ),
                          ),
                          onPressed: widget.onClose,
                          child: const Text('Cancel'),
                        ),
                      ),
          ],
        ),
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
