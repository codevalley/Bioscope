import 'package:intl/intl.dart';

/// Provides utility methods for formatting dates and times.
///
/// This class contains static methods that handle various date and time
/// formatting tasks, such as generating relative time strings and
/// formatting dates for different display contexts.
class DateFormatter {
  /// Generates a relative time string for a given [DateTime].
  ///
  /// This method creates a human-readable string describing how long ago
  /// the given [dateTime] was, relative to the current time.
  ///
  /// Examples:
  /// - "5 mins ago"
  /// - "2h ago"
  /// - "Yesterday"
  /// - "3 days ago"
  /// - "15 Jan" (for dates more than a week ago)
  ///
  /// [dateTime] The date and time to format.
  /// Returns a [String] representing the relative time.
  static String getRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return '${difference.inMinutes} mins ago';
      } else {
        return '${difference.inHours}h ago';
      }
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      final monthName = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec'
      ][dateTime.month - 1];
      return '${dateTime.day} $monthName';
    }
  }

  /// Formats a date with detailed information.
  ///
  /// This method creates a string representation of the given [date],
  /// including the day and time. It uses different formats based on how
  /// recent the date is.
  ///
  /// Examples:
  /// - "Today at 2:30 PM"
  /// - "Yesterday at 4:15 PM"
  /// - "April 15, 2023 at 10:00 AM"
  ///
  /// [date] The date to format.
  /// Returns a [String] with the formatted date and time.
  static String formatDetailDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today at ${DateFormat('h:mm a').format(date)}';
    } else if (difference.inDays == 1) {
      return 'Yesterday at ${DateFormat('h:mm a').format(date)}';
    } else {
      return DateFormat('MMMM d, y \'at\' h:mm a').format(date);
    }
  }

  /// Formats a date for short display.
  ///
  /// This method creates a string representation of the given [date],
  /// including the day of the week and the date.
  ///
  /// Example: "Mon, Jan 15"
  ///
  /// [date] The date to format.
  String formatShortDate(DateTime date) {
    final formatter = DateFormat('E, MMM d');
    return formatter.format(date);
  }

  /// Formats a date for greeting messages.
  ///
  /// This method creates a string representation of the given [date],
  /// including the day of the week and the date.
  ///
  /// Example: "Monday, 15 Jan"
  ///
  /// [date] The date to format.
  /// Returns a [String] with the formatted date for greetings.
  static String formatGreetingDate(DateTime date) {
    final dayNames = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    final monthNames = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];

    final dayName = dayNames[date.weekday - 1];
    final monthName = monthNames[date.month - 1];

    return "$dayName, ${date.day} $monthName";
  }
}
