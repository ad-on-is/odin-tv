import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:odin/controllers/detail_controller.dart';
import 'package:odin/theme.dart';
import 'package:odin/data/entities/trakt.dart';
import 'package:odin/ui/widgets/buttons.dart';
import 'package:odin/ui/widgets/ensure_visible.dart';

import 'widgets.dart';

class DetailShow extends ConsumerWidget {
  final Trakt item;
  const DetailShow(this.item, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    return Container(
      color: AppColors.darkGray,
      child: Background(
        item.tmdb!.backdropBig,
        child: SingleChildScrollView(
          child: Padding(
              padding:
                  const EdgeInsets.only(left: 50, right: 0, bottom: 10, top: 0),
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
                  SizedBox(
                    child: SeasonsAndEpisodes(item: item),
                  ),
                  SizedBox(
                    child: Column(
                      children: [
                        ItemCast(item: item),
                        const ImdbReview(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              )),
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
    return SizedBox(
      height: 25,
      child: Row(
        children: [
          ButtonWithIcon('Seasons',
              icon: const Icon(FontAwesomeIcons.film,
                  size: 15, color: Colors.white),
              node: ref.read(detailController.notifier).seasonButtonNode,
              onPress: () {
            // model.showEpisodes();
          }),
          const SizedBox(width: 20),
          ButtonWithIcon(
            'Trailer',
            icon: const Icon(FontAwesomeIcons.youtube,
                size: 15, color: Colors.white),
            onPress: () {
              // model.playTrailer();
            },
          ),
          const SizedBox(width: 20),
          ButtonWithIcon(
            'Trakt',
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
    );
  }
}
