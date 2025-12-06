// import 'package:flutter/material.dart';

// extension StringExtensions on String {
//   String capitalize() {
//     if (isEmpty) return this;
//     return '${this[0].toUpperCase()}${substring(1)}';
//   }

//   String get initials {
//     final names = split(' ');
//     if (names.length > 1) {
//       return '${names.first[0]}${names.last[0]}'.toUpperCase();
//     }
//     return length > 1 ? substring(0, 2).toUpperCase() : this;
//   }

//   bool get isEmail {
//     final emailRegex = RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+');
//     return emailRegex.hasMatch(this);
//   }

//   bool get isPhone {
//     final phoneRegex = RegExp(r'^[0-9]{10}$');
//     return phoneRegex.hasMatch(this);
//   }
// }

// extension DateTimeExtensions on DateTime {
//   String get formattedDate {
//     return '$day/$month/$year';
//   }

//   String get formattedTime {
//     return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
//   }

//   String get formattedDateTime {
//     return '$formattedDate $formattedTime';
//   }

//   bool isToday() {
//     final now = DateTime.now();
//     return year == now.year && month == now.month && day == now.day;
//   }

//   bool isYesterday() {
//     final yesterday = DateTime.now().subtract(const Duration(days: 1));
//     return year == yesterday.year &&
//         month == yesterday.month &&
//         day == yesterday.day;
//   }
// }

// extension BuildContextExtensions on BuildContext {
//   double get screenWidth => MediaQuery.of(this).size.width;
//   double get screenHeight => MediaQuery.of(this).size.height;
//   double get paddingTop => MediaQuery.of(this).padding.top;
//   double get paddingBottom => MediaQuery.of(this).padding.bottom;

//   ThemeData get theme => Theme.of(this);
//   TextTheme get textTheme => Theme.of(this).textTheme;

//   void showSnackBar(String message, {bool isError = false}) {
//     ScaffoldMessenger.of(this).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: isError ? Colors.red : Colors.green,
//         behavior: SnackBarBehavior.floating,
//       ),
//     );
//   }
// }
