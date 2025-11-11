# Transaction Filter Feature

## 概述
Transaction筛选弹窗是一个复杂的筛选界面，允许用户根据多个条件筛选交易记录。

## 筛选条件

### 1. Transaction Categories（交易分类）
- **Service**（服务）- 商务中心图标
- **Food**（食物）- 餐厅图标
- **Transport**（交通）- 汽车图标
- **Entertainment**（娱乐）- 电影图标
- **Shopping**（购物）- 购物袋图标
- **Other**（其他）- 更多图标

使用下拉选择器，带有图标和文字显示。

### 2. Time（时间筛选）
**快速选择按钮：**
- 1 week
- 1 month
- 3 months
- 6 months

**自定义日期范围：**
- From日期选择器
- To日期选择器
- 日期格式：DD MMM YYYY

**日期选择表格：**
- 显示预设的日期选项
- 蓝色边框高亮
- 选中项有蓝色背景和文字

### 3. Amount (AED)（金额筛选）
- **Min**最小金额输入框
- **Max**最大金额输入框
- 只允许数字输入
- 占位符：Min: 12,000, Max: 12,000,000

## UI特性

### 设计元素
- **顶部导航**：返回按钮 + 标题居中
- **分组布局**：每个筛选条件独立分组
- **按钮样式**：
  - 选中状态：橙色背景 (#FF6B35)
  - 未选中状态：透明背景，灰色边框
- **输入框**：圆角边框，聚焦时橙色边框

### 底部操作按钮
- **Clear all**：清空所有筛选条件
  - 白色背景，灰色边框
- **Apply**：应用筛选条件
  - 深灰色背景 (#2C2C2C)，白色文字

### 特殊组件

#### 日期选择表格
```
┌─────────────────────────────┐
│ 23    September    2022     │
│ 23    October      2023  ✓  │ (选中状态)
│ 23    November     2024     │
└─────────────────────────────┘
```
- 蓝色边框 (#4A90E2)
- 选中行有蓝色背景和文字

#### 下拉选择器
- 带图标的选项
- 展开时显示所有分类
- 默认显示"Service"

## 技术实现

### 数据模型
```dart
class FilterOptions {
  final TransactionCategory? category;
  final TimeFilter timeFilter;
  final DateTime? startDate;
  final DateTime? endDate;
  final double? minAmount;
  final double? maxAmount;
}
```

### 枚举类型
```dart
enum TransactionCategory { 
  service, food, transport, 
  entertainment, shopping, other 
}

enum TimeFilter { 
  oneWeek, oneMonth, threeMonths, 
  sixMonths, custom 
}
```

### 主要功能
1. **状态管理**：使用StatefulWidget管理筛选状态
2. **日期选择**：集成Flutter的DatePicker
3. **输入验证**：金额输入只允许数字
4. **回调处理**：筛选结果通过回调返回

## 使用方式

1. 在Transaction页面点击筛选图标（橙色调节器图标）
2. 选择交易分类（可选）
3. 选择时间范围（快速选择或自定义）
4. 输入金额范围（可选）
5. 点击"Apply"应用筛选或"Clear all"清空

## 集成方式

在`transactions_page.dart`中：
```dart
void _showFilterBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) => FilterBottomSheet(
      initialFilters: const FilterOptions(),
      onApplyFilters: (filters) {
        // 处理筛选逻辑
      },
    ),
  );
}
```

## 视觉效果
- 全屏高度弹窗（90%屏幕高度）
- 圆角顶部设计
- 滚动内容区域
- 固定底部操作按钮
- 与设计图完全一致的UI效果

## 扩展功能
- 可以轻松添加更多筛选条件
- 支持筛选条件的持久化存储
- 可以集成到Bloc状态管理中
- 支持筛选结果的实时预览
