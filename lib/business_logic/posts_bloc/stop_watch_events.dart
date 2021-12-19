part of 'stop_watch_bloc.dart';

@immutable
abstract class StopWatchEvents {
  const StopWatchEvents();

//needed if we want to compare tow instances of this class
/*  @override
  List<Object?> get props =>[];*/
}

class StartEvent extends StopWatchEvents {
  final int duration;

  const StartEvent({required this.duration});

  @override
  String toString() {
    return 'StartEvent {duration: $duration}';
  }
}

class PauseEvent extends StopWatchEvents {}

class ResumeEvent extends StopWatchEvents {}

class ResetEvent extends StopWatchEvents {}

class TickEvent extends StopWatchEvents {
  final int duration;

  const TickEvent({required this.duration});

//needed if we want to compare tow instances of this class
/*  @override
  List<Object?> get props =>[duration];*/

  @override
  String toString() {
    return 'TickEvent {duration: $duration}';
  }
}
