import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:helpers/helpers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:odin/controllers/app_controller.dart';
import 'package:odin/data/models/item_model.dart';
import 'package:odin/theme.dart';
import 'package:odin/ui/cover/animated.dart';
import 'package:odin/ui/cover/backdrop_cover.dart';
import 'package:odin/ui/cover/poster_cover.dart';
import 'package:odin/ui/detail/detail.dart';
import 'package:odin/ui/widgets/carousel.dart';
import 'package:odin/ui/widgets/ensure_visible.dart';

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
    final genre = ref.watch(genreProvider(e.type ?? ""));
    if (e.title == 'GENRE') {
      e.title = "GENRE: ${genres[genre]["name"]}";
      e.url = '/${e.type}/watched/monthly?genres=${genres[genre]["slug"]}';
    }
    List<Trakt> items = ref.watch(itemsProvider(e.url));

    if (e.filterWatched) {
      items = items.where((element) => element.watched == false).toList();
    }

    if (items.isNotEmpty) {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (ref.read(selectedItemOfSectionProvider(e.title)).title == "") {
          ref.read(selectedItemOfSectionProvider(e.title).notifier).state =
              items[0];
        }
      });
    }
    double extent = e.big ? 225 : 90;
    final sec = ref.watch(selectedSectionProvider);
    final af = ref.watch(afterFocusProvider);
    final bf = ref.watch(beforeFocusProvider);
    return EnsureVisible(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              alignment: Alignment.topLeft,
              child: Headline4(
                e.title.toCapitalize(),
                textAlign: TextAlign.left,
                style: TextStyle(color: AppColors.gray1, fontSize: 10),
              )),
          const SizedBox(height: 5),
          items.isEmpty
              ? Container(
                  height: e.big ? 145 : 150,
                  padding: const EdgeInsets.all(20),
                  alignment: Alignment.topLeft,
                  child: CaptionText(
                    'Getting items...',
                    style: TextStyle(color: AppColors.gray2),
                  ),
                )
              : SizedBox(
                  height: e.big ? 145 : 150,
                  // width: double.infinity,
                  child: OdinCarousel(
                      itemBuilder: (context, itemIndex, realIndex, controller) {
                        return AnimatedCover(
                          controller: controller,
                          extent: extent,
                          realIndex: realIndex,
                          target: sec == e.title,
                          child: e.big
                              ? BackdropCover(items[itemIndex])
                              : PosterCover(items[itemIndex]),
                        );
                      },
                      extent: extent,
                      onIndexChanged: (index) {
                        Future.delayed(const Duration(milliseconds: 10), () {
                          ref.read(selectedItemProvider.notifier).state =
                              items[index].show ?? items[index];
                          ref
                              .read(selectedItemOfSectionProvider(e.title)
                                  .notifier)
                              .state = items[index];
                          if (index == items.length - 1 && e.paginate) {
                            ref.read(itemsProvider(e.url).notifier).next(e.url);
                          }
                        });
                      },
                      onEnter: () {
                        final item = ref.read(selectedItemProvider);
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => Detail(item: item),
                        ));
                      },
                      keys: const [
                        PhysicalKeyboardKey.arrowLeft,
                        PhysicalKeyboardKey.arrowRight
                      ],
                      count: items.length,
                      autofocus: false,
                      axis: Axis.horizontal),
                )
        ],
      ),
    );
  }
}
