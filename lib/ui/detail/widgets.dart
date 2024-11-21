import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:helpers/helpers.dart';
import 'package:html_unescape/html_unescape_small.dart';
import 'package:odin/controllers/detail_controller.dart';
import 'package:odin/data/entities/tmdb.dart';
import 'package:odin/data/services/imdb_service.dart';
import 'package:odin/data/services/trakt_service.dart';
import 'package:odin/helpers.dart';
import 'package:odin/theme.dart';
import 'package:odin/data/entities/trakt.dart';
import 'package:odin/ui/app.dart';
import 'package:odin/ui/detail/episodes.dart';
import 'package:odin/ui/widgets/ensure_visible.dart';
import 'package:odin/ui/widgets/widgets.dart';
// import 'package:odintv/data/entities/entities.dart';
// import 'package:odintv/ui/themes/default.dart';
// import 'package:odintv/ui/widgets/widgets.dart';

String runtimeReadable(int runtime) {
  final int hrs = (runtime / 60).floor();
  final int ms = runtime % 60;
  if (hrs == 0) {
    return '$ms min';
  }
  if (ms == 0) {
    return '$hrs h';
  }
  return '$hrs h : $ms m';
}

String ratingCountToReadable(int count) {
  if (count < 1000) {
    return '$count ratings';
  } else if (count >= 1000 && count <= 1000000) {
    return '${(count / 1000).floor()}K ratings';
  } else {
    return '${(count / 1000000).floor()}M ratings';
  }
}

class Background extends StatelessWidget {
  final String background;
  final Widget child;
  final bool hideDetails;
  const Background(this.background,
      {Key? key, required this.child, this.hideDetails = false})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[const AppBackground(), child]);
  }
}

class ItemDetails extends ConsumerWidget {
  final Trakt item;
  const ItemDetails({Key? key, required this.item}) : super(key: key);
  @override
  Widget build(BuildContext context, ref) {
    final String preTitle = item.year.toString();
    final String overview = item.overview;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 200),
            ItemRating(item: item),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                CaptionText(preTitle),
                const CaptionText('  |  '),
                CaptionText(
                  runtimeReadable(item.runtime),
                ),
                const CaptionText('  |  '),
                CaptionText(
                  item.genres.map((e) => e.toCapitalize()).join(', '),
                ),
                const CaptionText('  |  '),
                CaptionText(item.language.toUpperCase()),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Headline4(
              item.network != ''
                  ? item.network
                  : item.tmdb!.productionCompanies.isNotEmpty
                      ? item.tmdb!.productionCompanies.first.name
                      : '',
              style: const TextStyle(fontSize: 7),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
              child: ref.watch(watchedProvider.notifier).items.contains(
                          BaseHelper.hiveKey(item.type, item.ids.trakt)) ||
                      item.watched
                  ? const Watched()
                  : const SizedBox(height: 15),
            ),
            Align(
                alignment: Alignment.topLeft,
                child: Headline4(item.tagline != '' ? item.tagline : '-')),
            const SizedBox(height: 5),
            SizedBox(
              width: 400,
              child: CaptionText(
                overview,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
          ],
        ),
        CachedNetworkImage(
            height: 150,
            width: 400,
            fit: BoxFit.contain,
            errorWidget: (_, __, ___) => const SizedBox(height: 30),
            placeholder: (_, __) => const SizedBox(height: 30),
            imageUrl: item.tmdb!.logoBig),
      ],
    );
  }
}

class ItemRating extends ConsumerWidget {
  final Trakt item;
  const ItemRating({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    ref.watch(imdbProvider);
    return Row(
      children: [
        Row(
          children: [
            Image.asset(
              'assets/images/tmdb.png',
              width: 25,
              height: 25,
            ),
            const SizedBox(width: 5),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Headline4(item.tmdb!.roundedRating.toString()),
                CaptionText(
                  ratingCountToReadable(item.tmdb!.voteCount),
                  style: TextStyle(color: AppColors.gray1),
                )
              ],
            ),
          ],
        ),
        const SizedBox(width: 20),
        Row(
          children: [
            Image.asset(
              'assets/images/trakt.png',
              width: 25,
              height: 25,
            ),
            const SizedBox(width: 5),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Headline4(item.roundedRating.toString()),
                CaptionText(ratingCountToReadable(item.votes),
                    style: TextStyle(color: AppColors.gray1)),
              ],
            ),
          ],
        ),
        const SizedBox(width: 20),
        Row(
          children: [
            Image.asset(
              'assets/images/imdb.png',
              width: 25,
              height: 25,
            ),
            const SizedBox(width: 5),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Headline4(
                    ref.read(imdbProvider.notifier).imdb?.rating.toString() ??
                        '-'),
                CaptionText(
                    ratingCountToReadable(
                        ref.read(imdbProvider.notifier).imdb?.votes ?? 0),
                    style: TextStyle(color: AppColors.gray1))
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class ImdbReview extends ConsumerWidget {
  const ImdbReview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    ref.watch(imdbProvider);
    return Column(
      children: [
        Row(children: [
          const Headline4('LATEST REVIEW'),
          const SizedBox(width: 10),
          Icon(
            FontAwesomeIcons.solidStar,
            size: 10,
            color: AppColors.primary,
          ),
          const SizedBox(width: 5),
          Subtitle2(
            ref.read(imdbProvider.notifier).imdb?.lastRating.toString() ?? '0',
          ),
        ]),
        const SizedBox(height: 20),
        Align(
          alignment: Alignment.topLeft,
          child: SizedBox(
            // width: Get.width * 0.6,
            child: BodyText1(
              HtmlUnescape().convert(
                  ref.read(imdbProvider.notifier).imdb?.lastComment ?? ''),
              maxLines: 13,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        EnsureVisible(
          child: RawMaterialButton(
              onPressed: () {
                print("Just here for focus");
              },
              child: const Icon(FontAwesomeIcons.heart)),
        ),
      ],
    );
  }
}

class ItemCast extends ConsumerWidget {
  final Trakt item;
  const ItemCast({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    List<TmdbCast> cast = item.tmdb!.credits.cast.take(20).toList();
    return Column(
      children: [
        const Align(
          alignment: Alignment.topLeft,
          child: Headline4("CAST & CHARACTERS"),
        ),
        const SizedBox(height: 20),
        SizedBox(
            height: 200,
            child: Row(
              children: cast
                  .getRange(0, cast.length > 6 ? 6 : cast.length)
                  .map((c) => Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: Column(
                          children: [
                            CachedNetworkImage(
                                imageUrl: c.profileSmall,
                                imageBuilder: (ctx, img) => CircleAvatar(
                                    radius: 50, backgroundImage: img),
                                errorWidget: (_, __, ___) => CircleAvatar(
                                    radius: 50,
                                    backgroundColor: AppColors.darkGray),
                                placeholder: (_, __) => CircleAvatar(
                                    radius: 50,
                                    backgroundColor: AppColors.darkGray)),
                            const SizedBox(height: 10),
                            Headline4(c.name),
                            CaptionText(
                              c.character,
                              // style: TextStyle(color: AppColors.gray1),
                            )
                          ],
                        ),
                      ))
                  .toList(),
            )
            // child: ListView.builder(
            //     scrollDirection: Axis.horizontal,
            //     itemCount: cast.length,
            //     itemBuilder: (ctx, index) => EnsureVisible(
            //           isFirst: index == 0,
            //           isLast: index == cast.length - 1,
            //           child: Focus(
            //             child: Padding(
            //               padding: const EdgeInsets.only(right: 20),
            //               child: Column(
            //                 children: [
            //                   CachedNetworkImage(
            //                       imageUrl: cast[index].profileSmall,
            //                       imageBuilder: (ctx, img) => CircleAvatar(
            //                           radius: 50, backgroundImage: img),
            //                       errorWidget: (_, __, ___) => CircleAvatar(
            //                           radius: 50,
            //                           backgroundColor: AppColors.darkGray),
            //                       placeholder: (_, __) => CircleAvatar(
            //                           radius: 50,
            //                           backgroundColor: AppColors.darkGray)),
            //                   const SizedBox(height: 10),
            //                   Headline4(cast[index].name),
            //                   CaptionText(
            //                     cast[index].character,
            //                     // style: TextStyle(color: AppColors.gray1),
            //                   )
            //                 ],
            //               ),
            //             ),
            //           ),
            //         )),
            ),
      ],
    );
  }
}

class SeasonsAndEpisodes extends ConsumerWidget {
  final Trakt item;
  const SeasonsAndEpisodes({Key? key, required this.item}) : super(key: key);

  bool isWatched(ref, List<Trakt> seasons, index) {
    return ref.watch(watchedProvider.notifier).items.contains(
            '${BaseHelper.hiveKey(item.type, item.ids.trakt, seasons[index].number)}full') ||
        seasons[index].episodeCount > 0 &&
            seasons[index].episodeCount ==
                seasons[index].episodes.where((e) => e.watched).length;
  }

  @override
  Widget build(BuildContext context, ref) {
    List<Trakt> seasons = [];
    ref.watch(seasonsProvider(item.ids)).whenData((value) {
      seasons.addAll(value);
    });

    return seasons.isEmpty
        ? const SizedBox(height: 100)
        : Column(
            children: [
              SizedBox(
                height: 40,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: seasons.length,
                    itemBuilder: (ctx, index) => EnsureVisible(
                        isFirst: index == 0,
                        isLast: index == seasons.length - 1,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: isWatched(ref, seasons, index)
                                  ? AppColors.green.withAlpha(100)
                                  : AppColors.primary.withAlpha(20),
                            ),
                            child: seasons[index].number == 0
                                ? CaptionText(seasons[index].title)
                                : CaptionText('S${seasons[index].number}'),
                            onPressed: () {
                              ref.read(selectedSeasonProvider.notifier).state =
                                  index;
                            },
                          ),
                        ))),
              ),
              Episodes(
                  season: seasons[ref.watch(selectedSeasonProvider)],
                  show: item)
            ],
          );
  }
}
