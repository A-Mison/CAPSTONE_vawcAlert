import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class AwarenessPage extends StatefulWidget {
  const AwarenessPage({super.key});

  @override
  State<AwarenessPage> createState() => _AwarenessPageState();
}

class _AwarenessPageState extends State<AwarenessPage> {
  late YoutubePlayerController _youtubeController;
  List<bool> _expanded = [false, false, false, false];

  // state flag to control absolute fullscreen overlay
  bool _isPlayerFullscreen = false;

  // --- NEW: titles and descriptions for each button (4 items) ---
  final List<String> _buttonTitles = [
    'Ano ang "Anti violence Against Women and their Children Act?"',
    'Sino ang puwedeng maghain ng kaso sa ilalim ng RA9262?',
    'Mga uri ng pag-aabuso.',
    'Ano ang Battered Women Syndrome (BWS)?'
  ];

  final List<String> _buttonDescriptions = [
    // 1
    'Ang “Anti-Violence Against Women and Their Children Act” (RA 9262) ay batas sa Pilipinas na naglalayong protektahan ang kababaihan at kanilang mga anak laban sa anumang anyo ng karahasan—pisikal, emosyonal, sekswal, at iba pa—at nagbibigay ng remedyo at parusa laban sa mga maysala.',
    // 2
    'Maaaring maghain ng kaso ang mismong biktima, o ang sinumang may legal na kapasidad o personalidad na kumatawan sa interes ng biktima (hal. magulang o tagapag-alaga para sa mga bata). May mga pagkakataon din na maaaring tumulong ang mga awtoridad o ahensya sa pag-file ng kaso.',
    // 3
    'Kabilang sa mga uri ng pag-aabuso ang: pisikal (pagpapalo, pananakit), emosyonal/psychological (panlalait, pagbabanta), sekswal (sapilitang pakikipagtalik o panghahalay), at ekonomikal (pagtanggi ng suporta, kontrol sa pera).',
    // 4
    'Ang Battered Woman Syndrome (BWS) ay isang pattern ng psychological at behavioral responses ng mga babae na matagal na inabuso — kadalasang may trauma, takot, at pagbabago sa kakayahang kumilos o magpasya dahil sa sistematikong pang-aabuso.'
  ];

  @override
  void initState() {
    super.initState();
    _youtubeController = YoutubePlayerController(
      initialVideoId: 'AF2iOwmjHTM', // Replace with actual VAWC video ID if different
      flags: const YoutubePlayerFlags(autoPlay: false, mute: false),
    );
  }

  @override
  void dispose() {
    _youtubeController.dispose();
    super.dispose();
  }

  // <-- Replaced implementation: removed call to nonexistent toggleFullScreen()
  Future<bool> _onWillPop() async {
    if (_isPlayerFullscreen) {
      // If our custom overlay fullscreen is active, close it and don't pop the route.
      setState(() => _isPlayerFullscreen = false);

      // Restore allowed orientations (allow all). Adjust if your app uses different prefs.
      await SystemChrome.setPreferredOrientations(DeviceOrientation.values);

      // Return false to consume the back press.
      return false;
    }
    // Not fullscreen — allow normal back navigation.
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final mediaSize = MediaQuery.of(context).size;

    final double avatarBase = mediaSize.width * 0.12;
    final double avatarSize = avatarBase.clamp(36, 72);
    final double guestFontSize = (mediaSize.width * 0.045).clamp(12, 20);

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/login_bg.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              Column(
                children: [
                  SizedBox(height: mediaSize.height * 0.15), // Space for navbar (resizable)
                  // Arrow + Awareness Title
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: Image.asset(
                            'assets/arrow-left.png',
                            width: mediaSize.width * 0.09,
                            height: mediaSize.width * 0.09,
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              'AWARENESS',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.bold,
                                fontSize: mediaSize.width * 0.05,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: mediaSize.width * 0.07),
                      ],
                    ),
                  ),
                  SizedBox(height: mediaSize.height * 0.02),

                  // ---------- YouTube player (normal inline position) ----------
                  // Use YoutubePlayerBuilder to get onEnterFullScreen/onExitFullScreen callbacks.
                  YoutubePlayerBuilder(
                    player: YoutubePlayer(
                      controller: _youtubeController,
                      showVideoProgressIndicator: true,
                      progressIndicatorColor: Colors.pink,
                    ),
                    builder: (context, player) {
                      // Show the inline player only when not in the absolute fullscreen overlay.
                      return !_isPlayerFullscreen
                          ? Padding(
                        padding: EdgeInsets.symmetric(horizontal: mediaSize.width * 0.03),
                        child: player,
                      )
                          : const SizedBox.shrink();
                    },
                    onEnterFullScreen: () {
                      // when the player's fullscreen control is pressed, show overlay
                      setState(() => _isPlayerFullscreen = true);

                      // Keep app in portrait while overlay is shown (prevents device rotating).
                      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
                    },
                    onExitFullScreen: () {
                      // when the player's "exit fullscreen" is pressed, hide overlay
                      setState(() => _isPlayerFullscreen = false);

                      // Restore allowed orientations (allow all). Adjust if your app has different prefs.
                      SystemChrome.setPreferredOrientations(DeviceOrientation.values);
                    },
                  ),

                  SizedBox(height: mediaSize.height * 0.02),
                  // Video Courtesy Text
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: mediaSize.width * 0.04),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Video Courtesy: GP ANGELES  AND ASSOCIATES LAW OFFICE',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: mediaSize.width * 0.04,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: mediaSize.height * 0.03),
                  // -------------------------
                  // Dropdown Buttons (RESIZABLE)
                  // -------------------------
                  Expanded(
                    child: ListView.builder(
                      itemCount: _buttonTitles.length,
                      padding: EdgeInsets.symmetric(horizontal: mediaSize.width * 0.04),
                      itemBuilder: (context, index) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Button (tap to expand)
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _expanded[index] = !_expanded[index];
                                });
                              },
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(
                                  vertical: mediaSize.height * 0.018,
                                  horizontal: mediaSize.width * 0.04,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFA43784),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: Colors.black, // border color
                                    width: 1, // border thickness
                                  ),
                                ),
                                child: Text(
                                  _buttonTitles[index],
                                  style: TextStyle(
                                    fontFamily: '',
                                    fontSize: mediaSize.width * 0.040,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),

                            // Expanded description (white box) — responsive margins & padding
                            if (_expanded[index])
                              Container(
                                width: double.infinity,
                                margin: EdgeInsets.only(top: mediaSize.height * 0.012),
                                padding: EdgeInsets.all(mediaSize.width * 0.04),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  _buttonDescriptions[index],
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: mediaSize.width * 0.038,
                                    color: Colors.black87,
                                    height: 1.35,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ),

                            // Space between items
                            SizedBox(height: mediaSize.height * 0.018),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),

              // Nav Bar (unchanged layout; responsive)
              SafeArea(
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: mediaSize.width * 0.04),
                  color: const Color(0xFF991F59),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Logo
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: mediaSize.width * 0.40,
                          maxHeight: mediaSize.height * 0.09,
                        ),
                        child: Image.asset(
                          'assets/vawca_logo.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                      // Avatar + Guest
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
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
                          GestureDetector(
                            onTap: () {},
                            child: Text(
                              'Guest',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: guestFontSize,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w600,
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

              // ---------- Absolute fullscreen overlay (covers entire screen) ----------
              if (_isPlayerFullscreen)
                Positioned.fill(
                  child: Material(
                    color: Colors.black,
                    child: SafeArea(
                      // show the player to occupy full overlay; hide inline player above by the builder returning SizedBox.shrink()
                      child: Center(
                        child: SizedBox.expand(
                          child: YoutubePlayer(
                            controller: _youtubeController,
                            showVideoProgressIndicator: true,
                            progressIndicatorColor: Colors.pink,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
