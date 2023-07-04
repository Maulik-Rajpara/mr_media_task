import 'dart:io';
import 'package:dio/dio.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:practical/screen/video_player_screen.dart';
import '../model/download_status.dart';
import '../model/media_model.dart';
import '../network_repo/service/api_service.dart';

class MediaListController extends GetxController {

  List<DownloadStatus> downloadStatusList = [];
  RxList<Video> videoList = <Video>[].obs;
  bool? isLoadMediaProgress = false;

  void getMediaFromList() async{
    isLoadMediaProgress = true;
    update();
    final mediaModel = await ApiService.fetchMediaData();
    isLoadMediaProgress = false;
    if (mediaModel != null) {

      if (mediaModel.categories!.isNotEmpty) {

        videoList.addAll(mediaModel.categories![0].videos!);

        update();
      }

    } else {
      if (kDebugMode) {
        print('Failed to fetch media data.');
      }
    }
  }

  void startDownload(int index, String fileUrl) async {
    try {
     videoList[index].isPause= false;
     update();

    ///  http.Client client = http.Client();
      final Dio dio = Dio();


      final response = await dio.get(fileUrl,
          onReceiveProgress: (receivedBytes, totalBytes) {
            if(videoList[index].isPause!) return;

            videoList[index].downloadedBytes= receivedBytes/totalBytes;
            videoList[index].totalBytes=totalBytes;
            videoList[index].status='downloading';
            if(receivedBytes==totalBytes){
              videoList[index].status='completed';
            }

            update();
          });

      if (response.statusCode == 200) {


        final bytes = response.data;
        String path;
        path = await ExternalPath.getExternalStoragePublicDirectory(
            ExternalPath.DIRECTORY_DOWNLOADS);

        final file = File("$path/media_$index.mp4");
        if (kDebugMode) {
          print("path $path ${file.path} ${bytes.runtimeType}");
        }

        if(bytes.runtimeType.toString()=="String"){
          return;
        }
        await file.writeAsBytes(bytes);


        videoList[index].downloadedBytes=bytes.length;
        videoList[index].totalBytes=bytes.length;
        videoList[index].status='completed';

        update();
        Get.snackbar(
          'Download Completed',
          '',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          'Failed to Download Media',
          '',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e,s) {
      if (kDebugMode) {
        print("ERROR $e $s");
      }
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void pauseDownload(int index) {
    videoList[index].isPause=true;
    videoList[index].status='paused';
    update();
  }

  void stopDownload(int index) {
    videoList[index].isPause=true;
    videoList[index].status='';
    videoList[index].downloadedBytes=0.0;
    videoList[index].totalBytes=0.0;
    update();
  }

  void playDownloadedMedia(int index) {
    Get.to(VideoPlayerScreen(videoList[index].sources![0]));
  }

}