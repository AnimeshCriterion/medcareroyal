import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

class AudioPlayerScreen extends StatefulWidget {
  final String audioUrl;

  const AudioPlayerScreen({Key? key, required this.audioUrl}) : super(key: key);
  @override
  _AudioPlayerScreenState createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
  final _player = AudioPlayer();
  bool isPlaying = false;

  bool isPlayingsss = false;
  @override
  void initState() {
    super.initState();
    _player.setUrl(widget.audioUrl); // Example URL
    _player.play();
    _player.playerStateStream.listen((state) {
      setState(() {
        isPlaying = state.playing;
      });
    });
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Audio Player'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // SeekBar with Timer
            StreamBuilder<Duration?>(
              stream: _player.durationStream,
              builder: (context, snapshot) {
                final duration = snapshot.data ?? Duration.zero;
                return StreamBuilder<Duration>(
                  stream: _player.positionStream,
                  builder: (context, snapshot) {
                    var position = snapshot.data ?? Duration.zero;
                    if (position > duration) {
                      position = duration;
                    }
                    return Column(
                      children: [
                        SeekBar(
                          duration: duration,
                          position: position,
                          onChanged: (newPosition) {
                            _player.seek(newPosition);
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            '${_formatDuration(position)} / ${_formatDuration(duration)}',
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            SizedBox(height: 30.0),
            // Playback Toggle Button
            IconButton(
              iconSize: 64.0,
              icon: Icon(isPlaying ? Icons.stop : Icons.play_arrow),
              onPressed: () {
                if (isPlaying) {
                  _player.stop();
                } else {
                  _player.play();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  // Function to format Duration as MM:SS
  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}

class SeekBar extends StatelessWidget {
  final Duration duration;
  final Duration position;
  final ValueChanged<Duration> onChanged;

  SeekBar({
    required this.duration,
    required this.position,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Slider(
      min: 0.0,
      max: duration.inMilliseconds.toDouble(),
      value: position.inMilliseconds.toDouble(),
      onChanged: (value) {
        onChanged(Duration(milliseconds: value.round()));
      },
    );
  }
}