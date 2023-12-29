import 'package:flutter/material.dart';

class ExerciseTile extends StatelessWidget {
  final String exerciseName;
  final String weight;
  final String sets;
  final String reps;
  final bool isCompleted;
  void Function(bool?)? onCheckBoxChanged;

  ExerciseTile({
    super.key,
    required this.exerciseName,
    required this.isCompleted,
    required this.reps,
    required this.sets,
    required this.weight,
    required this.onCheckBoxChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 111, 22, 255),
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20),bottomLeft: Radius.circular(20)),
        border: Border.all(width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 25.0),
        child: ListTile(
          title: Padding(
            padding: const EdgeInsets.only(left: 12, bottom: 10),
            child: Text(
              exerciseName,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Colors.white),
            ),
          ),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Chip(
                label: Text(
                  "$weight kgs",
                  style: const TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.grey[900],
              ),
              Chip(
                label: Text(
                  "$sets Sets",
                  style: const TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.grey[900],
              ),
              Chip(
                label: Text(
                  "$reps Reps",
                  style: const TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.grey[900],
              ),
            ],
          ),
          trailing: Checkbox(
            activeColor: Colors.white,
            splashRadius: 100,
            checkColor: const Color.fromARGB(255, 111, 22, 255),
            value: isCompleted,
            onChanged: (value) => onCheckBoxChanged!(value),
          ),
        ),
      ),
    );
  }
}
