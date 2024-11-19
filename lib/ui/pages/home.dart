import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:infinite_carousel/infinite_carousel.dart';
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
      for (var i = 0; i < sections.length; i++) {
        sections[i].big = false;
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
                extent: 235,
                keys: const [
                  PhysicalKeyboardKey.arrowUp,
                  PhysicalKeyboardKey.arrowDown
                ],
                count: sections.length,
                axis: Axis.vertical));

    // final dur = useState(300);
    // final dir = useState("");
    // final controller = useState(InfiniteScrollController());
    // final fn = useFocusNode();
    // return SizedBox(
    //   height: extent * sections.length,
    //   child: KeyboardListener(
    //       focusNode: fn,
    //       includeSemantics: true,
    //       onKeyEvent: (KeyEvent keyEvent) {
    //         if (![PhysicalKeyboardKey.arrowDown, PhysicalKeyboardKey.arrowUp]
    //             .contains(keyEvent.physicalKey)) {
    //           return;
    //         }
    //         if (keyEvent is KeyUpEvent) {
    //           return;
    //         }

    //         if (controller.value.offset <= extent) {
    //           toggleMenuFocus(true);
    //         } else {
    //           toggleMenuFocus(false);
    //         }

    //         if (keyEvent.physicalKey == PhysicalKeyboardKey.arrowUp) {
    //           if (dir.value != "prev") {
    //             dur.value = 300;
    //             dir.value = "prev";
    //           }
    //           print(controller.value.offset);

    //           if (controller.value.offset <= extent) {
    //             return;
    //           }

    //           controller.value.previousItem(
    //               duration: Duration(milliseconds: dur.value),
    //               curve: Curves.linearToEaseOut);
    //         }
    //         if (keyEvent.physicalKey == PhysicalKeyboardKey.arrowDown) {
    //           if (dir.value != "next") {
    //             dur.value = 300;
    //             dir.value = "next";
    //           }

    //           if (controller.value.offset >= (sections.length - 1) * extent) {
    //             return;
    //           }

    //           controller.value.nextItem(
    //               duration: Duration(milliseconds: dur.value),
    //               curve: Curves.linearToEaseOut);
    //         }
    //       },
    //       child: sections.isEmpty
    //           ? Container()
    //           : InfiniteCarousel.builder(
    //               itemCount: sections.length,
    //               itemExtent: extent,
    //               center: false,
    //               anchor: 0,
    //               velocityFactor: 0.2,
    //               onIndexChanged: (index) {
    //                 print(index);
    //                 // ref.read(selectedSectionProvider.notifier).state =
    //                 //     sections[index].title;
    //               },
    //               controller: controller.value,
    //               axisDirection: Axis.vertical,
    //               loop: false,
    //               scrollBehavior: ScrollConfiguration.of(context).copyWith(
    //                 dragDevices: {
    //                   // Allows to swipe in web browsers
    //                   PointerDeviceKind.touch,
    //                   PointerDeviceKind.mouse
    //                 },
    //               ),
    //               itemBuilder: (context, itemIndex, realIndex) {
    //                 return SizedBox(
    //                     height: 100, child: Section(e: sections[itemIndex]));
    //               },
    //             )),
    // );
  }
}
