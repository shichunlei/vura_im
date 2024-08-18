import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import 'package:im/utils/string_util.dart';
import 'package:im/utils/toast_util.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:wechat_assets_picker/wechat_assets_picker.dart';

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

/// 获取文件唯一名称
///
/// [filePath] 文件路径
///
String getFileNameByMicroseconds(String filePath) {
  if (StringUtil.isEmpty(filePath)) return '';
  return DateTime.now().microsecondsSinceEpoch.toString() + filePath.substring(filePath.lastIndexOf('.'));
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
            doneButtonTitle: "确定",
            cancelButtonTitle: "取消",
            cropStyle: CropStyle.circle,
            aspectRatioPresets: [CropAspectRatioPreset.square])
      ]);

  Log.d('cropImage=============${croppedFile?.path}');

  return croppedFile?.path;
}

// Future<List<AssetEntity>> pickerImages(BuildContext context,
//     {int maxImages = 9, List<AssetEntity> resultList = const []}) async {
//   List<AssetEntity> _resultList = [];
//
//   List<AssetEntity> _initResultList = [];
//   _initResultList.addAll(resultList);
//
//   try {
//     await AssetPicker.pickAssets(context,
//             pickerConfig: AssetPickerConfig(
//                 themeColor: Get.theme.primaryColor,
//                 maxAssets: maxImages,
//                 selectedAssets: resultList,
//                 requestType: RequestType.image))
//         .then((value) {
//       if (value != null) {
//         _resultList = value;
//       } else {
//         _resultList = _initResultList;
//       }
//     });
//   } on Exception catch (e) {
//     Log.e(e.toString());
//     _resultList = _initResultList;
//   }
//
//   return _resultList;
// }

TextInputFormatter phoneInputFormatter() {
  return TextInputFormatter.withFunction((oldValue, newValue) {
    String text = newValue.text;
    //获取光标左边的文本
    final positionStr = (text.substring(0, newValue.selection.baseOffset)).replaceAll(RegExp(r"\s+\b|\b\s"), "");
    //计算格式化后的光标位置
    int length = positionStr.length;
    var position = 0;
    if (length <= 3) {
      position = length;
    } else if (length <= 7) {
      // 因为前面的字符串里面加了一个空格
      position = length + 1;
    } else if (length <= 11) {
      // 因为前面的字符串里面加了两个空格
      position = length + 2;
    } else {
      // 号码本身为 11 位数字，因多了两个空格，故为 13
      position = 13;
    }

    //这里格式化整个输入文本
    text = text.replaceAll(RegExp(r"\s+\b|\b\s"), "");
    var string = "";
    for (int i = 0; i < text.length; i++) {
      // 这里第 4 位，与第 8 位，我们用空格填充
      if (i == 3 || i == 7) {
        if (text[i] != " ") {
          string = "$string ";
        }
      }
      string += text[i];
    }

    return TextEditingValue(
        text: string.length > 13 ? string.substring(0, 13) : string,
        selection: TextSelection.fromPosition(TextPosition(offset: position, affinity: TextAffinity.upstream)));
  });
}
