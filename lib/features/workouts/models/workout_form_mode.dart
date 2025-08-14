/// Enum to distinguish between workout creation and editing modes
enum WorkoutFormMode {
  creation,
  edit,
}

extension WorkoutFormModeExtensions on WorkoutFormMode {
  String get title {
    switch (this) {
      case WorkoutFormMode.creation:
        return 'Create Workout';
      case WorkoutFormMode.edit:
        return 'Edit Workout';
    }
  }

  String get submitButtonText {
    switch (this) {
      case WorkoutFormMode.creation:
        return 'Save Workout';
      case WorkoutFormMode.edit:
        return 'Update Workout';
    }
  }

  String get imagePickerText {
    switch (this) {
      case WorkoutFormMode.creation:
        return 'Add Cover Image';
      case WorkoutFormMode.edit:
        return 'Change Cover Image';
    }
  }
}