

sealed class Constants {
  static const String empty = "";
  static const int zero = 0;
  static const int quranIndex = 0;
  static const int hadithIndex = 1;
  static const int prayerTimingsIndex = 2;
  static const int adhkarIndex = 3;
  static const int settingsIndex = 4;
  static const int prayerNumbers = 6;
  static const int nextPageDuration = 500;
  static const String baseUrl = "https://api.aladhan.com/v1/";
  // static const String prayerTimingPath = "{date}?city={city}&country={country}";
  static const String prayerTimingPath = "/timings";
  static const Duration timeOut = Duration(seconds: 60);
  static const String token = "SEND TOKEN HERE";


}

(String, String) recordLocation = ("", "");

bool isThereABookMarkedPage = false;


