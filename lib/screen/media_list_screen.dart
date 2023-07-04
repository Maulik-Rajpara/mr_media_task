
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:practical/constant/api_constant.dart';
import 'package:practical/controller/media_controller.dart';
import 'package:practical/helper/permission_helper.dart';
import 'package:practical/model/media_model.dart';

import '../model/download_status.dart';

class MediaListScreen extends StatefulWidget {
  @override
  _MediaListScreenState createState() => _MediaListScreenState();
}

class _MediaListScreenState extends State<MediaListScreen> {
  MediaListController controller = Get.put(MediaListController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchDataFromApi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Media List'),
      ),
      body: SizedBox(
          width: Get.width,
          height: Get.height,
          child: GetBuilder<MediaListController>(
            builder: (c) {
              return c.isLoadMediaProgress!?
              const Center(child: CircularProgressIndicator()):
              (c.videoList.isNotEmpty?
              ListView.builder(
                itemCount: c.videoList.length,
                itemBuilder: (context, index) {
                  final video = c.videoList[index];
                  return buildMediaItem(video);
                },
              ):const
              Center(child: Text("No Media found!"),));
            },
          )),
    );
  }

  void fetchDataFromApi() async {
    await PermissionHelper.isCheckStoragePermission();
    controller.getMediaFromList();
  }

  Widget buildMediaItem(Video mediaItem) {
    int mediaIndex = controller.videoList.indexOf(mediaItem);


    String downloadStatusText = '';
    double downloadProgress = 0.0;
    bool isDownloading = false;


    downloadStatusText = controller.videoList[mediaIndex].status!;
    downloadProgress = controller.videoList[mediaIndex].downloadedBytes!;
    isDownloading = controller.videoList[mediaIndex].status == 'downloading';


    // print("isDownloading $downloadProgress");
    return ListTile(
      leading: Image.network(
        ApiConstant.imgBase + mediaItem.thumb!,
        width: 50,
        height: 50,
      ),
      title: Text(mediaItem.title!),

      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isDownloading)
            IconButton(
              icon: const Icon(Icons.pause),
              onPressed: () {
                controller.pauseDownload(mediaIndex);
              },
            ),
          if (!isDownloading && downloadProgress < 1.0)
            IconButton(
              icon: Icon(Icons.play_arrow),
              onPressed: () {
                controller.startDownload(mediaIndex, mediaItem.sources![0]);
              },
            ),
          if (!isDownloading && downloadProgress == 1.0)
            IconButton(
              icon: const Icon(Icons.play_circle_outline),
              onPressed: () {
                controller.playDownloadedMedia(mediaIndex);
              },
            ),
          IconButton(
            icon: Icon(Icons.stop),
            onPressed: () {
              controller.stopDownload(mediaIndex);
            },
          ),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text('Size: ${mediaItem.fileSize}'),
          if(controller.videoList[mediaIndex].totalBytes > 0)
            Text(
              'Downloaded: ${controller.videoList[mediaIndex].downloadedBytes
                  / 1048576} MB '
                  '/ ${controller.videoList[mediaIndex].totalBytes
                  / 1048576} MB',
            ),
          Text('Status: $downloadStatusText'),
          LinearProgressIndicator(
              value: controller.videoList[mediaIndex].downloadedBytes!

          ),
        ],
      ),
    );
  }



}