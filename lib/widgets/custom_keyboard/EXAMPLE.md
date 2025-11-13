# 自定义键盘使用示例

## 示例1：基本使用（自动滚动）

当输入框被键盘遮挡时，页面会自动滚动到合适位置。

```dart
import 'package:flutter/material.dart';
import 'package:my_flutter_app/widgets/custom_keyboard/custom_keyboard_export.dart';

class AmountInputPage extends StatefulWidget {
  const AmountInputPage({super.key});

  @override
  State<AmountInputPage> createState() => _AmountInputPageState();
}

class _AmountInputPageState extends State<AmountInputPage> {
  final TextEditingController _amountController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // 点击空白区域关闭键盘
      onTap: () => KeyboardManager.hideKeyboard(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('输入金额'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // 顶部内容
              Container(
                height: 400,
                color: Colors.blue[100],
                alignment: Alignment.center,
                child: const Text('顶部内容'),
              ),
              
              const SizedBox(height: 24),
              
              // 金额输入框
              const Text(
                '请输入金额',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              
              CustomKeyboardTextField(
                controller: _amountController,
                hintText: '0.00',
                showDecimal: true,
                onChanged: (value) {
                  print('输入金额: $value');
                },
                decoration: InputDecoration(
                  prefixText: '¥ ',
                  hintText: '0.00',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // 底部内容
              Container(
                height: 300,
                color: Colors.green[100],
                alignment: Alignment.center,
                child: const Text('底部内容'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

## 示例2：在BottomSheet中使用

```dart
import 'package:flutter/material.dart';
import 'package:my_flutter_app/widgets/custom_keyboard/custom_keyboard_export.dart';

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  final TextEditingController _minController = TextEditingController();
  final TextEditingController _maxController = TextEditingController();

  @override
  void dispose() {
    _minController.dispose();
    _maxController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // 点击空白区域关闭键盘
      onTap: () => KeyboardManager.hideKeyboard(),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // 标题
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                '金额范围',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            
            // 可滚动内容
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // 一些顶部内容
                    Container(
                      height: 400,
                      color: Colors.grey[200],
                      margin: const EdgeInsets.only(bottom: 24),
                    ),
                    
                    // 最小金额
                    const Text('最小金额', style: TextStyle(fontSize: 16)),
                    const SizedBox(height: 8),
                    CustomKeyboardTextField(
                      controller: _minController,
                      hintText: '12,000',
                      showDecimal: false,
                      onChanged: (value) {
                        print('最小金额: $value');
                      },
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // 最大金额
                    const Text('最大金额', style: TextStyle(fontSize: 16)),
                    const SizedBox(height: 8),
                    CustomKeyboardTextField(
                      controller: _maxController,
                      hintText: '12,000,000',
                      showDecimal: false,
                      onChanged: (value) {
                        print('最大金额: $value');
                      },
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // 一些底部内容
                    Container(
                      height: 300,
                      color: Colors.grey[200],
                    ),
                  ],
                ),
              ),
            ),
            
            // 底部按钮
            Container(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('确定'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 调用方式
void showFilterSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => const FilterBottomSheet(),
  );
}
```

## 示例3：表单中的多个输入框

```dart
import 'package:flutter/material.dart';
import 'package:my_flutter_app/widgets/custom_keyboard/custom_keyboard_export.dart';

class TransferForm extends StatefulWidget {
  const TransferForm({super.key});

  @override
  State<TransferForm> createState() => _TransferFormState();
}

class _TransferFormState extends State<TransferForm> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _feeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => KeyboardManager.hideKeyboard(),
      child: Scaffold(
        appBar: AppBar(title: const Text('转账')),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 收款人信息
              Container(
                height: 200,
                color: Colors.grey[200],
                margin: const EdgeInsets.only(bottom: 24),
                alignment: Alignment.center,
                child: const Text('收款人信息'),
              ),
              
              // 转账金额
              const Text('转账金额 (AED)', style: TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              CustomKeyboardTextField(
                controller: _amountController,
                hintText: '0.00',
                showDecimal: true,
                decoration: InputDecoration(
                  prefixText: 'AED ',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // 手续费
              const Text('手续费 (AED)', style: TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              CustomKeyboardTextField(
                controller: _feeController,
                hintText: '0.00',
                showDecimal: true,
                decoration: InputDecoration(
                  prefixText: 'AED ',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // 其他信息
              Container(
                height: 200,
                color: Colors.grey[200],
                margin: const EdgeInsets.only(bottom: 24),
                alignment: Alignment.center,
                child: const Text('其他信息'),
              ),
              
              // 提交按钮
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // 处理提交
                  },
                  child: const Text('提交'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

## 工作原理

1. **自动检测遮挡**：当键盘弹出时，系统会自动检测输入框是否被键盘遮挡
2. **计算滚动距离**：如果被遮挡，计算需要滚动的距离
3. **平滑滚动**：使用动画滚动到合适位置，确保输入框在键盘上方可见
4. **自动适配**：支持 `SingleChildScrollView`、`ListView` 等所有可滚动容器

## 注意事项

1. **必须有滚动容器**：输入框必须在可滚动的容器中（如 `SingleChildScrollView`）
2. **点击关闭**：建议在最外层添加 `GestureDetector` 监听点击事件，调用 `KeyboardManager.hideKeyboard()`
3. **BottomSheet**：在 BottomSheet 中使用时，建议设置 `isScrollControlled: true`
4. **键盘高度**：默认键盘高度为320像素，如需调整请修改 `KeyboardManager.keyboardHeight`

