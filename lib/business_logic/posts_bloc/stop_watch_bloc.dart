import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:stop_watch/data/ticker.dart';

part 'stop_watch_events.dart';

part 'stop_watch_states.dart';

class StopWatchBloc extends Bloc<StopWatchEvents, StopWatchStates> {
  //variables
  final int duration;
  final Ticker ticker;
  StreamSubscription<int>? _tickerSubscription;

  //constructor and initial states
  StopWatchBloc({required this.ticker, required this.duration})
      : super(ReadyState(duration));

  @override
  Stream<StopWatchStates> mapEventToState(StopWatchEvents event) async* {
    if (event is StartEvent) {
      // StopWatchStartEvent startEvent=event;
      yield RunningState(event.duration);
      _tickerSubscription?.cancel();
      _tickerSubscription =
          ticker.generateTicks(maxTime: event.duration).listen((duration) {
        add(TickEvent(duration: duration));
      });
    } else if (event is PauseEvent) {
      if (state is RunningState) {
        _tickerSubscription?.pause();
        yield PausedState(state.duration);
      }
    } else if (event is ResumeEvent) {
      if (state is PausedState) {
        _tickerSubscription?.resume();
        yield RunningState(state.duration);
      }
    } else if (event is ResetEvent) {
      _tickerSubscription?.cancel();
      yield ReadyState(duration);
    } else if (event is TickEvent) {
      //StopWatchTickEvent tickEvent=event;
      yield event.duration > 0
          ? RunningState(event.duration)
          : const FinishedState();
    }
  }

  @override
  Future<void> close() {
    /*cancel the _tickerSubscription
    when is no need to use it on disposing the bloc*/
    _tickerSubscription?.cancel();
    return super.close();
  }
}
