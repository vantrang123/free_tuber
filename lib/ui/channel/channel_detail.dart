import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../models/video_model.dart';
import '../animations/fade_in.dart';
import '../components/shimmer_container.dart';
import '../components/streams_list_tile.dart';

class ChannelPageDetail extends StatefulWidget {
  final Video video;

  ChannelPageDetail(
      {required this.video});

  @override
  _ChannelPageDetailState createState() => _ChannelPageDetailState();
}

class _ChannelPageDetailState extends State<ChannelPageDetail> {
  late GlobalKey<ScaffoldState> scaffoldKey;

  @override
  void initState() {
    super.initState();
    scaffoldKey = GlobalKey<ScaffoldState>();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
      ),
    );
    return Column(children: [
      Expanded(
          child: Scaffold(
              extendBodyBehindAppBar: true,
              key: scaffoldKey,
              appBar: AppBar(
                  titleSpacing: 0,
                  title: Text("${widget.video.channel?.title}",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Product Sans',
                        fontWeight: FontWeight.w600,
                        fontSize: 24,
                      )),
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back_ios_new_rounded,
                        color: Theme.of(context).iconTheme.color),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  elevation: 0,
                  backgroundColor: Colors.transparent),
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              body: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  // background image and bottom contents
                  Column(
                    children: <Widget>[
                      Container(
                        height: 150,
                        child: Stack(
                          children: [
                            Center(child: bannerWidget()),
                            Container(
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      colors: [
                                    Colors.black.withOpacity(0.8),
                                    Colors.transparent,
                                  ],
                                      begin: const Alignment(0.0, -1),
                                      end: const Alignment(0.0, 0.6),
                                      tileMode: TileMode.clamp)),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            // Title, subs and Suscribe Button
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 16, left: 132),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${widget.video.channel?.title}",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Product Sans',
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyText1!
                                          .color,
                                    ),
                                  ),
                                  // Subscribe button and subs count
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      /*ChannelSubscribeComponent(
                                              channelName: widget.name,
                                              channel: channel,
                                              scaffoldState: scaffoldKey.currentState
                                          ),*/
                                      SizedBox(width: 8),
                                      Text(
                                        "${NumberFormat.compact().format(0)} Subs",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'Product Sans',
                                            color: Theme.of(context)
                                                .textTheme
                                                .bodyText1!
                                                .color!
                                                .withOpacity(0.6)),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: 12),
                            Divider(
                                height: 1,
                                thickness: 1,
                                color: Colors.grey[600]!.withOpacity(0.1),
                                indent: 12,
                                endIndent: 12),
                            // Channel Uploads
                            Expanded(
                              child: FadeInTransition(
                                  delay: Duration(milliseconds: 600),
                                  child: StreamsListTile(
                                    video: widget.video,
                                    isFirstLoad: true,
                                    removePhysics: true,
                                    onTap: (video, index) async {},
                                  )),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  // Profile image
                  Positioned(
                    left: 16,
                    top: 132,
                    // (background container size) - (circle height / 2)
                    child: AnimatedSwitcher(
                      duration: Duration(milliseconds: 250),
                      child: true
                          ? Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  border: Border.all(
                                      width: 2,
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor)),
                              child: Hero(
                                tag: "",
                                child: Container(
                                  height: 100,
                                  width: 100,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: FadeInImage(
                                        fadeInDuration:
                                            Duration(milliseconds: 300),
                                        placeholder:
                                            MemoryImage(kTransparentImage),
                                        image: NetworkImage(""),
                                        fit: BoxFit.cover,
                                        imageErrorBuilder:
                                            (context, error, stackTrace) =>
                                                Image.network("url",
                                                    fit: BoxFit.cover)),
                                  ),
                                ),
                              ),
                            )
                          : ShimmerContainer(
                              height: 100,
                              width: 100,
                              borderRadius: BorderRadius.circular(100),
                            ),
                    ),
                  )
                ],
              )))
    ]);
  }

  Widget bannerWidget() {
    if (true) {
      return Container(color: Theme.of(context).colorScheme.secondary);
    } else {
      return FadeInImage(
        placeholder: MemoryImage(kTransparentImage),
        image: NetworkImage(""),
        fit: BoxFit.fitHeight,
        height: 150,
      );
    }
  }
}
