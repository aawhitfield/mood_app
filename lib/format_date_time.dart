import 'package:flutter/material.dart';

String formatDateTime(DateTime dateTime)
{

  String formattedDateTime = '';
  String dayOfWeek = '';
  String month = '';
  int hour = dateTime.hour;
  String amPM = '';
  String minutes = dateTime.minute.toString();

  // set Day of Week
  switch (dateTime.weekday) {
    case 1:
      dayOfWeek = "Monday";
      break;
    case 2:
      dayOfWeek = "Tuesday";
      break;
    case 3:
      dayOfWeek = "Wednesday";
      break;
    case 4:
      dayOfWeek = "Thursday";
      break;
    case 5:
      dayOfWeek = "Friday";
      break;
    case 6:
      dayOfWeek = "Saturday";
      break;
    case 7:
      dayOfWeek = "Sunday";
      break;
  }

  // Set month
  switch (dateTime.month) {
    case 1:
      month = "January";
      break;
    case 2:
      month = "February";
      break;
    case 3:
      month = "March";
      break;
    case 4:
      month = "April";
      break;
    case 5:
      month = "May";
      break;
    case 6:
      month = "June";
      break;
    case 7:
      month = "July";
      break;
    case 8:
      month = "August";
      break;
    case 9:
      month = "September";
      break;
    case 10:
      month = "October";
      break;
    case 11:
      month = "November";
      break;
    case 12:
      month = "December";
      break;
  }

  // set AM or PM
  if (hour < 12) {
    amPM = 'AM';
  } else {
    amPM = 'PM';
  }

  // sets 12 hour time
  if (hour == 0) {
    hour = 12;
  } else if (hour > 12) {
    hour -= 12;
  }

  // sets minutes formatted with leading zero as needed
  if (dateTime.minute < 10) {
    minutes = '0${dateTime.minute}';
  }

  formattedDateTime = '$dayOfWeek, $month ${dateTime.day}, ${dateTime.year} ~ $hour:$minutes $amPM';

  return formattedDateTime;
}