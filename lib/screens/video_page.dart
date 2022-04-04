import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_video_info/flutter_video_info.dart';
class VideoPage extends StatefulWidget {
  final String filePath;

  const VideoPage({Key? key, required this.filePath}) : super(key: key);

  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  late VideoPlayerController _videoPlayerController;
  final videoInfo = FlutterVideoInfo();
  late VideoData data;
  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  Future _initVideoPlayer() async {
    _videoPlayerController = VideoPlayerController.file(File(widget.filePath));
    await _videoPlayerController.initialize();
    await _videoPlayerController.setLooping(true);
    await _videoPlayerController.play();
  }

  getInfo() async {
    var info = await videoInfo.getVideoInfo(widget.filePath);
    return info;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preview'),
        elevation: 0,
        backgroundColor: Colors.black26,
        actions: [
          IconButton(
            icon: const Icon(Icons.info),
            onPressed: () async {
              data = await getInfo();
              print('width ' + data.width.toString());
              print('filesize ' + data.filesize.toString());
              showDialog(
      context: context,
      builder: (BuildContext context) {
        return  AlertDialog(
                title: Center(child: Text('Информация')),
                content: Container(
                  width: 150,
                  height: 100,
                  child: Center(
                    child: Column(children: [
                    Text('размер ' + (data.filesize! / 1000000).toString()),
                    Text('ширина ' + data.width.toString()),
                    Text('высота ' + data.height.toString()),
                    Text('длительность ' + (data.duration! / 1000).toString()),
                    ],),
                  ),
                ),);
      });
            },
          )
        ],
      ),
      extendBodyBehindAppBar: true,
      body: FutureBuilder(
        future: _initVideoPlayer(),
        builder: (context, state) {
          if (state.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return VideoPlayer(_videoPlayerController);
          }
        },
      ),
    );
  }
}