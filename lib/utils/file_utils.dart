import 'dart:io';
import 'package:path/path.dart' as Path;

import 'package:path_provider/path_provider.dart';

class FileUtils {
  static Future<String> get _localAppDirPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<File> _localFile(String projectUuid, String fileName) async {
    final appDirPath = await _localAppDirPath;
    final projectDir = Directory(Path.join(appDirPath, projectUuid));

    if (!await projectDir.exists()) {
      await projectDir.create(recursive: true);
    }

    return File(Path.join(projectDir.path, fileName));
  }

  static writeFile(String projectUuid, String fileName, String data) async {
    final file = await _localFile(projectUuid, fileName);
    return file.writeAsString(data);
  }

  static readFile(String projectUuid, String fileName) async {
    final file = await _localFile(projectUuid, fileName);
    return await file.readAsString();
  }
}
