import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:helpers/helpers.dart';
import 'package:odin/ui/widgets/ensure_visible.dart';
import 'package:odin/ui/widgets/widgets.dart';

import '../controllers/app_controller.dart';

class OdinAppBar extends ConsumerWidget {
  const OdinAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    return AppBar(
        backgroundColor: Colors.transparent,
        actions: [
          Builder(
            builder: (context) => EnsureVisible(
                paddingTop: 0,
                isLast: true,
                child: IconButton(
                  padding: const EdgeInsets.all(5),
                  focusColor: Colors.white.withAlpha(40),
                  splashRadius: 20,
                  icon: const Icon(FontAwesomeIcons.gear, size: 16),
                  onPressed: () => Scaffold.of(context).openEndDrawer(),
                )),
          ),
        ],
        elevation: 0,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const OdinLogo(),
            const SizedBox(width: 100),
            Flexible(
                child: Row(
              children: [
                EnsureVisible(
                  isFirst: true,
                  paddingTop: 0,
                  child: TextButton(
                    child: const Headline4('Home'),
                    onPressed: () {
                      ref.read(appPageProvider.notifier).state = 0;
                    },
                  ),
                ),
                const SizedBox(width: 15),
                EnsureVisible(
                  isFirst: false,
                  paddingTop: 0,
                  child: TextButton(
                    child: const Headline4('Movies'),
                    onPressed: () {
                      ref.read(appPageProvider.notifier).state = 1;
                    },
                  ),
                ),
                const SizedBox(width: 15),
                EnsureVisible(
                  paddingTop: 0,
                  child: TextButton(
                    child: const Headline4('TV Shows'),
                    onPressed: () {
                      ref.read(appPageProvider.notifier).state = 2;
                    },
                  ),
                ),
              ],
            )),
            const Expanded(child: SizedBox())
          ],
        ));
  }
}
