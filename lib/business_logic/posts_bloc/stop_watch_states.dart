part of 'stop_watch_bloc.dart';

@immutable
abstract class StopWatchStates {
  /*we make the variables and methods we need in all extended class in it
   to override it instead of declare different members in all classes*/
  final int duration;

  const StopWatchStates(this.duration);

//needed if we want to compare tow instances of this class
/*  @override
  List<Object?> get props => [duration];*/
}

class ReadyState extends StopWatchStates {
  const ReadyState(int duration) : super(duration);
}

class RunningState extends StopWatchStates {
  const RunningState(int duration) : super(duration);
}

class PausedState extends StopWatchStates {
  const PausedState(int duration) : super(duration);
}

class FinishedState extends StopWatchStates {
  const FinishedState() : super(0);
}
