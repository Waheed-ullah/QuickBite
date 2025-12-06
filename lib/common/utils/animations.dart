// import 'package:flutter/material.dart';

// class AppAnimations {
//   static Widget buildAddToCartAnimation(AnimationController controller) {
//     return ScaleTransition(
//       scale: Tween<double>(
//         begin: 0.5,
//         end: 1.0,
//       ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOutBack)),
//       child: FadeTransition(
//         opacity: controller,
//         child: const Icon(
//           Icons.shopping_cart_checkout,
//           color: Colors.green,
//           size: 24,
//         ),
//       ),
//     );
//   }

//   static Widget buildFadeInList(int index, Widget child) {
//     return TweenAnimationBuilder<double>(
//       tween: Tween<double>(begin: 0.0, end: 1.0),
//       duration: Duration(milliseconds: 300 + (index * 100)),
//       curve: Curves.easeIn,
//       builder: (context, value, child) {
//         return Opacity(
//           opacity: value,
//           child: Transform.translate(
//             offset: Offset(0, 20 * (1 - value)),
//             child: child,
//           ),
//         );
//       },
//       child: child,
//     );
//   }

//   static Widget buildShimmerLoading() {
//     return ShaderMask(
//       shaderCallback: (bounds) {
//         return LinearGradient(
//           colors: [
//             Colors.grey.shade300,
//             Colors.grey.shade100,
//             Colors.grey.shade300,
//           ],
//           stops: const [0.0, 0.5, 1.0],
//           begin: Alignment(-1.0, 0.0),
//           end: Alignment(1.0, 0.0),
//           tileMode: TileMode.clamp,
//         ).createShader(bounds);
//       },
//       child: Container(color: Colors.white),
//     );
//   }
// }
