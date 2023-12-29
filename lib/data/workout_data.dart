import 'package:flutter/material.dart';
import 'package:workout_tracker/data/hive_database.dart';
import 'package:workout_tracker/datetime/date_time.dart';
import 'package:workout_tracker/models/exercise.dart';
import 'package:workout_tracker/models/workout.dart';

class WorkoutData extends ChangeNotifier {
  final db = HiveDatabase();
  /*

  - This overall list contains different workouts
  - Each workout has name and list of exercises
  
  */

  List<Workout> workoutList = [
  ];

  void initializeWorkoutList() {
    if (db.previousDataExists()) {
      workoutList = db.readFromDatabase();
    } else {
      db.saveToDatabase(workoutList);
    }
    //load heap map
    loadHeapMap();
  }

  //get the list of workout
  List<Workout> getWorkoutList() {
    return workoutList;
  }

  //length of given workout
  int numberOfExerciseInWorkout(String workoutName) {
    Workout relevantWorkout = getRelevantWorkout(workoutName);
    return relevantWorkout.exercises.length;
  }

  //add the workout
  void addWorkout(String name) {
    //add a new workout with a blank list of exercise
    workoutList.add(Workout(name: name, exercises: []));
    notifyListeners();
    //save to database
    db.saveToDatabase(workoutList);
  }

  //add an exercise to the workout
  void addExercise(String workoutName, String exerciseName, String weight,
      String reps, String sets) {
    //find relevant workout
    Workout relevantWorkout = getRelevantWorkout(workoutName);

    relevantWorkout.exercises.add(
        Exercise(name: exerciseName, weight: weight, reps: reps, sets: sets));
    notifyListeners();
    //save to database
    db.saveToDatabase(workoutList);
  }

  //check off exercise
  void checkOffExercise(String workoutName, String exerciseName) {
    //find relevant workout and exercise in the workout
    Exercise relevantExercise = getRelevantExercise(workoutName, exerciseName);
    //check off boolean to show user completed the exercise
    relevantExercise.isCompleted = !relevantExercise.isCompleted;
    notifyListeners();
    //save to database
    db.saveToDatabase(workoutList);
    //load heap map
    loadHeapMap();
    
  }

  // return relevant workout object, given a workout name
  Workout getRelevantWorkout(String workoutName) {
    Workout relevantWorkout =
        workoutList.firstWhere((workout) => workout.name == workoutName);
    return relevantWorkout;
  }

  // return relevant exercise object, given a workout name + exercise name
  Exercise getRelevantExercise(String workoutName, String exerciseName) {
    // find relevant workout first
    Workout relevantWorkout = getRelevantWorkout(workoutName);

    //then find the relevant exercise in that workout
    Exercise relevantExercise = relevantWorkout.exercises
        .firstWhere((exercise) => exercise.name == exerciseName);
    return relevantExercise;
  }

  //get start date
  String getStartDate() {
    return db.getStartDate();
  }

  /*

    HEAP MAP

  */
  Map<DateTime, int> heatMapDataSet = {}; 

  //loading the heapmap
  void loadHeapMap() {
    DateTime startDate = createDateTimeObject(getStartDate());

    //count the number of days to load
    int daysInBetween = DateTime.now().difference(startDate).inDays;

    // go from start date to today, and add each completion status to the dataset
    // "COMPLETION_STATUS_yyyymmdd" will be the key in the database
    for (int i = 0; i < daysInBetween + 1; i++) {
      String yyyymmdd =
          convertDateTimeToYYYYMMDD(startDate.add(const Duration(days: 1)));

      // complettion status = 0 or 1
      int completionStatus = db.getCompletionStatus(yyyymmdd);

      // year
      int year = startDate.add(Duration(days: i)).year;

      // month
      int month = startDate.add(Duration(days: i)).month;

      // day
      int day = startDate.add(Duration(days: i)).day;

      final percentForEachDay = <DateTime, int>{
        DateTime(year, month, day) : completionStatus
      };

      // add to the heat map dataset
      heatMapDataSet.addEntries(percentForEachDay.entries);
    }
  }
}
