import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odin/data/entities/trakt.dart';
import 'package:odin/ui/pages/grid.dart';
import 'package:odin/ui/pages/home.dart';

final List<Widget> pages = [
  const HomePage(),
  const MoviesGrid(),
  const ShowsGrid()
];

final appPageProvider = StateProvider<int>((ref) => 0);
final selectedItemProvider = StateProvider<Trakt>((ref) => Trakt());
final selectedSectionProvider = StateProvider<String>((ref) => "");
final selectedItemOfSectionProvider = StateProviderFamily<Trakt, String>(
  (ref, section) => Trakt(),
);
final bgBusyProvider = StateProvider<bool>((ref) => false);
final appBusyProvider = StateProvider<bool>((ref) => false);
final bgAlpha = StateProvider<int>((ref) => 230);
final debugProvider = StateProvider<String>((ref) => "test");

final beforeFocusProvider = StateProvider<bool>((ref) => false);
final afterFocusProvider = StateProvider<bool>((ref) => false);
