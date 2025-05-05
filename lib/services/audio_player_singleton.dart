import 'package:audioplayers/audioplayers.dart';

class AudioPlayerSingleton {
  // Private constructor
  AudioPlayerSingleton._internal();

  // The single instance of AudioPlayer
  static final AudioPlayer _audioPlayer = AudioPlayer();

  // Getter to access the instance
  static AudioPlayer get instance => _audioPlayer;
}
