import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/achievement_model.dart';
import '../providers/achievement_provider.dart';
import '../routes/route_names.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Achievement detail =
        ModalRoute.of(context)!.settings.arguments as Achievement;
    final _achievementProvider =
        Provider.of<AchievementProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Achievement'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 150,
            color: Colors.grey.shade200,
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Image.network(
                detail.file,
                fit: BoxFit.cover,
                height: 80,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              detail.achievementName,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 16, bottom: 8, right: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Level',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                Text(
                  detail.level,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 16, bottom: 8, right: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Organizer',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                Text(
                  detail.organizer,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 16, bottom: 8, right: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Year',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                Text(
                  detail.year,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "btn-delete",
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Delete Achievement'),
                  content: const Text(
                      'Are you sure want to delete this achievement?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                        onPressed: () async {
                          showDialog(
                            context: context,
                            builder: (context) => const Dialog(
                              elevation: 0,
                              backgroundColor: Colors.transparent,
                              child: Center(child: CircularProgressIndicator()),
                            ),
                          );

                          final status = await _achievementProvider
                              .deleteAchievement(detail.id);

                          if (status) {
                            _achievementProvider.getListAchievement(false);
                            Navigator.of(context)
                                .popUntil((route) => route.isFirst);
                          } else {
                            Navigator.of(context).pop();
                          }
                        },
                        child: const Text('Delete')),
                  ],
                ),
              );
            },
            backgroundColor: Colors.red,
            child: const Icon(Icons.delete),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            heroTag: "btn-edit",
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Edit Achievement'),
                  content:
                      const Text('Are you sure want to edit this achievement?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                        onPressed: () => Navigator.of(context).popAndPushNamed(
                              RouteNames.inputScreen,
                              arguments: detail,
                            ),
                        child: const Text('Edit')),
                  ],
                ),
              );
            },
            child: const Icon(Icons.edit),
          ),
        ],
      ),
    );
  }
}
