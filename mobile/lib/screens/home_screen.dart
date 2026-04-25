import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/walk_event_provider.dart';
import '../models/walk_event.dart';
import '../widgets/walk_event_card.dart';
import '../widgets/add_walk_event_dialog.dart';
import '../widgets/stats_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WalkEventProvider>().loadWalkEvents();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PottyTracker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddDialog(context),
          ),
        ],
      ),
      body: Consumer<WalkEventProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.walkEvents.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return RefreshIndicator(
            onRefresh: provider.loadWalkEvents,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const StatsCard(),
                const SizedBox(height: 16),
                Text(
                  'Walk Events',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                if (provider.walkEvents.isEmpty && !provider.isLoading)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: Text('No walk events yet. Add your first walk!'),
                    ),
                  )
                else
                  ...provider.walkEvents.map((event) => WalkEventCard(
                        walkEvent: event,
                        onEdit: () => _showEditDialog(context, event),
                        onDelete: () => _showDeleteDialog(context, event),
                      )),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AddWalkEventDialog(
        onSave: (walkEvent) {
          context.read<WalkEventProvider>().addWalkEvent(walkEvent);
        },
      ),
    );
  }

  void _showEditDialog(BuildContext context, WalkEvent walkEvent) {
    showDialog(
      context: context,
      builder: (context) => AddWalkEventDialog(
        walkEvent: walkEvent,
        onSave: (updatedEvent) {
          if (walkEvent.id != null) {
            context.read<WalkEventProvider>().updateWalkEvent(
                  walkEvent.id!,
                  updatedEvent,
                );
          }
        },
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, WalkEvent walkEvent) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Walk Event'),
        content: const Text('Are you sure you want to delete this walk event?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (walkEvent.id != null) {
                context.read<WalkEventProvider>().deleteWalkEvent(walkEvent.id!);
              }
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}