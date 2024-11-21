import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:odin/controllers/detail_controller.dart';
import 'package:odin/ui/dialogs/streams.dart';
// import 'package:odin/ui/dialogs/streams.dart';
// import 'package:odin/ui/dialogs/trakt_actions.dart';
// import 'package:odin/ui/themes/default.dart';
import 'package:odin/ui/widgets/buttons.dart';
import 'package:odin/ui/widgets/ensure_visible.dart';
import 'package:odin/ui/widgets/widgets.dart';
import 'package:odin/data/entities/trakt.dart';
// import 'package:';

import '../../theme.dart';
import 'widgets.dart';

class DetailMovie extends StatelessWidget {
  final Trakt item;
  const DetailMovie(this.item, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Background(
      item.tmdb!.backdropBig,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 50, right: 50, bottom: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    EnsureVisible(child: Buttons(item: item)),
                    ItemDetails(item: item),
                  ],
                ),
              ),
              EnsureVisible(
                child: SizedBox(
                  child: Column(
                    children: [
                      ItemCast(item: item),
                      const ImdbReview(),
                    ],
                  ),
                ),
              )
            ],
          ),
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
    final controller = ref.read(detailController.notifier);
    return SizedBox(
      height: 30,
      child: Row(
        children: [
          ButtonWithIcon('Play',
              icon: const Icon(FontAwesomeIcons.play, size: 15),
              node: controller.playButtonNode, onPress: () async {
            showDialog(
                context: context,
                builder: (context) => Dialog(
                      backgroundColor: AppColors.darkGray,
                      child: StreamsDialog(item: item),
                    ));
          }),
          const SizedBox(width: 20),
          ButtonWithIcon(
            'Trailer',
            icon: const Icon(FontAwesomeIcons.youtube,
                size: 15, color: Colors.white),
            onPress: () {
              controller.playTrailer();
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
            onPress: () {},
          )
        ],
      ),
    );
  }
}
