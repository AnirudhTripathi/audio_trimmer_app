import 'dart:io';

class AudioFileEntity {
  final String name;
  final DateTime updatedTime;
  final Duration timeLength;
  final String filePath;

  AudioFileEntity({
    required this.name,
    required this.updatedTime,
    required this.timeLength,
    required this.filePath,
  });

  static Future<AudioFileEntity> fromFileSystemEntity(
      FileSystemEntity entity) async {
    final file = File(entity.path);
    final length = await file.length();
    return AudioFileEntity(
      name: file.path.split('/').last,
      updatedTime: file.lastModifiedSync(),
      timeLength: Duration(milliseconds: length),
      filePath: file.path,
    );
  }
}
