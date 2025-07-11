import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class NeumorphicSearchBar extends StatefulWidget {
  final String HintText;
  const NeumorphicSearchBar({
    super.key,
    required this.HintText,
  });

  @override
  State<NeumorphicSearchBar> createState() => _NeumorphicSearchBarState();
}

class _NeumorphicSearchBarState extends State<NeumorphicSearchBar>
    with SingleTickerProviderStateMixin {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _searchText = '';
  final TextEditingController _controller = TextEditingController();

  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
      lowerBound: 0.9,
      upperBound: 1.2,
    )..addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _speech.stop();
    super.dispose();
  }

  void _listen() async {
    HapticFeedback.lightImpact();

    final status = await Permission.microphone.status;
    if (!status.isGranted) {
      final result = await Permission.microphone.request();
      if (!result.isGranted) return;
    }

    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('STATUS: $val'),
        onError: (val) => print('ERROR: $val'),
      );

      if (available) {
        setState(() => _isListening = true);
        _animationController.repeat(reverse: true);
        _speech.listen(
          onResult: (val) {
            setState(() {
              _searchText = val.recognizedWords;
              _controller.text = _searchText;
              _controller.selection = TextSelection.fromPosition(
                TextPosition(offset: _controller.text.length),
              );
            });
          },
        );
      }
    } else {
      setState(() => _isListening = false);
      _animationController.stop();
      _animationController.value = 1.0;
      _speech.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color darkBoxColor = const Color(0xFF13132C);

    final LinearGradient neonGradient = const LinearGradient(
      colors: [
        Color(0xFF00F0FF),
        Color(0xFF002AFF),
      ],
    );

    return Center(
      child: Container(
        height: 55,
        width: 350,
        decoration: BoxDecoration(
          gradient: neonGradient,
          borderRadius: BorderRadius.circular(40),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF00F0FF).withOpacity(0.4),
              blurRadius: 12,
              spreadRadius: 1,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        padding: const EdgeInsets.all(3.5),
        child: Container(
          decoration: BoxDecoration(
            color: darkBoxColor,
            borderRadius: BorderRadius.circular(40),
          ),
          child: Row(
            children: [
              const SizedBox(width: 24),
              Expanded(
                child: TextField(
                  controller: _controller,
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                  cursorColor: Colors.cyanAccent,
                  decoration: InputDecoration(
                    hintText: widget.HintText,
                    hintStyle: const TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(right: 6),
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.search_sharp,
                  size: 20,
                  color: Colors.white,
                ),
              ),
              GestureDetector(
                onTap: _listen,
                child: Transform.scale(
                  scale: _isListening ? _animationController.value : 1.0,
                  child: Container(
                    margin: const EdgeInsets.only(right: 6),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: _isListening ? Colors.redAccent : Colors.blue,
                      shape: BoxShape.circle,
                      boxShadow: _isListening
                          ? [
                        BoxShadow(
                          color: Colors.redAccent.withOpacity(0.6),
                          blurRadius: 20,
                          spreadRadius: 1,
                        ),
                      ]
                          : [],
                    ),
                    child: Icon(
                      _isListening ? Icons.mic : Icons.mic_none,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
