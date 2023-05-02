import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:health/health.dart';

import 'health_screen.dart';

class SleepScreen extends StatefulWidget {
  const SleepScreen({super.key});

  @override
  State<SleepScreen> createState() => _SleepScreenState();
}

class _SleepScreenState extends State<SleepScreen> {
  List<HealthDataPoint> _healthDataList = [];
  AppState _state = AppState.DATA_NOT_FETCHED;

  HealthFactory health = HealthFactory(useHealthConnectIfAvailable: true);

  /// Fetch steps from the health plugin and show them in the app.
  Future fetchSleepData() async {
    setState(() => _state = AppState.FETCHING_DATA);
    var sleep;

    // get steps for today (i.e., since midnight)
    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day);

    bool requested =
        await health.requestAuthorization([HealthDataType.SLEEP_IN_BED]);

    print('requested -->>>>>  $requested');

    if (requested) {
      try {
        sleep = await health.getHealthDataFromTypes(
            midnight, now, [HealthDataType.SLEEP_IN_BED]);

        print('sleep -->>>>>>>  $sleep');
      } catch (error) {
        print("Caught exception in getTotalStepsInInterval: $error");
      }

      print('Total number of SLEEP: $sleep');

      setState(() {
        _healthDataList = (sleep == null) ? [] : sleep;
        _state = (sleep == null) ? AppState.NO_DATA : AppState.SLEEP;
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
                  onTap: fetchSleepData,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 20.0),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 08.0),
                    color: Colors.pink.withOpacity(0.6),
                    child: const Text('SLEEP DATA'),
                  ),
                ),
                _healthDataList.isEmpty
                    ? Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        child: Center(child: Text('No Data Avaialble')),
                      )
                    : SizedBox(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: _healthDataList.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin:
                                  const EdgeInsets.symmetric(vertical: 20.0),
                              child: Column(
                                children: [
                                  Text(
                                      'Total SLEEP value: ${_healthDataList[index]}'),
                                  // Text(
                                  //     'Total SLEEP source name: ${_healthDataList[index].sourceName}'),
                                  // Text(
                                  //     'Total SLEEP unit: ${_healthDataList[index].unit}'),
                                  // Text(
                                  //     'Total SLEEP Type: ${_healthDataList[index].type}'),
                                  // Text(
                                  //     'Total SLEEP Date: ${_healthDataList[index].dateFrom}'),
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
