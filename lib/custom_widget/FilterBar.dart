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
          ? [const Color(0xFF00CFFF), const Color(0xFF0055FF)]
          : [const Color(0xFF00A6FF), const Color(0xFF007BFF)],
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
          width: 380, // Match width with search bar
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
              children: [
                const SizedBox(width: 30),
                Icon(icon, size: 22, color: Colors.blue),
                const SizedBox(width: 10),
                const Text(
                  "Filter Properties",
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    color: Colors.blue,
                  ),
                ),
                const Spacer(),
                Container(
                  margin: const EdgeInsets.only(right: 12),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.blueAccent : Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.tune, // Filter icon
                    size: 20,
                    color: Colors.white,
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
