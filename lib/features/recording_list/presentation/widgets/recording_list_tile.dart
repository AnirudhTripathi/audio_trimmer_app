import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

class RecordingListTile extends StatelessWidget {
  final String title;
  final String duration;
  final String date;

  const RecordingListTile({
    super.key,
    required this.title,
    required this.duration,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: AppColors.onPrimary,
      title: Text(
        title,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(color: Colors.black),
      ),
      subtitle: Text(
        date,
        style: const TextStyle(color: AppColors.background),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            duration,
            style: const TextStyle(color: AppColors.background),
          ),
          const SizedBox(width: 10),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert, color: AppColors.background),
          ),
        ],
      ),
    );
  }
}
