import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LocationHeader extends StatelessWidget {
  const LocationHeader({super.key, required this.addressAsync});

  final AsyncValue<String?> addressAsync;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;
    final iconColor = isDark ? Colors.white70 : Colors.black54;
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Icon(Icons.location_on, size: 18, color: iconColor),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                addressAsync.when(
                  data: (addr) => addr ?? '주소 없음',
                  loading: () => '주소 불러오는 중...',
                  error: (err, stack) => '주소 불러오기 실패',
                ),
                style: TextStyle(
                  color: textColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
