import 'package:flutter/material.dart';
import 'package:helpers/helpers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:odin/data/models/auth_model.dart';
import 'package:odin/ui/widgets/widgets.dart';

class Login extends HookConsumerWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final code = ref.watch(codeProvider);
    final url = ref.watch(urlProvider);
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const OdinLogo(),
          const BodyText2(
              'Go to your devices settings and enter the code below:'),
          const SizedBox(height: 20),
          BodyText1(code, style: const TextStyle(fontSize: 50)),
          const SizedBox(height: 20),
          url != "" ? BodyText1("Connecting to: $url") : const SizedBox(),
        ],
      )),
    );
  }
}
