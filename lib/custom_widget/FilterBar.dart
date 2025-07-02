import 'package:flutter/material.dart';

class NeumorphicFilterBar extends StatelessWidget {
  final IconData icon;
  final Widget navigateTo;

  const NeumorphicFilterBar({
    super.key,
    required this.icon,
    required this.navigateTo,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final boxColor = isDark ? const Color(0xFF13132C) : Colors.white;
    final borderGradient = LinearGradient(
      colors: isDark
          ? [Color(0xFF00CFFF), Color(0xFF0055FF)]
          : [Color(0xFF00A6FF), Color(0xFF007BFF)],
    );

    return Center(
      child: GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (_) => navigateTo,
          ));
        },
        child: Container(
          height: 55,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: borderGradient,
            borderRadius: BorderRadius.circular(40),
          ),
          padding: const EdgeInsets.all(5),
          child: Container(
            decoration: BoxDecoration(
              color: boxColor,
              borderRadius: BorderRadius.circular(40),
              boxShadow: [
                if (!isDark)
                  const BoxShadow(
                    color: Colors.white,
                    offset: Offset(-3, -3),
                    blurRadius: 6,
                  ),
                BoxShadow(
                  color: isDark ? Colors.black54 : Colors.grey.shade400,
                  offset: const Offset(4, 4),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 22, color: Colors.blue),
                const SizedBox(width: 8),
                const Text(
                  "Filter",
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
