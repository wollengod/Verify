import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Verify/utilities/hex_color.dart';

import '../Screens/Real Estate/search_result.dart';

class NeumorphicSearchBar extends StatefulWidget {
  final String HintText;

  const NeumorphicSearchBar({
    super.key,
    required this.HintText,
  });

  @override
  State<NeumorphicSearchBar> createState() => _NeumorphicSearchBarState();
}

class _NeumorphicSearchBarState extends State<NeumorphicSearchBar> {

  final TextEditingController _controller = TextEditingController();

  void _navigateToResult(String keyword) {
    if (keyword.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SearchResultPage(keyword: keyword),
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color darkBoxColor = "#001234".toColor();
    final LinearGradient neonGradient = const LinearGradient(
      colors: [Color(0xFF00F0FF), Color(0xFF002AFF)],
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        return Center(
          child: Container(
            height: 55,
            width: constraints.maxWidth * 0.9, // takes 90% of available width
            decoration: BoxDecoration(
              gradient: neonGradient,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF00F0FF).withOpacity(0.4),
                  blurRadius: 6,
                  spreadRadius: 0,
                ),
              ],
            ),
            padding: const EdgeInsets.all(2),
            child: Container(
              decoration: BoxDecoration(
                color: darkBoxColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      onChanged: (_) => setState(() {}),
                      controller: _controller,
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                      cursorColor: Colors.cyanAccent,
                      decoration: InputDecoration(
                        hintText: widget.HintText,
                        hintStyle: const TextStyle(color: Colors.grey),
                        border: InputBorder.none,
                        suffixIcon: _controller.text.isNotEmpty
                            ? IconButton(
                          icon: const Icon(Icons.clear, color: Colors.white70),
                          onPressed: () {
                            setState(() {
                              _controller.clear();
                            });
                          },
                        )
                            : null,
                      ),
                      onSubmitted: (value) {
                        if (value.trim().isNotEmpty) {
                          _navigateToResult(value.trim());
                        }
                      },
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      final text = _controller.text.trim();
                      if (text.isNotEmpty) {
                        _navigateToResult(text);
                      }
                    },
                    child: Transform.scale(
                      scale: 1.0,
                      child: Container(
                        margin: const EdgeInsets.only(right: 6),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.4),
                              blurRadius: 10,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.send, // 🔥 changed here
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),                ],
              ),
            ),
          ),
        );
      },
    );
  }

}
