import 'package:flutter/material.dart';
import 'custom_keyboard.dart';

/// 自定义键盘管理器
/// 提供显示和隐藏键盘的方法
class KeyboardManager {
  static OverlayEntry? _overlayEntry;
  static bool _isKeyboardVisible = false;
  static const double keyboardHeight = 320; // 键盘高度
  
  // 键盘高度变化通知器，用于动态调整页面底部空间
  static final ValueNotifier<double> keyboardHeightNotifier = ValueNotifier<double>(0);

  /// 显示自定义键盘
  /// 
  /// [context] - BuildContext
  /// [onNumberPressed] - 数字按键回调
  /// [onDeletePressed] - 删除按键回调
  /// [onDecimalPressed] - 小数点按键回调（可选）
  /// [showDecimal] - 是否显示小数点按钮，默认为true
  /// [textFieldKey] - 输入框的GlobalKey，用于滚动到可见区域
  static void showKeyboard({
    required BuildContext context,
    required Function(String) onNumberPressed,
    required VoidCallback onDeletePressed,
    VoidCallback? onDecimalPressed,
    bool showDecimal = true,
    GlobalKey? textFieldKey,
  }) {
    // 如果键盘已经显示，先隐藏
    if (_isKeyboardVisible) {
      hideKeyboard();
    }

    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          // 半透明背景，点击关闭键盘
          Positioned.fill(
            child: GestureDetector(
              onTap: hideKeyboard,
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),
          
          // 键盘
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: GestureDetector(
              onTap: () {}, // 阻止点击事件传递到背景
              child: CustomKeyboard(
                onNumberPressed: onNumberPressed,
                onDeletePressed: onDeletePressed,
                onDecimalPressed: onDecimalPressed,
                showDecimal: showDecimal,
              ),
            ),
          ),
        ],
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
    _isKeyboardVisible = true;
    
    // 通知键盘高度变化
    keyboardHeightNotifier.value = keyboardHeight;

    // 如果提供了textFieldKey，滚动到可见区域
    if (textFieldKey != null && textFieldKey.currentContext != null) {
      // 延迟一小段时间，等待键盘动画开始和底部空间调整
      Future.delayed(const Duration(milliseconds: 150), () {
        if (textFieldKey.currentContext != null) {
          _scrollToTextField(textFieldKey);
        }
      });
    }
  }

  /// 滚动到输入框可见区域
  static void _scrollToTextField(GlobalKey textFieldKey) {
    final BuildContext? context = textFieldKey.currentContext;
    if (context == null) {
      print('⚠️ Context is null');
      return;
    }

    final RenderObject? renderObject = context.findRenderObject();
    if (renderObject == null) {
      print('⚠️ RenderObject is null');
      return;
    }

    final RenderBox textFieldBox = renderObject as RenderBox;
    final Offset textFieldPosition = textFieldBox.localToGlobal(Offset.zero);
    final Size textFieldSize = textFieldBox.size;
    
    // 获取屏幕高度
    final double screenHeight = MediaQuery.of(context).size.height;
    
    // 计算输入框的底部位置
    final double textFieldBottom = textFieldPosition.dy + textFieldSize.height;
    
    // 计算安全区域：键盘上方留出更多空间
    final double safeAreaTop = screenHeight - keyboardHeight - 100; // 留出100像素的可视空间
    
    print('📱 Screen height: $screenHeight');
    print('⌨️  Safe area top: $safeAreaTop');
    print('📦 TextField bottom: $textFieldBottom');
    print('📦 TextField position: ${textFieldPosition.dy}');
    
    // 只有当输入框在安全区域之外时才滚动
    if (textFieldBottom > safeAreaTop) {
      print('🔄 TextField needs to scroll into safe area');
      
      final ScrollableState? scrollableState = Scrollable.maybeOf(context);
      if (scrollableState == null) {
        print('⚠️ No scrollable found');
        return;
      }
      
      if (!scrollableState.position.hasPixels) {
        print('⚠️ Scrollable has no pixels');
        return;
      }
      
      // 计算需要滚动的距离
      final double currentScroll = scrollableState.position.pixels;
      final double neededScroll = textFieldBottom - safeAreaTop + 40; // 额外40像素padding
      final double targetPosition = currentScroll + neededScroll;
      final double maxScroll = scrollableState.position.maxScrollExtent;
      
      // 确保不超过最大滚动距离
      final double finalPosition = targetPosition > maxScroll ? maxScroll : targetPosition;
      
      print('📊 Current scroll: $currentScroll');
      print('📊 Needed scroll: $neededScroll');
      print('📊 Target position: $targetPosition');
      print('📊 Max scroll: $maxScroll');
      print('📊 Final position: $finalPosition');
      
      if (finalPosition > currentScroll) {
        scrollableState.position.animateTo(
          finalPosition,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    } else {
      print('✅ TextField is already in safe area');
    }
  }

  /// 隐藏自定义键盘
  static void hideKeyboard() {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
      _isKeyboardVisible = false;
      
      // 通知键盘高度变化为0
      keyboardHeightNotifier.value = 0;
    }
  }

  /// 检查键盘是否可见
  static bool get isKeyboardVisible => _isKeyboardVisible;
}

