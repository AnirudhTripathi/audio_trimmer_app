part of 'recording_list_bloc.dart';

@immutable
sealed class RecordingListEvent {}

class LoadRecordings extends RecordingListEvent {}

class PickAndSyncFolder extends RecordingListEvent {}

class PlayRecording extends RecordingListEvent {
  final AudioFileEntity audioFile;

  PlayRecording(this.audioFile);
}
