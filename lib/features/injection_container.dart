import 'package:audio_trimmer/features/recording_list/presentation/bloc/recording_list_bloc.dart';
import 'package:get_it/get_it.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initRecordingsList();
}

void _initRecordingsList() {
  serviceLocator.registerFactory(
    () => RecordingsListBloc(),
  );
}
