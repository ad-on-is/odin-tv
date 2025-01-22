import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:infinite_carousel/infinite_carousel.dart';
import 'package:odin/controllers/app_controller.dart';
import 'package:odin/data/services/db.dart';
import 'package:odin/helpers.dart';

final childStreamController = StreamController<String>.broadcast();
final currentRow = StateProvider<String>((ref) => "");
final previousRow = StateProvider<String>((ref) => "");
final currentRowBeforeDetail = StateProvider<String>((ref) => "");

class OdinCarousel extends HookConsumerWidget with BaseHelper {
  const OdinCarousel(
      {Key? key,
      required this.itemBuilder,
      required this.onRowIndexChanged,
      required this.onChildIndexChanged,
      this.onEnter,
      this.anchor,
      this.alignment,
      this.ensureVisible,
      this.center,
      this.id,
      required this.extent,
      required this.count,
      required this.axis})
      : super(key: key);
  final Widget Function(BuildContext context, int itemIndex, int realIndex,
      InfiniteScrollController controller) itemBuilder;
  final void Function(int) onRowIndexChanged;
  final void Function(int) onChildIndexChanged;
  final void Function(int)? onEnter;
  final double extent;
  final String? id;
  final double? anchor;
  final double? alignment;
  final bool? ensureVisible;
  final bool? center;
  final int count;
  final Axis axis;

  allowBeforeFocus(bool focus, ref) {
    ref.read(beforeFocusProvider.notifier).state = focus;
  }

  allowfterFocus(bool focus, ref) {
    ref.read(afterFocusProvider.notifier).state = focus;
  }

  @override
  Widget build(BuildContext context, ref) {
    final controller =
        useMemoized(() => InfiniteScrollController(initialItem: 0), [key]);

    final isChild = axis == Axis.horizontal;

    final carousel = Carousel(
        itemBuilder: itemBuilder,
        controller: controller,
        onIndexChanged: onChildIndexChanged,
        extent: extent,
        isChild: isChild,
        onEnter: onEnter,
        id: id ?? "NOT-CHILD",
        count: count,
        axis: axis);

    if (isChild) {
      return carousel;
    }

    return Listener(
      count: count,
      controller: controller,
      onIndexChanged: onRowIndexChanged,
      onEnter: onEnter,
      extent: extent,
      id: id,
      center: center,
      child: carousel,
    );
  }
}

class Carousel extends HookConsumerWidget with BaseHelper {
  const Carousel(
      {required this.itemBuilder,
      this.anchor,
      this.alignment,
      this.ensureVisible,
      required this.isChild,
      this.onIndexChanged,
      this.center,
      this.onEnter,
      required this.id,
      required this.controller,
      required this.extent,
      required this.count,
      required this.axis,
      Key? key})
      : super(key: key);

  final Widget Function(BuildContext context, int itemIndex, int realIndex,
      InfiniteScrollController controller) itemBuilder;

  final double extent;
  final double? anchor;
  final double? alignment;
  final bool? ensureVisible;
  final bool isChild;
  final InfiniteScrollController controller;
  final void Function(int)? onIndexChanged;
  final void Function(int)? onEnter;
  final bool? center;
  final int count;
  final Axis axis;
  final String id;

  @override
  Widget build(BuildContext context, ref) {
    final idx = useState(0);
    final didx = useDebounced(idx.value, const Duration(milliseconds: 50));
    final isAnim = useState(false);
    if (isChild) {
      useMemoized(() {
        childStreamController.stream.listen((data) {
          if (!data.startsWith(id)) {
            return;
          }
          final dir = data.replaceAll("$id-", "");
          if (isAnim.value) {
            return;
          }
          if (dir == "next") {
            // isAnim.value = true;
            controller.nextItem(
                duration: const Duration(milliseconds: 250),
                curve: Curves.linearToEaseOut);
          }
          if (dir == "prev") {
            // isAnim.value = true;
            controller.previousItem(
                duration: const Duration(milliseconds: 250),
                curve: Curves.linearToEaseOut);
          }

          if (dir == "select") {
            if (onEnter != null) {
              onEnter!(idx.value);
            }
          }
          if (onIndexChanged != null) {
            onIndexChanged!(idx.value);
          }
        });
      });
    }

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
      // logInfo("INDEX: ${index} - count ${count}");
      if (index > count) {
        index = count;
      }
      if (index < 0) {
        index = 0;
      }
      // isAnim.value = false;
      if (onIndexChanged != null) {
        onIndexChanged!(index);
      }
      return;
    }, [didx]);

    return InfiniteCarousel.builder(
      key: key,
      itemCount: count,
      itemExtent: extent,
      center: center ?? false,
      anchor: anchor ?? 0.02,
      velocityFactor: 0.2,
      loop: false,
      controller: controller,
      onIndexChanged: (i) {
        idx.value = i;
      },
      axisDirection: axis,
      physics: const NeverScrollableScrollPhysics(),
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
    );
  }
}

class Listener extends HookConsumerWidget with BaseHelper {
  const Listener(
      {required this.onIndexChanged,
      this.center,
      this.onEnter,
      this.id,
      required this.child,
      required this.extent,
      required this.count,
      required this.controller,
      Key? key})
      : super(key: key);
  final void Function(int) onIndexChanged;
  final void Function(int)? onEnter;
  final Widget child;
  final double extent;
  final InfiniteScrollController controller;
  final bool? center;
  final int count;
  final String? id;

  allowBeforeFocus(bool focus, ref) {
    ref.read(beforeFocusProvider.notifier).state = focus;
  }

  allowfterFocus(bool focus, ref) {
    ref.read(afterFocusProvider.notifier).state = focus;
  }

  @override
  Widget build(BuildContext context, ref) {
    final keys = [
      PhysicalKeyboardKey.arrowLeft,
      PhysicalKeyboardKey.arrowRight,
      PhysicalKeyboardKey.arrowUp,
      PhysicalKeyboardKey.arrowDown,
    ];
    final dir = useState("");
    final idx = useState(0);
    final didx = useDebounced(idx.value, const Duration(milliseconds: 50));

    final isAnim = useState(false);
    // final cw = ref.watch(currentRow);

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

    final fn = useFocusNode();
    useEffect(() {
      int index = didx ?? 0;

      if (index > count) {
        index = count;
      }
      if (index <= 0) {
        index = 0;
      } else {}
      onIndexChanged(index);
      return;
    }, [didx]);

    Future<bool> isSelect(PhysicalKeyboardKey key) async {
      final saved = await ref.read(dbProvider.notifier).hive?.get("selectKey");
      return [saved].contains(key.usbHidUsage);
    }

    return KeyboardListener(
        key: key,
        focusNode: fn,
        onKeyEvent: (KeyEvent keyEvent) async {
          if (keyEvent is KeyUpEvent) {
            dir.value = "";
            return;
          }

          if (isAnim.value) return;

          // ignore other keys
          if (![...keys, PhysicalKeyboardKey.enter]
                  .contains(keyEvent.physicalKey) &&
              !await isSelect(keyEvent.physicalKey)) {
            return;
          }
          if (keyEvent.physicalKey == PhysicalKeyboardKey.enter ||
              await isSelect(keyEvent.physicalKey)) {
            childStreamController.add("${ref.read(currentRow)}-select");
            if (onEnter != null) {
              onEnter!(didx ?? 0);
            }
            return;
          }

          if (controller.offset <= 20) {
            allowBeforeFocus(true, ref);
            fn.skipTraversal = false;
          } else {
            allowBeforeFocus(false, ref);
            fn.skipTraversal = true;
          }

          if (keyEvent.physicalKey == PhysicalKeyboardKey.arrowUp) {
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
          if (keyEvent.physicalKey == PhysicalKeyboardKey.arrowDown) {
            if (dir.value != "next") {
              dir.value = "next";
            }

            // if (controller.offset >= (count - 1) * extent) {
            //   return;
            // }

            controller.nextItem(
                duration: const Duration(milliseconds: 250),
                curve: Curves.linearToEaseOut);

            isAnim.value = true;
          }

          if (keyEvent.physicalKey == PhysicalKeyboardKey.arrowLeft) {
            childStreamController.add("${ref.read(currentRow)}-prev");
            isAnim.value = true;
          }
          if (keyEvent.physicalKey == PhysicalKeyboardKey.arrowRight) {
            childStreamController.add("${ref.read(currentRow)}-next");
            isAnim.value = true;
          }
        },
        child: child);
  }
}
