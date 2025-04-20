

import '../../../di/di.dart';
import '../../network/prayer_timings_api.dart';
import '../../responses/prayer_timings/prayer_timings_response.dart';

abstract class RemoteDataSource {
  Future<PrayerTimingsResponse> getPrayerTimings(
    double lat,
      double lag,
    int method,
  );
}

class RemoteDataSourceImpl implements RemoteDataSource {
  final PrayerTimingsServiceClient _prayerTimingsServiceClient =
      instance<PrayerTimingsServiceClient>();

  @override
  Future<PrayerTimingsResponse> getPrayerTimings(
      double lat, double lag, int method) async {
    return await _prayerTimingsServiceClient.getPrayerTimings(
      lat,
      lag,
      method,
    );
  }
}
