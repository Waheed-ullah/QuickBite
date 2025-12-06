// import 'package:connectivity_plus/connectivity_plus.dart';

// class OfflineService {
//   final Connectivity _connectivity = Connectivity();

//   Future<bool> isConnected() async {
//     final connectivityResult = await _connectivity.checkConnectivity();
//     return connectivityResult != ConnectivityResult.none;
//   }

//   Future<bool> hasCachedData(String key) async {
//     // Check if data exists in cache
//     // Implementation depends on storage method
//     return false;
//   }

//   Future<DateTime?> getCacheTimestamp(String key) async {
//     // Get when data was last cached
//     // Implementation depends on storage method
//     return null;
//   }

//   bool isCacheValid(
//     DateTime cacheTime, {
//     Duration maxAge = const Duration(hours: 1),
//   }) {
//     return DateTime.now().difference(cacheTime) < maxAge;
//   }
// }
