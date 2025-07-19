import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'plans_state.dart';

class PlansCubit extends Cubit<PlansState> {
  PlansCubit() : super(PlansInitial());
}
