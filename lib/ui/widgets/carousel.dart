import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:infinite_carousel/infinite_carousel.dart';
import 'package:odin/ui/focusnodes.dart';

class OdinCarousel extends HookConsumerWidget {
  const OdinCarousel(
      {Key? key,
      required this.itemBuilder,
      this.onIndexChanged,
      this.onEnter,
      required this.extent,
      required this.keys,
      required this.count,
      required this.axis})
      : super(key: key);
  final Widget Function(BuildContext context, int itemIndex, int realIndex,
      InfiniteScrollController controller) itemBuilder;
  final void Function(int)? onIndexChanged;
  final void Function()? onEnter;
  final double extent;
  final int count;
  final Axis axis;
  final List<PhysicalKeyboardKey> keys;

  toggleMenuFocus(bool focus) {
    for (var i = 0; i < menufocus.length; i++) {
      menufocus[i].canRequestFocus = focus;
    }
  }

  @override
  Widget build(BuildContext context, ref) {
    final dur = useState(300);
    final dir = useState("");
    final controller = useState(InfiniteScrollController());
    final fn = useFocusNode();
    bool holding = false;

    return KeyboardListener(
        focusNode: fn,
        includeSemantics: true,
        onKeyEvent: (KeyEvent keyEvent) {
          if (keyEvent is KeyUpEvent) {
            dur.value = 300;
            holding = false;
            return;
          }

          if (![...keys, PhysicalKeyboardKey.enter]
              .contains(keyEvent.physicalKey)) {
            return;
          }
          if (keyEvent.physicalKey == PhysicalKeyboardKey.enter) {
            if (onEnter != null) {
              onEnter!();
            }
            return;
          }

          if (controller.value.offset <= extent) {
            toggleMenuFocus(true);
          } else {
            toggleMenuFocus(false);
          }

          holding = true;

          if (keyEvent.physicalKey == keys[0]) {
            if (dir.value != "prev") {
              dur.value = 300;
              dir.value = "prev";
            }
            // print(controller.value.offset);

            if (controller.value.offset <= extent) {
              return;
            }

            controller.value.previousItem(
                duration: Duration(milliseconds: dur.value),
                curve: Curves.linearToEaseOut);
          }
          if (keyEvent.physicalKey == keys[1]) {
            if (dir.value != "next") {
              dur.value = 300;
              dir.value = "next";
            }

            if (controller.value.offset >= (count - 1) * extent) {
              return;
            }

            controller.value.nextItem(
                duration: Duration(milliseconds: dur.value),
                curve: Curves.linearToEaseOut);
          }

          if (holding) {
            dur.value -= 10;
            if (dur.value < 100) {
              dur.value = 100;
            }
          }
        },
        child: InfiniteCarousel.builder(
          itemCount: count,
          itemExtent: extent,
          center: false,
          anchor: 0,
          velocityFactor: 0.2,
          onIndexChanged: (index) {
            // print(controller.hashCode);
            if (onIndexChanged != null) {
              onIndexChanged!(index);
            }
          },
          controller: controller.value,
          axisDirection: axis,
          loop: false,
          scrollBehavior: ScrollConfiguration.of(context).copyWith(
            dragDevices: {
              // Allows to swipe in web browsers
              PointerDeviceKind.touch,
              PointerDeviceKind.mouse
            },
          ),
          itemBuilder: (context, itemIndex, realIndex) {
            return itemBuilder(context, itemIndex, realIndex, controller.value);
          },
        ));
  }
}

class OdinSectionCarousel extends HookConsumerWidget {
  const OdinSectionCarousel(
      {Key? key,
      required this.itemBuilder,
      this.onIndexChanged,
      this.onEnter,
      required this.extent,
      required this.keys,
      required this.count,
      required this.axis})
      : super(key: key);
  final Widget Function(BuildContext context, int itemIndex, int realIndex,
      InfiniteScrollController controller) itemBuilder;
  final void Function(int)? onIndexChanged;
  final void Function()? onEnter;
  final double extent;
  final int count;
  final Axis axis;
  final List<PhysicalKeyboardKey> keys;

  toggleMenuFocus(bool focus) {
    for (var i = 0; i < menufocus.length; i++) {
      menufocus[i].canRequestFocus = focus;
    }
  }

  @override
  Widget build(BuildContext context, ref) {
    final dur = useState(300);
    final dir = useState("");
    final controller = useState(InfiniteScrollController());
    final fn = useFocusNode();
    bool holding = false;

    return KeyboardListener(
        focusNode: fn,
        includeSemantics: true,
        onKeyEvent: (KeyEvent keyEvent) {
          if (keyEvent.logicalKey == LogicalKeyboardKey.enter) {
            if (onEnter != null) {
              onEnter!();
            }
            return;
          }

          if (!keys.contains(keyEvent.physicalKey)) {
            return;
          }
          if (keyEvent is KeyUpEvent) {
            return;
          }

          if (controller.value.offset <= extent) {
            toggleMenuFocus(true);
          } else {
            toggleMenuFocus(false);
          }

          if (keyEvent.physicalKey == keys[0]) {
            if (dir.value != "prev") {
              dur.value = 300;
              dir.value = "prev";
            }
            print(controller.value.offset);

            if (controller.value.offset <= extent) {
              return;
            }

            controller.value.previousItem(
                duration: Duration(milliseconds: dur.value),
                curve: Curves.linearToEaseOut);
          }
          if (keyEvent.physicalKey == keys[1]) {
            if (dir.value != "next") {
              dur.value = 300;
              dir.value = "next";
            }

            if (controller.value.offset >= (count - 1) * extent) {
              return;
            }

            controller.value.nextItem(
                duration: Duration(milliseconds: dur.value),
                curve: Curves.linearToEaseOut);
          }
        },
        child: InfiniteCarousel.builder(
          itemCount: count,
          itemExtent: extent,
          center: false,
          anchor: 0,
          velocityFactor: 0.2,
          onIndexChanged: (index) {
            // print(controller.hashCode);
            if (onIndexChanged != null) {
              onIndexChanged!(index);
            }
          },
          controller: controller.value,
          axisDirection: axis,
          loop: false,
          scrollBehavior: ScrollConfiguration.of(context).copyWith(
            dragDevices: {
              // Allows to swipe in web browsers
              PointerDeviceKind.touch,
              PointerDeviceKind.mouse
            },
          ),
          itemBuilder: (context, itemIndex, realIndex) {
            return itemBuilder(context, itemIndex, realIndex, controller.value);
          },
        ));
  }
}
