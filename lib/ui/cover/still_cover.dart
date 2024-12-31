import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:helpers/helpers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:odin/data/entities/trakt.dart';
import 'package:odin/data/services/trakt_service.dart';
import 'package:odin/helpers.dart';
import 'package:odin/theme.dart';
import 'package:odin/ui/widgets/widgets.dart';

class StillCover extends HookConsumerWidget {
  final Trakt? item;
  final Trakt? season;
  final Trakt? show;
  final Function? onPressed;
  final Function? onFocus;
  final bool? focus;
  const StillCover(
      {Key? key,
      this.item,
      this.season,
      this.onPressed,
      this.show,
      this.onFocus,
      this.focus})
      : super(key: key);

  String airDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}";
  }

  bool isWatched(ref, Trakt item, Trakt season, Trakt show) {
    return item.watched ||
        ref.watch(watchedProvider.notifier).items.contains(BaseHelper.hiveKey(
            'show', show.ids.trakt, season.number, item.number));
  }

  @override
  Widget build(BuildContext context, ref) {
    return GestureDetector(
      onTap: () {
        onPressed!();
      },
      child: Stack(
        children: [
          CachedNetworkImage(
            imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withAlpha(180),
                        blurRadius: 10,
                        spreadRadius: -10,
                        offset: const Offset(5, 15))
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(7),
                  child: Image(
                    image: imageProvider,
                  ),
                )),
            imageUrl: item?.tmdb?.stillSmall ?? '',
            errorWidget: (_, __, ___) => Container(
              height: 105,
              width: 185,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7),
                color: AppColors.darkGray,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withAlpha(180),
                      blurRadius: 10,
                      spreadRadius: -10,
                      offset: const Offset(5, 15))
                ],
              ),
              child: Icon(
                FontAwesomeIcons.image,
                color: AppColors.darkGray,
                size: 30,
              ),
            ),
            placeholder: (_, __) => Container(
              height: 105,
              width: 185,
              decoration: BoxDecoration(
                color: AppColors.darkGray,
                borderRadius: BorderRadius.circular(7),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withAlpha(180),
                      blurRadius: 10,
                      spreadRadius: -10,
                      offset: const Offset(5, 15))
                ],
              ),
              child: Icon(
                FontAwesomeIcons.image,
                color: AppColors.darkGray,
                size: 30,
              ),
            ),
            fit: BoxFit.fill,
          ),
          Container(
            height: 105,
            width: 185,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7),
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      AppColors.darkGray.withAlpha(50),
                      AppColors.darkGray.withAlpha(200),
                      AppColors.darkGray.withAlpha(250),

                      // AppColors.darkGray.withAlpha(250),
                    ])),
          ),
          Container(
            height: 105,
            width: 185,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Headline4('S${season?.number}E${item?.number}',
                        style: TextStyle(
                            fontSize: 8,
                            color: AppColors.gray1.withOpacity(0.5))),
                    isWatched(ref, item!, season!, show!)
                        ? const Watched(iconOnly: true)
                        : const SizedBox(),
                    CaptionText(
                      item!.firstAired.isAfter(DateTime.now())
                          ? 'in ${item!.firstAired.difference(DateTime.now()).inDays} days'
                          : airDate(item!.firstAired),
                      style: TextStyle(fontSize: 6, color: AppColors.gray1),
                    ),
                  ],
                ),
                CaptionText(
                  item?.title ?? '',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: const TextStyle(fontSize: 9),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
