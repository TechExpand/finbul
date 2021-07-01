import 'dart:async';
import 'package:audioplayer/audioplayer.dart';
import 'package:flutter/material.dart';

typedef void OnError(Exception exception);

enum PlayerState { stopped, playing, paused }

class AudioApp extends StatefulWidget {
  final kUrl;
  final tag;
  AudioApp({this.kUrl, this.tag});

  @override
  _AudioAppState createState() => _AudioAppState();
}

class _AudioAppState extends State<AudioApp> {
  Duration duration;
  Duration position;

  AudioPlayer audioPlayer;

  String localFilePath;

  PlayerState playerState = PlayerState.stopped;

  get isPlaying => playerState == PlayerState.playing;
  get isPaused => playerState == PlayerState.paused;

  get durationText =>
      duration != null ? duration.toString().split('.').first : '';

  get positionText =>
      position != null ? position.toString().split('.').first : '';

  bool isMuted = false;

  StreamSubscription _positionSubscription;
  StreamSubscription _audioPlayerStateSubscription;

  @override
  void initState() {
    super.initState();
    initAudioPlayer();
  }

  @override
  void dispose() {
    _positionSubscription.cancel();
    _audioPlayerStateSubscription.cancel();
    audioPlayer.stop();
    super.dispose();
  }

  void initAudioPlayer() {
    audioPlayer = AudioPlayer();
    _positionSubscription = audioPlayer.onAudioPositionChanged
        .listen((p) => setState(() => position = p));
    _audioPlayerStateSubscription =
        audioPlayer.onPlayerStateChanged.listen((s) {
      if (s == AudioPlayerState.PLAYING) {
        setState(() => duration = audioPlayer.duration);
      } else if (s == AudioPlayerState.STOPPED) {
        onComplete();
        setState(() {
          position = duration;
        });
      }
    }, onError: (msg) {
      setState(() {
        playerState = PlayerState.stopped;
        duration = Duration(seconds: 0);
        position = Duration(seconds: 0);
      });
    });
  }

  Future play() async {
    await audioPlayer.play(widget.kUrl);
    setState(() {
      playerState = PlayerState.playing;
    });
  }

  Future pause() async {
    await audioPlayer.pause();
    setState(() => playerState = PlayerState.paused);
  }

  Future stop() async {
    await audioPlayer.stop();
    setState(() {
      playerState = PlayerState.stopped;
      position = Duration();
    });
  }

  Future mute(bool muted) async {
    await audioPlayer.mute(muted);
    setState(() {
      isMuted = muted;
    });
  }

  void onComplete() {
    setState(() => playerState = PlayerState.stopped);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
          backgroundColor: Colors.black,
          leading: IconButton(
            icon:Icon(Icons.arrow_back),
            onPressed: (){
              Navigator.pop(context);
            },
          )
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Container(
            padding: EdgeInsets.all(3),
            margin: EdgeInsets.all(3),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8), color: Colors.white),
            height: 140,
            child: _buildPlayer),
      ),
    );
  }

  Widget get _buildPlayer => Container(
        padding: EdgeInsets.all(4.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
//            audioPlayer.loading
//                ? Text(
//                    'Loading...',
//                    style: TextStyle(
//                        fontWeight: FontWeight.bold, color: Colors.black),
//                  )
//                : Container(),
            if (duration != null)
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: Color(0xFF372C6A),
                  inactiveTrackColor: Color(0xFF372C6A),
                  trackShape: RoundedRectSliderTrackShape(),
                  trackHeight: 5.0,
                  thumbShape:
                  RoundSliderThumbShape(enabledThumbRadius: 12.0),
                  thumbColor: Color(0xFF5e5780),
                  overlayColor: Color(0xFF372C6A),
                  overlayShape:
                  RoundSliderOverlayShape(overlayRadius: 15.0),
                  tickMarkShape: RoundSliderTickMarkShape(),
                  activeTickMarkColor: Color(0xFF372C6A),
                  inactiveTickMarkColor:Color(0xFF372C6A),
                  valueIndicatorShape: PaddleSliderValueIndicatorShape(),
                  valueIndicatorColor: Color(0xFF5e5780),
                  valueIndicatorTextStyle: TextStyle(
                    color: Colors.white,
                  ),
                ),
                child: Slider(
                    value: position?.inMilliseconds?.toDouble() ?? 0.0,
                    onChanged: (double value) {
                      return audioPlayer.seek((value / 1000).roundToDouble());
                    },
                    min: 0.0,
                    max: duration.inMilliseconds.toDouble()),
              )
            else if (duration == null)
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: Color(0xFF372C6A),
                  inactiveTrackColor: Color(0xFF372C6A),
                  trackShape: RoundedRectSliderTrackShape(),
                  trackHeight: 5.0,
                  thumbShape:
                  RoundSliderThumbShape(enabledThumbRadius: 12.0),
                  thumbColor: Color(0xFF5e5780),
                  overlayColor: Color(0xFF372C6A),
                  overlayShape:
                  RoundSliderOverlayShape(overlayRadius: 15.0),
                  tickMarkShape: RoundSliderTickMarkShape(),
                  activeTickMarkColor: Color(0xFF372C6A),
                  inactiveTickMarkColor:Color(0xFF372C6A),
                  valueIndicatorShape: PaddleSliderValueIndicatorShape(),
                  valueIndicatorColor: Color(0xFF5e5780),
                  valueIndicatorTextStyle: TextStyle(
                    color: Colors.white,
                  ),
                ),
                child: Slider(
                  value: 0,
                  onChanged: (double value) {},
                  min: 0.0,
                  max: 10.0,
                ),
              ),
            if (position != null)
              _buildProgressView()
            else if (position == null)
              Row(mainAxisSize: MainAxisSize.min, children: [
                Text(
                  "0:00:00/0:00:00",
                  style: TextStyle(fontSize: 15.0, color: Colors.black),
                )
              ]),
            Padding(
              padding: const EdgeInsets.only(top: 1.0),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Container(
                  margin: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 7.0,
                        spreadRadius: 2.0,
                        offset:
                            Offset(5.0, 5.0), // shadow direction: bottom right
                      )
                    ],
                  ),
                  child: IconButton(
                    onPressed: isPlaying
                        ? null
                        : () {
                            play();
                          },
                    iconSize: 30.0,
                    icon: Hero(tag: widget.tag, child: Icon(Icons.play_arrow)),
                    color: Color(0xFF372C6A),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 7.0,
                        spreadRadius: 2.0,
                        offset:
                            Offset(5.0, 5.0), // shadow direction: bottom right
                      )
                    ],
                  ),
                  child: IconButton(
                    onPressed: isPlaying ? () => pause() : null,
                    iconSize: 30.0,
                    icon: Icon(Icons.pause),
                    color: Color(0xFF372C6A),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 7.0,
                        spreadRadius: 2.0,
                        offset:
                            Offset(5.0, 5.0), // shadow direction: bottom right
                      )
                    ],
                  ),
                  child: IconButton(
                    onPressed: isPlaying || isPaused ? () => stop() : null,
                    iconSize: 30.0,
                    icon: Icon(Icons.stop),
                    color: Color(0xFF372C6A),
                  ),
                ),
              ]),
            ),
          ],
        ),
      );

  Row _buildProgressView() => Row(mainAxisSize: MainAxisSize.min, children: [
        Text(
          position != null
              ? "${positionText ?? ''} / ${durationText ?? ''}"
              : duration != null
                  ? durationText
                  : '',
          style: TextStyle(fontSize: 15.0, color: Colors.black),
        )
      ]);
}
