import 'package:dartz/dartz.dart';


import '../../app/error/failure.dart';
import '../models/prayer_timings/prayer_timings_model.dart';

abstract class Repository {

  // Future<Either<Failure, PrayerTimingsModel>> getPrayerTimings(
  //   String date,
  //   String city,
  //   String country,
  // );
  Future<Either<Failure, PrayerTimingsModel>> getPrayerTimings(
      double latitude,
      double longitude,
      int method,
      );



}
