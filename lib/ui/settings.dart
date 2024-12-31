import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:helpers/helpers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:odin/data/models/auth_model.dart';
import 'package:odin/data/models/settings_model.dart';
import 'package:odin/data/services/api.dart';
import 'package:odin/helpers.dart';
import 'package:odin/theme.dart';
import 'package:odin/ui/dialogs/default.dart';
import 'package:odin/ui/widgets/buttons.dart';

import '../controllers/settings_controller.dart';

class Settings extends HookConsumerWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final config = ref.read(settingsController.notifier).config;
    final scrobble = useState(config.scrobble);
    final player = useState(config.player);

    useEffect(() {
      config.player = player.value;
      config.scrobble = scrobble.value;
      ref.read(settingsController.notifier).save();
    }, [player.value, scrobble.value]);

    final rd = useState("");
    final ad = useState("");
    final trakt = useState("");
    final user = useState("");
    final device = useState("");
    final status = ref.watch(statusProvider);
    final auth = ref.watch(authProvider.notifier);
    final url = useState("");
    Future.delayed(const Duration(milliseconds: 100), () async {
      final creds = await auth.getCredentials();
      url.value = creds["url"];
      device.value = creds["device"];
    });

    // ref.refresh(statusProvider);

    status.whenData((data) {
      var rduntil = data["realdebrid"]?["expiration"] ?? "";
      if (rduntil != "") {
        rduntil = rduntil.split("T")[0];
        rd.value = "Valid until: $rduntil";
      } else {
        rduntil.value = "Not available";
      }
      var aduntil = data["alldebrid"]?["data"]["user"]["premiumUntil"] ?? 0;
      if (aduntil != 0) {
        final d = DateTime.fromMillisecondsSinceEpoch(aduntil * 1000);
        aduntil = d.toIso8601String().split("T")[0];
        ad.value = "Valid until: $aduntil";
      } else {
        ad.value = "Not available";
      }

      trakt.value = data["trakt"]?["user"]["username"] ?? "Not available";
      user.value = data["user"]?["username"] ?? "Not available";
    });
    return Column(
      children: [
        ListTile(
          dense: true,
          focusColor: AppColors.gray4,
          onTap: () async {
            final select = await showDialog(
                context: context,
                builder: (ctx) => const DefaultDialog(
                      child: ChangePlayer(),
                    ));

            if (select != null) {
              player.value = select;
            }
          },
          minLeadingWidth: 20,
          leading: const Icon(FontAwesomeIcons.circlePlay,
              color: Colors.white, size: 17),
          title: const BodyText1('Player'),
          subtitle: CaptionText(
            config.player,
            style: TextStyle(color: AppColors.gray2),
          ),
        ),
        // Divider(color: AppColors.gray3),
        ListTile(
          dense: true,
          focusColor: AppColors.gray4,
          onTap: () async {
            final select = await showDialog(
                context: context,
                builder: (ctx) => const DefaultDialog(
                      child: Reauth(),
                    ));

            if (select == true) {
              ref.read(authProvider.notifier).clear();
            }
          },
          minLeadingWidth: 20,
          leading: const Icon(
            FontAwesomeIcons.user,
            color: Colors.white,
            size: 17,
          ),
          title: BodyText1(user.value),
          subtitle: CaptionText(
            "${device.value}\n${url.value}",
            style: TextStyle(color: AppColors.gray2),
          ),
        ),
        ListTile(
          dense: true,
          focusColor: AppColors.gray4,
          onTap: () {
            scrobble.value = !scrobble.value;
          },
          minLeadingWidth: 20,
          leading: const Icon(
            FontAwesomeIcons.eye,
            color: Colors.white,
            size: 17,
          ),
          title: const BodyText1("Scrobble"),
          subtitle: CaptionText(
              "Sync with Trakt while watching\n${config.scrobble ? "Enabled" : "Disabled"}",
              style: TextStyle(color: AppColors.gray2)),
        ),

        Divider(color: AppColors.gray3),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const BodyText1("Trakt"),
                // Image.asset("assets/images/trakt.png", height: 17),
                CaptionText(trakt.value,
                    style: TextStyle(color: AppColors.gray2)),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const BodyText1("RealDebrid"),
                // Image.asset("assets/images/realdebrid.png", height: 17),
                CaptionText(rd.value, style: TextStyle(color: AppColors.gray2)),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const BodyText1("AllDebrid"),
                // Image.asset("assets/images/trakt.png", height: 17),
                CaptionText(ad.value, style: TextStyle(color: AppColors.gray2)),
              ],
            ),
          ]),
        ),
      ],
    );
  }
}

class Reauth extends ConsumerWidget {
  const Reauth({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    return SizedBox(
      width: 100,
      height: 130,
      child: Column(children: [
        const SizedBox(height: 10),
        Icon(FontAwesomeIcons.triangleExclamation, color: AppColors.red),
        const BodyText1("Are you sure you want to log out?"),
        const SizedBox(height: 10),
        DefaultButton("Yes!", onPress: () {
          Navigator.of(context).pop(true);
        })
      ]),
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
                // ref.read(settingsController.notifier).config.player =
                //     players[index]["title"]!;
                // ref.read(settingsController.notifier).save();
                Navigator.of(context).pop(players[index]["title"]);
              }))),
    );
  }
}
