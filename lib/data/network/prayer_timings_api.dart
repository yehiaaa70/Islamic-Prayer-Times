import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';

import '../../app/utils/constants.dart';
import '../responses/prayer_timings/prayer_timings_response.dart';

part 'prayer_timings_api.g.dart';

@RestApi(baseUrl: Constants.baseUrl) // should be https://api.aladhan.com/v1/
abstract class PrayerTimingsServiceClient {
  factory PrayerTimingsServiceClient(Dio dio, {String baseUrl}) = _PrayerTimingsServiceClient;

  @GET("timings")
  Future<PrayerTimingsResponse> getPrayerTimings(
      @Query("latitude") double latitude,
      @Query("longitude") double longitude,
      @Query("method") int method,
      );
}
