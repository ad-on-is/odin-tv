import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:helpers/helpers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:odin/data/entities/trakt.dart';
import 'package:odin/theme.dart';

class StillCover extends HookConsumerWidget {
  final Trakt? item;
  final Trakt? season;
  final Function? onPressed;
  final Function? onFocus;
  final bool? focus;
  const StillCover(
      {Key? key,
      this.item,
      this.season,
      this.onPressed,
      this.onFocus,
      this.focus})
      : super(key: key);

  String airDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}";
  }

  @override
  Widget build(BuildContext context, ref) {
    final node = useFocusNode();

    return Focus(
      focusNode: node,
      child: GestureDetector(
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
                        AppColors.darkGray.withAlpha(230),

                        // AppColors.darkGray.withAlpha(250),
                      ])),
            ),
            Container(
              height: 105,
              width: 185,
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Headline4('S${season?.number}E${item?.number}',
                          style: const TextStyle(fontSize: 8)),
                      CaptionText(
                        item!.firstAired.isAfter(DateTime.now())
                            ? 'in ${item!.firstAired.difference(DateTime.now()).inDays} days'
                            : airDate(item!.firstAired),
                        style: const TextStyle(fontSize: 8),
                      ),
                    ],
                  ),
                  CaptionText(
                    item?.title ?? '',
                    style: const TextStyle(fontSize: 8),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
