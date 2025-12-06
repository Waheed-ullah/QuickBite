// import 'package:intl/intl.dart';

// class Helpers {
//   static String formatPrice(double price) {
//     return NumberFormat.currency(
//       locale: 'en_IN',
//       symbol: '₹',
//       decimalDigits: 0,
//     ).format(price);
//   }

//   static String formatDateTime(DateTime dateTime) {
//     return DateFormat('dd MMM yyyy, hh:mm a').format(dateTime);
//   }

//   static String getInitials(String name) {
//     final names = name.split(' ');
//     if (names.length > 1) {
//       return '${names.first[0]}${names.last[0]}'.toUpperCase();
//     }
//     return name.length > 1 ? name.substring(0, 2).toUpperCase() : name;
//   }

//   static String truncateWithEllipsis(String text, int maxLength) {
//     if (text.length <= maxLength) return text;
//     return '${text.substring(0, maxLength)}...';
//   }

//   static double calculateAverageRating(List<double> ratings) {
//     if (ratings.isEmpty) return 0;
//     final sum = ratings.reduce((a, b) => a + b);
//     return sum / ratings.length;
//   }

//   static String getDeliveryTimeEstimate(String zone) {
//     switch (zone) {
//       case 'Urban':
//         return '20-30 minutes';
//       case 'Suburban':
//         return '30-45 minutes';
//       case 'Remote':
//         return '45-60 minutes';
//       default:
//         return '30-45 minutes';
//     }
//   }
// }
