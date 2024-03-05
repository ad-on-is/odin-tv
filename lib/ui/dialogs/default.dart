import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:helpers/helpers/widgets/text.dart';
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 10),
            child: Headline4(title,
                style: const TextStyle(overflow: TextOverflow.ellipsis)),
          ),
          SizedBox(
            width: 200,
            child: Divider(
              height: 1,
              color: AppColors.blue,
            ),
          ),
          child,
        ],
      ),
    );
  }
}
