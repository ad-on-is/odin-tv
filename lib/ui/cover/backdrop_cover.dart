import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:helpers/helpers.dart';
import 'package:helpers/helpers/widgets/text.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:odin/data/entities/trakt.dart';
import 'package:odin/data/services/trakt_service.dart';
import 'package:odin/helpers.dart';
import 'package:odin/theme.dart';
import 'package:odin/ui/widgets/widgets.dart';

class BackdropCover extends HookConsumerWidget {
  final Trakt item;

  const BackdropCover(this.item, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    useAutomaticKeepAlive();
    useSingleTickerProvider();
    return Stack(
      alignment: Alignment.topLeft,
      children: [
        CachedNetworkImage(
          imageUrl: item.tmdb!.backdropSmall,
          errorWidget: (_, __, ___) => Container(
            decoration: BoxDecoration(
                color: Colors.black, borderRadius: BorderRadius.circular(5)),
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
                      offset: const Offset(10, 15))
                ],
              ),
              // padding: const EdgeInsets.all(2),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image(
                  image: imageProvider,
                ),
              )),
          placeholder: (_, __) => Container(
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
          height: 127,
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
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 95),
              Headline4(
                item.title,
                maxLines: 1,
                style: const TextStyle(fontSize: 8),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 5),
              item.episode != null
                  ? CaptionText(
                      'S${item.episode!.season}E${item.episode!.number} - ${item.episode!.title}',
                      style: TextStyle(
                          color: AppColors.gray1,
                          overflow: TextOverflow.ellipsis),
                    )
                  : Row(
                      children: [
                        Subtitle1(item.year.toString(),
                            style: TextStyle(
                                color: AppColors.gray1,
                                fontSize: 8,
                                fontWeight: FontWeight.w600)),
                        const SizedBox(width: 12),
                        Row(
                          children: [
                            Icon(
                              FontAwesomeIcons.solidStar,
                              size: 8,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 5),
                            Subtitle1(
                              item.roundedRating.toString(),
                              style: TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 8,
                                  fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(width: 135),
                            ref.watch(watchedProvider.notifier).items.contains(
                                        BaseHelper.hiveKey(
                                            item.type, item.ids.trakt)) ||
                                    item.watched
                                ? const Watched(
                                    iconOnly: true,
                                  )
                                : const SizedBox()
                          ],
                        ),
                      ],
                    )
            ],
          ),
        ),
      ],
    );
  }
}
