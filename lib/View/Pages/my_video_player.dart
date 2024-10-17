import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayer extends StatefulWidget {
  // ignore: use_key_in_widget_constructor


  final String url;
  final bool? isAssetsFile;

  const VideoPlayer({Key? key, required this.url,  this.isAssetsFile=false}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _VideoPlayerState();
  }
}

class _VideoPlayerState extends State<VideoPlayer> {
  VideoPlayerController? _videoPlayerController1;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    initializePlayer();
  }

  @override
  void dispose() {
    _videoPlayerController1!.dispose();
    _chewieController!.dispose();
    super.dispose();
  }

  Future<void> initializePlayer() async {
    _videoPlayerController1 = (widget.isAssetsFile??false)? VideoPlayerController.asset(widget.url):VideoPlayerController.network(widget.url);
    await Future.wait([
      _videoPlayerController1!.initialize(),
    ]);
    _chewieController = ChewieController(materialProgressColors:ChewieProgressColors(backgroundColor: Colors.grey),
      showControls: true,
      videoPlayerController: _videoPlayerController1!,
      autoPlay: true,
      looping: false,
      // aspectRatio: 16 / 9,
      fullScreenByDefault: false,

      // Try playing around with some of these other options:


      // materialProgressColors: ChewieProgressColors(
      //   playedColor: Colors.red,
      //   handleColor: Colors.blue,
      //   backgroundColor: Colors.grey,
      //
      //   bufferedColor: Colors.lightGreen,
      // ),
      placeholder: Container(
        color: Colors.black,
      ),
      autoInitialize: true,
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(color: Colors.blue,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(title: Text((widget.url??'').toString().split('/').last)),
          body: Container(
            color: Colors.black,

            child: Column(
              children: <Widget>[
                Expanded(
                  child: Stack(
                    children: [
                      Center(
                          child: _chewieController != null &&
                              _chewieController!
                                  .videoPlayerController.value.isInitialized
                              ? Chewie(
                            controller: _chewieController!,
                          )
                              : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                CircularProgressIndicator(),
                                SizedBox(height: 20),
                                Text('Loading'),
                              ]
                          )
                      ),

                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
