import 'package:just_audio/just_audio.dart';

class AudioPlayerSingleton {
  static final AudioPlayerSingleton _singleton =
      AudioPlayerSingleton._internal();

  factory AudioPlayerSingleton() {
    return _singleton;
  }

  AudioPlayer _audioPlayer = AudioPlayer();

  AudioPlayer get audioPlayer => _audioPlayer;

  void playNewSong(AudioSource source) {
    _audioPlayer.stop();
    _audioPlayer.setAudioSource(source);
    _audioPlayer.play();
  }

  AudioPlayerSingleton._internal();
}
