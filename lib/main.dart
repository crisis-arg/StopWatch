import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeApp(),
    );
  }
}

class HomeApp extends StatefulWidget {
  const HomeApp({super.key});

  @override
  State<HomeApp> createState() => _HomeAppState();
}

class _HomeAppState extends State<HomeApp> {
  int seconds = 0, minutes = 0, hours = 0;
  String digitSeconds = "00", digitMinutes = "00", digitHours = "00";
  Timer? timer;
  bool started = false;
  List laps = [];

  //stop timer function
  void stop() {
    timer!.cancel();
    setState(() {
      started = false;
    });
  }

  //reset function
  void reset() {
    timer!.cancel();
    setState(() {
      seconds = 0;
      minutes = 0;
      hours = 0;

      digitSeconds = "00";
      digitMinutes = "00";
      digitHours = "00";

      started = false;
    });
  }

  void addLaps() {
    String lap = "$digitHours:$digitMinutes:$digitSeconds";
    setState(() {
      laps.add(lap);
    });
  }

  //start timer function
  void start() {
    started = true;
    timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        int localSeconds = seconds + 1;
        int localMinutes = minutes;
        int localHours = hours;
        if (localSeconds > 59) {
          if (localMinutes > 59) {
            localHours++;
            localMinutes = 0;
          } else {
            localMinutes++;
            localSeconds = 0;
          }
        }
        setState(() {
          seconds = localSeconds;
          minutes = localMinutes;
          hours = localHours;
          digitSeconds = (seconds >= 10) ? "$seconds" : "0$seconds";
          digitMinutes = (minutes >= 10) ? "$minutes" : "0$minutes";
          digitHours = (hours >= 10) ? "$hours" : "0$hours";
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C2757),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Center(
                child: Text(
                  "StopWatch App",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              Center(
                child: Text(
                  "$digitHours:$digitMinutes:$digitSeconds",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 82.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                height: 400.0,
                decoration: BoxDecoration(
                  color: const Color(0xFF323F68),
                  borderRadius: BorderRadius.circular(16.0),
                ),
                //list builder
                child: Scrollbar(
                  thumbVisibility: true,
                  radius: const Radius.circular(16.0),
                  child: ListView.builder(
                    itemCount: laps.length,
                    itemBuilder: (
                      context,
                      index,
                    ) {
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Lap no. ${index + 1}",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                              ),
                            ),
                            Text(
                              "${laps[index]}",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: RawMaterialButton(
                      onPressed: () {
                        (!started) ? start() : stop();
                      },
                      shape: const StadiumBorder(
                        side: BorderSide(color: Colors.blue),
                      ),
                      child: Text(
                        (!started) ? "start" : "pause",
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    color: Colors.white,
                    onPressed: () {
                      addLaps();
                    },
                    icon: const Icon(Icons.flag),
                  ),
                  Expanded(
                    child: RawMaterialButton(
                      onPressed: () {
                        reset();
                        laps.clear();
                      },
                      fillColor: Colors.blue,
                      shape: const StadiumBorder(),
                      child: const Text(
                        'Reset',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
