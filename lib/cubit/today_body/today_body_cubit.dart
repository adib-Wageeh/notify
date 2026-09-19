import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'today_body_cubit.freezed.dart';
part 'today_body_state.dart';

class TodayBodyCubit extends Cubit<TodayBodyState> {
  TodayBodyCubit() : super(const TodayBodyState.initial());

}
