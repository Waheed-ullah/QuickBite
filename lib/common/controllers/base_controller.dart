// import 'package:get/get.dart';

// abstract class BaseController extends GetxController {
//   final RxBool _isLoading = false.obs;
//   final RxString _error = ''.obs;

//   bool get isLoading => _isLoading.value;
//   String get error => _error.value;

//   void setLoading(bool loading) {
//     _isLoading.value = loading;
//   }

//   void setError(String error) {
//     _error.value = error;
//   }

//   void clearError() {
//     _error.value = '';
//   }

//   Future<void> handleApiCall<T>(
//     Future<T> Function() apiCall, {
//     Function(T)? onSuccess,
//     Function(String)? onError,
//     bool showLoading = true,
//   }) async {
//     try {
//       if (showLoading) setLoading(true);
//       clearError();

//       final result = await apiCall();

//       if (onSuccess != null) {
//         onSuccess(result);
//       }
//     } catch (e) {
//       final errorMessage = e.toString();
//       setError(errorMessage);

//       if (onError != null) {
//         onError(errorMessage);
//       } else {
//         Get.snackbar('Error', errorMessage);
//       }
//     } finally {
//       if (showLoading) setLoading(false);
//     }
//   }

//   @override
//   void onClose() {
//     _isLoading.close();
//     _error.close();
//     super.onClose();
//   }
// }
