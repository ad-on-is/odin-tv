import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:infinite_carousel/infinite_carousel.dart';

class AnimatedCover extends StatelessWidget {
  final Widget? child;
  final InfiniteScrollController? controller;
  final double? extent;
  final int? realIndex;
  final bool? target;
  const AnimatedCover(
      {Key? key,
      this.child,
      this.controller,
      this.extent,
      this.realIndex,
      this.target})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentOffset = extent! * realIndex!;
    const maxScale = 1;
    const fallOff = 0.2;
    const minScale = 0.90;
    return AnimatedBuilder(
      animation: controller!,
      builder: (context, child) {
        final diff = (controller!.offset - currentOffset);

        final carouselRatio = extent! / fallOff;
        // double r = (maxScale - (diff / carouselRatio));
        double s = (maxScale - (diff / carouselRatio).abs());

        double f = s;
        double b = s;
        double o = s;
        if (s < minScale) {
          s = minScale;
        }

        if (f < 0.4) {
          f = 0.4;
        }

        if (b < 0.2) {
          b = 0.2;
        }

        return child!
            .animate()
            // .blurXY(end: 0, begin: 5)
            .animate(target: target! ? 1 : 0)
            .scaleXY(end: s, begin: minScale, curve: Curves.easeInOutExpo)
            .tint(end: 1 - f, begin: 1 - f)

            //.blurXY(end: 1.3 - (1.3 * b), begin: 1.3 - (1.3 * b))
            .fade(end: f, begin: f);
        // .flipH(end: 1.5 - (1.5 * s))
      },
      child: child!,
    );
  }
}
