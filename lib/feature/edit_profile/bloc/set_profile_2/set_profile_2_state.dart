part of 'set_profile_2_bloc.dart';

sealed class SetProfile2State {}

class InitialState extends SetProfile2State {}

class LoadingState extends SetProfile2State {}

class LoadedState extends SetProfile2State {}

class ErrorState extends SetProfile2State {}