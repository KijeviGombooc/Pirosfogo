import 'package:flutter/material.dart';

class ProfileWidget extends StatelessWidget {
  static Image defaultImage = Image.asset("assets/images/head.png");
  final Image? image;
  final void Function()? onTap;

  const ProfileWidget({
    this.image,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          child: AspectRatio(
            aspectRatio: 1,
            child: (image == null ? defaultImage : image),
          ),
        ),
      ),
    );
  }
}
