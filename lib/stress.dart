import 'package:flutter/material.dart';
import 'package:health/health.dart';
import 'health_screen.dart';

class StressScreen extends StatefulWidget {
  const StressScreen({super.key});

  @override
  State<StressScreen> createState() => _StressScreenState();
}

class _StressScreenState extends State<StressScreen> {
  List<HealthDataPoint> _healthDataList = [];
  AppState _state = AppState.DATA_NOT_FETCHED;
  var _stressScreen;

  HealthFactory health = HealthFactory(useHealthConnectIfAvailable: true);

  Future fetchStepData() async {
    int? stressData;

    // get StressScreen for today (i.e., since midnight)
    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day);

    bool requested = await health
        .requestAuthorization([HealthDataType.ACTIVE_ENERGY_BURNED]);

    if (requested) {
      try {
        // stressData =
        //     await health.getHealthDataFromTypes(midnight, now, [HealthDataType.]);
      } catch (error) {
        print("Caught exception in getTotalStressScreenInInterval: $error");
      }

      print('Total number of StressScreen: $StressScreen');

      setState(() {
        _stressScreen = (StressScreen == null) ? 0 : StressScreen;
        _state = (StressScreen == null) ? AppState.NO_DATA : AppState.STRESS;
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
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: fetchStepData,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 20.0),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 08.0),
                    color: Colors.pink.withOpacity(0.6),
                    child: const Text('StressScreen'),
                  ),
                ),
                SizedBox(height: 150),
                SizedBox(
                  child: Text(
                      'Total StressScreen is : ${_stressScreen.toString()}'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
