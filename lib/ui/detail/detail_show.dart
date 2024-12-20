import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:odin/controllers/app_controller.dart';
import 'package:odin/theme.dart';
import 'package:odin/data/entities/trakt.dart';
import 'package:odin/ui/widgets/buttons.dart';
import 'package:odin/ui/widgets/ensure_visible.dart';

import 'widgets.dart';

class DetailShow extends HookConsumerWidget {
  final Trakt item;
  const DetailShow(this.item, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    return Container(
      color: AppColors.darkGray,
      child: Background(
        item,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  EnsureVisible(child: Buttons(item: item)),
                  // const SizedBox(height: 10),
                  ItemDetails(item: item),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ItemSlides(item: item),
          ],
        ),
      ),
    );
  }
}

class Buttons extends ConsumerWidget {
  final Trakt item;
  const Buttons({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final mf = ref.watch(beforeFocusProvider);
    return Padding(
      padding: const EdgeInsets.only(left: 40.0),
      child: SizedBox(
        height: 25,
        child: Row(
          children: [
            ButtonWithIcon('Seasons',
                icon: const Icon(FontAwesomeIcons.film,
                    size: 15, color: Colors.white),
                node: FocusNode(canRequestFocus: mf, skipTraversal: !mf),
                onPress: () {
              // model.showEpisodes();
            }),
            const SizedBox(width: 20),
            ButtonWithIcon(
              'Trailer',
              node: FocusNode(canRequestFocus: mf, skipTraversal: !mf),
              icon: const Icon(FontAwesomeIcons.youtube,
                  size: 15, color: Colors.white),
              onPress: () {
                // model.playTrailer();
              },
            ),
            const SizedBox(width: 20),
            ButtonWithIcon(
              'Trakt',
              node: FocusNode(canRequestFocus: mf, skipTraversal: !mf),
              icon: Image.asset(
                'assets/images/trakt.png',
                width: 15,
                color: Colors.white,
              ),
              onPress: () {
                // show trakt Dialog
              },
            )
          ],
        ),
      ),
    );
  }
}
