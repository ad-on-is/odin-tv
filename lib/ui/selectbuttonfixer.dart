import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:helpers/helpers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:odin/data/models/auth_model.dart';
import 'package:odin/main.dart';
import 'package:odin/theme.dart';
import 'package:odin/ui/widgets/widgets.dart';

class SelectButtonFixer extends HookConsumerWidget {
  const SelectButtonFixer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current = useState("");
    final fn = useFocusNode();
    fn.requestFocus();
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Headline4("Fix select button"),
          const CaptionText(
              "Due to a bug in Flutter, Odin needs to detect your remotes select key (usually the middle button) manually."),
          const SizedBox(height: 20),
          const BodyText1("Please click the middle key on your remote now!"),
          const SizedBox(height: 20),
          KeyboardListener(
            focusNode: fn,
            onKeyEvent: (KeyEvent keyEvent) async {
              final label = keyEvent.logicalKey.keyLabel;
              final code = keyEvent.physicalKey.usbHidUsage;
              if (label == "Select" ||
                  label.toString().contains("Key with ID")) {
                current.value = "${keyEvent.physicalKey.debugName}";
                ref.read(selectButtonProvider.notifier).state = code;
              } else {
                current.value = "${label} - ${code}";
              }
            },
            child: Icon(FontAwesomeIcons.circleDot,
                color: AppColors.primary, size: 100),
          ),
          BodyText1(current.value)
        ],
      )),
    );
  }
}
