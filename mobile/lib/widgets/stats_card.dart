import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/walk_event_provider.dart';

class StatsCard extends StatefulWidget {
  const StatsCard({super.key});

  @override
  State<StatsCard> createState() => _StatsCardState();
}

class _StatsCardState extends State<StatsCard> {
  Map<String, dynamic>? _stats;
  bool _loadingStats = false;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    setState(() => _loadingStats = true);
    try {
      final provider = context.read<WalkEventProvider>();
      final stats = await provider.getStats();
      if (mounted) {
        setState(() => _stats = stats);
      }
    } catch (e) {
      // Handle error silently for now
    } finally {
      if (mounted) {
        setState(() => _loadingStats = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Statistics',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const Spacer(),
                if (_loadingStats)
                  const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                else
                  IconButton(
                    icon: const Icon(Icons.refresh, size: 20),
                    onPressed: _loadStats,
                  ),
              ],
            ),
            const SizedBox(height: 16),
            if (_stats != null)
              Row(
                children: [
                  Expanded(
                    child: _buildStatItem(
                      context,
                      'Total Walks',
                      '${_stats!['total_walks'] ?? 0}',
                      Icons.directions_walk,
                    ),
                  ),
                  Expanded(
                    child: _buildStatItem(
                      context,
                      'Avg Duration',
                      '${(_stats!['average_duration'] ?? 0).toStringAsFixed(1)} min',
                      Icons.access_time,
                    ),
                  ),
                ],
              )
            else if (!_loadingStats)
              const Center(
                child: Text('Unable to load statistics'),
              ),
            if (_stats != null) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildStatItem(
                      context,
                      'Total Pee',
                      '${_stats!['total_pee'] ?? 0}',
                      Icons.water_drop,
                      color: Colors.yellow.shade700,
                    ),
                  ),
                  Expanded(
                    child: _buildStatItem(
                      context,
                      'Total Poop',
                      '${_stats!['total_poop'] ?? 0}',
                      Icons.circle,
                      color: Colors.brown,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, String label, String value, IconData icon, {Color? color}) {
    return Column(
      children: [
        Icon(icon, color: color ?? Theme.of(context).colorScheme.primary),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}