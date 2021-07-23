import 'package:flutter/material.dart';

class ProfileWidget extends StatelessWidget {
  static Image defaultImage = Image.asset("assets/images/head.png");
  final Image? image;
  final void Function()? onTap;
  final Size maxSize;

  const ProfileWidget({
    this.image,
    this.onTap,
    this.maxSize = const Size(double.infinity, double.infinity),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: ClipOval(
        child: Container(
          constraints: BoxConstraints(
              maxWidth: maxSize.width, maxHeight: maxSize.height),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: InkWell(
            onTap: onTap,
            child: AspectRatio(
              aspectRatio: 1,
              child: (image == null ? defaultImage : image),
            ),
          ),
        ),
      ),
    );
  }
}
