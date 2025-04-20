
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:islamic/app/utils/extensions.dart';

import '../resources/resources.dart';


Future<String> fetchDataFromJson(String jsonPath) async {
  String jsonString = await rootBundle.loadString(jsonPath);
  return jsonString;
}

double calculateFontSize(int noOfChars) {
  double fontSize = 0.0;
  if (0 < noOfChars && noOfChars < 200) {
    fontSize = FontSize.s23;
  } else if (200 < noOfChars && noOfChars < 400) {
    fontSize = FontSize.s22;
  } else if (400 < noOfChars && noOfChars < 600) {
    fontSize = FontSize.s20;
  } else if (600 < noOfChars && noOfChars < 800) {
    fontSize = FontSize.s17;
  } else if (800 < noOfChars && noOfChars < 1000) {
    fontSize = FontSize.s16;
  } else if (1000 < noOfChars && noOfChars < 1200) {
    fontSize = FontSize.s14_5;
  } else {
    fontSize = FontSize.s11_5;
  }
  return fontSize;
}


double calculateFontLineHeight(int noOfChars) {
  double lineHeight = 0.0;
  if (0 < noOfChars && noOfChars < 500) {
    lineHeight = AppSize.s1_5.h;
  } else if (500 < noOfChars && noOfChars < 1200) {
    lineHeight = AppSize.s1_27.h;
  } else {
    lineHeight = AppSize.s1_25.h;
  }
  return lineHeight;
}

String getAyahNumberWithSymbol(int ayahNumber) {
  return "  \uFD3F${ayahNumber.toArabic()}\uFD3E    ";
}

int sum(List<int> numbers) {
  int total = 0;
  for (int number in numbers) {
    total += number;
  }
  return total;
}

String getQuranImageNumberFromPageNumber(int quranPageNumber) {
  return quranPageNumber.toString().padLeft(3, "0");
}

Uri getUri(String url) {
  return Uri.parse(url);
}
