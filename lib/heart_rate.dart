import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:health/health.dart';

import 'health_screen.dart';

class HeartRate extends StatefulWidget {
  const HeartRate({super.key});

  @override
  State<HeartRate> createState() => _HeartRateState();
}

class _HeartRateState extends State<HeartRate> {
  List<HealthDataPoint> _healthDataList = [];
  AppState _state = AppState.DATA_NOT_FETCHED;

  HealthFactory health = HealthFactory(useHealthConnectIfAvailable: true);

  /// Fetch steps from the health plugin and show them in the app.
  Future fetchHeartRateData() async {
    setState(() => _state = AppState.FETCHING_DATA);
    var heart_rate;

    // get steps for today (i.e., since midnight)
    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day);

    bool requested =
        await health.requestAuthorization([HealthDataType.HEART_RATE]);

    print('requested -->>>>>  $requested');

    if (requested) {
      try {
        // steps = await health.getTotalStepsInInterval(midnight, now);
        // heart_rate = await health
        //     .getHealthDataFromTypes(midnight, now, [HealthDataType.HEART_RATE]);

        heart_rate = await health
            .getHealthDataFromTypes(midnight, now, [HealthDataType.HEART_RATE]);

        print('heart_rate -->>>>>>>  $heart_rate');
      } catch (error) {
        print("Caught exception in getTotalStepsInInterval: $error");
      }

      print('Total number of Heart Rate: $heart_rate');

      setState(() {
        _healthDataList = (heart_rate == null) ? [] : heart_rate;
        _state = (heart_rate == null) ? AppState.NO_DATA : AppState.HEART_RATE;
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
          child: Column(
            children: [
              InkWell(
                onTap: fetchHeartRateData,
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 20.0),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 08.0),
                  color: Colors.pink.withOpacity(0.6),
                  child: const Text('heart_beat'),
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
                              'Total Heart Rate value: ${_healthDataList[index].value}'),
                          Text(
                              'Total Heart Rate source name: ${_healthDataList[index].sourceName}'),
                          Text(
                              'Total Heart Rate unit: ${_healthDataList[index].unit}'),
                          Text(
                              'Total Heart Rate Type: ${_healthDataList[index].type}'),
                          Text(
                              'Total Heart Rate Date: ${_healthDataList[index].dateFrom}'),
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
    );
  }
}
