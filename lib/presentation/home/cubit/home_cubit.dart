import 'dart:async';

import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:geocoding/geocoding.dart';
import 'package:location/location.dart' as location_package;

import '../../../app/utils/app_prefs.dart';
import '../../../app/utils/constants.dart';
import '../../../di/di.dart';
import '../../../../../app/resources/resources.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final AppPreferences _preferences = instance<AppPreferences>();

  HomeCubit() : super(HomeInitial());

  static HomeCubit get(context) => BlocProvider.of(context);

  int currentIndex = Constants.quranIndex;

  void changeBotNavIndex(int index) {
    currentIndex = index;
    emit(HomeChangeBotNavIndexState());
  }

  bool darkModeOn(BuildContext context) {
    final currentThemeMode = _preferences.getAppTheme();
    return currentThemeMode == ThemeMode.dark;
  }

  void changeAppTheme(BuildContext context) {
    _preferences.changeAppTheme();
    Phoenix.rebirth(context);
    emit(HomeChangeAppThemeState());
  }

  void changeAppLanguage(BuildContext context) {
    _preferences.changeAppLanguage();
    Phoenix.rebirth(context);
    emit(HomeChangeAppLanguageState());
  }

  bool isPageBookMarked(int quranPageNumber) {
    return _preferences.isPageBookMarked(quranPageNumber);
  }

  Future<bool> isThereABookMarked() async {
    await _preferences
        .isThereABookMarked()
        .then((value) => isThereABookMarkedPage = value);
    emit(CheckQuranBookMarkPageState());
    return isThereABookMarkedPage;
  }

  Future<void> bookMarkPage(int quranPageNumber) async {
    if (!isPageBookMarked(quranPageNumber)) {
      _preferences.bookMarkPage(quranPageNumber);
    } else {
      _preferences.removeBookMarkPage();
    }
    await isThereABookMarked();
    emit(QuranBookMarkPageState());
  }

  int? bookMarkedPage;

  int? getBookMarkPage() {
    bookMarkedPage = _preferences.getBookMarkedPage();
    emit(GetQuranBookMarkPageState());
    return bookMarkedPage;
  }

  location_package.Location location = location_package.Location();

  Future<void> getLocation() async {
    emit(GetLocationLoadingState());

    try {
      // Check if location service is enabled
      bool serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          recordLocation = (
          AppStrings.enableLocation.tr(),
          AppStrings.enableLocation.tr()
          );
          emit(GetLocationErrorState(AppStrings.enableLocation.tr()));
          return;
        }
      }

      // Check and request permissions
      var permissionStatus = await location.hasPermission();
      if (permissionStatus == location_package.PermissionStatus.denied ||
          permissionStatus == location_package.PermissionStatus.deniedForever) {
        permissionStatus = await location.requestPermission();
        if (permissionStatus != location_package.PermissionStatus.granted) {
          emit(GetLocationErrorState(AppStrings.giveLocationAccessPermission.tr()));
          recordLocation = (
          AppStrings.giveLocationAccessPermission.tr(),
          AppStrings.giveLocationAccessPermission.tr()
          );
          return;
        }
      }

      // Get location with timeout
      final locationData = await location.getLocation().timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw TimeoutException('Location request timed out');
        },
      );

      // Get placemarks with retry logic
      List<Placemark> placeMarks = await _getPlacemarksWithRetry(
        locationData.latitude!,
        locationData.longitude!,
        retries: 3,
      );

      if (placeMarks.isNotEmpty) {
        recordLocation = (
        placeMarks[0].subAdministrativeArea ?? placeMarks[0].locality ?? 'Unknown',
        placeMarks[0].country ?? 'Unknown'
        );
        emit(GetLocationSuccessState());
      } else {
        recordLocation = (
        AppStrings.noLocationFound.tr(),
        AppStrings.noLocationFound.tr()
        );
        emit(GetLocationErrorState(AppStrings.noLocationFound.tr()));
      }
    } on PlatformException catch (e) {
      _handleLocationError(e);
    } on TimeoutException {
      emit(GetLocationErrorState('Location request timed out'));
      recordLocation = ('Timeout', 'Location request timed out');
    } catch (e) {
      emit(GetLocationErrorState(e.toString()));
      recordLocation = ('Error', e.toString());
    }
  }

  Future<List<Placemark>> _getPlacemarksWithRetry(
      double latitude,
      double longitude, {
        int retries = 3,
      }) async {
    for (int i = 0; i < retries; i++) {
      try {
        return await placemarkFromCoordinates(latitude, longitude)
            .timeout(const Duration(seconds: 5));
      } catch (e) {
        if (i == retries - 1) rethrow;
        await Future.delayed(const Duration(seconds: 1));
      }
    }
    return [];
  }

  void _handleLocationError(PlatformException e) {
    String errorMessage;
    switch (e.code) {
      case 'PERMISSION_DENIED':
        errorMessage = AppStrings.giveLocationAccessPermission.tr();
        break;
      case 'SERVICE_STATUS_ERROR':
        errorMessage = 'Location service unavailable';
        break;
      default:
        errorMessage = e.message ?? 'Unknown location error';
    }

    emit(GetLocationErrorState(errorMessage));
    recordLocation = (errorMessage, errorMessage);
  }}
