import 'package:flutter/material.dart';
import 'package:vitium/app/presentation/global/components/visual_details/profile_image.dart';

class HeaderWithImage extends StatelessWidget {
  const HeaderWithImage({
    super.key,
    required this.firstText,
    required this.seccondText,
    this.scaleDown = false,
  });

  final String firstText;
  final String seccondText;
  final bool scaleDown;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          constraints: BoxConstraints(maxWidth: width * 0.6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                firstText,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: scaleDown ? 24 : 32,
                ),
              ),
              FittedBox(
                child: Text(
                  seccondText,
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.w500,
                    fontSize: scaleDown ? 20 : 28,
                  ),
                ),
              ),
            ],
          ),
        ),
        const ProfileImage(
          radius: 40,
        ),
      ],
    );
  }
}
