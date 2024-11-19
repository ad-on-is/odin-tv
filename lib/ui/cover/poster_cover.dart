import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:helpers/helpers/widgets/text.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:odin/controllers/app_controller.dart';
import 'package:odin/data/entities/trakt.dart';
import 'package:odin/data/services/trakt_service.dart';
import 'package:odin/helpers.dart';
import 'package:odin/theme.dart';
import 'package:odin/ui/widgets/widgets.dart';

class PosterCover extends HookConsumerWidget {
  final Trakt item;
  const PosterCover(this.item, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    useAutomaticKeepAlive();
    useSingleTickerProvider();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        Flexible(
          flex: 3,
          child: Center(
            child: CachedNetworkImage(
              imageUrl: item.tmdb!.posterSmall,
              errorWidget: (_, str, d) => Container(
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(5)),
                child: Center(
                    child: Icon(
                  FontAwesomeIcons.image,
                  color: AppColors.primary,
                  size: 30,
                )),
              ),
              imageBuilder: (context, imageProvider) => ClipRRect(
                  borderRadius: BorderRadius.circular(7),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Image(
                      image: imageProvider,
                    ),
                  )),
              placeholder: (context, url) => Container(
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(5)),
                child: Center(
                    child: Icon(
                  FontAwesomeIcons.image,
                  color: AppColors.darkGray,
                  size: 30,
                )),
              ),
              fit: BoxFit.fill,
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 5),
                CaptionText(
                  item.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          style:
                              TextStyle(color: AppColors.primary, fontSize: 8),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
