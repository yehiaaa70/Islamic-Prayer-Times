import 'dart:async';
import 'dart:ui' as ui;

import 'package:audioplayers/audioplayers.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:islamic/app/utils/extensions.dart';

import '../../../../../app/utils/constants.dart';
import '../../../../../domain/models/prayer_timings/prayer_timings_model.dart';
import '../../../../components/separator.dart';
import '../../../../../app/resources/resources.dart';

import '../cubit/prayer_timings_cubit.dart';

class PrayerTimingsScreen extends StatefulWidget {
  const PrayerTimingsScreen({Key? key}) : super(key: key);

  @override
  State<PrayerTimingsScreen> createState() => _PrayerTimingsScreenState();
}

class _PrayerTimingsScreenState extends State<PrayerTimingsScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  StreamSubscription? _timeSubscription;
  bool _isStreamStarted = false;
  String? _currentAzanTime;
  bool _isAzanPlaying = false;

  @override
  void initState() {
    super.initState();

    _audioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        _isAzanPlaying = false;
        _currentAzanTime = null;
      });
    });
  }

  void _playAzan(String time) async {
    await _audioPlayer.play(AssetSource('audio/azan.mp3'));
    setState(() {
      _isAzanPlaying = true;
      _currentAzanTime = time;
    });
  }

  void _stopAzan() async {
    await _audioPlayer.stop();
    setState(() {
      _isAzanPlaying = false;
      _currentAzanTime = null;
    });
  }

  String convertTo12HourFormat(String time) {
    final parts = time.split(":");
    int hour = int.parse(parts[0]);
    int minute = int.parse(parts[1]);

    if (hour > 12) {
      hour -= 12;
    }
    if (hour == 0) {
      hour = 12;
    }

    return "$hour:${minute.toString().padLeft(2, '0')}";
  }

  void _startListeningToTime(List<String> timings) {
    if (_isStreamStarted) return;

    _isStreamStarted = true;

    _timeSubscription = Stream.periodic(Duration(seconds: 45), (_) {
      final currentTime = DateTime.now();

      int hour = currentTime.hour;
      if (hour > 12) hour -= 12;
      if (hour == 0) hour = 12;

      final currentFormattedTime =
          "$hour:${currentTime.minute.toString().padLeft(2, '0')}";

      for (var timing in timings) {
        if (currentFormattedTime == timing && _currentAzanTime != timing) {
          _playAzan(timing);
          break;
        }
      }
    }).listen((_) {});
  }

  @override
  void dispose() {
    _timeSubscription?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PrayerTimingsCubit, PrayerTimingsState>(
      builder: (context, state) {
        PrayerTimingsCubit cubit = PrayerTimingsCubit.get(context);
        PrayerTimingsModel prayerTimingsModel = cubit.prayerTimingsModel;
        bool isConnected = cubit.isConnected;
        final currentLocale = context.locale;
        bool isEnglish =
            currentLocale.languageCode == LanguageType.english.getValue();

        if (prayerTimingsModel.code == 0) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                AppStrings.gettingLocation.tr(),
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 5.h),
              Center(
                child: SizedBox(
                  width: (MediaQuery.of(context).size.width * 0.55),
                  child: const LinearProgressIndicator(color: Colors.amber),
                ),
              ),
            ],
          );
        } else if (prayerTimingsModel.code == 200) {
          List<String> timings = [
            "12:18",
            prayerTimingsModel.data!.timings!.sunrise.convertTo12HourFormat(),
            prayerTimingsModel.data!.timings!.dhuhr.convertTo12HourFormat(),
            prayerTimingsModel.data!.timings!.asr.convertTo12HourFormat(),
            prayerTimingsModel.data!.timings!.maghrib.convertTo12HourFormat(),
            prayerTimingsModel.data!.timings!.isha.convertTo12HourFormat(),
          ];

          if (!_isStreamStarted) {
            _startListeningToTime(timings);
          }

          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 5.h),
                  child: Text(
                    isEnglish
                        ? prayerTimingsModel.data!.date!.gregorian!.weekday!.en
                        : prayerTimingsModel.data!.date!.hijri!.weekday!.ar,
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                isEnglish
                    ? Text(
                  "${prayerTimingsModel.data!.date!.hijri!.day} ${prayerTimingsModel.data!.date!.hijri!.month!.en} ${prayerTimingsModel.data!.date!.hijri!.year}",
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.black,
                  ),
                )
                    : Text(
                  "${prayerTimingsModel.data!.date!.hijri!.day} ${prayerTimingsModel.data!.date!.hijri!.month!.ar} ${prayerTimingsModel.data!.date!.hijri!.year}",
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.black,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 5.h),
                  child: Text(
                    prayerTimingsModel.data!.date!.gregorian!.date,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey,
                    ),
                  ),
                ),
                if (_isAzanPlaying)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      onPressed: _stopAzan,
                      icon: const Icon(Icons.stop, color: Colors.white),
                      label: const Text(
                        "Stop Azan",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ...List.generate(Constants.prayerNumbers, (index) {
                  return _prayerIndexItem(
                    isEnglish: isEnglish,
                    context: context,
                    timings: timings,
                    prayerTimingsModel: prayerTimingsModel,
                    index: index,
                  );
                }),
              ],
            ),
          );
        } else {
          return Center(
            child: Text(
              !isConnected
                  ? AppStrings.noInternetConnection.tr()
                  : AppStrings.noLocationFound.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.black,
                height: 1.3.h,
              ),
            ),
          );
        }
      },
    );
  }

  Widget _prayerIndexItem({
    required PrayerTimingsModel prayerTimingsModel,
    required List<String> timings,
    required int index,
    required bool isEnglish,
    required BuildContext context,
  }) {
    bool isCurrent = timings[index] == _currentAzanTime;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isEnglish
                      ? AppStrings.englishPrayerNames[index]
                      : AppStrings.arabicPrayerNames[index],
                  style: TextStyle(
                    fontSize: 18.sp,
                    color: isCurrent ? Colors.red : Colors.black,
                  ),
                ),
                SizedBox(height: 5.h),
                Text(
                  isEnglish
                      ? AppStrings.arabicPrayerNames[index]
                      : AppStrings.englishPrayerNames[index],
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: isCurrent ? Colors.red : Colors.grey,
                  ),
                ),
              ],
            ),
            SizedBox(width: 35.w),
            Text(
              timings[index],
              style: TextStyle(
                fontSize: 18.sp,
                color: isCurrent ? Colors.red : Colors.black,
              ),
            ),
          ],
        ),
        Divider(color: Colors.grey[300], thickness: 1),
      ],
    );
  }
}