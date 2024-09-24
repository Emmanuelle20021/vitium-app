import 'dart:io';
import 'package:image/image.dart' as imd;
import 'package:path_provider/path_provider.dart';

class ImageCompresser {
  ImageCompresser._();

  static Future<File> compressImage(
      {required File image, required String fileName}) async {
    final tDirectory = await getTemporaryDirectory();
    final path = tDirectory.path;
    imd.Image mImageFile = imd.decodeImage(image.readAsBytesSync())!;
    final compressedImageFile = File('$path/$fileName.jpg')
      ..writeAsBytesSync(imd.encodeJpg(mImageFile, quality: 10));
    return compressedImageFile;
  }
}
