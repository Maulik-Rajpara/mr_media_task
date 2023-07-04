import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';



/// Stateful widget to fetch and then display video content.
class VideoPlayerScreen extends StatefulWidget {
  final String? sourceUrl;
   const VideoPlayerScreen(this.sourceUrl,{super.key,});

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  dynamic playerWidget;
  dynamic chewieController;
  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(
        widget.sourceUrl!))
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
        chewieController = ChewieController(
        videoPlayerController: _controller,
        autoPlay: true,
        looping: true,
        );
      });



  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Video player")),
      backgroundColor: Colors.black,
      body: Center(
       /* child: _controller.value.isInitialized
            ? AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: VideoPlayer(_controller),
        )
            : Container(),*/
        child: playerWidget==null && chewieController==null?Container():
          Chewie(
          controller: chewieController,
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    if(chewieController!=null){
      chewieController.dispose();
    }
  }
}