export 'buttons.dart';
export 'loaders.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:helpers/helpers/widgets/text.dart';
import 'package:odin/data/models/auth_model.dart';
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

class HealthCheck extends ConsumerWidget {
  const HealthCheck({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final healthy = ref.watch(healthProvider);

    return healthy.when(
      data: (value) => value
          ? const SizedBox()
          : Container(
              color: AppColors.red,
              padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  FaIcon(FontAwesomeIcons.triangleExclamation,
                      size: 8, color: AppColors.darkGray),
                  const SizedBox(width: 5),
                  CaptionText("Connection error",
                      style: TextStyle(color: AppColors.darkGray, fontSize: 8)),
                ],
              ),
            ),
      error: (_, __) => const BodyText1("Connection error"),
      loading: () => const SizedBox(),
    );
  }
}

class OdinLogo extends StatelessWidget {
  final double height;
  final bool showText;
  const OdinLogo({Key? key, this.height = 25, this.showText = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset("assets/images/logo.svg", height: height),
        showText ? SizedBox(width: height / 5) : const SizedBox(),
        showText
            ? Headline4(
                "ODIN",
                style: TextStyle(fontSize: height / 1.5),
              )
            : const SizedBox(),
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
