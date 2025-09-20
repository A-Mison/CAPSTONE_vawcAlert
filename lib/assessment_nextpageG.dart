// next_page_g.dart
import 'package:flutter/material.dart';
import 'package:vawc_alert_proj/assessment_nextpageH.dart'; // siguraduhing i-update ang NextPageH ayon sa snippet sa ibaba
// import any other assets you need

class NextPageG extends StatefulWidget {
  final List<String> previousAnswers;
  const NextPageG({Key? key, this.previousAnswers = const []}) : super(key: key);

  @override
  State<NextPageG> createState() => _NextPageGState();
}

class _NextPageGState extends State<NextPageG> {
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

    final double navBarHeight = kToolbarHeight + paddingTop;
    final double topNavSpacer = navBarHeight + (mediaSize.height * 0.01);

    final double arrowSize = (mediaSize.width * 0.09).clamp(30.0, 60.0);
    final double titleFont = (mediaSize.width * 0.05).clamp(16.0, 24.0);
    final double questionFont = (mediaSize.width * 0.042).clamp(14.0, 20.0);
    final double optionFont = (mediaSize.width * 0.045).clamp(13.0, 18.0);
    final double questionPadding = mediaSize.width * 0.04;
    final double betweenSpacing = mediaSize.height * 0.018;

    final double avatarBase = mediaSize.width * 0.12;
    final double avatarSize = avatarBase.clamp(36.0, 72.0);
    final double guestFontSize = (mediaSize.width * 0.045).clamp(12.0, 20.0);

    final double nextBtnHeight = (mediaSize.height * 0.05).clamp(36.0, 52.0);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        constraints: BoxConstraints(minHeight: mediaSize.height),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/login_bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: topNavSpacer),
                  SizedBox(height: mediaSize.height * 0.03),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: mediaSize.width * 0.04),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: Image.asset(
                            'assets/arrow-left.png',
                            width: arrowSize,
                            height: arrowSize,
                            fit: BoxFit.contain,
                          ),
                        ),
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
                          '9/10',
                          style: TextStyle(
                            fontSize: screenWidth * 0.08,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Inter',
                          ),
                        );
                      },
                    ),
                  ),

                  SizedBox(height: betweenSpacing,),

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
                        'May pagkakataon ba na sinisira o kinukuha ang iyong mga gamit o personal na ari-arian bilang paraan ng galit o pananakot?',
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

                        SizedBox(height: mediaSize.height * 0.008),

                        SizedBox(
                          width: double.infinity,
                          height: nextBtnHeight,
                          child: ElevatedButton(
                            onPressed: _selectedOption == null
                                ? null
                                : () {
                              // Append current answer to the previousAnswers and pass to NextPageH
                              final updatedAnswers = List<String>.from(widget.previousAnswers)
                                ..add(_selectedOption!);

                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => NextPageH(previousAnswers: updatedAnswers),
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

                        SizedBox(height: mediaSize.height * 0.03),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SafeArea(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: mediaSize.width * 0.04),
                color: const Color(0xFF991F59),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
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
