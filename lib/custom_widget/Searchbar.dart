import 'package:flutter/material.dart';

class NeumorphicSearchBar extends StatelessWidget {
  final bool isDark;

  const NeumorphicSearchBar({super.key, this.isDark = false});

  @override
  Widget build(BuildContext context) {
    final bgColor = isDark ? const Color(0xFF0D0D1F) : const Color(0xFFF0F2F7);
    final boxColor = isDark ? const Color(0xFF13132C) : Colors.white;
    final borderGradient = LinearGradient(
      colors: isDark
          ? [Color(0xFF00CFFF), Color(0xFF0055FF)] // neon blue tones
          : [Color(0xFF00A6FF), Color(0xFF007BFF)],

    );

    return Center(
      child: Container(
        height: 55,
        width: 380,
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
              const SizedBox(width: 20),
              const Expanded(
                child: TextField(
                  style: TextStyle(fontSize: 16),
                  decoration: InputDecoration(
                    hintText: "Ask me anything...",
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isDark ? Colors.blueAccent : Colors.blue,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.send_rounded,
                  size: 20,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
