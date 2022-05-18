import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../routes/route_names.dart';
import '../services/response_call.dart';
import '../widgets/achievement_card.dart';
import '../providers/achievement_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _achievementProvider =
        Provider.of<AchievementProvider>(context, listen: false);

    _achievementProvider.getListAchievement();

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(title: const Text('My Achievements')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).pushNamed(
          RouteNames.inputScreen,
          arguments: null,
        ),
        child: const Icon(Icons.add),
      ),
      body: Consumer<AchievementProvider>(
        builder: (context, provider, child) {
          if (provider.apiCall.status == Status.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.apiCall.status == Status.error) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      provider.apiCall.message!,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: provider.getListAchievement,
                    child: const Text('Try Again'),
                    style: ElevatedButton.styleFrom(
                        visualDensity: VisualDensity.compact),
                  )
                ],
              ),
            );
          }

          if (provider.listAchievements.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      'Achievement is Empty',
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: provider.getListAchievement,
                    child: const Text('Try Again'),
                    style: ElevatedButton.styleFrom(
                        visualDensity: VisualDensity.compact),
                  )
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              await provider.getListAchievement();
            },
            child: ListView.separated(
              itemCount: provider.listAchievements.length,
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, index) {
                final achievement = provider.listAchievements[index];

                return AchievementCard(achievement: achievement);
              },
              separatorBuilder: (context, index) => const SizedBox(height: 8),
            ),
          );
        },
      ),
    );
  }
}
