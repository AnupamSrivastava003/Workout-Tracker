import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:workout_tracker/datetime/date_time.dart';


class MyHeapMap extends StatelessWidget {
  final Map<DateTime, int>? datasets;
  final String startDateYYYYMMDD;

  const MyHeapMap({super.key,
  required this.datasets,
  required this.startDateYYYYMMDD,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(25),
      child: HeatMap(
        startDate: createDateTimeObject(startDateYYYYMMDD),
        endDate: DateTime.now().add(const Duration(days: 0)),
        datasets: datasets,
        colorMode: ColorMode.color,
        defaultColor: Colors.grey[800],
        textColor: Colors.white,
        showColorTip: true ,
        colorTipCount: 4,
        showText: true,
        scrollable: true,
        size: 30,
        colorsets: const {
            1: Color.fromARGB(255, 145, 216, 147),
            3: Colors.green,
            5: Color.fromARGB(255, 55, 141, 58),
            7: Color.fromARGB(255, 0, 101, 3),
        },
      ),
    );
  }
}