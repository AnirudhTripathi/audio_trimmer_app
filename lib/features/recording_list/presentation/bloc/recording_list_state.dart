part of 'recording_list_bloc.dart';

@immutable
sealed class RecordingsListState {}

final class RecordingListInitial extends RecordingsListState {}

class RecordingsListInitial extends RecordingsListState {}

class RecordingsListLoading extends RecordingsListState {}

class RecordingsPlaying extends RecordingsListState {
  final AudioFileEntity currentRecording;

  RecordingsPlaying({required this.currentRecording});
}

class RecordingsListLoaded extends RecordingsListState {
  final List<AudioFileEntity> recordings;

  RecordingsListLoaded({required this.recordings});
}

class RecordingsListError extends RecordingsListState {
  final String message;

  RecordingsListError({required this.message});
}
