import 'package:go_router/go_router.dart';
import 'package:audio_trimmer/features/audio_player/presentation/pages/audio_player_page.dart';
import 'package:audio_trimmer/features/audio_recorder/presentation/pages/audio_recorder_page.dart';
import 'package:just_audio/just_audio.dart';

import '../../features/recording_list/presentation/pages/recording_list_page.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const RecordingsListPage(),
      ),
      GoRoute(
        path: '/recorder',
        builder: (context, state) => const AudioRecorderPage(),
      ),
      GoRoute(
        path: '/player',
        builder: (context, state) {
          return AudioPlayerPage(
            audioPlayer: (state.extra as Map)['audioPlayer'] as AudioPlayer,
            audioFilePath:
                (state.extra as Map<String, dynamic>)['filePath'] as String,
          );
        },
      ),
    ],
  );
}
