import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../di/components/service_locator.dart';
import '../events/audio_listening.dart';
import '../events/my_event_bus.dart';
import '../provider/audio_control.dart';
import '../ui/components/thumbnail.dart';
import '../ui/player/audio_manager.dart';
import '../utils/routes/routes.dart';
import 'marquee.dart';

class VideoPageCollapsed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _myEventBus = getIt<MyEventBus>();
    final _audioControl = Provider.of<AudioControlProvider>(context);
    _myEventBus.eventBus.on<AudioListeningEvent>().listen((event) {
      _audioControl.setPlayStatus(event.playerState.playing);
    });

    final _audioManager = getIt<AudioManager>();
    String title = _audioManager.currentVideo?.title ?? "";
    String author = _audioManager.currentVideo?.channelTitle ?? "";
    String thumbnailUrl = _audioManager.currentVideo?.thumbnailUrl ??
        "https://imag.malavida.com/mvimgbig/download-fs/songtube-31886-0.jpg";

    return Consumer<AudioControlProvider>(builder: (context, data, child) {
      // if (_audioManager.currentVideo != null && !data.isPlaying)
      //   handlePlayPause(_audioManager);
      return InkWell(
        onTap: () {
          _audioManager.pause();
          Navigator.pushNamed(context, Routes.player,
              arguments: _audioManager.currentVideo);
        },
        child: _audioManager.currentVideo != null
            ? Container(
                height: kBottomNavigationBarHeight * 1.15,
                decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            height: 50,
                            margin: EdgeInsets.only(left: 12),
                            child: Thumbnail(ratio: 16 / 9, url: thumbnailUrl),
                          ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(left: 8),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  MarqueeWidget(
                                    animationDuration: Duration(seconds: 8),
                                    backDuration: Duration(seconds: 3),
                                    pauseDuration: Duration(seconds: 2),
                                    direction: Axis.horizontal,
                                    child: Text(
                                      "$title",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Product Sans',
                                        fontSize: 14,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.fade,
                                      softWrap: false,
                                    ),
                                  ),
                                  if (author != "") SizedBox(height: 2),
                                  if (author != "")
                                    Text(
                                      "$author",
                                      style: TextStyle(
                                          fontFamily: 'Product Sans',
                                          fontSize: 11,
                                          color: Theme.of(context)
                                              .textTheme
                                              .bodyText1!
                                              .color!
                                              .withOpacity(0.6)),
                                      overflow: TextOverflow.fade,
                                      softWrap: false,
                                      maxLines: 1,
                                    )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    // Play/Pause
                    SizedBox(width: 8),
                    Container(
                      color: Colors.transparent,
                      child: IconButton(
                          icon: data.isPlaying
                              ? Icon(CupertinoIcons.pause, size: 22)
                              : Icon(CupertinoIcons.play, size: 22),
                          onPressed: () {
                            handlePlayPause(_audioManager);
                          }),
                    ),
                    InkWell(
                      onTap: () {
                        _audioManager.stopPlayer();
                      },
                      child: Ink(
                          color: Colors.transparent,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(EvaIcons.close),
                          )),
                    ),
                    SizedBox(width: 16)
                  ],
                ),
              )
            : SizedBox(),
      );
    });
  }

  void handlePlayPause(AudioManager manager) {
    if (!manager.isPlaying) {
      if (manager.currentVideo?.lastDuration != null) {
        manager.seek(manager.currentVideo!.lastDuration!);
      }
      manager.play();
    } else
      manager.pause();
  }
}
