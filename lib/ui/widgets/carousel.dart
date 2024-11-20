import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:infinite_carousel/infinite_carousel.dart';
import 'package:odin/helpers.dart';
import 'package:odin/ui/focusnodes.dart';

class OdinCarousel extends HookConsumerWidget with BaseHelper {
  const OdinCarousel(
      {Key? key,
      required this.itemBuilder,
      required this.onIndexChanged,
      this.onEnter,
      this.anchor,
      required this.extent,
      required this.keys,
      required this.count,
      required this.axis})
      : super(key: key);
  final Widget Function(BuildContext context, int itemIndex, int realIndex,
      InfiniteScrollController controller) itemBuilder;
  final void Function(int) onIndexChanged;
  final void Function()? onEnter;
  final double extent;
  final double? anchor;
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
    final idx = useState(0);
    final didx = useDebounced(idx.value, const Duration(milliseconds: 50));
    // print("REBUILDING ${count}");

    final controller = useMemoized(() => InfiniteScrollController(), [key]);

    useEffect(
      () {
        void listener() {
          idx.value = (controller.offset / extent).round();
        }

        controller.addListener(listener);
        return () => controller.removeListener(listener);
      },
    );

    useEffect(() {
      int index = didx ?? 0;
      if (index > count) {
        index = count;
      }
      if (index < 0) {
        index = 0;
      }
      onIndexChanged(index);
      return;
    }, [didx]);

    final fn = useFocusNode();
    bool holding = false;

    return KeyboardListener(
        key: key,
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

          if (controller.offset <= extent) {
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

            if (controller.offset <= extent / 2) {
              return;
            }

            controller.previousItem(
                duration: Duration(milliseconds: dur.value),
                curve: Curves.linearToEaseOut);
          }
          if (keyEvent.physicalKey == keys[1]) {
            if (dir.value != "next") {
              dur.value = 300;
              dir.value = "next";
            }

            if (controller.offset >= (count - 1) * extent) {
              return;
            }

            controller.nextItem(
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
          key: key,
          itemCount: count,
          itemExtent: extent,
          center: false,
          anchor: anchor ?? 0.02,
          velocityFactor: 0.2,
          onIndexChanged: (index) {
            // print(controller.hashCode);

            // if (onIndexChanged != null) {
            //   onIndexChanged!(index);
            // }
          },
          controller: controller,
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
            return itemBuilder(context, itemIndex, realIndex, controller);
          },
        ));
  }
}
