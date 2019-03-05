// A series of functions that work with DateTime objects and parses/formats them into user friendly Strings
import 'package:flutter/material.dart';

String dayOfWeek(DateTime dateTime) {
                                                                                // takes a DateTime objects and returns a String containing the fully spelled out day of week. For an abbreviated String use abbreviatedWeekday
  String _dayOfWeek = '';

  switch (dateTime.weekday) {
    case 1:
      _dayOfWeek = "Monday";
      break;
    case 2:
      _dayOfWeek = "Tuesday";
      break;
    case 3:
      _dayOfWeek = "Wednesday";
      break;
    case 4:
      _dayOfWeek = "Thursday";
      break;
    case 5:
      _dayOfWeek = "Friday";
      break;
    case 6:
      _dayOfWeek = "Saturday";
      break;
    case 7:
      _dayOfWeek = "Sunday";
      break;
  }

  return _dayOfWeek;
}

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

String fullMonth(DateTime dateTime) {                                           // takes a DateTime object and returns a String with a month in full
  // Set month
  String _month = '';

  switch (dateTime.month) {
    case 1:
      _month = "January";
      break;
    case 2:
      _month = "February";
      break;
    case 3:
      _month = "March";
      break;
    case 4:
      _month = "April";
      break;
    case 5:
      _month = "May";
      break;
    case 6:
      _month = "June";
      break;
    case 7:
      _month = "July";
      break;
    case 8:
      _month = "August";
      break;
    case 9:
      _month = "September";
      break;
    case 10:
      _month = "October";
      break;
    case 11:
      _month = "November";
      break;
    case 12:
      _month = "December";
      break;
  }

  return _month;
}

String abbreviatedMonth(DateTime dateTime)                                      // takes a DateTime object and returns a String with an abbreviated month
{
  String _month = '';

  switch (dateTime.month) {
    case 1:
      _month = "Jan";
      break;
    case 2:
      _month = "Feb";
      break;
    case 3:
      _month = "Mar";
      break;
    case 4:
      _month = "Apr";
      break;
    case 5:
      _month = "May";
      break;
    case 6:
      _month = "June";
      break;
    case 7:
      _month = "July";
      break;
    case 8:
      _month = "Aug";
      break;
    case 9:
      _month = "Sept";
      break;
    case 10:
      _month = "Oct";
      break;
    case 11:
      _month = "Nov";
      break;
    case 12:
      _month = "Dec";
      break;
  }
  return _month;
}


String formatAMPM(int hour)                                                     // takes an integer representing an hour of the day in 24H time and returns a String with the correct AM/PM value
{
  String amOrPm = '';
  hour >= 12 ? amOrPm = 'PM' : amOrPm = 'AM';

  return amOrPm;
}

String formatHour(int hour)                                                     // takes an integer representing an hour of the day in 24H time and returns a String correctly formatted of a 1 or 2 digit String in 12H time
{
  String _hourString = '';

  if (hour == 0) {
    hour = 12;
  }
  else if (hour > 12) {
    hour -= 12;
  }
  _hourString = hour.toString();

  return _hourString;

}

String formatMinutes(int minutes){                                              // takes an integer representing the number of minutes in time and returns a 1 or 2 digit String representing that time.
  // sets minutes formatted with leading zero as needed
  String minuteString = '';
  (minutes < 10) ? minuteString = '0$minutes' : minuteString = minutes.toString();

  return minuteString;
}

String formatAbbreviatedDayWeekDateTime(DateTime dateTime)                                        // takes a DateTime object and formats it into user friendly format of DayOfWeek, Month, Day, Year ~ HH:MM AM/PM
{

  String formattedDateTime = '';

  formattedDateTime = abbreviatedWeekday(dateTime) + ', ' + fullMonth(dateTime) + ' ${dateTime.day}, ${dateTime.year} ~ ' + formatHour(dateTime.hour) + ':' + formatMinutes(dateTime.minute) + ' ' + formatAMPM(dateTime.hour);

  return formattedDateTime;
}

String formatAbbreviatedDayWeekMDY(DateTime dateTime)                                        // takes a DateTime object and formats it into user friendly format of DayOfWeek, Month, Day, Year ~ HH:MM AM/PM
{

  String formattedDateTime = '';

  formattedDateTime = abbreviatedWeekday(dateTime) + ', ' + abbreviatedMonth(dateTime) + ' ${dateTime.day}, ${dateTime.year}';

  return formattedDateTime;
}


String formatDateTime(DateTime dateTime)                                        // takes a DateTime object and formats it into user friendly format of DayOfWeek, Month, Day, Year ~ HH:MM AM/PM
{

  String formattedDateTime = '';
  
  formattedDateTime = dayOfWeek(dateTime) + ', ' + fullMonth(dateTime) + ' ${dateTime.day}, ${dateTime.year} ~ ' + formatHour(dateTime.hour) + ':' + formatMinutes(dateTime.minute) + ' ' + formatAMPM(dateTime.hour);

  return formattedDateTime;
}

DateTime combineDateTime(DateTime dateTime, TimeOfDay timeOfDay){               // combines a DateTime (e.g., from a DatePicker) and a TimeOfDay (e.g., from a TimePicker) into a single DateTime

  DateTime combinedDateTime = new DateTime(dateTime.year, dateTime.month, dateTime.day, timeOfDay.hour, timeOfDay.minute);

  return combinedDateTime;
}

String splitOffTime(DateTime dateTime)                                          // takes a DateTime and returns only the time
{
  return formatHour(dateTime.hour) + ':' + formatMinutes(dateTime.minute) + ' ' + formatAMPM(dateTime.hour);
}