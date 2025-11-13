import 'package:flutter/material.dart';

class CustomKeyboard extends StatelessWidget {
  final Function(String) onNumberPressed;
  final VoidCallback onDeletePressed;
  final VoidCallback? onDecimalPressed;
  final bool showDecimal;

  const CustomKeyboard({
    super.key,
    required this.onNumberPressed,
    required this.onDeletePressed,
    this.onDecimalPressed,
    this.showDecimal = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 8, bottom: 16),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[400],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Keyboard buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Column(
              children: [
                // Row 1: 1, 2, 3
                Row(
                  children: [
                    _buildKeyButton('1'),
                    _buildKeyButton('2'),
                    _buildKeyButton('3'),
                  ],
                ),
                const SizedBox(height: 8),
                
                // Row 2: 4, 5, 6
                Row(
                  children: [
                    _buildKeyButton('4'),
                    _buildKeyButton('5'),
                    _buildKeyButton('6'),
                  ],
                ),
                const SizedBox(height: 8),
                
                // Row 3: 7, 8, 9
                Row(
                  children: [
                    _buildKeyButton('7'),
                    _buildKeyButton('8'),
                    _buildKeyButton('9'),
                  ],
                ),
                const SizedBox(height: 8),
                
                // Row 4: ., 0, delete
                Row(
                  children: [
                    if (showDecimal)
                      _buildKeyButton('.')
                    else
                      const Expanded(child: SizedBox()),
                    _buildKeyButton('0'),
                    _buildDeleteButton(),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }

  Widget _buildKeyButton(String text) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            onTap: () {
              if (text == '.') {
                onDecimalPressed?.call();
              } else {
                onNumberPressed(text);
              }
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              height: 56,
              alignment: Alignment.center,
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDeleteButton() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Material(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            onTap: onDeletePressed,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              height: 56,
              alignment: Alignment.center,
              child: const Icon(
                Icons.backspace_outlined,
                size: 24,
                color: Colors.black87,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

