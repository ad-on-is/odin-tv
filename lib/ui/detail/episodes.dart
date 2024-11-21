import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:helpers/helpers.dart';
import 'package:odin/controllers/detail_controller.dart';

import 'package:odin/data/entities/trakt.dart';
import 'package:odin/data/services/trakt_service.dart';
import 'package:odin/helpers.dart';
import 'package:odin/theme.dart';
import 'package:odin/ui/cover/animated.dart';
import 'package:odin/ui/cover/still_cover.dart';
import 'package:odin/ui/dialogs/streams.dart';
import 'package:odin/ui/widgets/carousel.dart';
import 'package:odin/ui/widgets/ensure_visible.dart';
import 'package:odin/ui/widgets/widgets.dart';

class Episodes extends ConsumerWidget {
  final Trakt season;
  final Trakt show;
  const Episodes({Key? key, required this.season, required this.show})
      : super(key: key);

  String airDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}";
  }

  @override
  Widget build(BuildContext context, ref) {
    ref.watch(detailController);
    const extent = 200.0;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Headline4(
          season.number == 0 ? season.title : 'Season ${season.number}',
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width / 2,
          height: 20,
          child: BodyText1(
            season.overview,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        SizedBox(
            height: 120,
            child: OdinCarousel(
                itemBuilder: (context, itemIndex, realIndex, controller) {
                  return AnimatedCover(
                    controller: controller,
                    realIndex: realIndex,
                    extent: extent,
                    target: true,
                    child: StillCover(
                        item: season.episodes[itemIndex],
                        season: season,
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) => Dialog(
                                    backgroundColor: AppColors.darkGray,
                                    child: StreamsDialog(
                                        item: season.episodes[itemIndex],
                                        season: season,
                                        show: show),
                                  ));
                        },
                        focus: itemIndex == 0),
                  );
                },
                onIndexChanged: (index) {},
                extent: extent,
                anchor: 0.0,
                keys: const [
                  PhysicalKeyboardKey.arrowLeft,
                  PhysicalKeyboardKey.arrowRight
                ],
                count: season.episodes.length,
                axis: Axis.horizontal)),
        const SizedBox(height: 20),
      ],
    );
  }
}
