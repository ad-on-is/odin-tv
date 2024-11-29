import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:helpers/helpers.dart';
import 'package:odin/theme.dart';
import 'package:odin/ui/focusnodes.dart';
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
            builder: (context) => IconButton(
              padding: const EdgeInsets.all(5),
              focusColor: Colors.white.withAlpha(40),
              splashRadius: 20,
              focusNode: menufocus[0],
              icon: const Icon(FontAwesomeIcons.gear, size: 16),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
            ),
          ),
        ],
        elevation: 0,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const OdinLogo(),
            const SizedBox(width: 20),
            Flexible(
                child: SizedBox(
              height: 20,
              child: Row(
                children: [
                  TextButton(
                    focusNode: menufocus[1],
                    child: BodyText1(
                      'Home',
                      style: TextStyle(fontSize: 10, color: AppColors.purple),
                    ),
                    onPressed: () {
                      ref.read(appPageProvider.notifier).state = 0;
                    },
                  ),
                  const SizedBox(width: 5),
                  TextButton(
                    focusNode: menufocus[2],
                    child: BodyText1(
                      'Movies',
                      style: TextStyle(fontSize: 10, color: AppColors.purple),
                    ),
                    onPressed: () {
                      ref.read(appPageProvider.notifier).state = 1;
                    },
                  ),
                  const SizedBox(width: 5),
                  TextButton(
                    focusNode: menufocus[3],
                    child: BodyText1(
                      'TV Shows',
                      style: TextStyle(fontSize: 10, color: AppColors.purple),
                    ),
                    onPressed: () {
                      ref.read(appPageProvider.notifier).state = 2;
                    },
                  ),
                ],
              ),
            )),
            const Expanded(child: SizedBox())
          ],
        ));
  }
}
