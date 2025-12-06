// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:get/get.dart';

// class NetworkController extends GetxController {
//   final Connectivity _connectivity = Connectivity();
//   final RxBool _isConnected = true.obs;

//   bool get isConnected => _isConnected.value;

//   @override
//   void onInit() {
//     super.onInit();
//     _initConnectivity();
//     _connectivity.onConnectivityChanged.listen(
//       _updateConnectionStatus as void Function(List<ConnectivityResult> event)?,
//     );
//   }

//   Future<void> _initConnectivity() async {
//     final result = await _connectivity.checkConnectivity();
//     _updateConnectionStatus(result as ConnectivityResult);
//   }

//   void _updateConnectionStatus(ConnectivityResult result) {
//     _isConnected.value = result != ConnectivityResult.none;

//     if (!_isConnected.value) {
//       Get.snackbar(
//         'No Internet Connection',
//         'Please check your internet connection',
//         snackPosition: SnackPosition.BOTTOM,
//         duration: const Duration(seconds: 4),
//       );
//     }
//   }
// }
