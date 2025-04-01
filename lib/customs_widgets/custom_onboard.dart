import 'package:agri_flutter/core/image.dart';
import 'package:agri_flutter/customs_widgets/reusable.dart';
import 'package:flutter/material.dart';

class CustomOnboard extends StatelessWidget {
  const CustomOnboard({
    super.key,
    required this.image,
    required this.title,
    required this.description,
  });

  final String image;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(ImageConst.logo, width: 120, height: 120),
            SizedBox(height: 40),
            Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              width: 300,
              height: 300,
              child: Image.asset(image, fit: BoxFit.cover),
            ),
            SizedBox(height: 20),
            largeBold(title),
            // Text(title),
            SizedBox(height: 20),
            smallText(description),
          ],
        ),
      ),
    );
  }
}
