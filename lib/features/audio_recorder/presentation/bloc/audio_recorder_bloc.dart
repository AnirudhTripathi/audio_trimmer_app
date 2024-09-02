import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'audio_recorder_event.dart';
part 'audio_recorder_state.dart';

class AudioRecorderBloc extends Bloc<AudioRecorderEvent, AudioRecorderState> {
  AudioRecorderBloc() : super(AudioRecorderInitial()) {
    on<AudioRecorderEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
