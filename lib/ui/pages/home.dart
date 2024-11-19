import 'dart:ffi';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
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
    });

    return sections.isEmpty
        ? const SizedBox(
            height: 235,
          )
        : SizedBox(
            height: 235 * (sections.length - 2) * 1.0,
            child: OdinCarousel(
              key: const Key("home"),
              itemBuilder: (context, itemIndex, realIndex, controller) {
                return SizedBox(
                    height: 235, child: Section(e: sections[itemIndex]));
              },
              extent: 235,
              onIndexChanged: (index) => {print(index)},
              count: sections.length,
              axis: Axis.vertical,
              keys: const [
                PhysicalKeyboardKey.arrowDown,
                PhysicalKeyboardKey.arrowUp
              ],
            ),
          );
  }
}
