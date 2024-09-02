import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

class RecordButton extends StatefulWidget {
  const RecordButton({super.key});

  @override
  State<RecordButton> createState() => _RecordButtonState();
}

class _RecordButtonState extends State<RecordButton> {
  bool _isRecording = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isRecording = !_isRecording;
        });
      },
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _isRecording ? Colors.red : AppColors.primary,
        ),
        child: Center(
          child: Icon(
            _isRecording ? Icons.stop : Icons.mic,
            size: 40,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
