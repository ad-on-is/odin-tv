import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odin/theme.dart';

class DefaultDialog extends ConsumerWidget {
  final Widget child;
  final String title;
  const DefaultDialog({Key? key, required this.child, this.title = ''})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dialog(
      backgroundColor: AppColors.darkGray,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: child,
    );
  }
}
