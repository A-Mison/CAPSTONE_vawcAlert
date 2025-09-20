import 'package:flutter/material.dart';
import 'package:vawc_alert_proj/assessment_nextpage.dart';
import 'package:vawc_alert_proj/assessment_nextpageD.dart';

class NextPageC extends StatefulWidget {
  final List<String> previousAnswers;
  const NextPageC({super.key, required this.previousAnswers});

  @override
  State<NextPageC> createState() => _NextPageCState();
}

class _NextPageCState extends State<NextPageC> {
  String? _selectedOption;

  final List<String> _options = [
    'Oo, madalas',
    'Oo, paminsan-minsan',
    'Halos hindi',
    'Hindi kailanman',
  ];

  @override
  Widget build(BuildContext context) {
    final mediaSize = MediaQuery.of(context).size;
    final paddingTop = MediaQuery.of(context).padding.top;

    // Nav bar height baseline (toolbar + status bar)
    final double navBarHeight = kToolbarHeight + paddingTop;
    // Leave a little extra space below the nav bar so the content doesn't appear beneath it
    final double topNavSpacer = navBarHeight + (mediaSize.height * 0.01);

    // Responsive sizes
    final double arrowSize = (mediaSize.width * 0.09).clamp(30.0, 60.0);
    final double titleFont = (mediaSize.width * 0.05).clamp(16.0, 24.0);
    final double questionFont = (mediaSize.width * 0.042).clamp(14.0, 20.0);
    final double optionFont = (mediaSize.width * 0.045).clamp(13.0, 18.0);
    final double questionPadding = mediaSize.width * 0.04;
    final double betweenSpacing = mediaSize.height * 0.018;

    // Nav bar avatar
    final double avatarBase = mediaSize.width * 0.12;
    final double avatarSize = avatarBase.clamp(36.0, 72.0);
    final double guestFontSize = (mediaSize.width * 0.045).clamp(12.0, 20.0);

    // Next button slightly smaller than before (requested)
    final double nextBtnHeight = (mediaSize.height * 0.05).clamp(36.0, 52.0);

    return Scaffold(
      // Keep scaffold background transparent so our container's background image is visible.
      backgroundColor: Colors.transparent,
      body: Container(
        // Ensure background covers the entire screen (no white gap at bottom)
        constraints: BoxConstraints(minHeight: mediaSize.height),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/login_bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            // Whole page scrolls if needed (options are fixed; not individually scrollable)
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Reserve space for the overlaid nav bar so content never scrolls above it.
                  SizedBox(height: topNavSpacer),
                  SizedBox(height: mediaSize.height *0.03),
                  // Arrow + Title row (just below nav bar)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: mediaSize.width * 0.04),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Back arrow
                        GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: Image.asset(
                            'assets/arrow-left.png',
                            width: arrowSize,
                            height: arrowSize,
                            fit: BoxFit.contain,
                          ),
                        ),

                        // Title centered
                        Expanded(
                          child: Center(
                            child: Text(
                              'ASSESSMENT',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.bold,
                                fontSize: titleFont,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),

                        // Balanced spacer so title is visually centered
                        SizedBox(width: arrowSize),
                      ],
                    ),
                  ),

                  SizedBox(height: betweenSpacing),

                  Center(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        double screenWidth = MediaQuery.of(context).size.width;
                        return Text(
                          '5/10',
                          style: TextStyle(
                            fontSize: screenWidth * 0.08, // scales with screen width
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Inter',
                          ),
                        );
                      },
                    ),
                  ),

                  SizedBox(height: betweenSpacing,),

                  // Question container with gray background and black border
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: mediaSize.width * 0.04),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(questionPadding),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        border: Border.all(color: Colors.black, width: 1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'May pagkakataon ba na kinokontrol ang iyong pera o pinagkakaitan ka ng pinansyal na suporta?',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: questionFont,
                          color: Colors.black87,
                          height: 1.3,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: betweenSpacing),

                  // Options (NOT a scrolling list - fixed column)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: mediaSize.width * 0.04),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        for (var i = 0; i < _options.length; i++) ...[
                          RadioListTile<String>(
                            value: _options[i],
                            groupValue: _selectedOption,
                            onChanged: (val) {
                              setState(() {
                                _selectedOption = val;
                              });
                            },
                            title: Text(
                              _options[i],
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: optionFont,
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: mediaSize.width * 0.02,
                              vertical: mediaSize.height * 0.001,
                            ),
                            activeColor: const Color(0xFFA43784),
                          ),
                          SizedBox(height: mediaSize.height * 0.012),
                        ],

                        // Smaller gap before Next (requested smaller than before)
                        SizedBox(height: mediaSize.height * 0.008),

                        // Next button (disabled until an option is selected)
                        SizedBox(
                          width: double.infinity,
                          height: nextBtnHeight,
                          child: ElevatedButton(
                            onPressed: _selectedOption == null
                                ? null
                                : () {
                              // append current answer to previousAnswers and pass to next page
                              final updatedAnswers = List<String>.from(widget.previousAnswers)
                                ..add(_selectedOption!);

                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => NextPageD(previousAnswers: updatedAnswers),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFA43784),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 2,
                            ),
                            child: Text(
                              'Next',
                              style: TextStyle(
                                fontSize: (mediaSize.width * 0.045).clamp(14.0, 20.0),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                        // Bottom padding so last element isn't flush to the very bottom edge
                        SizedBox(height: mediaSize.height * 0.03),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Nav Bar (overlaid, stays on top)
            SafeArea(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: mediaSize.width * 0.04),
                color: const Color(0xFF991F59),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Left logo (same as your previous pages)
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
          ],
        ),
      ),
    );
  }
}
