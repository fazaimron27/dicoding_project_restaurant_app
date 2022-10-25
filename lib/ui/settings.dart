import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dicoding_project_restaurant_app/common/styles.dart';
import 'package:dicoding_project_restaurant_app/provider/scheduling_provider.dart';

class SettingsPage extends StatelessWidget {
  static const String settingsTitle = 'Settings';

  const SettingsPage({Key? key}) : super(key: key);

  Widget _buildList(BuildContext context) {
    return ListView(
      children: [
        Material(
          child: ListTile(
            title: const Text('Scheduling Restaurant'),
            trailing: Consumer<SchedulingProvider>(
              builder: (context, scheduled, _) {
                return Switch.adaptive(
                  value: scheduled.isScheduled,
                  onChanged: (value) async {
                    scheduled.scheduledRestaurant(value);
                  },
                );
              },
            ),
          ),
        ),
        Material(
          child: ListTile(
            title: const Text('Show Recommended Restaurant Now'),
            trailing: Consumer<SchedulingProvider>(
              builder: (context, scheduled, _) {
                return IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () {
                    scheduled.scheduledNow();
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: secondaryColor,
        toolbarHeight: 100,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "Settings",
              style: TextStyle(fontSize: 32, color: primaryColor),
            ),
            Text(
              "Let's make your day better",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.normal,
                fontStyle: FontStyle.italic,
                color: primaryColor,
              ),
            ),
          ],
        ),
      ),
      body: _buildList(context),
    );
  }
}
