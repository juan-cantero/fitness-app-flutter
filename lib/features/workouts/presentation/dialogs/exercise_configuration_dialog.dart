import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../providers/workout_creation_providers.dart';

class ExerciseConfigurationDialog extends StatefulWidget {
  final WorkoutExerciseConfig exerciseConfig;
  final Function(WorkoutExerciseConfig) onConfigurationUpdated;

  const ExerciseConfigurationDialog({
    super.key,
    required this.exerciseConfig,
    required this.onConfigurationUpdated,
  });

  @override
  State<ExerciseConfigurationDialog> createState() => _ExerciseConfigurationDialogState();
}

class _ExerciseConfigurationDialogState extends State<ExerciseConfigurationDialog> {
  late TextEditingController _setsController;
  late TextEditingController _repsController;
  late TextEditingController _weightController;
  late TextEditingController _durationMinutesController;
  late TextEditingController _durationSecondsController;
  late TextEditingController _restTimeController;
  late TextEditingController _notesController;

  bool _isTimeBasedExercise = false;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _isTimeBasedExercise = widget.exerciseConfig.durationSeconds != null;
  }

  void _initializeControllers() {
    _setsController = TextEditingController(text: widget.exerciseConfig.sets.toString());
    _repsController = TextEditingController(
      text: widget.exerciseConfig.reps?.toString() ?? '',
    );
    _weightController = TextEditingController(
      text: widget.exerciseConfig.weightKg?.toString() ?? '',
    );
    
    final duration = widget.exerciseConfig.durationSeconds ?? 0;
    final minutes = duration ~/ 60;
    final seconds = duration % 60;
    _durationMinutesController = TextEditingController(text: minutes > 0 ? minutes.toString() : '');
    _durationSecondsController = TextEditingController(text: seconds > 0 ? seconds.toString() : '');
    
    _restTimeController = TextEditingController(
      text: widget.exerciseConfig.restTimeSeconds.toString(),
    );
    _notesController = TextEditingController(
      text: widget.exerciseConfig.notes ?? '',
    );
  }

  @override
  void dispose() {
    _setsController.dispose();
    _repsController.dispose();
    _weightController.dispose();
    _durationMinutesController.dispose();
    _durationSecondsController.dispose();
    _restTimeController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        constraints: const BoxConstraints(maxWidth: 500),
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Configure Exercise',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              
              // Exercise name
              Text(
                widget.exerciseConfig.exercise.name,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
              const SizedBox(height: 24),

              // Sets
              TextFormField(
                controller: _setsController,
                decoration: const InputDecoration(
                  labelText: 'Sets *',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              const SizedBox(height: 16),

              // Exercise type toggle
              Row(
                children: [
                  Expanded(
                    child: SegmentedButton<bool>(
                      segments: const [
                        ButtonSegment(
                          value: false,
                          label: Text('Reps'),
                          icon: Icon(Icons.repeat),
                        ),
                        ButtonSegment(
                          value: true,
                          label: Text('Time'),
                          icon: Icon(Icons.timer),
                        ),
                      ],
                      selected: {_isTimeBasedExercise},
                      onSelectionChanged: (Set<bool> selection) {
                        setState(() {
                          _isTimeBasedExercise = selection.first;
                          // Clear the opposite field when switching
                          if (_isTimeBasedExercise) {
                            _repsController.clear();
                          } else {
                            _durationMinutesController.clear();
                            _durationSecondsController.clear();
                          }
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Reps or Duration based on toggle
              if (!_isTimeBasedExercise) ...[
                TextFormField(
                  controller: _repsController,
                  decoration: const InputDecoration(
                    labelText: 'Reps',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
              ] else ...[
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _durationMinutesController,
                        decoration: const InputDecoration(
                          labelText: 'Minutes',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _durationSecondsController,
                        decoration: const InputDecoration(
                          labelText: 'Seconds',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 16),

              // Weight
              TextFormField(
                controller: _weightController,
                decoration: const InputDecoration(
                  labelText: 'Weight (kg)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                ],
              ),
              const SizedBox(height: 16),

              // Rest time
              TextFormField(
                controller: _restTimeController,
                decoration: const InputDecoration(
                  labelText: 'Rest Time (seconds)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              const SizedBox(height: 16),

              // Notes
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Notes',
                  border: OutlineInputBorder(),
                  hintText: 'Add any additional notes for this exercise',
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 24),

              // Action buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 16),
                  FilledButton(
                    onPressed: _saveConfiguration,
                    child: const Text('Save'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveConfiguration() {
    // Validate sets (required)
    final sets = int.tryParse(_setsController.text);
    if (sets == null || sets <= 0) {
      _showError('Sets must be a positive number');
      return;
    }

    // Parse optional fields
    final reps = _isTimeBasedExercise ? null : int.tryParse(_repsController.text);
    final weight = double.tryParse(_weightController.text);
    final restTime = int.tryParse(_restTimeController.text) ?? 60;

    // Parse duration for time-based exercises
    int? durationSeconds;
    if (_isTimeBasedExercise) {
      final minutes = int.tryParse(_durationMinutesController.text) ?? 0;
      final seconds = int.tryParse(_durationSecondsController.text) ?? 0;
      if (minutes > 0 || seconds > 0) {
        durationSeconds = (minutes * 60) + seconds;
      }
    }

    // Validation: Either reps or duration must be specified
    if (!_isTimeBasedExercise && reps == null) {
      _showError('Please specify the number of reps');
      return;
    }
    if (_isTimeBasedExercise && durationSeconds == null) {
      _showError('Please specify the duration');
      return;
    }

    // Create updated configuration
    final updatedConfig = widget.exerciseConfig.copyWith(
      sets: sets,
      reps: reps,
      weightKg: weight,
      durationSeconds: durationSeconds,
      restTimeSeconds: restTime,
      notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
    );

    widget.onConfigurationUpdated(updatedConfig);
    Navigator.of(context).pop();
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }
}