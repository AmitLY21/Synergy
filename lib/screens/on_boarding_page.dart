import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:synergy/constants/app_constants.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({Key? key}) : super(key: key);

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  List<PageViewModel> listPagesViewModel = [
    PageViewModel(
      title: AppConstants.introPage1Title,
      bodyWidget: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Flexible(
            child: Text(
              AppConstants.introPage1Description,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
      image: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
            child: Lottie.network(
          AppConstants.introPage1Lottie,
          animate: true,
        )),
      ),
    ),
    PageViewModel(
      title: AppConstants.introPage2Title,
      bodyWidget: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Flexible(
            child: Text(
              AppConstants.introPage2Description,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
      image: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Lottie.network(
            AppConstants.introPage2Lottie,
            animate: true,
          ),
        ),
      ),
    ),
    PageViewModel(
      title: AppConstants.introPage3Title,
      bodyWidget: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Flexible(
            child: Text(
              AppConstants.introPage3Description,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
      image: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Lottie.network(
            AppConstants.introPage3Lottie,
            animate: true,
          ),
        ),
      ),
    )
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: IntroductionScreen(
          pages: listPagesViewModel,
          showBackButton: true,
          back: const Icon(Icons.arrow_back),
          next: const Icon(Icons.arrow_forward),
          done:
              const Text("Done", style: TextStyle(fontWeight: FontWeight.w700)),
          baseBtnStyle: TextButton.styleFrom(
            backgroundColor: Colors.grey.shade200,
          ),
          onDone: () {
            // On Done button pressed
            Navigator.pushNamedAndRemoveUntil(context, 'auth', (e) => false);
          },
          dotsDecorator: DotsDecorator(
            size: const Size.square(10.0),
            activeSize: const Size(20.0, 10.0),
            spacing: const EdgeInsets.symmetric(horizontal: 3.0),
            activeShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0)),
          ),
        ),
      ),
    );
  }
}
