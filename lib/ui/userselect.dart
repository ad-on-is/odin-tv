import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:helpers/helpers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:odin/data/models/auth_model.dart';
import 'package:odin/ui/widgets/widgets.dart';

class UserSelect extends HookConsumerWidget {
  const UserSelect({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final users = [];
    ref.watch(usersProvider);
    final usersData = ref.refresh(usersProvider);
    // ref.refresh(usersProvider);
    usersData.whenData((data) => {users.addAll(data)});
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const OdinLogo(height: 100, showText: false),
          const SizedBox(height: 20),
          const Headline4("Select a user"),
          const SizedBox(height: 20),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.from(
                users.map(
                  (u) => DefaultButton(
                    "${u.user["username"]}",
                    icon: FontAwesomeIcons.user,
                    onPress: () {
                      ref.read(authProvider.notifier).selectUser(u);
                    },
                  ),
                ),
              )..add(
                  DefaultButton(
                    "New user",
                    icon: FontAwesomeIcons.userPlus,
                    onPress: () {
                      ref.read(authProvider.notifier).newUser();
                    },
                  ),
                )),
        ],
      )),
    );
  }
}
