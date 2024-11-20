export 'buttons.dart';
export 'loaders.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:helpers/helpers/widgets/text.dart';
import 'package:odin/theme.dart';

class TextChip extends StatelessWidget {
  final String text;

  const TextChip(this.text, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
      decoration: BoxDecoration(
          color: Colors.white.withAlpha(50),
          borderRadius: BorderRadius.circular(5)),
      child: BodyText1(text),
    );
  }
}

class TextChipBig extends StatelessWidget {
  final String text;

  const TextChipBig(this.text, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
      decoration: BoxDecoration(
          color: Colors.white.withAlpha(50),
          borderRadius: BorderRadius.circular(5)),
      child: Text(
        text,
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    );
  }
}

class OdinLogo extends StatelessWidget {
  const OdinLogo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      // mainAxisSize: MainAxisSize.max,
      children: [
        SvgPicture.asset("assets/images/logo.svg", height: 25),
      ],
    );
  }
}

class Watched extends StatelessWidget {
  final bool iconOnly;
  const Watched({Key? key, this.iconOnly = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      // ignore: prefer_const_literals_to_create_immutables
      children: [
        Icon(
          FontAwesomeIcons.solidCircleCheck,
          color: AppColors.green.withAlpha(100),
          size: 9,
        ),
        SizedBox(width: iconOnly ? 0 : 5),
        iconOnly
            ? const SizedBox()
            : Subtitle1("Watched", style: TextStyle(color: AppColors.green))
      ],
    );
  }
}
