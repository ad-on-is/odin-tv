import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:helpers/helpers/widgets/text.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:odin/controllers/streams_controller.dart';
import 'package:odin/data/entities/trakt.dart';
import 'package:odin/helpers.dart';
import 'package:odin/theme.dart';
import 'package:odin/ui/detail/widgets.dart';

class QualityBadge extends StatelessWidget {
  final String quality;
  final List<String> infos;
  const QualityBadge(this.quality, this.infos, {Key? key}) : super(key: key);

  Color qualityToColor() {
    switch (quality) {
      case 'HDR':
        return AppColors.blue;
      case '4K':
        return AppColors.purple;
      case '1080p':
        return AppColors.yellow;
      case '720p':
        return AppColors.blue;
    }
    return Colors.white;
  }

  String qualityText() {
    String text = "";
    List<String> texts = [];
    if (infos.contains("DD") || infos.contains("DD+")) {
      texts.add("DD");
    }
    if (infos.contains("ATMOS")) {
      texts.add("ATMOS");
    }

    if (infos.contains("5.1")) {
      texts.add("5.1");
    }

    if (texts.isNotEmpty) {
      if (texts.length > 2) {
        texts = texts.take(2).toList();
      }
      return texts.join('|');
    }

    switch (quality) {
      case 'HDR':
        return '4K|ULTRA';
      case '4K':
        return 'ULTRA';
      case '1080p':
        return 'FULL|HD';
      case '720p':
        return 'HD';
    }
    return text;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      width: 35,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 0),
            child: Headline4(quality, style: const TextStyle(fontSize: 8)),
          ),
          Container(
              width: double.infinity,
              color: qualityToColor(),
              child: CaptionText(
                qualityText(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 5,
                  color: Colors.black,
                ),
              )),
        ],
      ),
    );
  }
}

class StreamsDialog extends ConsumerStatefulWidget {
  final Trakt item;
  final Trakt? show;
  final Trakt? season;
  const StreamsDialog({Key? key, required this.item, this.show, this.season})
      : super(key: key);

  @override
  StreamsDialogState createState() => StreamsDialogState();
}

class StreamsDialogState extends ConsumerState<StreamsDialog>
    with WidgetsBindingObserver, BaseHelper {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.read(streamsController.notifier).checkInTrakt(context);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Color qualityToColor(String quality) {
    switch (quality) {
      case 'HDR':
        return AppColors.red;
      case '4K':
        return AppColors.orange;
      case '1080p':
        return AppColors.green;
      case '720p':
        return AppColors.blue;
    }
    return Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(streamsController);
    final controller = ref.read(streamsController.notifier);
    if (controller.inited == false) {
      controller.init(widget.item, widget.show, widget.season);
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Headline4(controller.playerTitle),
            ],
          ),
        ),
        SizedBox(
            width: MediaQuery.of(context).size.width * 0.7,
            height: MediaQuery.of(context).size.height * 0.6,
            child: controller.allUrls().isEmpty
                ? Center(child: BodyText2(controller.status))
                : ListView.builder(
                    shrinkWrap: true,
                    itemExtent: 43,
                    itemCount: controller.allUrls().length,
                    itemBuilder: (context, index) => RawMaterialButton(
                      focusColor: AppColors.gray4,
                      onPressed: () {
                        controller
                            .openPlayer(controller.allUrls()[index].download);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                QualityBadge(
                                    controller.allUrls()[index].quality,
                                    controller.allUrls()[index].info),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      CaptionText(
                                        controller.allUrls()[index].filename,
                                        maxLines: 1,
                                        style: const TextStyle(fontSize: 9),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          CaptionText(
                                            controller
                                                .allUrls()[index]
                                                .info
                                                .join(" | "),
                                            style: TextStyle(
                                                color: AppColors.gray2,
                                                fontSize: 8),
                                          ),
                                          CaptionText(
                                            filesize(controller
                                                .allUrls()[index]
                                                .filesize),
                                            style: TextStyle(
                                                color: AppColors.gray2,
                                                fontSize: 8),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Divider(color: AppColors.gray3.withAlpha(80))
                          ],
                        ),
                      ),
                    ),
                  )),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(FontAwesomeIcons.clock, size: 12, color: AppColors.primary),
              const SizedBox(width: 5),
              BodyText2(
                  "Runtime: ${runtimeReadable(controller.item?.runtime ?? 0)}"),
              const SizedBox(width: 20),
              controller.status == "Done"
                  ? Icon(FontAwesomeIcons.hourglassEnd,
                      size: 15, color: AppColors.gray1)
                  : Icon(FontAwesomeIcons.hourglassHalf,
                      size: 15, color: AppColors.gray3),
              const SizedBox(width: 5),
              CaptionText(controller.status),
              const SizedBox(width: 20),
              Icon(FontAwesomeIcons.film, size: 12, color: AppColors.primary),
              const SizedBox(width: 5),
              CaptionText("${controller.allUrls().length} streams")
            ],
          ),
        ),
      ],
    );
  }
}
