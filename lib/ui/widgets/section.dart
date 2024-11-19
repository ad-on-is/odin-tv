import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:helpers/helpers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:odin/controllers/app_controller.dart';
import 'package:odin/data/models/item_model.dart';
import 'package:odin/theme.dart';
import 'package:odin/ui/cover/backdrop_cover.dart';
import 'package:odin/ui/cover/poster_cover.dart';
import 'package:odin/ui/detail/detail.dart';
import 'package:odin/ui/widgets/carousel.dart';

import '../../data/entities/trakt.dart';

class Section extends HookConsumerWidget {
  final SectionItem e;
  final Function? lastItemReached;
  const Section({Key? key, required this.e, this.lastItemReached})
      : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    if (ref.watch(itemsProvider(e.url).notifier).page == 0) {
      ref.watch(itemsProvider(e.url).notifier).init(e.url);
    }
    List<Trakt> items = ref.watch(itemsProvider(e.url));

    if (e.filterWatched) {
      items = items.where((element) => element.watched == false).toList();
    }
    double extent = e.big ? 220 : 90;

    return Column(
      children: [
        const SizedBox(height: 20),
        Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
            // margin: const EdgeInsets.only(bottom: 40),
            alignment: Alignment.topLeft,
            child: Headline4(
              e.title,
              textAlign: TextAlign.left,
            )),
        const SizedBox(height: 15),
        items.isEmpty
            ? Container(
                height: extent,
                padding: const EdgeInsets.all(20),
                alignment: Alignment.topLeft,
                child: CaptionText(
                  'Getting items...',
                  style: TextStyle(color: AppColors.gray2),
                ),
              )
            : Container(
                transform: Matrix4.translationValues(0, -10, 0),
                height: 180,
                width: double.infinity,
                child: OdinCarousel(
                    key: Key(e.title),
                    itemBuilder: (context, itemIndex, realIndex, controller) {
                      final currentOffset = extent * realIndex;
                      const maxScale = 1;
                      const fallOff = 0.2;
                      const minScale = 0.85;
                      return AnimatedBuilder(
                        animation: controller,
                        builder: (context, child) {
                          final diff = (controller.offset - currentOffset);

                          final carouselRatio = extent / fallOff;
                          double s = (maxScale - (diff / carouselRatio).abs());

                          double f = s;
                          double b = s;
                          if (s < minScale) {
                            s = minScale;
                          }

                          if (f < 0.3) {
                            f = 0.3;
                          }

                          if (b < 0.2) {
                            b = 0.2;
                          }

                          return child!
                              .animate()
                              .blurXY(end: 0, begin: 5)
                              .fade(end: f)
                              .blurXY(end: 1.3 - (1.3 * b))
                              // .flipH(end: 1.5 - (1.5 * s))
                              .scaleXY(end: s, curve: Curves.easeInOutExpo);
                        },
                        child: PosterCover(items[itemIndex]),
                      );
                    },
                    extent: 90,
                    onIndexChanged: (index) {
                      // ref.read(selectedItemProvider.notifier).state =
                      //     items[index];
                    },
                    onEnter: () {
                      final item = ref.read(selectedItemProvider);
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => Detail(
                                item: item.show != null ? item.show! : item,
                              )));
                    },
                    keys: const [
                      PhysicalKeyboardKey.arrowRight,
                      PhysicalKeyboardKey.arrowLeft
                    ],
                    count: items.length,
                    axis: Axis.horizontal),
              )
      ],
    );
  }
}
