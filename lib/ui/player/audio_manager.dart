import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

import '../../di/components/service_locator.dart';
import '../../events/audio_listening.dart';
import '../../events/my_event_bus.dart';
import '../../models/video_model.dart';

Future<void> initAudioService() async {
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.trangdv.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
}

class AudioManager {
  AudioPlayer _player = AudioPlayer();

  final _playlist = ConcatenatingAudioSource(children: []);

  get isPlaying => _player.playing;

  get currentPlaybackPosition => _player.position;

  Video? currentVideo;

  Future<void> addMediaItem(String audioUrl, Video video) async {
    try {
      currentVideo = null;
      _player.pause();

      _player
        ..playerStateStream.listen((event) {
          final _myEventBus = getIt<MyEventBus>();
          _myEventBus.eventBus.fire(AudioListeningEvent(event));
        })
        ..positionStream.listen((event) {
          if (event.inMilliseconds != 0 && this.isPlaying)
            currentVideo?.lastDuration = event;
        });

      _playlist.clear();
      _playlist.add(ClippingAudioSource(
          child: AudioSource.uri(Uri.parse(audioUrl)),
          tag: MediaItem(
            id: video.id ?? "",
            album: video.channelTitle,
            title: video.title ?? "",
            artUri: Uri.parse(video.thumbnailUrl ?? ""),
          )));

      currentVideo = video;
      await _player.setAudioSource(_playlist);
    } catch (e) {
      print("Error loading audio source: $e");
    }
  }

  void onPositionChange(Function(Duration) onChange) {
    _player.positionStream.listen((event) {
      if (event.inMilliseconds != 0 && this.isPlaying) {
        currentVideo?.lastDuration = event;
        onChange(event);
      }
    });
  }

  void play() => _player.play();

  void pause() => _player.pause();

  void stopPlayer() {
    _player.dispose();
    _player = AudioPlayer();
    currentVideo = null;
  }

  void seek(Duration position) => _player.seek(position);
}
