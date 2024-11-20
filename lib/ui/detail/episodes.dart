import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:helpers/helpers.dart';
import 'package:odin/controllers/detail_controller.dart';

import 'package:odin/data/entities/trakt.dart';
import 'package:odin/data/services/trakt_service.dart';
import 'package:odin/helpers.dart';
import 'package:odin/theme.dart';
import 'package:odin/ui/cover/still_cover.dart';
import 'package:odin/ui/dialogs/streams.dart';
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Headline2(
          'Season ${season.number}',
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width / 2,
          height: 40,
          child: BodyText1(
            season.overview,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        SizedBox(
          height: 140,
          child: ListView.builder(
              itemCount: season.episodes.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) => EnsureVisible(
                    isFirst: index == 0,
                    isLast: index == season.episodes.length - 1,
                    child: StillCover(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) => Dialog(
                                  backgroundColor: AppColors.darkGray,
                                  child: StreamsDialog(
                                      item: season.episodes[index],
                                      season: season,
                                      show: show),
                                ));
                        // Get.defaultDialog(
                        //   content: StreamsDialog(
                        //       item: season.episodes[index],
                        //       season: season,
                        //       show: show),
                        //   title:
                        //       '${show.title} S${season.number}E${season.episodes[index].number} - ${season.episodes[index].title} - ${runtimeReadable(season.episodes[index].runtime)}',
                        //   titleStyle: Theme.of(context).textTheme.headlineSmall,
                        //   titlePadding: const EdgeInsets.symmetric(
                        //       vertical: 15, horizontal: 0),
                        //   radius: 5,
                        //   backgroundColor: AppColors.darkGray.withAlpha(240),
                        // );
                      },
                      onFocus: () {
                        ref.read(detailController.notifier).setEpisode(index);
                      },
                      imagePath: ref
                          .read(detailController.notifier)
                          .getEpisodeImage(
                              season.number, season.episodes[index].number),
                      focus: index == 0,
                    ),
                  )),
        ),
        const SizedBox(height: 20),
        season.episodes.length <= ref.read(detailController.notifier).episode
            ? const SizedBox()
            : SizedBox(
                height: 150,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CaptionText(
                          airDate(season
                              .episodes[
                                  ref.read(detailController.notifier).episode]
                              .firstAired),
                          style: TextStyle(color: AppColors.gray1),
                        ),
                        const SizedBox(width: 10),
                        season
                                    .episodes[ref
                                        .read(detailController.notifier)
                                        .episode]
                                    .watched ||
                                ref
                                    .watch(watchedProvider.notifier)
                                    .items
                                    .contains(BaseHelper.hiveKey(
                                        'show',
                                        show.ids.trakt,
                                        season.number,
                                        season
                                            .episodes[ref
                                                .read(detailController.notifier)
                                                .episode]
                                            .number))
                            ? const Watched()
                            : const SizedBox()
                      ],
                    ),
                    const SizedBox(height: 7),
                    Headline4(
                        'S${season.number}E${ref.watch(detailController.notifier).episode + 1} - ${season.episodes[ref.watch(detailController.notifier).episode].title}'),
                    const SizedBox(height: 5),
                    const SizedBox(height: 15),
                    SizedBox(
                        width: MediaQuery.of(context).size.width / 2,
                        child: CaptionText(
                          season
                              .episodes[
                                  ref.watch(detailController.notifier).episode]
                              .overview,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        )),
                  ],
                ),
              ),
      ],
    );
  }
}
