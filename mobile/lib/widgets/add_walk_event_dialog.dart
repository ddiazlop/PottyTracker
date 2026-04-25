import 'package:flutter/material.dart';
import '../models/walk_event.dart';

class AddWalkEventDialog extends StatefulWidget {
  final WalkEvent? walkEvent;
  final Function(WalkEvent) onSave;

  const AddWalkEventDialog({
    super.key,
    this.walkEvent,
    required this.onSave,
  });

  @override
  State<AddWalkEventDialog> createState() => _AddWalkEventDialogState();
}

class _AddWalkEventDialogState extends State<AddWalkEventDialog> {
  final _formKey = GlobalKey<FormState>();
  late DateTime _timestamp;
  late int _durationMinutes;
  late int _peeCount;
  late int _poopCount;
  late TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    _timestamp = widget.walkEvent?.timestamp ?? DateTime.now();
    _durationMinutes = widget.walkEvent?.durationMinutes ?? 30;
    _peeCount = widget.walkEvent?.peeCount ?? 0;
    _poopCount = widget.walkEvent?.poopCount ?? 0;
    _notesController = TextEditingController(text: widget.walkEvent?.notes ?? '');
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.walkEvent == null ? 'Add Walk Event' : 'Edit Walk Event'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Date and Time
              ListTile(
                title: const Text('Date & Time'),
                subtitle: Text(_timestamp.toString().split('.')[0]),
                trailing: const Icon(Icons.calendar_today),
                onTap: _selectDateTime,
              ),
              const SizedBox(height: 16),

              // Duration
              TextFormField(
                initialValue: _durationMinutes.toString(),
                decoration: const InputDecoration(
                  labelText: 'Duration (minutes)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter duration';
                  }
                  final duration = int.tryParse(value);
                  if (duration == null || duration <= 0) {
                    return 'Please enter a valid duration';
                  }
                  return null;
                },
                onSaved: (value) => _durationMinutes = int.parse(value!),
              ),
              const SizedBox(height: 16),

              // Pee Count
              TextFormField(
                initialValue: _peeCount.toString(),
                decoration: const InputDecoration(
                  labelText: 'Pee Count',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return null; // Optional field
                  }
                  final count = int.tryParse(value);
                  if (count == null || count < 0) {
                    return 'Please enter a valid count';
                  }
                  return null;
                },
                onSaved: (value) => _peeCount = int.tryParse(value!) ?? 0,
              ),
              const SizedBox(height: 16),

              // Poop Count
              TextFormField(
                initialValue: _poopCount.toString(),
                decoration: const InputDecoration(
                  labelText: 'Poop Count',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return null; // Optional field
                  }
                  final count = int.tryParse(value);
                  if (count == null || count < 0) {
                    return 'Please enter a valid count';
                  }
                  return null;
                },
                onSaved: (value) => _poopCount = int.tryParse(value!) ?? 0,
              ),
              const SizedBox(height: 16),

              // Notes
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Notes (optional)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _save,
          child: const Text('Save'),
        ),
      ],
    );
  }

  Future<void> _selectDateTime() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _timestamp,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_timestamp),
      );

      if (pickedTime != null) {
        setState(() {
          _timestamp = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final walkEvent = WalkEvent(
        id: widget.walkEvent?.id,
        timestamp: _timestamp,
        durationMinutes: _durationMinutes,
        peeCount: _peeCount,
        poopCount: _poopCount,
        notes: _notesController.text.isEmpty ? null : _notesController.text,
      );

      widget.onSave(walkEvent);
      Navigator.of(context).pop();
    }
  }
}