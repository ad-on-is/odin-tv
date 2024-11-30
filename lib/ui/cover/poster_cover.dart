import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:helpers/helpers/widgets/text.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:odin/controllers/app_controller.dart';
import 'package:odin/data/entities/trakt.dart';
import 'package:odin/data/services/trakt_service.dart';
import 'package:odin/helpers.dart';
import 'package:odin/theme.dart';
import 'package:odin/ui/detail/detail.dart';
import 'package:odin/ui/widgets/widgets.dart';

class PosterCover extends HookConsumerWidget {
  final Trakt item;
  const PosterCover(this.item, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    useAutomaticKeepAlive();
    useSingleTickerProvider();
    return GestureDetector(
      onTap: () {
        ref.read(selectedItemProvider.notifier).state = item;
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => Detail(item: item),
        ));
      },
      child: Stack(
        children: [
          CachedNetworkImage(
            imageUrl: item.tmdb!.posterSmall,
            errorWidget: (_, str, d) => Container(
              width: 100,
              height: 135,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Icon(
                FontAwesomeIcons.image,
                color: AppColors.primary,
                size: 30,
              ),
            ),
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
            placeholder: (context, url) => Container(
              decoration: BoxDecoration(
                  color: Colors.black, borderRadius: BorderRadius.circular(5)),
              child: Icon(
                FontAwesomeIcons.image,
                color: AppColors.darkGray,
                size: 30,
              ),
            ),
            fit: BoxFit.fill,
          ),
          Container(
            height: 136,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7),
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      AppColors.darkGray.withAlpha(50),
                      AppColors.darkGray.withAlpha(230),

                      // AppColors.darkGray.withAlpha(250),
                    ])),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 118),
                // Headline4(
                //   item.title,
                //   maxLines: 1,
                //   overflow: TextOverflow.ellipsis,
                //   style: const TextStyle(fontSize: 6),
                // ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Subtitle1(
                      item.year.toString(),
                      style: TextStyle(color: AppColors.gray1, fontSize: 8),
                    ),
                    ref.watch(watchedProvider.notifier).items.contains(
                                BaseHelper.hiveKey(
                                    item.type, item.ids.trakt)) ||
                            item.watched
                        ? const Watched(
                            iconOnly: true,
                          )
                        : const SizedBox(),
                    Row(
                      children: [
                        Icon(
                          FontAwesomeIcons.solidStar,
                          size: 7,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 5),
                        Subtitle2(
                          item.roundedRating.toString(),
                          style: TextStyle(fontSize: 8),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
