import 'package:ai_barcode_scanner/ai_barcode_scanner.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vura/utils/string_util.dart';
import 'package:vura/utils/toast_util.dart';

import 'log_utils.dart';

CacheManager cacheManager = CacheManager(Config('im_image', maxNrOfCacheObjects: 30));

/// 复制到剪粘板
///
void copyToClipboard(String? text) {
  if (text == null) return;
  Clipboard.setData(ClipboardData(text: text));
  showToast(text: "已复制到剪切板");
}

/// 获取粘贴板中的内容
///
Future<String> getTextFromClipboard() async {
  var clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
  if (clipboardData != null) {
    return clipboardData.toString();
  } else {
    return "";
  }
}

/// 根据文件本地路径获取文件名称
///
/// [filePath] 文件路径
///
String getFileNameByPath(String filePath) {
  if (StringUtil.isEmpty(filePath)) return '';
  return filePath.lastIndexOf('/') > -1 ? filePath.substring(filePath.lastIndexOf('/') + 1) : filePath;
}

/// 选择图片
///
/// [source] 来源
/// [cropImage] 是否裁剪
///
Future<String?> pickerImage(ImageSource source, {bool cropImage = true}) async {
  try {
    XFile? image = await ImagePicker().pickImage(source: source);

    if (image != null) {
      if (cropImage) {
        return _cropImage(image.path);
      } else {
        return image.path;
      }
    } else {
      return null;
    }
  } catch (e) {
    Log.e(e.toString());
    return null;
  }
}

/// 裁剪
///
/// [imagePath] 要裁剪的图片
///
Future<String?> _cropImage(String imagePath) async {
  CroppedFile? croppedFile = await ImageCropper().cropImage(

      /// 图像文件的绝对路径。
      sourcePath: imagePath,

      /// 最大裁剪的图像宽度
      maxWidth: 256,

      /// 最大裁剪的图像高度
      maxHeight: 256,

      /// 控制裁剪边界的纵横比。如果设置了此值，裁剪器将被锁定，用户无法更改裁剪边界的纵横比。
      aspectRatio: const CropAspectRatio(ratioY: 1, ratioX: 1),

      /// 结果图像的格式，png或jpg
      compressFormat: ImageCompressFormat.jpg,

      /// 用于控制图像压缩的质量，取值范围[1-100]
      compressQuality: 100,
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: "裁剪",
            toolbarColor: Get.theme.primaryColor,
            statusBarColor: Get.theme.primaryColor,
            toolbarWidgetColor: Colors.white,
            hideBottomControls: true,
            cropStyle: CropStyle.circle,
            aspectRatioPresets: [CropAspectRatioPreset.square]),
        IOSUiSettings(
            title: "裁剪",
            doneButtonTitle: "Done".tr,
            cancelButtonTitle: "Cancel".tr,
            cropStyle: CropStyle.circle,
            aspectRatioPresets: [CropAspectRatioPreset.square])
      ]);

  Log.d('cropImage=============${croppedFile?.path}');

  return croppedFile?.path;
}

Future goScan() async {
  return await Get.to(AiBarcodeScanner(
      onDetect: (BarcodeCapture capture) {
        /// The row string scanned barcode value
        final String? scannedValue = capture.barcodes.first.rawValue;
        Log.d("Barcode scanned: $scannedValue");

        /// The `Uint8List` image is only available if `returnImage` is set to `true`.
        final Uint8List? image = capture.image;
        Log.d("Barcode image: $image");

        /// row data of the barcode
        final Object? raw = capture.raw;
        Log.d("Barcode raw: $raw");

        /// List of scanned barcodes if any
        final List<Barcode> barcodes = capture.barcodes;
        Log.d("Barcode list: $barcodes");

        Get.back(result: scannedValue);
      },
      onDispose: () {
        /// This is called when the barcode scanner is disposed.
        /// You can write your own logic here.
        Log.d("Barcode scanner disposed!");
      },
      hideGalleryButton: false,
      controller: MobileScannerController(detectionSpeed: DetectionSpeed.noDuplicates),
      validator: (value) {
        if (value.barcodes.isEmpty) {
          return false;
        }
        if (!(value.barcodes.first.rawValue?.contains('flutter.dev') ?? false)) {
          return false;
        }
        return true;
      },
      sheetTitle: "扫一扫"));
}
