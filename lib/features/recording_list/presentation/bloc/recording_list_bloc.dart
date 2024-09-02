import 'dart:io';

import 'package:audio_trimmer/features/recording_list/domain/entities/audio_file_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:file_picker/file_picker.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path/path.dart' as path;
part 'recording_list_event.dart';
part 'recording_list_state.dart';

class RecordingsListBloc extends Bloc<RecordingListEvent, RecordingsListState> {
  final audioPlayer = AudioPlayer();

  RecordingsListBloc() : super(RecordingListInitial()) {
    on<LoadRecordings>(_onLoadRecordings);
    on<PickAndSyncFolder>(_onPickAndSyncFolder);
    on<PlayRecording>(_onPlayRecording);
  }

  Future<void> _onLoadRecordings(
      LoadRecordings event, Emitter<RecordingsListState> emit) async {
    emit(RecordingsListLoading());
    try {
      // Request READ_EXTERNAL_STORAGE permission
      final permissionStatus = await Permission.mediaLibrary.request();

      if (permissionStatus.isGranted) {
        // Get all external storage directories
        final directories = await getExternalStorageDirectories();

        // Find the phone's shared storage directory
        final sharedStorageDirectory = directories?.firstWhere(
            (directory) => directory.path.contains('/storage/emulated/0'));

        if (sharedStorageDirectory != null) {
          final List<FileSystemEntity> files =
              sharedStorageDirectory.listSync(recursive: true);
          final recordings = await Future.wait(files
              .where((file) =>
                  file.path.endsWith('.mp3') || file.path.endsWith('.wav'))
              .map((file) => AudioFileEntity.fromFileSystemEntity(
                  file)) // Use the static method
              .toList()); // Use Future.wait to handle multiple futures

          if (recordings.isNotEmpty) {
            emit(RecordingsListLoaded(recordings: recordings));
          } else {
            emit(RecordingsListError(
                message:
                    'No recordings found,\nTap on Edit button to select the folder'));
          }
        } else {
          emit(RecordingsListError(
              message: 'Could not find phone\'s shared storage'));
        }
      } else {
        emit(RecordingsListError(message: 'Storage permission denied'));
      }
    } catch (e) {
      emit(RecordingsListError(message: 'Error: ${e.toString()}'));
    }
  }

  Future<void> _onPickAndSyncFolder(
      PickAndSyncFolder event, Emitter<RecordingsListState> emit) async {
    emit(RecordingsListLoading());

    try {
      final permissionStatus = await Permission.manageExternalStorage.request();

      if (permissionStatus.isGranted) {
        final String? selectedDirectory =
            await FilePicker.platform.getDirectoryPath();

        if (selectedDirectory != null) {
          final String combinedPath = path.join('/storage/emulated/0', selectedDirectory);
          // final directory = Directory(combinedPath);

          final directory = Directory(combinedPath);
          final List<FileSystemEntity> newFiles =
              directory.listSync(recursive: true);
          final newRecordings = await Future.wait(newFiles
              .where((file) =>
                  file.path.endsWith('.mp3') || file.path.endsWith('.wav'))
              .map((file) => AudioFileEntity.fromFileSystemEntity(
                  file)) // Use the static method
              .toList()); // Use Future.wait to handle multiple futures

          // Get existing recordings from the current state (if any)
          final currentState = state;
          final existingRecordings = currentState is RecordingsListLoaded
              ? currentState.recordings
              : <AudioFileEntity>[];

          // Combine existing and new recordings, removing duplicates
          final allRecordings = <AudioFileEntity>{
            ...existingRecordings,
            ...newRecordings
          }.toList();

          emit(RecordingsListLoaded(recordings: allRecordings));
        }
        
         else {
          emit(RecordingsListError(message: 'No folder selected'));
        }
      } else {
        emit(RecordingsListError(message: 'Storage permission denied'));
      }
    } catch (e) {
      emit(RecordingsListError(message: 'Error: ${e.toString()}'));
    }
  }

  Future<void> _onPlayRecording(
      PlayRecording event, Emitter<RecordingsListState> emit) async {
    try {
      await audioPlayer.setFilePath(event.audioFile.filePath);
      await audioPlayer.play();
      emit(RecordingsPlaying(currentRecording: event.audioFile));
    } catch (e) {
      emit(
          RecordingsListError(message: 'Error playing audio: ${e.toString()}'));
    }
  }

  @override
  Future<void> close() {
    audioPlayer.dispose(); // Dispose audio player when bloc is closed
    return super.close();
  }
}
