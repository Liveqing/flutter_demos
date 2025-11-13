# 自定义数字键盘组件

这是一个自定义的数字键盘组件，提供了完整的键盘UI和输入管理功能。

## 功能特性

- ✅ 自定义数字键盘UI（0-9 + 小数点 + 删除）
- ✅ 点击输入框外自动关闭键盘
- ✅ 支持小数点输入（可选）
- ✅ 自动限制小数位数（最多2位）
- ✅ 支持最大长度限制
- ✅ 提供输入变化回调
- ✅ 半透明背景遮罩
- ✅ 平滑的键盘动画
- ✅ **自动滚动页面，确保输入框可见**
- ✅ **动态调整页面底部空间（键盘弹出时自动增加，隐藏时恢复）**

## 使用方法

### 方法1：使用 CustomKeyboardTextField（推荐）

这是最简单的方式，直接替换原有的 `TextField`：

```dart
import 'package:my_flutter_app/widgets/custom_keyboard/custom_keyboard_export.dart';

class MyPage extends StatefulWidget {
  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  final TextEditingController _amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomKeyboardTextField(
        controller: _amountController,
        hintText: '请输入金额',
        showDecimal: true, // 是否显示小数点按钮
        onChanged: (value) {
          // 输入变化时的回调
          print('输入值: $value');
        },
        decoration: InputDecoration(
          hintText: '12,000',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
```

### 方法2：使用 KeyboardManager（高级用法）

如果需要更多自定义控制，可以手动调用 `KeyboardManager`：

```dart
import 'package:my_flutter_app/widgets/custom_keyboard/custom_keyboard_export.dart';

class MyPage extends StatefulWidget {
  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  String _inputValue = '';

  void _showCustomKeyboard() {
    KeyboardManager.showKeyboard(
      context: context,
      onNumberPressed: (number) {
        setState(() {
          _inputValue += number;
        });
      },
      onDeletePressed: () {
        if (_inputValue.isNotEmpty) {
          setState(() {
            _inputValue = _inputValue.substring(0, _inputValue.length - 1);
          });
        }
      },
      onDecimalPressed: () {
        if (!_inputValue.contains('.')) {
          setState(() {
            _inputValue += '.';
          });
        }
      },
      showDecimal: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: _showCustomKeyboard,
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(_inputValue.isEmpty ? '点击输入' : _inputValue),
        ),
      ),
    );
  }
}
```

### 动态调整页面底部空间（推荐）

使用 `ValueListenableBuilder` 监听键盘高度变化，动态调整页面底部空间：

```dart
@override
Widget build(BuildContext context) {
  return Scaffold(
    body: ValueListenableBuilder<double>(
      valueListenable: KeyboardManager.keyboardHeightNotifier,
      builder: (context, keyboardHeight, child) {
        return SingleChildScrollView(
          child: Column(
            children: [
              // 你的内容
              YourContent(),
              
              // 动态底部空间：键盘弹出时增加，隐藏时为0
              SizedBox(height: keyboardHeight > 0 ? keyboardHeight + 80 : 0),
            ],
          ),
        );
      },
    ),
  );
}
```

这种方式会在键盘弹出时自动增加页面底部的空间，提供更流畅的用户体验。

## API 参考

### CustomKeyboardTextField 参数

| 参数 | 类型 | 必填 | 默认值 | 说明 |
|------|------|------|--------|------|
| `controller` | `TextEditingController` | ✅ | - | 文本控制器 |
| `hintText` | `String?` | ❌ | null | 提示文字 |
| `labelText` | `String?` | ❌ | null | 标签文字 |
| `showDecimal` | `bool` | ❌ | true | 是否显示小数点按钮 |
| `maxLength` | `int?` | ❌ | null | 最大输入长度 |
| `textStyle` | `TextStyle?` | ❌ | null | 文本样式 |
| `decoration` | `InputDecoration?` | ❌ | null | 输入框装饰 |
| `onChanged` | `Function(String)?` | ❌ | null | 输入变化回调 |

### KeyboardManager 方法

#### showKeyboard

显示自定义键盘

```dart
KeyboardManager.showKeyboard({
  required BuildContext context,
  required Function(String) onNumberPressed,  // 数字按键回调
  required VoidCallback onDeletePressed,      // 删除按键回调
  VoidCallback? onDecimalPressed,             // 小数点按键回调（可选）
  bool showDecimal = true,                    // 是否显示小数点按钮
});
```

#### hideKeyboard

隐藏自定义键盘

```dart
KeyboardManager.hideKeyboard();
```

#### isKeyboardVisible

检查键盘是否可见

```dart
bool isVisible = KeyboardManager.isKeyboardVisible;
```

#### keyboardHeightNotifier

键盘高度变化通知器，用于监听键盘高度变化

```dart
// 监听键盘高度变化
KeyboardManager.keyboardHeightNotifier.addListener(() {
  double height = KeyboardManager.keyboardHeightNotifier.value;
  print('Keyboard height: $height');
});

// 在ValueListenableBuilder中使用（推荐）
ValueListenableBuilder<double>(
  valueListenable: KeyboardManager.keyboardHeightNotifier,
  builder: (context, keyboardHeight, child) {
    // keyboardHeight: 0表示键盘隐藏，320表示键盘显示
    return YourWidget();
  },
)
```

## 注意事项

1. **小数位数限制**：默认限制最多2位小数
2. **重复小数点**：不允许输入多个小数点
3. **键盘层级**：键盘使用 `OverlayEntry` 显示，会覆盖在所有内容之上
4. **自动关闭**：点击键盘外的半透明区域会自动关闭键盘
5. **页面跳转**：在页面跳转时会自动清理键盘
6. **自动滚动**：当输入框被键盘遮挡时，页面会自动滚动确保输入框可见
7. **滚动容器**：确保输入框在可滚动的容器中（如 `SingleChildScrollView`、`ListView` 等）

## 完整示例

参考 `lib/transaction/widgets/filter_bottom_sheet.dart` 中的 Amount 输入部分。

## 文件结构

```
lib/widgets/custom_keyboard/
├── custom_keyboard.dart              # 键盘UI组件
├── keyboard_manager.dart             # 键盘管理器
├── custom_keyboard_text_field.dart   # 自定义输入框组件
├── custom_keyboard_export.dart       # 导出文件
└── README.md                         # 本文档
```

