import 'package:flutter/material.dart';

import '../models/achievement_model.dart';
import '../routes/route_names.dart';

class AchievementCard extends StatelessWidget {
  const AchievementCard({
    Key? key,
    required this.achievement,
  }) : super(key: key);

  final Achievement achievement;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed(
        RouteNames.detailScreen,
        arguments: achievement,
      ),
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              blurRadius: 8,
              color: Colors.black.withOpacity(0.1),
            )
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                bottomLeft: Radius.circular(8),
              ),
              child: Container(
                width: 80,
                color: Colors.grey.shade200,
                padding: const EdgeInsets.all(8),
                child: Image.network(
                  achievement.file,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 8),
                  Text(
                    achievement.achievementName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    achievement.organizer,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Text(
                    "(${achievement.year})",
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
