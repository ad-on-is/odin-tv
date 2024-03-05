import 'package:flutter/material.dart';
import 'package:helpers/helpers.dart';
import 'package:helpers/helpers/widgets/text.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:odin/data/models/item_model.dart';
import 'package:odin/theme.dart';
import 'package:odin/ui/cover/backdrop_cover.dart';
import 'package:odin/ui/cover/poster_cover.dart';

import '../../data/entities/trakt.dart';
import 'ensure_visible.dart';

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

    return Column(
      children: [
        Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
            // margin: const EdgeInsets.only(bottom: 40),
            alignment: Alignment.topLeft,
            child: Headline4(e.title.toUpperCase(), textAlign: TextAlign.left)),
        items.isEmpty
            ? Container(
                height: e.big ? 340 : 210,
                padding: const EdgeInsets.all(20),
                alignment: Alignment.topLeft,
                child: CaptionText(
                  'Getting items...',
                  style: TextStyle(color: AppColors.gray2),
                ),
              )
            : Container(
                transform: Matrix4.translationValues(0, -10, 0),
                height: 210,
                child: ListView.builder(
                  shrinkWrap: false,
                  addAutomaticKeepAlives: false,
                  cacheExtent: e.big ? 230 : 100,
                  itemCount: items.length,
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemExtent: e.big ? 230 : 100,
                  itemBuilder: (ctx, index) => EnsureVisible(
                      onFocus: () {
                        if (index == items.length - 10 && e.paginate) {
                          ref.read(itemsProvider(e.url).notifier).next(e.url);
                        }
                      },
                      isFirst: index == 0,
                      isLast: index == items.length - 1,
                      child: e.big
                          ? BackdropCover(
                              items[index],
                              autoFocus: index == 0,
                            )
                          : PosterCover(items[index])),
                ),
              )
      ],
    );
  }
}
