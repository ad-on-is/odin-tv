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
    return Stack(children: <Widget>[
      CachedNetworkImage(
        imageUrl: background,
        fit: BoxFit.fill,
        errorWidget: (_, __, ___) => Container(color: AppColors.darkGray),
        placeholder: (_, __) => Container(color: AppColors.darkGray),
      ),
      Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                colors: [
              AppColors.darkGray,
              AppColors.darkGray.withAlpha(200),
              AppColors.darkGray.withAlpha(100),
              AppColors.darkGray.withAlpha(0),
            ])),
      ),
      child
    ]);
  }
}

class ItemDetails extends ConsumerWidget {
  final Trakt item;
  const ItemDetails({Key? key, required this.item}) : super(key: key);
  @override
  Widget build(BuildContext context, ref) {
    final String preTitle = item.year.toString();
    final String overview = item.overview;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        CaptionText(item.network != ''
            ? item.network
            : item.tmdb!.productionCompanies.isNotEmpty
                ? item.tmdb!.productionCompanies.first.name
                : ''),
        // CachedNetworkImage(
        //     height: 30,
        //     errorWidget: (_, __, ___) => const SizedBox(height: 50),
        //     placeholder: (_, __) => const SizedBox(height: 50),
        //     imageUrl: item.tmdb!.smallPath +
        //         item.tmdb!.productionCompanies.first.logoPath),
        Headline1(item.title),
        Row(
          children: [
            Headline3(preTitle),
            const Headline3('  |  '),
            Headline4(
              runtimeReadable(item.runtime),
            ),
            const Headline3('  |  '),
            Headline4(
              item.genres.map((e) => e.toCapitalize()).join(', '),
            ),
            const Headline3('  |  '),
            Headline4(item.language.toUpperCase()),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
          child: ref.watch(watchedProvider.notifier).items.contains(
                      BaseHelper.hiveKey(item.type, item.ids.trakt)) ||
                  item.watched
              ? const Watched()
              : const SizedBox(),
        ),
        const SizedBox(
          height: 20,
        ),
        Column(
          children: [
            ItemRating(item: item),
            const SizedBox(
              height: 20,
            ),
            Align(
                alignment: Alignment.topLeft,
                child: Headline3(item.tagline != '' ? item.tagline : '-')),
            const SizedBox(height: 5),
            Container(
              height: 60,
              padding: const EdgeInsets.only(right: 350),
              child: Align(
                alignment: Alignment.topLeft,
                child: BodyText1(
                  overview,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 15,
        ),
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
        )
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
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: cast.length,
              itemBuilder: (ctx, index) => EnsureVisible(
                    isFirst: index == 0,
                    isLast: index == cast.length - 1,
                    child: Focus(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: Column(
                          children: [
                            CachedNetworkImage(
                                imageUrl: cast[index].profileSmall,
                                imageBuilder: (ctx, img) => CircleAvatar(
                                    radius: 50, backgroundImage: img),
                                errorWidget: (_, __, ___) => CircleAvatar(
                                    radius: 50,
                                    backgroundColor: AppColors.darkGray),
                                placeholder: (_, __) => CircleAvatar(
                                    radius: 50,
                                    backgroundColor: AppColors.darkGray)),
                            const SizedBox(height: 10),
                            Headline4(cast[index].name),
                            CaptionText(
                              cast[index].character,
                              // style: TextStyle(color: AppColors.gray1),
                            )
                          ],
                        ),
                      ),
                    ),
                  )),
        ),
      ],
    );
  }
}

class SeasonsAndEpisodes extends ConsumerWidget {
  final Trakt item;
  const SeasonsAndEpisodes({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    ref.watch(detailController);
    List<Trakt> seasons = ref.read(detailController.notifier).seasons;
    return seasons.isEmpty
        ? const SizedBox()
        : Column(
            children: [
              const Align(
                alignment: Alignment.topLeft,
                child: Headline4("SEASONS & EPISODES"),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 50,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: seasons.length,
                    itemBuilder: (ctx, index) => EnsureVisible(
                        isFirst: index == 0,
                        isLast: index == seasons.length - 1,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: TextButton(
                            child: Row(children: [
                              CaptionText('Season ${seasons[index].number}'),
                              ref.watch(watchedProvider.notifier).items.contains(
                                          '${BaseHelper.hiveKey(item.type, item.ids.trakt, seasons[index].number)}full') ||
                                      seasons[index].episodeCount > 0 &&
                                          seasons[index].episodeCount ==
                                              seasons[index]
                                                  .episodes
                                                  .where((e) => e.watched)
                                                  .length
                                  ? const Padding(
                                      padding: EdgeInsets.only(left: 5),
                                      child: Watched(iconOnly: true))
                                  : const SizedBox()
                            ]),
                            onPressed: () {
                              ref
                                  .read(detailController.notifier)
                                  .setSeason(index);
                            },
                          ),
                        ))),
              ),
              Episodes(
                  season: seasons[ref.watch(detailController.notifier).season],
                  show: item)
            ],
          );
  }
}
