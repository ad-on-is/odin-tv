import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:odin/controllers/app_controller.dart';
import 'package:odin/controllers/home_controller.dart';
import 'package:odin/data/models/item_model.dart';
import 'package:odin/ui/focusnodes.dart';
import 'package:odin/ui/widgets/carousel.dart';
import 'package:odin/ui/widgets/section.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  toggleMenuFocus(bool focus) {
    for (var i = 0; i < menufocus.length; i++) {
      menufocus[i].canRequestFocus = focus;
    }
  }

  @override
  Widget build(BuildContext context, ref) {
    final provider = ref.watch(homeSectionProvider);

    List<SectionItem> sections = [];
    provider.whenData((value) {
      sections = value;
      if (value.isNotEmpty) {
        Future.delayed(const Duration(milliseconds: 50), () {
          ref.read(selectedSectionProvider.notifier).state = value[0].title;
          ref.read(bgAlpha.notifier).state = 50;
        });
      }
    });

    double extent = 185;
    return sections.isEmpty
        ? SizedBox(height: extent)
        : Container(
            padding: const EdgeInsets.only(top: 200),
            height: extent * sections.length,
            child: OdinCarousel(
                itemBuilder: (context, itemIndex, realIndex, controller) {
                  return Section(e: sections[itemIndex], idx: itemIndex);
                },
                extent: extent,
                // ensureFocus: true,
                keys: const [
                  PhysicalKeyboardKey.arrowUp,
                  PhysicalKeyboardKey.arrowDown
                ],
                // ensureFocus: true,
                onIndexChanged: (index) {
                  Future.delayed(const Duration(milliseconds: 100), () {
                    if (index > sections.length - 1) {
                      return;
                    }
                    ref.read(selectedSectionProvider.notifier).state =
                        sections[index].title;

                    ref.read(selectedItemProvider.notifier).state = ref.read(
                        selectedItemOfSectionProvider(sections[index].title));
                  });
                },
                anchor: 0.0,
                count: sections.length,
                axis: Axis.vertical));
  }
}
