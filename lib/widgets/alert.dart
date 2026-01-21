// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AlertMessage {
  showAlert(BuildContext context, message, status) {
    Color? warnafill;
    Color warnagaris;
    IconData ikon;

    if (status) {
      warnafill = const Color.fromARGB(255, 45, 184, 35);
      warnagaris = Colors.white;
      ikon = Icons.check_circle_outlined;
    } else {
      warnafill = Colors.red;
      warnagaris = Colors.white;
      ikon = Icons.error_outline;
    }

    final overlay = Overlay.of(context);

    final entry = OverlayEntry(
      builder: (_) => Positioned(
        top: MediaQuery.of(context).padding.top + 16,
        left: 16,
        right: 16,
        child: Material(
          color: Colors.transparent,
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: warnafill,
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromARGB(76, 0, 0, 0),
                    spreadRadius: 1.5,
                    blurRadius: 8.0,
                    offset: Offset(0, 4),
                  ),
                ],
                borderRadius: BorderRadius.circular(50),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    message,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Icon(ikon, size: 28, color: warnagaris),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(entry);

    Future.delayed(const Duration(seconds: 3), () {
      entry.remove();
    });
  }
}
