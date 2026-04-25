import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/walk_event.dart';

class WalkEventCard extends StatelessWidget {
  final WalkEvent walkEvent;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const WalkEventCard({
    super.key,
    required this.walkEvent,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    DateFormat('MMM dd, yyyy - HH:mm').format(walkEvent.timestamp),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                if (onEdit != null || onDelete != null)
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'edit' && onEdit != null) onEdit!();
                      if (value == 'delete' && onDelete != null) onDelete!();
                    },
                    itemBuilder: (context) => [
                      if (onEdit != null)
                        const PopupMenuItem(
                          value: 'edit',
                          child: Text('Edit'),
                        ),
                      if (onDelete != null)
                        const PopupMenuItem(
                          value: 'delete',
                          child: Text('Delete'),
                        ),
                    ],
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildStatChip(
                  context,
                  Icons.access_time,
                  '${walkEvent.durationMinutes} min',
                  Colors.blue,
                ),
                const SizedBox(width: 8),
                _buildStatChip(
                  context,
                  Icons.water_drop,
                  '${walkEvent.peeCount}',
                  Colors.yellow.shade700,
                ),
                const SizedBox(width: 8),
                _buildStatChip(
                  context,
                  Icons.circle,
                  '${walkEvent.poopCount}',
                  Colors.brown,
                ),
              ],
            ),
            if (walkEvent.notes != null && walkEvent.notes!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                walkEvent.notes!,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatChip(BuildContext context, IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(color: color, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}