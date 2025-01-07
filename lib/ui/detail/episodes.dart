import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:helpers/helpers.dart';
import 'package:odin/controllers/detail_controller.dart';

import 'package:odin/data/entities/trakt.dart';
import 'package:odin/ui/cover/animated.dart';
import 'package:odin/ui/cover/still_cover.dart';
import 'package:odin/ui/dialogs/default.dart';
import 'package:odin/ui/dialogs/streams.dart';
import 'package:odin/ui/widgets/carousel.dart';

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
        Padding(
          padding: const EdgeInsets.only(left: 50),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Headline4(
              season.number == 0 ? season.title : 'Season ${season.number}',
            ),
          ]),
        ),
        SizedBox(
            height: 120,
            child: OdinCarousel(
                itemBuilder: (context, itemIndex, realIndex, controller) {
                  return AnimatedCover(
                    // controller: controller,
                    realIndex: realIndex,
                    extent: extent,
                    target: true,
                    child: StillCover(
                        item: season.episodes[itemIndex],
                        season: season,
                        show: show,
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) => DefaultDialog(
                                    child: StreamsDialog(
                                        item: season.episodes[itemIndex],
                                        season: season,
                                        show: show),
                                  ));
                        },
                        focus: itemIndex == 0),
                  );
                },
                onRowIndexChanged: (index) {},
                onChildIndexChanged: (index) {},
                onEnter: (idx) {
                  showDialog(
                      context: context,
                      builder: (context) => DefaultDialog(
                            child: StreamsDialog(
                                item: season.episodes[idx],
                                season: season,
                                show: show),
                          ));
                },
                extent: extent,
                anchor: 0.05,
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
