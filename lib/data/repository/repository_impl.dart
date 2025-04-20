import 'package:dartz/dartz.dart';
import 'package:islamic/data/mapper/mapper.dart';


import '../../app/error/failure.dart';
import '../../di/di.dart';
import '../../domain/models/prayer_timings/prayer_timings_model.dart';
import '../../domain/repository/repository.dart';
import '../data_source/remote/remote_data_source.dart';
import '../network/error_handler.dart';
import '../network/network_info.dart';

class RepositoryImpl implements Repository {
  final RemoteDataSource _remoteDataSource = instance<RemoteDataSource>();
  final NetworkInfo _networkInfo = instance<NetworkInfo>();

  RepositoryImpl();





  @override
  Future<Either<Failure, PrayerTimingsModel>> getPrayerTimings(
      double lat, double lag, int method) async {
    if (await _networkInfo.isConnected) {
      try {
        final response =
            await _remoteDataSource.getPrayerTimings(lat, lag, method);

        if (response.code == ApiInternalStatus.success) {
          //success
          return Right(response.toDomain());
        } else {
          //failure (business)
          return Left(ServerFailure(response.code ?? ApiInternalStatus.failure,
              response.status ?? ResponseMessage.unknown));
        }
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      //failure (connection)
      return Left(DataSource.noInternetConnection.getServerFailure());
    }
  }


}
