import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:helpers/helpers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:odin/controllers/app_controller.dart';
import 'package:odin/data/models/item_model.dart';
import 'package:odin/helpers.dart';
import 'package:odin/theme.dart';
import 'package:odin/ui/cover/animated.dart';
import 'package:odin/ui/cover/backdrop_cover.dart';
import 'package:odin/ui/cover/poster_cover.dart';
import 'package:odin/ui/detail/detail.dart';
import 'package:odin/ui/widgets/carousel.dart';

import '../../data/entities/trakt.dart';

class Section extends HookConsumerWidget with BaseHelper {
  final int idx;
  final SectionItem e;
  final Function? lastItemReached;
  const Section(
      {Key? key, required this.e, this.idx = -1, this.lastItemReached})
      : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final itemData =
        useMemoized(() => ItemsProviderData(e.url, e.filterWatched));
    List<Trakt> items = ref.watch(itemsProvider(itemData));

    double extent = e.big ? 225 : 90;
    //ref.watch(selectedItemProvider);
    final sec = ref.watch(currentRow);
    // final af = ref.watch(afterFocusProvider);
    // final bf = ref.watch(beforeFocusProvider);
    return Column(
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
            ? SizedBox(
                height: 160,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: CaptionText(
                    'Getting items...',
                    style: TextStyle(color: AppColors.gray2),
                  ),
                ),
              )
            : SizedBox(
                height: 160,
                // width: double.infinity,
                child: OdinCarousel(
                    itemBuilder: (context, itemIndex, realIndex, controller) {
                      return AnimatedCover(
                        controller: controller,
                        extent: extent,
                        realIndex: realIndex,
                        target: sec == e.url && !ref.watch(beforeFocusHasFocus),
                        child: e.big
                            ? BackdropCover(items[itemIndex])
                            : PosterCover(items[itemIndex]),
                      );
                    },
                    extent: extent,
                    id: e.url,
                    ensureVisible: true,
                    alignment: e.big ? 0.16 : 0.10,
                    onRowIndexChanged: (index) {},
                    onChildIndexChanged: (index) {
                      Future.delayed(const Duration(milliseconds: 10), () {
                        final items = ref.read(itemsProvider(itemData));
                        ref.read(selectedItemProvider.notifier).state =
                            items[index].show ?? items[index];
                        // ref
                        //     .read(
                        //         selectedItemOfSectionProvider(e.title).notifier)
                        //     .state = items[index];
                        if (items.isNotEmpty &&
                            index == items.length - 1 &&
                            e.paginate) {
                          ref.read(itemsProvider(itemData).notifier).next();
                          // ref.read(pageProvider(e.url).notifier).state++;
                        }
                      });
                    },
                    onEnter: (idx) async {
                      final items = ref.read(itemsProvider(itemData));
                      Future.delayed(const Duration(milliseconds: 50), () {
                        ref.read(currentRowBeforeDetail.notifier).state =
                            ref.read(currentRow);
                      });
                      await Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => Detail(
                            item: items[idx].type == "episode"
                                ? items[idx].show!
                                : items[idx]),
                      ));
                      //
                      Future.delayed(const Duration(milliseconds: 50), () {
                        ref.read(currentRow.notifier).state =
                            ref.read(currentRowBeforeDetail);
                      });
                    },
                    count: items.length,
                    axis: Axis.horizontal),
              )
      ],
    );
  }
}
