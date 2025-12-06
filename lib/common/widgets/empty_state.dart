// import 'package:flutter/material.dart';

// class EmptyState extends StatelessWidget {
//   final String title;
//   final String? description;
//   final IconData icon;
//   final VoidCallback? onAction;
//   final String? actionText;

//   const EmptyState({
//     super.key,
//     required this.title,
//     this.description,
//     this.icon = Icons.inbox,
//     this.onAction,
//     this.actionText,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(32),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(icon, size: 64, color: Colors.grey.shade400),
//             const SizedBox(height: 16),
//             Text(
//               title,
//               style: Theme.of(
//                 context,
//               ).textTheme.titleLarge?.copyWith(color: Colors.grey.shade600),
//               textAlign: TextAlign.center,
//             ),
//             if (description != null) ...[
//               const SizedBox(height: 8),
//               Text(
//                 description!,
//                 textAlign: TextAlign.center,
//                 style: TextStyle(color: Colors.grey.shade500),
//               ),
//             ],
//             if (onAction != null && actionText != null) ...[
//               const SizedBox(height: 24),
//               ElevatedButton(onPressed: onAction, child: Text(actionText!)),
//             ],
//           ],
//         ),
//       ),
//     );
//   }
// }
