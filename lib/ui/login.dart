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
    final error = ref.watch(errorProvider);
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const OdinLogo(height: 50),
          const SizedBox(height: 20),
          error != "" ? BodyText1(error) : const SizedBox(),
          url != ""
              ? BodyText1("Connecting to: $url")
              : const Opacity(
                  opacity: 0.5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Headline4('In the ODIN frontend:'),
                      BodyText1("- Login as a regular user"),
                      BodyText1("- Go to Devices"),
                      BodyText1("- Click on 'Link Device'"),
                      BodyText1("- Enter the code below"),
                      BodyText1("- Click on 'Connect'"),
                    ],
                  ),
                ),
          const SizedBox(height: 20),
          BodyText1(code, style: const TextStyle(fontSize: 50)),
        ],
      )),
    );
  }
}
