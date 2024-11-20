import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:helpers/helpers/widgets/text.dart';
import 'package:odin/controllers/app_controller.dart';
import 'package:odin/controllers/grid_controller.dart';
import 'package:odin/data/models/item_model.dart';
import 'package:odin/ui/widgets/carousel.dart';
import 'package:odin/ui/widgets/section.dart';
// import 'package:odintv/ui/cover/poster_cover.dart';

class Grid extends ConsumerWidget {
  final String type;
  const Grid(this.type, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, ref) {
    final provider = ref.watch(gridSectionProvider(type));

    List<SectionItem> sections = [];
    provider.whenData((value) {
      sections = value;
      if (value.isNotEmpty) {
        Future.delayed(const Duration(milliseconds: 50), () {
          ref.read(selectedSectionProvider.notifier).state = value[0].title;
        });
      }
    });

    double extent = 235;

    return sections.isEmpty
        ? const SizedBox()
        : SizedBox(
            height: extent * sections.length,
            child: OdinCarousel(
                itemBuilder: (context, itemIndex, realIndex, controller) {
                  return SizedBox(
                      height: 100, child: Section(e: sections[itemIndex]));
                },
                extent: extent,
                onIndexChanged: (index) {
                  Future.delayed(const Duration(milliseconds: 100), () {
                    ref.read(selectedSectionProvider.notifier).state =
                        sections[index].title;
                    ref.read(selectedItemProvider.notifier).state = ref.read(
                        selectedItemOfSectionProvider(sections[index].title));
                  });
                },
                keys: const [
                  PhysicalKeyboardKey.arrowUp,
                  PhysicalKeyboardKey.arrowDown
                ],
                count: sections.length,
                axis: Axis.vertical));

    // return SingleChildScrollView(
    //   child: Column(
    //     children: [
    //       Column(
    //           children: sections
    //               .map((SectionItem e) => Section(
    //                     e: e,
    //                     lastItemReached: () {
    //                       // controller.nextPage(e.url);
    //                     },
    //                   ))
    //               .toList()),
    //       // SizedBox(
    //       //   height: 50,
    //       //   child: ListView.builder(
    //       //       scrollDirection: Axis.horizontal,
    //       //       itemCount: genres.length,
    //       //       itemBuilder: (ctx, index) => EnsureVisible(
    //       //           isFirst: index == 0,
    //       //           isLast: index == genres.length - 1,
    //       //           child: Padding(
    //       //             padding: const EdgeInsets.only(right: 10),
    //       //             child: TextButton(
    //       //               child: CaptionText(genres[index]["name"]!),
    //       //               onPressed: () {
    //       //                 ref.read(genreProvider(type).notifier).state = index;
    //       //               },
    //       //             ),
    //       //           ))),
    //       // ),
    //       const SizedBox(height: 20),
    //       // Consumer(builder: (ctx, ref, _) {
    //       //   final genre = ref.watch(genreProvider(type));
    //       //   return Section(
    //       //       e: SectionItem(
    //       //           title: 'GENRE: ${genres[genre]["name"]!.toUpperCase()}',
    //       //           url:
    //       //               '/$type/watched/monthly?genres=${genres[genre]["slug"]}'));
    //       // })
    //     ],
    //   ),
    // );
  }
}

// need two separate classes for fadethrough-animation to work propperly

class MoviesGrid extends StatelessWidget {
  const MoviesGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Grid('movies');
  }
}

class ShowsGrid extends StatelessWidget {
  const ShowsGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Grid('shows');
  }
}
