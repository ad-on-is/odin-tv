import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:helpers/helpers/widgets/text.dart';
import 'package:odin/controllers/app_controller.dart';
import 'package:odin/data/entities/trakt.dart';
import 'package:odin/data/services/trakt_service.dart';
import 'package:odin/helpers.dart';
import 'package:odin/theme.dart';
import 'package:odin/ui/detail/detail.dart';
import 'package:odin/ui/widgets/widgets.dart';

class PosterCover extends ConsumerStatefulWidget {
  final Trakt item;
  final Function? onFocus;
  final bool autoFocus;
  final bool requestFocus;
  const PosterCover(this.item,
      {Key? key,
      this.autoFocus = false,
      this.onFocus,
      this.requestFocus = false})
      : super(key: key);

  @override
  PosterCoverState createState() => PosterCoverState();
}

class PosterCoverState extends ConsumerState<PosterCover>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  AnimationController? _controller;
  Animation<double>? _animation;
  FocusNode? _node;
  Color _focusColor = Colors.transparent;
  @override
  void initState() {
    _node = FocusNode();
    _node?.addListener(_onFocusChange);

    _controller = AnimationController(
        duration: const Duration(milliseconds: 100),
        vsync: this,
        lowerBound: 0.9,
        upperBound: 1);
    _animation = CurvedAnimation(parent: _controller!, curve: Curves.easeIn);
    super.initState();
  }

  void _onFocusChange() async {
    if (_node!.hasFocus) {
      _controller?.forward();
      if (widget.onFocus != null) {
        widget.onFocus!();
      }
      ref.read(pageBackgroundProvider.notifier).state =
          widget.item.tmdb!.backdropBig;
      setState(() {
        _focusColor = Colors.transparent;
      });
    } else {
      _controller?.reverse();
      setState(() {
        _focusColor = Colors.transparent;
      });
    }
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _controller?.dispose();
    _node?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RawMaterialButton(
      focusNode: _node,
      autofocus: widget.autoFocus,
      elevation: 0,
      focusElevation: 0,
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => Detail(
                  item: widget.item.show != null
                      ? widget.item.show!
                      : widget.item,
                )));
      },
      child: ScaleTransition(
        scale: _animation!,
        child: AspectRatio(
            aspectRatio: 0.526,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Flexible(
                  flex: 3,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.only(top: 5),
                      height: MediaQuery.of(context).size.height,
                      child: CachedNetworkImage(
                        imageUrl: widget.item.tmdb!.posterSmall,
                        errorWidget: (_, str, d) => Container(
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(5)),
                          child: Center(
                              child: Icon(
                            FontAwesomeIcons.image,
                            color: AppColors.primary,
                            size: 30,
                          )),
                        ),
                        imageBuilder: (context, imageProvider) => ClipRRect(
                            borderRadius: BorderRadius.circular(7),
                            child: Container(
                              color: _focusColor,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: Image(
                                  image: imageProvider,
                                ),
                              ),
                            )),
                        placeholder: (context, url) => Container(
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(5)),
                          child: Center(
                              child: Icon(
                            FontAwesomeIcons.image,
                            color: AppColors.darkGray,
                            size: 30,
                          )),
                        ),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 5),
                        BodyText1(
                          widget.item.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Subtitle1(
                              widget.item.year.toString(),
                              style: TextStyle(color: AppColors.gray1),
                            ),
                            ref.watch(watchedProvider.notifier).items.contains(
                                        BaseHelper.hiveKey(widget.item.type,
                                            widget.item.ids.trakt)) ||
                                    widget.item.watched
                                ? const Watched(
                                    iconOnly: true,
                                  )
                                : const SizedBox(),
                            Row(
                              children: [
                                Icon(
                                  FontAwesomeIcons.solidStar,
                                  size: 7,
                                  color: AppColors.primary,
                                ),
                                const SizedBox(width: 5),
                                Subtitle2(
                                  widget.item.roundedRating.toString(),
                                  style: TextStyle(color: AppColors.primary),
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
