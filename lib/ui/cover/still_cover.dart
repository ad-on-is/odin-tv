import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:odin/theme.dart';

class StillCover extends StatefulWidget {
  final String? imagePath;
  final Function? onPressed;
  final Function? onFocus;
  final bool? focus;
  const StillCover(
      {Key? key, this.imagePath, this.onPressed, this.onFocus, this.focus})
      : super(key: key);

  @override
  StillCoverState createState() => StillCoverState();
}

class StillCoverState extends State<StillCover> with TickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _animation;
  FocusNode? _node;
  // Color _focusColor = Colors.black.withAlpha(200);
  @override
  void initState() {
    _node = FocusNode();
    // if (widget.focus) {
    //   if (this.mounted) _node.requestFocus();
    // }
    _node!.addListener(_onFocusChange);
    _controller = AnimationController(
        duration: const Duration(milliseconds: 100),
        vsync: this,
        lowerBound: 0.9,
        upperBound: 1);
    _animation = CurvedAnimation(parent: _controller!, curve: Curves.easeIn);

    super.initState();
  }

  void _onFocusChange() {
    if (_node!.hasFocus) {
      _controller!.forward();
      setState(() {
        // _focusColor = Colors.transparent;
      });
      widget.onFocus!();
    } else {
      // _focusColor = Colors.black.withAlpha(200);
      _controller!.reverse();
      setState(() {});
    }
  }

  @override
  void dispose() {
    _controller!.dispose();
    _node!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      focusNode: _node,
      elevation: 0,
      focusElevation: 0,
      fillColor: Colors.transparent,
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      onPressed: () {
        widget.onPressed!();
      },
      child: AspectRatio(
        aspectRatio: 1.78,
        child: ScaleTransition(
          scale: _animation!,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: CachedNetworkImage(
              imageUrl: widget.imagePath!,
              errorWidget: (_, __, ___) => Container(color: AppColors.darkGray),
              placeholder: (_, __) => Container(color: AppColors.darkGray),
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
    );
  }
}
