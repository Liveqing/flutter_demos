import 'package:flutter/material.dart';
import 'keyboard_manager.dart';

/// 自定义键盘输入框
/// 点击时显示自定义数字键盘
class CustomKeyboardTextField extends StatefulWidget {
  final TextEditingController controller;
  final String? hintText;
  final String? labelText;
  final bool showDecimal;
  final int? maxLength;
  final TextStyle? textStyle;
  final InputDecoration? decoration;
  final Function(String)? onChanged;

  const CustomKeyboardTextField({
    super.key,
    required this.controller,
    this.hintText,
    this.labelText,
    this.showDecimal = true,
    this.maxLength,
    this.textStyle,
    this.decoration,
    this.onChanged,
  });

  @override
  State<CustomKeyboardTextField> createState() => _CustomKeyboardTextFieldState();
}

class _CustomKeyboardTextFieldState extends State<CustomKeyboardTextField> {
  final FocusNode _focusNode = FocusNode();
  final GlobalKey _textFieldKey = GlobalKey();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: _textFieldKey,
      onTap: _showKeyboard,
      child: AbsorbPointer(
        // 禁用系统键盘
        child: TextField(
          controller: widget.controller,
          focusNode: _focusNode,
          style: widget.textStyle,
          decoration: widget.decoration ??
              InputDecoration(
                hintText: widget.hintText,
                labelText: widget.labelText,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFFFF6B35),
                    width: 2,
                  ),
                ),
              ),
          readOnly: true,
        ),
      ),
    );
  }

  void _showKeyboard() {
    _focusNode.requestFocus();
    
    KeyboardManager.showKeyboard(
      context: context,
      onNumberPressed: _handleNumberPressed,
      onDeletePressed: _handleDeletePressed,
      onDecimalPressed: widget.showDecimal ? _handleDecimalPressed : null,
      showDecimal: widget.showDecimal,
      textFieldKey: _textFieldKey,
    );
  }

  void _handleNumberPressed(String number) {
    final currentText = widget.controller.text;
    
    // 检查最大长度
    if (widget.maxLength != null && currentText.length >= widget.maxLength!) {
      return;
    }

    // 如果已经有小数点，检查小数位数
    if (currentText.contains('.')) {
      final parts = currentText.split('.');
      if (parts.length > 1 && parts[1].length >= 2) {
        // 最多2位小数
        return;
      }
    }

    setState(() {
      widget.controller.text = currentText + number;
      widget.onChanged?.call(widget.controller.text);
    });
  }

  void _handleDeletePressed() {
    final currentText = widget.controller.text;
    if (currentText.isNotEmpty) {
      setState(() {
        widget.controller.text = currentText.substring(0, currentText.length - 1);
        widget.onChanged?.call(widget.controller.text);
      });
    }
  }

  void _handleDecimalPressed() {
    final currentText = widget.controller.text;
    
    // 如果已经有小数点，不能再添加
    if (currentText.contains('.')) {
      return;
    }

    // 如果为空或最后一个字符不是数字，不能添加小数点
    if (currentText.isEmpty) {
      setState(() {
        widget.controller.text = '0.';
        widget.onChanged?.call(widget.controller.text);
      });
      return;
    }

    setState(() {
      widget.controller.text = '$currentText.';
      widget.onChanged?.call(widget.controller.text);
    });
  }
}

