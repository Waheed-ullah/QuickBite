import 'package:flutter/material.dart';

class OfflineBanner extends StatelessWidget {
  final bool isOffline;
  final VoidCallback? onRefresh;

  const OfflineBanner({super.key, required this.isOffline, this.onRefresh});

  @override
  Widget build(BuildContext context) {
    if (!isOffline) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.amber,
      child: Row(
        children: [
          const Icon(Icons.wifi_off, size: 16),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              'Offline Mode - Showing cached data',
              style: TextStyle(fontSize: 12),
            ),
          ),
          if (onRefresh != null) ...[
            const SizedBox(width: 8),
            GestureDetector(
              onTap: onRefresh,
              child: const Icon(Icons.refresh, size: 16),
            ),
          ],
        ],
      ),
    );
  }
}
