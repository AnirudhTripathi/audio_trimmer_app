import 'dart:io';

import 'package:easy_audio_trimmer/easy_audio_trimmer.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../../../../core/constants/app_colors.dart';

class AudioPlayerPage extends StatefulWidget {
  final AudioPlayer audioPlayer;
  final String audioFilePath;

  const AudioPlayerPage(
      {super.key, required this.audioPlayer, required this.audioFilePath});

  @override
  State<AudioPlayerPage> createState() => _AudioPlayerPageState();
}

class _AudioPlayerPageState extends State<AudioPlayerPage> {
  final Trimmer _trimmer = Trimmer();
  double _startValue = 0.0;
  double _endValue = 0.0;
  Future<void>? _initializeFuture;
  bool _isPlaying = false;
  bool _progressVisibility = false;
  // Future<int>? _audioDuration;

  @override
  void initState() {
    super.initState();
    _initializeFuture = _initialize();
  }

  Future<bool> _saveAudio() async {
    setState(() {
      _progressVisibility = true;
    });

    try {
      _trimmer.saveTrimmedAudio(
        startValue: _startValue,
        endValue: _endValue,
        audioFileName: DateTime.now().millisecondsSinceEpoch.toString(),
        onSave: (outputPath) {
          setState(() {
            _progressVisibility = false;
          });
          debugPrint('OUTPUT PATH: $outputPath');
          return true;
        },
      );
      return false;
    } catch (e) {
      debugPrint('Error saving audio: $e');
      setState(() {
        _progressVisibility = false;
      });
      return false;
    }
  }

  Future<void> _initialize() async {
    await _trimmer.loadAudio(audioFile: File(widget.audioFilePath));

    // _audioDuration = _trimmer.currentAudioFile?.length();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
        ),
        title: const Text('Trim',
            style: TextStyle(
              color: Colors.white,
            )),
        actions: [
          TextButton(
            onPressed: () async {
              final isSuccess = await _saveAudio();
              if (isSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Audio saved successfully!'),
                    backgroundColor: Colors.green,
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Audio saving failed!'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Text(
              'Save',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: FutureBuilder(
          future: _initializeFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TrimViewer(
                        trimmer: _trimmer,
                        viewerHeight: 50.0,
                        viewerWidth: MediaQuery.of(context).size.width,
                        maxAudioLength: Duration(seconds: 60),
                        durationStyle: DurationStyle.FORMAT_MM_SS,
                        backgroundColor: Theme.of(context).primaryColor,
                        barColor: Colors.white,
                        durationTextStyle:
                            TextStyle(color: Theme.of(context).primaryColor),
                        allowAudioSelection: true,
                        editorProperties: TrimEditorProperties(
                          circleSize: 10,
                          borderPaintColor: Colors.pink,
                          borderWidth: 4,
                          borderRadius: 5,
                          circlePaintColor: Colors.pink.shade800,
                        ),
                        areaProperties:
                            TrimAreaProperties.edgeBlur(blurEdges: true),
                        onChangeStart: (value) => _startValue = value,
                        onChangeEnd: (value) => _endValue = value,
                        onChangePlaybackState: (value) {
                          if (mounted) {
                            setState(() => _isPlaying = value);
                          }
                        }),
                    const SizedBox(height: 50),
                    const Text(
                      '00:19:06',
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 50),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.fast_rewind),
                          color: Colors.white,
                          iconSize: 36,
                        ),
                        IconButton(
                          onPressed: () async {
                            bool playbackState =
                                await _trimmer.audioPlaybackControl(
                              startValue: _startValue,
                              endValue: _endValue,
                            );
                            setState(() => _isPlaying = playbackState);
                          },
                          icon: _isPlaying
                              ? Icon(Icons.pause)
                              : Icon(Icons.play_arrow),
                          color: Colors.white,
                          iconSize: 48,
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.fast_forward),
                          color: Colors.white,
                          iconSize: 36,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Delete',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              // Audio is still loading, show a loading indicator
              return const Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}
