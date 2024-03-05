import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odin/controllers/detail_controller.dart';
import 'package:odin/data/entities/trakt.dart';
import 'package:odin/data/services/imdb_service.dart';

import 'detail_movie.dart';
import 'detail_show.dart';

class Detail extends ConsumerWidget {
  final Trakt item;
  const Detail({Key? key, required this.item}) : super(key: key);
  @override
  Widget build(BuildContext context, ref) {
    ref.watch(imdbProvider.notifier).getReviews(item.ids.imdb);
    ref.read(detailController.notifier).onInit(item);
    return item.isMovie ? DetailMovie(item) : DetailShow(item);
  }
}
