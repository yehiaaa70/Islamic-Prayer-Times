import 'package:dartz/dartz.dart';

import 'package:equatable/equatable.dart';

import '../../app/error/failure.dart';
import '../../di/di.dart';
import '../models/prayer_timings/prayer_timings_model.dart';
import '../repository/repository.dart';
import 'base_usecase.dart';

class GetPrayerTimingsUseCase
    implements
        BaseUseCase<GetPrayerTimingsUseCaseUseCaseInput, PrayerTimingsModel> {
  final Repository _repository = instance<Repository>();

  GetPrayerTimingsUseCase();

  @override
  Future<Either<Failure, PrayerTimingsModel>> call(
      GetPrayerTimingsUseCaseUseCaseInput input) async {
    return await _repository.getPrayerTimings(
        input.latitude, input.longitude, input.method);
  }
}

class GetPrayerTimingsUseCaseUseCaseInput extends Equatable {
  final double latitude;
  final double longitude;
  final int method;

  const GetPrayerTimingsUseCaseUseCaseInput({
    required this.latitude,
    required this.longitude,
    required this.method,
  });

  @override
  List<Object> get props => [
    latitude,
    longitude,
    method,
  ];

  GetPrayerTimingsUseCaseUseCaseInput copyWith({
    double? latitude,
    double? longitude,
    int? method,
  }) {
    return GetPrayerTimingsUseCaseUseCaseInput(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      method: method ?? this.method,
    );
  }
}