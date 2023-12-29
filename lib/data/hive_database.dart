import 'package:hive/hive.dart';
import 'package:workout_tracker/datetime/date_time.dart';
import 'package:workout_tracker/models/exercise.dart';
import 'package:workout_tracker/models/workout.dart';

class HiveDatabase {
  // reference our hive box
  final _myBox = Hive.box("workout_database1");

  // check if there is already data stored, if not, record the start date
  bool previousDataExists() {
    if (_myBox.isEmpty) {
      print("Previous data does not exists.");
      _myBox.put("START_DATE", todaysDateYYYYMMDD());
      return false;
    } else {
      print("Previous data exists.");
      return true;
    }
  }

  // return start date as yyyymmdd
  String getStartDate() {
    return _myBox.get("START_DATE");
  }

  // write data
  void saveToDatabase(List<Workout> workouts) {
    // convert workout objects into lists of strings so that we can save in hive
    final workoutList = convertObjectToWorkoutList(workouts);
    final exerciseList = convertObjectToExerciseList(workouts);

    //check if any exercises have been done
    //we will put a 0 or 1 for each yyyymmdd date

    if (exerciseCompleted(workouts)) {
      _myBox.put("COMPLETION_STATUS_${todaysDateYYYYMMDD()}", 1);
    } else {
      _myBox.put("COMPLETION_STATUS_${todaysDateYYYYMMDD()}", 0);
    }

    //save the workout and exercise
    _myBox.put("WORKOUTS", workoutList);
    _myBox.put("EXERCISES", exerciseList);
  }

  // read data, and return a list of workouts
  List<Workout> readFromDatabase() {
    List<Workout> mySavedWorkouts = [];
    List<String> workoutNames = _myBox.get("WORKOUTS");
    final exerciseDetails = _myBox.get("EXERCISES");

    for (int i = 0; i < workoutNames.length; i++) {
      List<Exercise> exercisesInEachWorkout = [];
      for (int j = 0; j < exerciseDetails[i].length; j++) {
        exercisesInEachWorkout.add(Exercise(
          name: exerciseDetails[i][j][0],
          weight: exerciseDetails[i][j][1],
          reps: exerciseDetails[i][j][2],
          sets: exerciseDetails[i][j][3],
          isCompleted: exerciseDetails[i][j][4] == "true" ? true : false,
        ));
      }

      //create individual workout
      Workout workout =
          Workout(name: workoutNames[i], exercises: exercisesInEachWorkout);

      //add workout to overall list
      mySavedWorkouts.add(workout);
    }
    return mySavedWorkouts;
  }

  // return completion status of a given date yyyymmdd
  bool exerciseCompleted(List<Workout> workouts) {
    for (var workout in workouts) {
      for (var exercise in workout.exercises) {
        if (exercise.isCompleted) {
          return true;
        }
      }
    }
    return false;
  }

  // return complete status of a given date yyyymmdd
  int getCompletionStatus(String yyyymmdd) {
    // return 0 or 1, if null then return 0
    int completionStatus = _myBox.get("COMPLETION_STATUS_$yyyymmdd") ?? 0;
    return completionStatus;
  }

}
// converts workout obiects into a list
List<String> convertObjectToWorkoutList(List<Workout> workouts) {
  List<String> workoutList = [
    // eg. [upperbody, lowerbody]
  ];

  for (int i = 0; i < workouts.length; i++) {
    // in each workout, add the name, followed by lists of exercises
    workoutList.add(
      workouts[i].name,
    );
  }
  return workoutList;
}

// converts the exercises in a workout object into a list of strings
List<List<List<String>>> convertObjectToExerciseList(List<Workout> workouts) {
  List<List<List<String>>> exerciseList = [];

  for (int i = 0; i < workouts.length; i++) {
    List<Exercise> exercisesInWorkout = workouts[i].exercises;
    List<List<String>> individualWorkout = [];

    for (int j = 0; j < exercisesInWorkout.length; j++) {
      List<String> individualExercise = [];
      individualExercise.addAll(
        [
          exercisesInWorkout[j].name,
          exercisesInWorkout[j].weight,
          exercisesInWorkout[j].reps,
          exercisesInWorkout[j].sets,
          exercisesInWorkout[j].isCompleted.toString(),
        ],
      );
      individualWorkout.add(individualExercise);
    }
    exerciseList.add(individualWorkout);
  }
  return exerciseList;
}

