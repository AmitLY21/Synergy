import 'package:flutter/cupertino.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({
    Key? key,
    required this.title,
    required this.subtitle,
  }) : super(key: key);

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GradientText(
          title,
          style: const TextStyle(
            fontSize: 40.0,
          ),
          colors: const [Color(0xFF674188), Color(0xFFC3ACD0)],
        ),
        SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Text(
            subtitle,
            softWrap: true,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
