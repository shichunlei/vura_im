import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';

import 'log_utils.dart';
import 'toast_util.dart';

class FileUtil {
  static Uint8List convert(ByteData data) {
    var bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    return bytes;
  }

  static Future<Uint8List?> readFileByte(String filePath) async {
    Uri myUri = Uri.parse(filePath);
    File file = File.fromUri(myUri);
    Uint8List? bytes;
    await file.readAsBytes().then((value) {
      bytes = Uint8List.fromList(value);
      Log.d('reading of bytes is completed');
    }).catchError((onError) {
      Log.d('Exception Error while reading audio from path:$onError');
    });
    return bytes;
  }

  static Future<String> cacheFileName(String filePath, String fileKey) async {
    final directory = await getTemporaryDirectory();
    return "${directory.path}/$filePath/$fileKey";
  }

  static Future<bool> checkExist(String fileName) {
    Uri myUri = Uri.parse(fileName);
    File file = File.fromUri(myUri);
    Future<bool> result = file.exists();
    return result;
  }

  static deleteFile(String filePath) async {
    File file = File(filePath);
    //如果文件存在，删除
    if (await file.exists()) {
      file.deleteSync();
      Log.d('文件删除成功');
    }
  }

  static Future<Directory> get tempDirectory async => await getTemporaryDirectory();

  static Future<Directory> get applicationDirectory async => await getApplicationDocumentsDirectory();

  /// 获取本地文档根目录
  ///
  static Future<String?> getLocalPath() async {
    /// 文档目录，该目录用于存储只有自己可以访问的文件。只有当应用程序被卸载时，系统才会清除该目录。在iOS上，这对应于NSDocumentDirectory。在Android上，这是AppData目录。
    var appDocDir = await applicationDirectory;
    return "${appDocDir.path}/";
  }

  /// 获取本地临时根目录
  ///
  static Future<String> getTempPath() async {
    /// 临时目录, 系统可随时清除的临时目录（缓存）。在iOS上，这对应于NSTemporaryDirectory() 返回的值。在Android上，这是getCacheDir()返回的值。
    Directory tempDir = await tempDirectory;
    return "${tempDir.path}/";
  }

  /// 获取SD卡根目录，仅仅在Android平台可以使用
  ///
  static Future<String?> getSDCardPath() async {
    try {
      var sdDir = await getExternalStorageDirectory();
      if (sdDir != null) return "${sdDir.path}/";
    } catch (err) {
      Log.e(err.toString());
      return null;
    }
    return null;
  }

  static Future checkFolder(String folderPath) async {
    bool appFolderExists = await Directory(folderPath).exists();
    if (!appFolderExists) {
      final created = await Directory(folderPath).create(recursive: true);
      Log.d(created.path);
    }
  }

  /*删除目录*/
  static void deleteFolder(path) {
    Directory dir = Directory(path);
    var exist = dir.existsSync();
    if (exist) {
      dir.deleteSync(recursive: true);
    }
  }

  static Future<List<int>> fileToUint8List(String path, {bool isLocal = false}) async {
    Uint8List? bytes;

    if (isLocal) {
      bytes = await readFileByte(path);
    } else {
      var response = await Dio().get(path, options: Options(responseType: ResponseType.bytes));
      bytes = Uint8List.fromList(response.data);
    }

    return bytes ?? [];
  }

  static Future<ByteData> fetchAsset(String fileName) async {
    return await rootBundle.load('assets/wav/$fileName');
  }

  static Future<File> fetchToMemory(String fileName) async {
    String path = "${(await getTemporaryDirectory()).path}/$fileName";

    final file = File(path);

    await file.create(recursive: true);

    return await file.writeAsBytes((await fetchAsset(fileName)).buffer.asUint8List());
  }

  static Future<List<File>> fetchFilesFromFolder(String path) async {
    Directory dir = Directory(path);
    List<FileSystemEntity> fileSystemEntity;
    fileSystemEntity = dir.listSync(recursive: true, followLinks: false);

    List<File> files = [];
    for (FileSystemEntity entity in fileSystemEntity) {
      String filePath = entity.path;
      Log.d(filePath);
      files.add(File(filePath));
    }

    return files;
  }

  /// 根据文件本地路径获取文件名称
  ///
  /// [filePath] 文件路径
  ///
  static String getFileNameByPath(String? filePath) {
    if (filePath == null) return '';
    return (filePath.lastIndexOf('/') > -1 ? filePath.substring(filePath.lastIndexOf('/') + 1) : filePath)
        .split(".")
        .first;
  }

  /// 根据文件本地路径获取文件名称（带后缀）
  ///
  /// [filePath] 文件路径
  ///
  static String getFileNameByPathWithSuffix(String? filePath) {
    if (filePath == null) return '';
    return filePath.lastIndexOf('/') > -1 ? filePath.substring(filePath.lastIndexOf('/') + 1) : filePath;
  }

  static Future<Uint8List?> getImageData(GlobalKey globalKey) async {
    RenderRepaintBoundary boundary = globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage(pixelRatio: 3.0);
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData?.buffer.asUint8List();
  }

  static Future saveScreen(Uint8List imageBytes) async {
    final result = await ImageGallerySaver.saveImage(imageBytes, quality: 100);
    if (result != null) {
      showToast(text: "保存成功");
    } else {
      showToast(text: "保存失败");
    }
  }

  static Future<double> loadCache() async {
    try {
      double value = await _getTotalSizeOfFilesInDir(await tempDirectory);
      Log.d('临时目录大小: ${value.toStringAsFixed(2)} B');
      return value;
    } catch (err) {
      Log.e(err.toString());
      return 0.0;
    }
  }

  static Future<double> _getTotalSizeOfFilesInDir(final FileSystemEntity file) async {
    if (file is File) {
      int length = await file.length();
      return double.parse(length.toString());
    } else if (file is Directory) {
      final List<FileSystemEntity> children = file.listSync();
      double total = 0;
      for (final FileSystemEntity child in children) {
        total += await _getTotalSizeOfFilesInDir(child);
      }
      return total;
    }
    return 0.0;
  }

  static String renderSize(double value) {
    List<String> unitArr = ['B', 'KB', 'MB', 'GB'];
    int index = 0;
    while (value > 1024) {
      value = value / 1024;
      index++;
    }
    return '${value.toStringAsFixed(2)} ${unitArr[index]}';
  }

  /// 清除缓存
  static Future clearCache() async {
    try {
      await delDir(await tempDirectory);
      Log.d('清除缓存成功');
    } catch (e) {
      Log.e('清除缓存失败: ${e.toString()}');
    }
  }

  static Future<Null> delDir(FileSystemEntity file) async {
    if (file is Directory) {
      final List<FileSystemEntity> children = file.listSync();
      for (final FileSystemEntity child in children) {
        await delDir(child);
      }
    }
    await file.delete();
  }
}
