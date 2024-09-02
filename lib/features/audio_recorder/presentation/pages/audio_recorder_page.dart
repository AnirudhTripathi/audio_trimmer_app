import 'dart:async';

import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

class AudioRecorderPage extends StatefulWidget {
  const AudioRecorderPage({Key? key}) : super(key: key);

  @override
  State<AudioRecorderPage> createState() => _AudioRecorderPageState();
}

class _AudioRecorderPageState extends State<AudioRecorderPage> {
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = const Duration(seconds: 300);
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(milliseconds: 250), (timer) {
      setState(() {
        _currentPosition += const Duration(milliseconds: 250);
        if (_currentPosition > _totalDuration) {
          _currentPosition = _totalDuration;
          _timer?.cancel();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF242A37),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Text(
            'Yerba Buena Gardens',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            '9:41 AM 0.05',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 40),
          Expanded(
            child: AudioWaveform(
              currentPosition: _currentPosition.inMilliseconds.toDouble(),
              totalDuration: _totalDuration.inMilliseconds.toDouble(),
            ),
          ),
          SizedBox(height: 30),
          Text(
            _formatDuration(_currentPosition),
            style: TextStyle(
              color: Colors.white,
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.replay_10,
                  color: Colors.grey,
                ),
                iconSize: 35,
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.play_arrow_rounded,
                  color: Colors.grey,
                ),
                iconSize: 80,
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.forward_10,
                  color: Colors.grey,
                ),
                iconSize: 35,
              ),
            ],
          ),
          SizedBox(height: 30),
          Row(
            children: [
              Spacer(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF242A37),
                    side: const BorderSide(
                      width: 3,
                      color: Colors.white,
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 40,
                    ),
                    textStyle: TextStyle(fontSize: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(45),
                    ),
                  ),
                  child: IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.pause,
                      color: Colors.red,
                      size: 40,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 40,
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  'Done',
                  style: TextStyle(
                    color: Color(0xFF4B9EFF),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 60),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    String twoDigitMilliseconds = (duration.inMilliseconds % 1000)
        .toString()
        .padLeft(2, '0')
        .substring(0, 2);
    return "$twoDigitMinutes:$twoDigitSeconds.$twoDigitMilliseconds";
  }
}

class AudioWaveform extends StatelessWidget {
  final double currentPosition;
  final double totalDuration;

  const AudioWaveform(
      {Key? key, required this.currentPosition, required this.totalDuration})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          onTapDown: (details) {
            double newPosition =
                details.localPosition.dx / constraints.maxWidth;
          },
          child: CustomPaint(
            size: Size(constraints.maxWidth, 100),
            painter: _AudioWaveformPainter(currentPosition, totalDuration),
          ),
        );
      },
    );
  }
}

class _AudioWaveformPainter extends CustomPainter {
  final double currentPosition;
  final double totalDuration;

  _AudioWaveformPainter(this.currentPosition, this.totalDuration);

  @override
  void paint(Canvas canvas, Size size) {
    final wavePaint = Paint()
      ..color = const Color(0xFFF43838)
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    final playedLinePaint = Paint()
      ..color = Colors.red
      ..strokeWidth = 3.0;

    final waveformWidth = size.width;
    final waveformHeight = size.height;

    final barWidth = 3.0;
    final barSpacing = 1.0;

    final numberOfBars = (waveformWidth / (barWidth + barSpacing)).floor();

    final maxBarHeight = waveformHeight * 0.8;
    final minBarHeight = waveformHeight * 0.2;

    final playedLineX = (currentPosition / totalDuration) * waveformWidth;

    for (int i = 0; i < numberOfBars; i++) {
      final barX = i * (barWidth + barSpacing);

      final barHeight = (maxBarHeight - minBarHeight) * 0.5 + minBarHeight;

      canvas.drawLine(
        Offset(barX, waveformHeight / 2 - barHeight / 2),
        Offset(barX, waveformHeight / 2 + barHeight / 2),
        wavePaint,
      );

      canvas.drawLine(
        Offset(playedLineX, 0),
        Offset(playedLineX, waveformHeight),
        playedLinePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
