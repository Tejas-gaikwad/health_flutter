import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:health/health.dart';

import 'health_screen.dart';

class Calories extends StatefulWidget {
  const Calories({super.key});

  @override
  State<Calories> createState() => _CaloriesState();
}

class _CaloriesState extends State<Calories> {
  List<HealthDataPoint> _healthDataList = [];
  AppState _state = AppState.DATA_NOT_FETCHED;

  HealthFactory health = HealthFactory(useHealthConnectIfAvailable: true);

  /// Fetch steps from the health plugin and show them in the app.
  Future fetchCaloriesData() async {
    setState(() => _state = AppState.FETCHING_DATA);
    var calories_burned;

    // get steps for today (i.e., since midnight)
    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day);

    bool requested = await health
        .requestAuthorization([HealthDataType.ACTIVE_ENERGY_BURNED]);

    print('requested -->>>>>  $requested');

    if (requested) {
      try {
        // steps = await health.getTotalStepsInInterval(midnight, now);
        // calories_burned = await health
        //     .getHealthDataFromTypes(midnight, now, [HealthDataType.calories_burned]);

        calories_burned = await health.getHealthDataFromTypes(
            midnight, now, [HealthDataType.ACTIVE_ENERGY_BURNED]);

        print('calories_burned -->>>>>>>  $calories_burned');
      } catch (error) {
        print("Caught exception in getTotalStepsInInterval: $error");
      }

      print('Total number of calories: $calories_burned');

      setState(() {
        _healthDataList = (calories_burned == null) ? [] : calories_burned;
        _state =
            (calories_burned == null) ? AppState.NO_DATA : AppState.CALORIES;
      });
    } else {
      print("Authorization not granted - error in authorization");
      setState(() => _state = AppState.DATA_NOT_FETCHED);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: SingleChildScrollView(
            child: Column(
              children: [
                InkWell(
                  onTap: fetchCaloriesData,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 20.0),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 08.0),
                    color: Colors.pink.withOpacity(0.6),
                    child: const Text('calories'),
                  ),
                ),
                SizedBox(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _healthDataList.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 20.0),
                        child: Column(
                          children: [
                            Text(
                                'Total calories value: ${_healthDataList[index].value}'),
                            Text(
                                'Total calories source name: ${_healthDataList[index].sourceName}'),
                            Text(
                                'Total calories unit: ${_healthDataList[index].unit}'),
                            Text(
                                'Total calories Type: ${_healthDataList[index].type}'),
                            Text(
                                'Total calories Date: ${_healthDataList[index].dateFrom}'),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
