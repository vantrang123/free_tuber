import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../../di/components/service_locator.dart';
import '../../models/video_model.dart';
import '../../provider/video_control.dart';
import '../../provider/video_duration_change.dart';
import '../../stores/explore/explore_store.dart';
import '../../stores/player/player_store.dart';
import '../../widgets/channel_info.dart';
import '../../widgets/measure_size.dart';
import '../../widgets/video_info.dart';
import '../components/streams_list_tile.dart';
import '../components/thumbnail.dart';
import '../controller/cupertino_controls.dart';
import 'audio_manager.dart';

class PlayerScreen extends StatefulWidget {
  late Video video;

  PlayerScreen({required this.video});

  @override
  _PlayerScreenState createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  late ExploreStore _exploreStore;
  PlayerStore? _playerStore;
  VideoPlayerController? _videoPlayerController;
  VideoControlProvider? _videoControlProvider;
  AudioManager? _audioManager;

  // late SharedPreferenceHelper _sharedPrefsHelper;
  bool isAudioOnly = false;
  late Widget videoWidget;
  late Widget portraitPage;
  late Widget fullscreenPage;

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  void dispose() {
    if (_videoPlayerController?.value.isPlaying == true) playAudio();
    _videoPlayerController?.dispose();
    _playerStore?.playerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: _buildBody(),
    );
  }

  Widget _buildBody() {
    portraitPage = _portraitPage();
    fullscreenPage = _fullscreenPage();
    return Material(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: _buildMainContent());
  }

  Widget _buildMainContent() {
    return Consumer<VideoControlProvider>(builder: (context, data, child) {
      return data.isFullScreen ? fullscreenPage : portraitPage;
    });
  }

  Widget _portraitPage() {
    return SafeArea(
        top: true,
        bottom: true,
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              _buildVideoPlayer(),
              SizedBox(height: 12),
              VideoInfo(infoItem: widget.video, onMoreDetails: () {}),
              Divider(height: 1),
              ChannelInfo(video: widget.video),
              Divider(height: 1),
              SizedBox(height: 12),
              StreamsListTile(
                video: widget.video,
                isFirstLoad: true,
                removePhysics: true,
                onTap: (video, index) async {
                  _videoPlayerController?.dispose();
                  // _audioManager?.dispose();
                  widget.video = video;
                  init();
                  setState(() {});
                },
              ),
            ],
          ),
        ));
  }

  Widget _fullscreenPage() {
    return MeasureSize(onChange: (Size size) {}, child: _buildVideoPlayer());
  }

  void init() {
    _audioManager = getIt<AudioManager>();
    _audioManager?.pause();
    _videoControlProvider =
        Provider.of<VideoControlProvider>(context, listen: false);
    _videoPlayerController = null;
    _exploreStore = Provider.of<ExploreStore>(context, listen: false);
    // check to see if already called api
    if (!_exploreStore.loading) {
      _exploreStore.videoStreamUrl = null;
      _exploreStore.getVideoStreamUrl(widget.video.id ?? "");
    }

    _playerStore = Provider.of<PlayerStore>(context, listen: false);
    _playerStore?.playerController = null;
  }

  void initializePlayer(String? url) {
    if (url != null) {
      _videoPlayerController = VideoPlayerController.network(url);

      _playerStore?.initVideoPlayerControl(_videoPlayerController!);
    }
    _videoPlayerController?.addListener(videoListener);
  }

  void initializeAudio(String? url) {
    if (url != null) {
      _audioManager?.addMediaItem(url, widget.video);
    }
  }

  Widget _buildVideoPlayer() => Observer(
        builder: (context) {
          if (_playerStore?.playerController == null &&
              !isAudioOnly &&
              _playerStore!.errorStore.errorMessage.isEmpty) {
            initializePlayer(_exploreStore.videoStreamUrl);
            initializeAudio(_exploreStore.audioStreamUrl);
          }
          if (_playerStore!.errorStore.errorMessage.isNotEmpty &&
              _playerStore?.playerController?.dataSource !=
                  _exploreStore.audioStreamUrl) {
            initializePlayer(_exploreStore.audioStreamUrl);
            isAudioOnly = true;
          }

          return OrientationBuilder(builder: (context, orientation) {
            return Stack(
              alignment: orientation == Orientation.portrait
                  ? Alignment.topCenter
                  : Alignment.center,
              children: [
                if (_playerStore?.playerController?.value.isInitialized == true)
                  AspectRatio(
                      aspectRatio:
                          _playerStore!.playerController!.value.aspectRatio,
                      child: VideoPlayer(_playerStore!.playerController!)),
                if (_playerStore?.playerController?.value.isInitialized != true)
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Stack(
                      children: [
                        Thumbnail(
                            ratio: 16 / 9,
                            url: widget.video.thumbnailUrl ?? ""),
                        Container(
                          alignment: Alignment.center,
                          child: CupertinoActivityIndicator(),
                        ),
                      ],
                    ),
                  ),
                if (_playerStore?.playerController?.value.isInitialized == true)
                  CupertinoControls(
                    thumbnailUrl: widget.video.thumbnailUrl ?? "",
                    iconColor: Color.fromARGB(255, 200, 200, 200),
                    controller: _videoPlayerController!,
                    isAudioOnly: isAudioOnly,
                  )
              ],
            );
          });
        },
      );

  void videoListener() {
    final currentPosition = _videoPlayerController?.value.position ?? Duration();
    if (currentPosition != Duration()) _audioManager?.currentVideo?.lastDuration = currentPosition;
    if (_videoPlayerController?.value.isInitialized == true &&
        currentPosition >= _videoPlayerController!.value.duration) {
      _videoControlProvider?.setVideoStatusEnd(true);
    }

    VideoDurationChange durationChange =
        Provider.of<VideoDurationChange>(context, listen: false);
    durationChange.onChange();

    if (currentPosition != Duration() &&
        _videoPlayerController?.value.isPlaying == false &&
        _videoControlProvider?.isUserAction == false) {
      playAudio();
    } else if (_videoPlayerController?.value.isPlaying == true &&
        _videoControlProvider?.isUserAction == false && _audioManager?.isPlaying == true) {
      _audioManager?.pause();
      _videoPlayerController?.seekTo(_audioManager?.currentPlaybackPosition ?? Duration());
      _videoControlProvider?.setUserAction(false);
    }
  }

  void playAudio() {
    if (_audioManager?.isPlaying == false) {
      _audioManager?.seek(_videoPlayerController?.value.position ?? Duration());
      _audioManager?.play();
      _videoControlProvider?.setUserAction(false);
    }
  }
}
