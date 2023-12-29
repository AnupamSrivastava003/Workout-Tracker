import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:workout_tracker/components/heap_map.dart';
import 'package:workout_tracker/data/workout_data.dart';
import 'package:workout_tracker/pages/workout_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    Provider.of<WorkoutData>(context, listen: false).initializeWorkoutList();
  }

  //text controller
  final newWorkoutNameController = TextEditingController();

  //create a new workout
  void createNewButton() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          "Create new workout",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: TextField(
          controller: newWorkoutNameController,
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

  //go to workout page
  void goToWorkoutPage(String workoutName) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WorkoutPage(
            workoutName: workoutName,
          ),
        ));
  }

  //save workout
  void save() {
    Provider.of<WorkoutData>(context, listen: false)
        .addWorkout(newWorkoutNameController.text);
    // remove the dialogue after button press
    Navigator.pop(context);
    //clear textfield after button press
    newWorkoutNameController.clear();
  }

  //cancel workout
  void cancel() {
    // remove the dialogue after button press
    Navigator.pop(context);
    //clear textfield after button press
    newWorkoutNameController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutData>(
      builder: (context, value, child) => Scaffold(
          backgroundColor: Colors.grey[900],
          appBar: AppBar(
            title: const Text("Workout Tracker",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                )),
            backgroundColor: Colors.grey[900],
            elevation: 0,
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.grey.shade800,
            onPressed: createNewButton,
            child: const Icon(
              Icons.add,
              color: Color.fromARGB(255, 255, 255, 255),
            ),
          ),
          body: ListView(
            children: [
              //heap map
              MyHeapMap(
                  datasets: value.heatMapDataSet,
                  startDateYYYYMMDD: value.getStartDate()),

              //workout list
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.only(left: 25, right: 25, top: 29),
                  child: Slidable(
                    endActionPane:
                        ActionPane(motion: const StretchMotion(), children: [
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
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 111, 22, 255),
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            topLeft: Radius.circular(20),
                            ),
                      ),
                      padding: const EdgeInsets.all(25),
                      child: ListTile(
                        title: Text(
                          value.getWorkoutList()[index].name,
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                        trailing: IconButton(
                          onPressed: () => goToWorkoutPage(
                              value.getWorkoutList()[index].name),
                          icon: const Icon(Icons.arrow_forward_ios,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
                itemCount: value.getWorkoutList().length,
              ),
            ],
          )),
    );
  }
}
