import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:mood_tunes/models/savn_search.dart';
import 'package:mood_tunes/models/song_detail_model.dart';
import 'package:mood_tunes/screens/singleton.dart';
import 'common.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';

class MainSongScreenSongDetail extends StatefulWidget {
  const MainSongScreenSongDetail({required this.songmodel_savn});
  final SongDetail songmodel_savn;
  @override
  MainSongScreenSongDetailState createState() =>
      MainSongScreenSongDetailState();
}

class MainSongScreenSongDetailState extends State<MainSongScreenSongDetail>
    with WidgetsBindingObserver {
  late String songlink;
  late AudioPlayerSingleton _audioPlayerSingleton;

  // init method
  @override
  void initState() {
    super.initState();

    // WidgetsBinding.instance?.addObserver(this);
    _audioPlayerSingleton = AudioPlayerSingleton();

    _player = _audioPlayerSingleton.audioPlayer;
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.black,
    ));
    songlink = widget.songmodel_savn.downloadUrl[2].link;
    a1 = AudioSource.uri(
      Uri.parse(songlink),
      tag: MediaItem(
        id: '${_nextMediaId++}',
        album: widget.songmodel_savn.album.name,
        title: widget.songmodel_savn.name,
        artUri: Uri.parse(
          widget.songmodel_savn.image[2].link,
        ),
      ),
    );
    // _player.play(); // Add this line to start playing when the screen opens

    _init();
    _audioPlayerSingleton.playNewSong(a1);
  }

  static int _nextMediaId = 0;
  late AudioPlayer _player;
  late AudioSource a1;
  late final _playlist = ConcatenatingAudioSource(children: [
    a1,
  ]);

  int _addedCount = 0;

  Future<void> _init() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.speech());
    // Listen to errors during playback.
    _player.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace stackTrace) {
      print('A stream error occurred: $e');
    });
    try {
      await _player.setAudioSource(_playlist);
    } catch (e, stackTrace) {
      // Catch load errors: 404, invalid url ...
      print("Error loading playlist: $e");
      print(stackTrace);
    }
  }

  @override
  void dispose() {
    // WidgetsBinding.instance?.removeObserver(this);

    // _player.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      _player.setAutomaticallyWaitsToMinimizeStalling(false);
      _player.play();
    } else {
      _player.setAutomaticallyWaitsToMinimizeStalling(true);
      _player.pause();
    }
  }

  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          _player.positionStream,
          _player.bufferedPositionStream,
          _player.durationStream,
          (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.blueGrey[900],
        body: Padding(
          padding: const EdgeInsets.only(
              top: 40.0, left: 8.0, right: 8.0, bottom: 138.0),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: StreamBuilder<SequenceState?>(
                    stream: _player.sequenceStateStream,
                    builder: (context, snapshot) {
                      final state = snapshot.data;
                      if (state?.sequence.isEmpty ?? true) {
                        return const SizedBox();
                      }
                      final metadata = state!.currentSource!.tag as MediaItem;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                  child: Image.network(
                                      metadata.artUri.toString())),
                            ),
                          ),
                          Text(
                            metadata.title,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                          const SizedBox(height: 8.0),
                          Text(metadata.album!,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12)),
                        ],
                      );
                    },
                  ),
                ),
                ControlButtons(_player),
                StreamBuilder<PositionData>(
                  stream: _positionDataStream,
                  builder: (context, snapshot) {
                    final positionData = snapshot.data;
                    return SeekBar(
                      duration: positionData?.duration ?? Duration.zero,
                      position: positionData?.position ?? Duration.zero,
                      bufferedPosition:
                          positionData?.bufferedPosition ?? Duration.zero,
                      onChangeEnd: (newPosition) {
                        _player.seek(newPosition);
                      },
                    );
                  },
                ),
                const SizedBox(height: 8.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ControlButtons extends StatelessWidget {
  final AudioPlayer player;

  const ControlButtons(this.player, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          color: Colors.amber[600],
          icon: const Icon(Icons.volume_up),
          onPressed: () {
            showSliderDialog(
              value: player.volume,
              context: context,
              title: "Adjust volume",
              divisions: 10,
              min: 0.0,
              max: 1.0,
              stream: player.volumeStream,
              onChanged: player.setVolume,
            );
          },
        ),
        StreamBuilder<SequenceState?>(
          stream: player.sequenceStateStream,
          builder: (context, snapshot) => IconButton(
            color: player.hasPrevious ? Colors.amber[600] : Colors.indigo,
            icon: const Icon(Icons.skip_previous_rounded),
            iconSize: 50,
            onPressed: player.hasPrevious ? player.seekToPrevious : null,
          ),
        ),
        StreamBuilder<PlayerState>(
          stream: player.playerStateStream,
          builder: (context, snapshot) {
            final playerState = snapshot.data;
            final processingState = playerState?.processingState;
            final playing = playerState?.playing;
            if (processingState == ProcessingState.loading ||
                processingState == ProcessingState.buffering) {
              return Container(
                margin: const EdgeInsets.all(8.0),
                width: 64.0,
                height: 64.0,
                //color: Colors.grey[900],
                child: const CircularProgressIndicator(
                  color: Colors.amber,
                  backgroundColor: Colors.grey,
                ),
              );
            } else if (playing != true) {
              return IconButton(
                icon: const Icon(Icons.play_arrow),
                iconSize: 64.0,
                color: Colors.amber[600],
                onPressed: player.play,
              );
            } else if (processingState != ProcessingState.completed) {
              return IconButton(
                  icon: const Icon(Icons.pause_circle_filled_outlined),
                  iconSize: 64.0,
                  onPressed: player.pause,
                  color: Colors.amber[600],
                  style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                  ));
            } else {
              return IconButton(
                icon: const Icon(Icons.replay),
                iconSize: 64.0,
                color: Colors.amber[600],
                onPressed: () => player.seek(Duration.zero,
                    index: player.effectiveIndices!.first),
              );
            }
          },
        ),
        StreamBuilder<SequenceState?>(
          stream: player.sequenceStateStream,
          builder: (context, snapshot) => IconButton(
            icon: const Icon(Icons.skip_next),
            color: Colors.amber[600],
            iconSize: 50,
            onPressed: player.hasNext ? player.seekToNext : null,
          ),
        ),
        StreamBuilder<double>(
          stream: player.speedStream,
          builder: (context, snapshot) => IconButton(
            color: Colors.amber[600],
            icon: Text("${snapshot.data?.toStringAsFixed(1)}x",
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.amber)),
            onPressed: () {
              showSliderDialog(
                value: player.speed,
                context: context,
                title: "Adjust speed",
                divisions: 10,
                min: 0.5,
                max: 1.5,
                stream: player.speedStream,
                onChanged: player.setSpeed,
              );
            },
          ),
        ),
      ],
    );
  }
}
