import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EnsureVisible extends StatefulWidget {
  final Widget child;
  final double alignment;
  final bool isLast;
  final bool isFirst;
  final double paddingTop;
  final Function? onFocus;
  final Function? onRight;
  final Function? onLeft;
  const EnsureVisible(
      {Key? key,
      required this.child,
      this.alignment = 0.1,
      this.paddingTop = 20,
      this.isLast = false,
      this.isFirst = false,
      this.onFocus,
      this.onRight,
      this.onLeft})
      : super(key: key);

  @override
  State<EnsureVisible> createState() => _EnsureVisibleState();
}

class _EnsureVisibleState extends State<EnsureVisible> {
  KeyEventResult _handleKey(BuildContext context, RawKeyEvent rawKeyEvent) {
    if (rawKeyEvent.logicalKey == LogicalKeyboardKey.arrowRight &&
        widget.isLast) {
      return KeyEventResult.handled;
    }
    if (rawKeyEvent.logicalKey == LogicalKeyboardKey.arrowLeft &&
        widget.isFirst) {
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) => Focus(
        onKey: (_, rawKeyEvent) => _handleKey(context, rawKeyEvent),
        canRequestFocus: false,
        onFocusChange: (focused) {
          if (focused) {
            Scrollable.ensureVisible(
              context,
              alignment: widget.alignment,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
            if (widget.onFocus != null) {
              widget.onFocus!();
            }
          }
        },
        child: Container(
            padding: EdgeInsets.only(top: widget.paddingTop),
            child: widget.child),
      );
}

class EnsureVisibleList extends StatefulWidget {
  final Widget child;
  final double alignment;
  final bool isLast;
  final bool isFirst;
  final double paddingTop;
  final Function? onFocus;
  const EnsureVisibleList(
      {Key? key,
      required this.child,
      this.alignment = 0.1,
      this.paddingTop = 20,
      this.isLast = false,
      this.isFirst = false,
      this.onFocus})
      : super(key: key);

  @override
  State<EnsureVisibleList> createState() => _EnsureVisibleListState();
}

class _EnsureVisibleListState extends State<EnsureVisibleList> {
  KeyEventResult _handleKey(BuildContext context, RawKeyEvent rawKeyEvent) {
    if (rawKeyEvent.logicalKey == LogicalKeyboardKey.arrowRight &&
        widget.isLast) {
      return KeyEventResult.handled;
    }
    if (rawKeyEvent.logicalKey == LogicalKeyboardKey.arrowLeft &&
        widget.isFirst) {
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) => Focus(
        onKey: (_, rawKeyEvent) => _handleKey(context, rawKeyEvent),
        canRequestFocus: false,
        onFocusChange: (focused) {
          if (focused) {
            Scrollable.ensureVisible(
              context,
              alignment: widget.alignment,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
            if (widget.onFocus != null) {
              widget.onFocus!();
            }
          }
        },
        child: Container(
            padding: EdgeInsets.only(top: widget.paddingTop),
            child: widget.child),
      );
}
