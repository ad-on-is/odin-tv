import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:infinite_carousel/infinite_carousel.dart';
import 'package:odin/controllers/app_controller.dart';
import 'package:odin/helpers.dart';

class OdinCarousel extends HookConsumerWidget with BaseHelper {
  const OdinCarousel(
      {Key? key,
      required this.itemBuilder,
      required this.onIndexChanged,
      this.onEnter,
      this.anchor,
      this.autofocus,
      this.center,
      required this.extent,
      required this.keys,
      required this.count,
      required this.axis})
      : super(key: key);
  final Widget Function(BuildContext context, int itemIndex, int realIndex,
      InfiniteScrollController controller) itemBuilder;
  final void Function(int) onIndexChanged;
  final void Function(int)? onEnter;
  final double extent;
  final double? anchor;
  final bool? autofocus;
  final bool? center;
  final int count;
  final Axis axis;
  final List<PhysicalKeyboardKey> keys;

  toggleBeforeFocus(bool focus, ref) {
    ref.read(beforeFocusProvider.notifier).state = focus;
  }

  toggleAfterFocus(bool focus, ref) {
    ref.read(afterFocusProvider.notifier).state = focus;
  }

  @override
  Widget build(BuildContext context, ref) {
    // final dur = useState(300);
    final dir = useState("");
    final idx = useState(0);
    final didx = useDebounced(idx.value, const Duration(milliseconds: 50));
    // print("REBUILDING ${count}");

    final controller = useMemoized(() => InfiniteScrollController(), [key]);

    final isAnim = useState(false);

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
      final timer = Timer.periodic(const Duration(milliseconds: 50), (_) async {
        //print(holdingCount.value);
        isAnim.value = false;
      });
      return () => timer.cancel();
    });

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

    bool isSelect(PhysicalKeyboardKey key) {
      return [73014444264, 458840].contains(key.usbHidUsage);
    }

    return FocusTraversalGroup(
      child: KeyboardListener(
          key: key,
          focusNode: fn,
          autofocus: autofocus ?? false,
          onKeyEvent: (KeyEvent keyEvent) {
            if (keyEvent is KeyUpEvent) {
              dir.value = "";
              return;
            }

            if (isAnim.value) return;

            if (![...keys, PhysicalKeyboardKey.enter]
                    .contains(keyEvent.physicalKey) &&
                !isSelect(keyEvent.physicalKey)) {
              return;
            }
            if (keyEvent.physicalKey == PhysicalKeyboardKey.enter ||
                isSelect(keyEvent.physicalKey)) {
              if (onEnter != null) {
                onEnter!(didx ?? 0);
              }
              return;
            }

            if (controller.offset <= extent) {
              toggleBeforeFocus(true, ref);
              fn.skipTraversal = false;
            } else {
              toggleBeforeFocus(false, ref);
              fn.skipTraversal = true;
            }

            if (keyEvent.physicalKey == keys[0]) {
              if (dir.value != "prev") {
                dir.value = "prev";
              }
              // print(controller.value.offset);

              if (controller.offset <= extent / 2) {
                return;
              }

              controller.previousItem(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.linearToEaseOut);
              isAnim.value = true;
            }
            if (keyEvent.physicalKey == keys[1]) {
              if (dir.value != "next") {
                dir.value = "next";
              }

              if (controller.offset >= (count - 1) * extent) {
                return;
              }

              controller.nextItem(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.linearToEaseOut);

              isAnim.value = true;
            }
          },
          child: InfiniteCarousel.builder(
            key: key,
            itemCount: count,
            itemExtent: extent,
            center: center ?? false,
            anchor: anchor ?? 0.02,
            velocityFactor: 0.2,
            onIndexChanged: (index) {
              // print(controller.hashCode);

              // if (onIndexChanged != null) {
              //   onIndexChanged!(index);
              // }
            },
            loop: false,
            controller: controller,
            axisDirection: axis,
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
          )),
    );
  }
}
