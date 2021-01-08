import 'dart:io';

import 'package:path_provider/path_provider.dart';

class FileWriter {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> _localFile(String uuid) async {
    final path = await _localPath;
    return File('$path/$uuid/map.json');
  }

  writeFile(String uuid, String data) async {
      final file = await _localFile(uuid);
      return file.writeAsString(data);
  }
}
