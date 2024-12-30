import 'package:flutter/material.dart';
import 'package:helpers/helpers.dart';

class DialogButton extends StatelessWidget {
  final String text;
  final Color color;
  final Function? onPress;
  const DialogButton(this.text,
      {Key? key, this.color = Colors.white, this.onPress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
        onPressed: () {
          if (onPress != null) {
            onPress!();
          }
        },
        child: BodyText1(text));
  }
}

class ButtonWithIcon extends StatelessWidget {
  final Function? onPress;
  final FocusNode? node;
  final String? text;
  final Widget? icon;
  const ButtonWithIcon(this.text,
      {Key? key, this.icon, required this.onPress, this.node})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return TextButton(
        focusNode: node,
        onPressed: () {
          if (onPress != null) {
            onPress!();
          }
        },
        child: Row(
          children: [
            icon ?? const SizedBox(),
            const SizedBox(width: 10),
            CaptionText(text ?? '')
          ],
        ));
  }
}

// class RoundIconButton extends StatelessWidget {
//   final double size;
//   final Function onPressed;
//   final IconData icon;
//   RoundIconButton({this.onPressed, this.icon, this.size: 35.0});
//   @override
//   Widget build(BuildContext context) {
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(size),
//       child: Container(
//         width: size,
//         height: size,
//         child: FlatButton(
//             padding: EdgeInsets.all(0),
//             color: Colors.black.withAlpha(100),
//             onPressed: () {
//               if (onPressed != null) {
//                 onPressed();
//               }
//             },
//             child: Icon(
//               icon,
//               color: Colors.white,
//               size: size / 2.5,
//             )),
//       ),
//     );
//   }
// }

// class FakeButtonForScroll extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 0,
//       child: Opacity(
//         opacity: 0,
//         child: RawMaterialButton(onPressed: () {}, child: Text('Fake')),
//       ),
//     );
//   }
// }
