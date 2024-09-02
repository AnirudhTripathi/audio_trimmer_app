import 'package:audio_trimmer/features/recording_list/presentation/bloc/recording_list_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:just_audio/just_audio.dart';

class RecordingPlayerWidget extends StatelessWidget {
  final String filePath;
  const RecordingPlayerWidget({super.key, required this.filePath});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecordingsListBloc, RecordingsListState>(
      builder: (context, state) {
        final audioPlayer = context.read<RecordingsListBloc>().audioPlayer;
        final currentRecording =
            state is RecordingsPlaying ? state.currentRecording : null;

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (currentRecording != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 300,
                          child: Text(
                            currentRecording.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          currentRecording.updatedTime.toString(),
                          style: const TextStyle(
                            fontSize: 14.0,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        // TODO
                      },
                      child: SvgPicture.asset(
                        "assets/vectors/menu_circular.svg",
                        color: Colors.blue.shade700,
                        width: 35,
                      ),
                    ),
                    // IconButton(
                    //   onPressed: () {
                    //     // More options action
                    //   },
                    //   icon: const Icon(Icons.more_horiz_rounded),
                    // ),
                  ],
                ),

              // Audio Slider
              StreamBuilder<Duration?>(
                stream: audioPlayer.positionStream,
                builder: (context, snapshot) {
                  final position = snapshot.data ?? Duration.zero;
                  return StreamBuilder<Duration?>(
                    stream: audioPlayer.durationStream,
                    builder: (context, snapshot) {
                      final duration = snapshot.data ?? Duration.zero;
                      return Slider(
                        value: position.inMilliseconds.toDouble(),
                        onChanged: (value) {
                          audioPlayer
                              .seek(Duration(milliseconds: value.toInt()));
                        },
                        min: 0.0,
                        max: duration.inMilliseconds.toDouble(),
                      );
                    },
                  );
                },
              ),

              // Time Labels
              StreamBuilder<Duration?>(
                stream: audioPlayer.positionStream,
                builder: (context, snapshot) {
                  final position = snapshot.data ?? Duration.zero;
                  return StreamBuilder<Duration?>(
                    stream: audioPlayer.durationStream,
                    builder: (context, snapshot) {
                      final duration = snapshot.data ?? Duration.zero;
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(_formatDuration(position)),
                          Text('-${_formatDuration(duration - position)}'),
                        ],
                      );
                    },
                  );
                },
              ),

              // Controls
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: () {
                      context.push('/player', extra: {
                        'audioPlayer': audioPlayer,
                        'filePath': filePath
                      });
                    },
                    icon: SvgPicture.asset(
                      "assets/vectors/slider.svg",
                      color: Colors.blue.shade700,
                      width: 35,
                    ),
                  ),
                  // IconButton(
                  //   onPressed: () {
                  //     context.push('/player', extra: audioPlayer);
                  //   },
                  //   icon: const Icon(Icons.graphic_eq_rounded),
                  // ),
                  IconButton(
                    onPressed: () {
                      audioPlayer.seek(audioPlayer.position -
                          const Duration(seconds: 15)); // Rewind 15 seconds
                    },
                    icon: const Icon(Icons.replay_10),
                    iconSize: 40,
                  ),
                  StreamBuilder<PlayerState>(
                    stream: audioPlayer.playerStateStream,
                    builder: (context, snapshot) {
                      final playerState = snapshot.data;
                      final processingState = playerState?.processingState;
                      final playing = playerState?.playing;
                      if (processingState == ProcessingState.loading ||
                          processingState == ProcessingState.buffering) {
                        return Container(
                          margin: const EdgeInsets.all(8.0),
                          width: 64.0,
                          height: 64.0,
                          child: const CircularProgressIndicator(),
                        );
                      } else if (playing != true) {
                        return IconButton(
                          icon: const Icon(Icons.play_arrow_rounded),
                          iconSize: 80.0,
                          onPressed: audioPlayer.play,
                        );
                      } else if (processingState != ProcessingState.completed) {
                        return IconButton(
                          icon: const Icon(Icons.pause),
                          iconSize: 64.0,
                          onPressed: audioPlayer.pause,
                        );
                      } else {
                        return IconButton(
                          icon: const Icon(Icons.replay),
                          iconSize: 64.0,
                          onPressed: () => audioPlayer.seek(Duration.zero),
                        );
                      }
                    },
                  ),
                  IconButton(
                    onPressed: () {
                      audioPlayer.seek(audioPlayer.position +
                          const Duration(seconds: 15)); // Forward 15 seconds
                    },
                    iconSize: 40,
                    icon: const Icon(Icons.forward_10),
                  ),
                  IconButton(
                    onPressed: () {
                      // Handle delete
                    },
                    icon: const Icon(Icons.delete_outline_rounded),
                    color: Colors.blue.shade800,
                    iconSize: 30,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }
}
