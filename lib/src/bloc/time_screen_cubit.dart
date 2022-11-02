import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ripper/src/models/time_screen_models.dart';

class TimeScreenCubit extends Cubit<TimeScreenModels> {
  TimeScreenCubit() : super(TimeScreenModels.withOut());

  void changeTimeScreen(TimeScreenModels timeScreenModels) {
    emit(timeScreenModels);
  }
}
