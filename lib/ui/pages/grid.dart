import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
      // if (value.isNotEmpty) {
      //   Future.delayed(const Duration(milliseconds: 50), () {
      //     ref.read(bgAlpha.notifier).state = 230;
      //     ref.read(selectedSectionProvider.notifier).state = value[0].title;
      //   });
      // }
    });

    double extent = 185;

    return sections.isEmpty
        ? const SizedBox()
        : Padding(
            padding: const EdgeInsets.only(top: 150),
            child: OdinCarousel(
                itemBuilder: (context, itemIndex, realIndex, controller) {
                  return Section(e: sections[itemIndex], idx: itemIndex);
                },
                extent: extent,
                onRowIndexChanged: (index) {
                  // Future.delayed(const Duration(milliseconds: 50), () {
                  //   ref.read(selectedSectionProvider.notifier).state =
                  //       sections[index].title;
                  //   ref.read(currentRow.notifier).state = sections[index].url;
                  //   ref.read(selectedItemProvider.notifier).state = ref.read(
                  //       selectedItemOfSectionProvider(sections[index].title));
                  // });
                },
                onChildIndexChanged: (index) {
                  // Future.delayed(const Duration(milliseconds: 50), () {
                  //   ref.read(selectedSectionProvider.notifier).state =
                  //       sections[index].title;
                  //   ref.read(currentRow.notifier).state = sections[index].url;
                  //   ref.read(selectedItemProvider.notifier).state = ref.read(
                  //       selectedItemOfSectionProvider(sections[index].title));
                  // });
                },
                keys: const [
                  PhysicalKeyboardKey.arrowUp,
                  PhysicalKeyboardKey.arrowDown
                ],
                anchor: 0.0,
                count: sections.length,
                axis: Axis.vertical));
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
