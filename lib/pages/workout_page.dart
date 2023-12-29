import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:workout_tracker/components/exercise_tile.dart';
import 'package:workout_tracker/data/workout_data.dart';

class WorkoutPage extends StatefulWidget {
  final String workoutName;
  const WorkoutPage({super.key, required this.workoutName});

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  //checkbox was tapped
  void onCheckBoxChanged(String workoutName, String exerciseName) {
    Provider.of<WorkoutData>(context, listen: false)
        .checkOffExercise(workoutName, exerciseName);
  }

  //text controller
  final exerciseNameController = TextEditingController();
  final weightController = TextEditingController();
  final setsController = TextEditingController();
  final repsController = TextEditingController();

  //create new exercise
  void createNewExercise() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          "Add new exercise",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            //name
            TextField(
              controller: exerciseNameController,
            ),
            //weight
            TextField(
              controller: weightController,
            ),
            //reps
            TextField(
              controller: repsController,
            ),
            //sets
            TextField(
              controller: setsController,
            ),
          ],
        ),
        actions: [
          MaterialButton(
            onPressed: save,
            child: const Text("save"),
          ),
          MaterialButton(
            onPressed: cancel,
            child: const Text("cancel"),
          ),
        ],
      ),
    );
  }

  //save workout
  void save() {
    Provider.of<WorkoutData>(context, listen: false).addExercise(
        widget.workoutName,
        exerciseNameController.text,
        weightController.text,
        setsController.text,
        repsController.text);
    // remove the dialogue after button press
    Navigator.pop(context);
    //clear textfield after button press
    exerciseNameController.clear();
    weightController.clear();
    setsController.clear();
    repsController.clear();
  }

  //cancel workout
  void cancel() {
    // remove the dialogue after button press
    Navigator.pop(context);
    //clear textfield after button press
    exerciseNameController.clear();
    weightController.clear();
    setsController.clear();
    repsController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutData>(
      builder: (context, value, child) => Scaffold(
        backgroundColor: Colors.grey[900],
        appBar: AppBar(
          title: Text(widget.workoutName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              )),
          backgroundColor: Colors.grey[900],
          elevation: 0,
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.grey.shade800,
          onPressed: createNewExercise,
          child: const Icon(
            Icons.add,
            color: Color.fromARGB(255, 255, 255, 255),
          ),
        ),
        body: ListView.builder(
          itemCount: value.numberOfExerciseInWorkout(widget.workoutName),
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 25),
            child: Slidable(
              endActionPane: ActionPane(motion: const StretchMotion(), children: [
                SlidableAction(
                  onPressed: (context) => {},
                  backgroundColor: const Color.fromARGB(255, 239, 239, 239),
                  icon: Icons.edit,
                  
                ),
                SlidableAction(
                  onPressed: (context) => {},
                  backgroundColor: Colors.red,
                  icon: Icons.delete,
                  
                ),
              ]),
              child: ExerciseTile(
                exerciseName: value
                    .getRelevantWorkout(widget.workoutName)
                    .exercises[index]
                    .name,
                weight: value
                    .getRelevantWorkout(widget.workoutName)
                    .exercises[index]
                    .weight,
                sets: value
                    .getRelevantWorkout(widget.workoutName)
                    .exercises[index]
                    .sets,
                reps: value
                    .getRelevantWorkout(widget.workoutName)
                    .exercises[index]
                    .reps,
                isCompleted: value
                    .getRelevantWorkout(widget.workoutName)
                    .exercises[index]
                    .isCompleted,
                onCheckBoxChanged: (val) => onCheckBoxChanged(
                    widget.workoutName,
                    value
                        .getRelevantWorkout(widget.workoutName)
                        .exercises[index]
                        .name),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
