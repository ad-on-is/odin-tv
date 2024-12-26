import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:helpers/helpers.dart';
import 'package:odin/data/models/settings_model.dart';
import 'package:odin/theme.dart';
import 'package:odin/ui/dialogs/default.dart';

import '../controllers/settings_controller.dart';

class Settings extends ConsumerWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    ref.watch(settingsController);
    return ListView(
      children: [
        const Padding(
          padding: EdgeInsets.all(15),
          child: Headline4('SETTINGS'),
        ),
        ListTile(
          dense: true,
          onTap: () {
            showDialog(
                context: context,
                builder: (ctx) => const DefaultDialog(
                      child: ChangePlayer(),
                    ));
          },
          minLeadingWidth: 20,
          leading: const Icon(FontAwesomeIcons.circlePlay,
              color: Colors.white, size: 17),
          title: const BodyText1('Player'),
          subtitle: CaptionText(
            ref.read(settingsController.notifier).config.player,
            style: TextStyle(color: AppColors.gray2),
          ),
        ),
      ],
    );
  }
}

class ChangePlayer extends ConsumerWidget {
  const ChangePlayer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    return SizedBox(
      width: 300,
      height: 300,
      child: ListView.builder(
          itemCount: players.length,
          itemBuilder: ((context, index) => RawMaterialButton(
              child: BodyText1(players[index]['title']!),
              onPressed: () {
                ref.read(settingsController.notifier).player = index;
                ref.read(settingsController.notifier).save();
                Navigator.of(context).pop();
              }))),
    );
  }
}
