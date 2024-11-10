import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odin/controllers/home_controller.dart';
import 'package:odin/data/models/item_model.dart';
import 'package:odin/ui/widgets/section.dart';

class HomePage extends ConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  // @override
  // Widget build(BuildContext context, ref) {
  //   final provider = ref.watch(homeSectionProvider);

  //   List<SectionItem> sections = [];

  // }

  @override
  Widget build(BuildContext context, ref) {
    final provider = ref.watch(homeSectionProvider);

    List<SectionItem> sections = [];
    provider.whenData((value) {
      sections = value;
    });

    return SingleChildScrollView(
        child: Column(
      children: sections
          .map((SectionItem e) => Section(
                e: e,
              ))
          .toList(),
    ));
  }
}
