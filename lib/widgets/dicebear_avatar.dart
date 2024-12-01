import 'package:flutter/material.dart';
import 'package:dice_bear/dice_bear.dart';
import 'package:flutter_svg/svg.dart';

class DiceBearAvatar extends StatelessWidget {
  final String seed;
  final double radius;

  const DiceBearAvatar({
    super.key,
    required this.seed,
    this.radius = 60,
  });

  @override
  Widget build(BuildContext context) {
    final Avatar avatar = DiceBearBuilder(
      sprite: DiceBearSprite.botttsNeutral,
      seed: seed,
    ).build();

    print('Avatar URL: ${avatar.svgUri}');

    return ClipOval(
      child: SvgPicture.network(
        avatar.svgUri.toString(),
        height: radius * 2,
        width: radius * 2,
        placeholderBuilder: (context) => Container(
          height: radius * 2,
          width: radius * 2,
          color: Colors.grey.shade200,
          child: const CircularProgressIndicator(),
        ),
      ),
    );
  }
}
