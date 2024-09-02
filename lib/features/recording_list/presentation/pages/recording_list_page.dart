import 'package:audio_trimmer/core/routes/app_router.dart';
import 'package:audio_trimmer/features/recording_list/presentation/widgets/recording_player_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../bloc/recording_list_bloc.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/recording_list_tile.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class RecordingsListPage extends StatefulWidget {
  const RecordingsListPage({super.key});

  @override
  State<RecordingsListPage> createState() => _RecordingsListPageState();
}

class _RecordingsListPageState extends State<RecordingsListPage> {
  RecordingsListLoaded? _loadedState;
  String? currentFilePath;

  @override
  void initState() {
    super.initState();
    context.read<RecordingsListBloc>().add(LoadRecordings());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'All Recordings',
        actions: [
          // IconButton(
          //   onPressed: () {},
          //   icon: const Icon(Icons.edit),
          // ),
          TextButton(
              onPressed: () {
                context.read<RecordingsListBloc>().add(PickAndSyncFolder());
              },
              child: Text(
                "Edit",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade700,
                  fontSize: 25,
                ),
              )),
        ],
      ),
      body: BlocBuilder<RecordingsListBloc, RecordingsListState>(
        builder: (context, state) {
          if (state is RecordingsListLoaded) {
            _loadedState = state;
          }
          if (state is RecordingsListLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (_loadedState != null) {
            return Column(
              children: [
                const Divider(),
                if (currentFilePath != null)
                  RecordingPlayerWidget(
                    filePath: currentFilePath!,
                  ),
                _buildRecordingList(_loadedState!), // Use the stored state
              ],
            );
          } else if (state is RecordingsListError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.grey[200],
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: 60,
            child: Center(
              child: FloatingActionButton(
                shape: const CircleBorder(
                  side: BorderSide(
                    strokeAlign: BorderSide.strokeAlignOutside,
                    width: 4,
                    color: Colors.grey,
                  ),
                ),
                onPressed: () {
                  context.push('/recorder');
                  // Handle the button press
                },
                backgroundColor: Colors.red,
                // child: const Icon(Icons.mic),
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  // Separate widget to build the recording list using the stored state
  Widget _buildRecordingList(RecordingsListLoaded state) {
    return Expanded(
      child: ListView.builder(
        itemCount: state.recordings.length,
        itemBuilder: (context, index) {
          final file = state.recordings[index];
          return Column(
            children: [
              const Divider(),
              InkWell(
                onTap: () {
                  context.read<RecordingsListBloc>().add(PlayRecording(file));
                  currentFilePath = file.filePath;
                  setState(() {});
                },
                child: RecordingListTile(
                  title: file.name,
                  duration: file.timeLength.toString(),
                  date: file.updatedTime.toString(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
