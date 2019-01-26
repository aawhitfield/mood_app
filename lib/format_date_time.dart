import 'package:flutter/material.dart';

String abbreviatedWeekday(DateTime dateTime)                                    // takes a DateTime and parses out the Day of the week and returns it in abbreviated form as a String
{
  String dayOfWeek = '';

  // set Day of Week
  switch (dateTime.weekday) {
    case 1:
      dayOfWeek = "Mon";
      break;
    case 2:
      dayOfWeek = "Tues";
      break;
    case 3:
      dayOfWeek = "Wed";
      break;
    case 4:
      dayOfWeek = "Thurs";
      break;
    case 5:
      dayOfWeek = "Fri";
      break;
    case 6:
      dayOfWeek = "Sat";
      break;
    case 7:
      dayOfWeek = "Sun";
      break;
  }

  return dayOfWeek;
}


String abbreviatedMonth(DateTime dateTime)
{
  String month = '';

  switch (dateTime.month) {
    case 1:
      month = "Jan";
      break;
    case 2:
      month = "Feb";
      break;
    case 3:
      month = "Mar";
      break;
    case 4:
      month = "Apr";
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
      month = "Aug";
      break;
    case 9:
      month = "Sept";
      break;
    case 10:
      month = "Oct";
      break;
    case 11:
      month = "Nov";
      break;
    case 12:
      month = "Dec";
      break;
  }
  return month;
}


String formatAMPM(int hour)
{
  String amOrPm = '';
  hour >= 12 ? amOrPm = 'PM' : amOrPm = 'AM';

  return amOrPm;
}

String formatHour(int hour)
{
  String _hourString = '';

  if (hour == 0) {
    hour = 12;
  }
  else if (hour > 12) {
    hour -= 12;
  }
  (hour < 10) ? _hourString = '0$hour' : _hourString = hour.toString();

  return _hourString;

}

String formatMinutes(int minutes){
  // sets minutes formatted with leading zero as needed
  String minuteString = '';
  (minutes < 10) ? minuteString = '0$minutes' : minuteString = minutes.toString();

  return minuteString;
}


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