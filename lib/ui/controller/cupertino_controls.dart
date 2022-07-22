import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:provider/provider.dart';
import '../../di/components/service_locator.dart';
import '../../provider/video_control.dart';
import '../../provider/video_duration_change.dart';
import '../../utils/strings.dart';
import '../components/thumbnail.dart';
import '../player/audio_manager.dart';
import 'center_play_button.dart';
import 'cupertino_progress_bar.dart';
import 'player_progress_colors.dart';

class CupertinoControls extends StatefulWidget {
  const CupertinoControls({
    required this.thumbnailUrl,
    required this.iconColor,
    required this.controller,
    required this.isAudioOnly,
    Key? key,
  }) : super(key: key);

  final String thumbnailUrl;
  final Color iconColor;
  final bool isAudioOnly;
  final VideoPlayerController controller;

  @override
  State<StatefulWidget> createState() {
    return _CupertinoControlsState();
  }
}

class _CupertinoControlsState extends State<CupertinoControls>
    with SingleTickerProviderStateMixin {
  double? _latestVolume;
  Timer? _hideTimer;
  final marginSize = 5.0;

  bool _dragging = false;
  bool _isShowControl = true;
  bool _isAudioOnlyRunning = false;
  late VideoControlProvider _videoControlProvider;

  @override
  void initState() {
    super.initState();
    _startHideTimer();
    seek2LastPosition();
  }

  @override
  Widget build(BuildContext context) {
    _videoControlProvider =
        Provider.of<VideoControlProvider>(context, listen: false);
    if (widget.controller.value.hasError) {
      return Container(
        alignment: Alignment.center,
        child: Icon(
          CupertinoIcons.exclamationmark_circle,
          color: Colors.white,
          size: 42,
        ),
      );
    }

    return _buildContent();
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    super.dispose();
  }

  Widget _buildContent() {
    final orientation = MediaQuery.of(context).orientation;
    final backgroundColor = Color.fromRGBO(41, 41, 41, 0.7);
    final iconColor = widget.iconColor;
    final barHeight = orientation == Orientation.portrait ? 30.0 : 47.0;
    final buttonPadding = orientation == Orientation.portrait ? 16.0 : 24.0;
    if (_videoControlProvider.isEnd) _isShowControl = true;
    return AspectRatio(
      aspectRatio: widget.controller.value.aspectRatio,
      child: Stack(
        children: [
          if (widget.isAudioOnly)
            Thumbnail(ratio: 16 / 9, url: widget.thumbnailUrl),
          if (_isAudioOnlyRunning || _videoControlProvider.isEnd)
            Thumbnail(
                ratio: widget.controller.value.aspectRatio,
                url: widget.thumbnailUrl),
          Container(
            child: GestureDetector(
              onTap: () {
                _isShowControl = !_isShowControl;
                _cancelAndRestartTimer();
                setState(() {});
              },
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _buildTopBar(
                backgroundColor,
                iconColor,
                barHeight,
                buttonPadding,
              ),
              _buildHitArea(barHeight, backgroundColor),
              _buildBottomBar(
                  backgroundColor, iconColor, barHeight, buttonPadding),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildBottomBar(Color backgroundColor, Color iconColor,
      double barHeight, double buttonPadding) {
    return AnimatedOpacity(
      opacity: _isShowControl ? 1 : 0,
      duration: const Duration(milliseconds: 300),
      child: Container(
        color: Colors.transparent,
        alignment: Alignment.bottomCenter,
        margin: EdgeInsets.all(marginSize),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: BackdropFilter(
            filter: ui.ImageFilter.blur(
              sigmaX: 10.0,
              sigmaY: 10.0,
            ),
            child: Container(
              height: barHeight,
              color: backgroundColor,
              child: false
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        _buildPlayPause(
                            widget.controller, iconColor, barHeight),
                        _buildLive(iconColor),
                      ],
                    )
                  : Row(
                      children: <Widget>[
                        // _buildSkipBack(iconColor, barHeight),
                        /*_buildPlayPause(
                            widget.controller, iconColor, barHeight),*/
                        // _buildSkipForward(iconColor, barHeight),
                        _buildPosition(iconColor),
                        _buildProgressBar(),
                        _buildRemaining(iconColor),
                        _buildExpandButton(
                          backgroundColor,
                          iconColor,
                          barHeight,
                          buttonPadding,
                        )
                        // _buildSubtitleToggle(iconColor, barHeight),
                        //   _buildSpeedButton(widget.controller, iconColor, barHeight),
                        // _buildOptionsButton(iconColor, barHeight),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLive(Color iconColor) {
    return Padding(
      padding: const EdgeInsets.only(right: 12.0),
      child: Text(
        'LIVE',
        style: TextStyle(color: iconColor, fontSize: 12.0),
      ),
    );
  }

  GestureDetector _buildExpandButton(
    Color backgroundColor,
    Color iconColor,
    double barHeight,
    double buttonPadding,
  ) {
    VideoControlProvider videoControlProvider =
        Provider.of<VideoControlProvider>(context);
    return GestureDetector(
      onTap: _onExpandCollapse,
      child: AnimatedOpacity(
        opacity: _isShowControl ? 1 : 0,
        duration: const Duration(milliseconds: 300),
        child: Container(
          height: barHeight,
          padding: EdgeInsets.only(
            left: buttonPadding,
            right: buttonPadding,
          ),
          color: Colors.transparent,
          child: Center(
            child: Icon(
              videoControlProvider.isFullScreen
                  ? CupertinoIcons.arrow_down_right_arrow_up_left
                  : CupertinoIcons.arrow_up_left_arrow_down_right,
              color: iconColor,
              size: 16,
            ),
          ),
        ),
      ),
    );
  }

  GestureDetector _buildMuteButton(
    VideoPlayerController controller,
    Color backgroundColor,
    Color iconColor,
    double barHeight,
    double buttonPadding,
  ) {
    return GestureDetector(
      onTap: () {
        if (_isShowControl) {
          if (widget.controller.value.volume == 0) {
            controller.setVolume(_latestVolume ?? 0.5);
          } else {
            _latestVolume = controller.value.volume;
            controller.setVolume(0.0);
          }
        } else {
          setState(() {
            _isShowControl = true;
          });
        }
        _cancelAndRestartTimer();
      },
      child: AnimatedOpacity(
        opacity: _isShowControl ? 1 : 0,
        duration: const Duration(milliseconds: 300),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: 10.0),
            child: Container(
              color: backgroundColor,
              child: Container(
                height: barHeight,
                padding: EdgeInsets.only(
                  left: buttonPadding,
                  right: buttonPadding,
                ),
                child: Icon(
                  widget.controller.value.volume > 0
                      ? Icons.volume_up
                      : Icons.volume_off,
                  color: iconColor,
                  size: 16,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  GestureDetector _buildIconBack(double barHeight, Color backgroundColor) {
    return GestureDetector(
        onTap: () {
          if (_isShowControl) {
            Navigator.pop(context);
          } else {
            setState(() {
              _isShowControl = true;
            });
          }
        },
        child: Container(
          height: barHeight,
          decoration: BoxDecoration(
            color: backgroundColor,
            shape: BoxShape.circle,
          ),
          padding: const EdgeInsets.only(
            left: 6.0,
            right: 6.0,
          ),
          child: Icon(
            Icons.keyboard_arrow_down,
            color: widget.iconColor,
            size: 20,
          ),
        ));
  }

  GestureDetector _buildPlayPause(
    VideoPlayerController controller,
    Color iconColor,
    double barHeight,
  ) {
    return GestureDetector(
      onTap: _playPauseAudioOnly,
      child: Container(
        height: barHeight,
        color: Colors.transparent,
        padding: const EdgeInsets.only(
          left: 6.0,
          right: 6.0,
        ),
        child: Icon(
          _isAudioOnlyRunning
              ? Icons.music_note_outlined
              : Icons.music_off_outlined,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }

  Widget _buildPosition(Color iconColor) {
    return Consumer<VideoDurationChange>(builder: (context, data, child) {
      final position = widget.controller.value.position;

      return Padding(
        padding: const EdgeInsets.only(left: 12.0, right: 12.0),
        child: Text(
          formatDuration(position),
          style: TextStyle(
            color: iconColor,
            fontSize: 12.0,
          ),
        ),
      );
    });
  }

  Widget _buildRemaining(Color iconColor) {
    return Consumer<VideoDurationChange>(builder: (context, data, child) {
      final position =
          widget.controller.value.duration - widget.controller.value.position;

      return Padding(
        padding: const EdgeInsets.only(right: 0),
        child: Text(
          '-${formatDuration(position)}',
          style: TextStyle(color: iconColor, fontSize: 12.0),
        ),
      );
    });
  }

  GestureDetector _buildSkipBack(
      Color iconColor, double barHeight, Color backgroundColor) {
    return GestureDetector(
        onTap: _skipBack,
        child: AnimatedOpacity(
          opacity: _isShowControl ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 300),
          child: Container(
            height: barHeight,
            margin: const EdgeInsets.only(right: 16.0),
            decoration: BoxDecoration(
              color: backgroundColor,
              shape: BoxShape.circle,
            ),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Icon(
                CupertinoIcons.gobackward_15,
                color: iconColor,
                size: 18.0,
              ),
            ),
          ),
        ));
  }

  GestureDetector _buildSkipForward(
      Color iconColor, double barHeight, Color backgroundColor) {
    return GestureDetector(
      onTap: _skipForward,
      child: AnimatedOpacity(
        opacity: _isShowControl ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 300),
        child: Container(
          height: barHeight,
          margin: const EdgeInsets.only(
            left: 16.0,
          ),
          decoration: BoxDecoration(
            color: backgroundColor,
            shape: BoxShape.circle,
          ),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Icon(
              CupertinoIcons.goforward_15,
              color: iconColor,
              size: 18.0,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(
    Color backgroundColor,
    Color iconColor,
    double barHeight,
    double buttonPadding,
  ) {
    return Opacity(
      opacity: _isShowControl ? 1 : 0,
      child: Container(
        height: barHeight,
        margin: EdgeInsets.only(
          top: marginSize,
          right: marginSize,
          left: marginSize,
        ),
        child: Row(
          children: <Widget>[
            if (true) _buildIconBack(barHeight, backgroundColor),
            const Spacer(),
            if (true)
              _buildMuteButton(
                widget.controller,
                backgroundColor,
                iconColor,
                barHeight,
                buttonPadding,
              ),
          ],
        ),
      ),
    );
  }

  void _cancelAndRestartTimer() {
    _hideTimer?.cancel();

    setState(() {
      _startHideTimer();
    });
  }

  void _onExpandCollapse() {
    if (_isShowControl) {
      VideoControlProvider videoControlProvider =
          Provider.of<VideoControlProvider>(context, listen: false);
      videoControlProvider.setUserAction(true);
      final orientation = MediaQuery.of(context).orientation;
      if (orientation == Orientation.portrait) {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ]);
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
        videoControlProvider.toggleFullScreen();
      } else {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]);
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
            overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
        videoControlProvider.exitFullScreen();
      }
    } else {
      setState(() {
        _isShowControl = true;
      });
    }
    _cancelAndRestartTimer();
  }

  Widget _buildProgressBar() {
    return Consumer<VideoDurationChange>(builder: (context, data, child) {
      return Expanded(
        child: Padding(
          padding: const EdgeInsets.only(right: 12.0),
          child: Visibility(
            visible: _isShowControl,
            child: CupertinoVideoProgressBar(
              widget.controller,
              onDragStart: () {
                setState(() {
                  _dragging = true;
                });

                // _hideTimer?.cancel();
              },
              onDragEnd: () {
                setState(() {
                  _dragging = false;
                });

                // _startHideTimer();
              },
              onSeekChange: () {
                if (_isAudioOnlyRunning) {
                  final _audioManager = getIt<AudioManager>();
                  _audioManager.pause();
                  _audioManager.seek(widget.controller.value.position);
                  Future.delayed(Duration(milliseconds: 200), () {
                    _audioManager.play();
                  });
                }
              },
              colors: PlayerProgressColors(
                playedColor: const Color.fromARGB(
                  120,
                  255,
                  255,
                  255,
                ),
                handleColor: const Color.fromARGB(
                  255,
                  255,
                  255,
                  255,
                ),
                bufferedColor: const Color.fromARGB(
                  60,
                  255,
                  255,
                  255,
                ),
                backgroundColor: const Color.fromARGB(
                  20,
                  255,
                  255,
                  255,
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  void _skipBack() {
    if (_isShowControl) {
      _handleCaseAudioRunning();
      final beginning = Duration.zero.inMilliseconds;
      final skip =
          (widget.controller.value.position - const Duration(seconds: 15))
              .inMilliseconds;
      final duration = Duration(milliseconds: math.max(skip, beginning));
      if (_isAudioOnlyRunning) {
        final _audioManager = getIt<AudioManager>();
        _audioManager.seek(duration);
      } else {
        widget.controller.seekTo(duration);
      }
    } else {
      setState(() {
        _isShowControl = true;
      });
    }
    _cancelAndRestartTimer();
  }

  void _skipForward() {
    if (_isShowControl) {
      final end = widget.controller.value.duration.inMilliseconds;
      final skip =
          (widget.controller.value.position + const Duration(seconds: 15))
              .inMilliseconds;
      final duration = Duration(milliseconds: math.min(skip, end));
      if (_isAudioOnlyRunning) {
        final _audioManager = getIt<AudioManager>();
        _audioManager.seek(duration);
      } else {
        widget.controller.seekTo(duration);
      }
    } else {
      setState(() {
        _isShowControl = true;
      });
    }
    _cancelAndRestartTimer();
  }

  void _startHideTimer() {
    _hideTimer = Timer(const Duration(seconds: 4), () {
      _isShowControl = false;
      setState(() {});
    });
  }

  Widget _buildHitArea(double barHeight, Color backgroundColor) {
    final bool isFinished =
        widget.controller.value.position >= widget.controller.value.duration;
    return AnimatedOpacity(
      opacity: _isShowControl ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 300),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildSkipBack(widget.iconColor, barHeight, backgroundColor),
          CenterPlayButton(
            backgroundColor: Color.fromRGBO(41, 41, 41, 0.7),
            iconColor: widget.iconColor,
            isFinished: isFinished,
            isPlaying: widget.controller.value.isPlaying,
            show: !_dragging,
            onPressed: _playPause,
          ),
          _buildSkipForward(widget.iconColor, barHeight, backgroundColor)
        ],
      ),
    );
  }

  void _playPause() {
    if (_isShowControl) {
      _videoControlProvider.setUserAction(true);
      if (widget.controller.value.isPlaying) {
        widget.controller.pause();
      } else {
        widget.controller.play();
        if (_videoControlProvider.isEnd) {
          _videoControlProvider.setVideoStatusEnd(false);
        }
      }
    } else {
      setState(() {
        _isShowControl = true;
      });
    }
    _cancelAndRestartTimer();
  }

  void _playPauseAudioOnly() {
    if (_isShowControl) {
      _isAudioOnlyRunning = !_isAudioOnlyRunning;
      _isAudioOnlyRunning ? _handlePlayAudio() : _handlePauseAudio();
      _cancelAndRestartTimer();
    } else {
      setState(() {
        _isShowControl = true;
      });
    }
  }

  void _handlePlayAudio() {
    final _audioManager = getIt<AudioManager>();
    _audioManager.onPositionChange(_onAudioPlayerChange);
    widget.controller.pause();
    _audioManager.seek(widget.controller.value.position);
    _audioManager.play();
    // _videoControlProvider.setUserAction(true);
  }

  void _handlePauseAudio() {
    _videoControlProvider.setUserAction(true);
    final _audioManager = getIt<AudioManager>();
    _audioManager.pause();
    widget.controller.seekTo(_audioManager.currentPlaybackPosition);
    widget.controller.play();
  }

  void seek2LastPosition() {
    final _audioManager = getIt<AudioManager>();
    if (_audioManager.currentVideo?.lastDuration != null) {
      widget.controller
        ..pause()
        ..seekTo(_audioManager.currentVideo?.lastDuration ?? Duration())
        ..play();
    }
  }

  void _onAudioPlayerChange(value) {
    if (_isAudioOnlyRunning) widget.controller.seekTo(value);
  }

  void _handleCaseAudioRunning() {
    if (_isAudioOnlyRunning) {
      final _audioManager = getIt<AudioManager>();
      _audioManager.pause();
      Future.delayed(Duration(milliseconds: 400), () {
        _audioManager.play();
      });
    }
  }
}
