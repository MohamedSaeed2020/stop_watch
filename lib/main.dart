import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stop_watch/business_logic/bloc_observer.dart';
import 'package:stop_watch/business_logic/posts_bloc/stop_watch_bloc.dart';
import 'package:stop_watch/data/ticker.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

void main() {
  //to observe the bloc states
  // Bloc.observer = MyBlocObserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color.fromRGBO(109, 234, 255, 1),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: const Color.fromRGBO(72, 74, 126, 1),
          brightness: Brightness.dark,
        ),
      ),
      home: BlocProvider<StopWatchBloc>(
        create: (context) => StopWatchBloc(ticker: Ticker(), duration: 60),
        child: const Home(),
      ),
    );
  }
}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stop Watch'),
      ),
      body: Stack(
        children: [
          const BackGroundWaves(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ///Time
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 100.0),
                child: Center(
                  child: BlocBuilder<StopWatchBloc, StopWatchStates>(
                    builder: (context, state) {
                      debugPrint('Timer: ${state.runtimeType}  ***  ${state.duration}');
                      final String minutes = ((state.duration / 60) % 60)
                          .floor()
                          .toString()
                          .padLeft(2, '0');
                      final String seconds = (state.duration % 60)
                          .floor()
                          .toString()
                          .padLeft(2, '0');
                      return Text(
                        '$minutes : $seconds',
                        style: const TextStyle(
                          fontSize: 60.0,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                ),
              ),
              ///Buttons
              BlocBuilder<StopWatchBloc, StopWatchStates>(

                builder: (context, state) {
                  debugPrint('builder --> ${state.runtimeType}');
                  return const Actions();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Actions extends StatelessWidget {
  const Actions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint('ActionsBuild');
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: mapStateToActionButtons(
          stopWatchBloc: BlocProvider.of<StopWatchBloc>(context,listen: true)),
    );
  }

  List<Widget> mapStateToActionButtons({required StopWatchBloc stopWatchBloc}) {
    final StopWatchStates currentState = stopWatchBloc.state;
    if (currentState is ReadyState) {
      return [
        FloatingActionButton(
          child: const Icon(Icons.play_arrow),
          onPressed: () {
            stopWatchBloc.add(StartEvent(duration: currentState.duration));
          },
        ),
      ];
    } else if (currentState is RunningState) {
      return [
        FloatingActionButton(
          child: const Icon(Icons.pause),
          onPressed: () {
            stopWatchBloc.add(PauseEvent());
          },
        ),
        FloatingActionButton(
          child: const Icon(Icons.replay),
          onPressed: () {
            stopWatchBloc.add(ResetEvent());
          },
        ),
      ];
    } else if (currentState is PausedState) {
      return [
        FloatingActionButton(
          child: const Icon(Icons.play_arrow),
          onPressed: () {
            stopWatchBloc.add(ResumeEvent());
          },
        ),
        FloatingActionButton(
          child: const Icon(Icons.replay),
          onPressed: () {
            stopWatchBloc.add(ResetEvent());
          },
        ),
      ];
    } else if (currentState is FinishedState) {
      return [
        FloatingActionButton(
          child: const Icon(Icons.replay),
          onPressed: () {
            stopWatchBloc.add(ResetEvent());
          },
        ),
      ];
    }
    return [];
  }
}

class BackGroundWaves extends StatelessWidget {
  const BackGroundWaves({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WaveWidget(
      config: CustomConfig(
        gradients: [
          //for three waves
          [
            const Color.fromRGBO(72, 74, 126, 1),
            const Color.fromRGBO(125, 170, 206, 1),
            const Color.fromRGBO(184, 189, 245, 0.7),
          ],
          [
            const Color.fromRGBO(72, 74, 126, 1),
            const Color.fromRGBO(125, 170, 206, 1),
            const Color.fromRGBO(172, 182, 219, 0.7),
          ],
          [
            const Color.fromRGBO(72, 74, 126, 1),
            const Color.fromRGBO(125, 170, 206, 1),
            const Color.fromRGBO(190, 238, 246, 0.7),
          ],
        ],
        //in milli seconds for three waves
        durations: [19440, 10000, 6000],
        //for three waves
        heightPercentages: [0.03, 0.01, 0.02],
        gradientBegin: Alignment.bottomCenter,
        gradientEnd: Alignment.topCenter,
      ),
      size: const Size(double.infinity, double.infinity),
      backgroundColor: Colors.blue[50],
    );
  }
}
