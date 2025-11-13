// 自定义键盘组件导出文件
// 
// 使用方法：
// ```dart
// import 'package:my_flutter_app/widgets/custom_keyboard/custom_keyboard_export.dart';
// 
// // 方法1: 使用CustomKeyboardTextField（推荐）
// CustomKeyboardTextField(
//   controller: _controller,
//   hintText: 'Enter amount',
//   showDecimal: true,
// )
// 
// // 方法2: 手动调用KeyboardManager
// KeyboardManager.showKeyboard(
//   context: context,
//   onNumberPressed: (number) {
//     // 处理数字输入
//   },
//   onDeletePressed: () {
//     // 处理删除
//   },
// );
// 
// // 隐藏键盘
// KeyboardManager.hideKeyboard();
// ```

export 'custom_keyboard.dart';
export 'keyboard_manager.dart';
export 'custom_keyboard_text_field.dart';

