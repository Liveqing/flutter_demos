# Account Details Feature

## 概述
Account Details页面是在Manage页面的基础上新增的详情页面，点击Account卡片后跳转到此页面。

## 页面设计

### 1. 顶部区域（SliverAppBar）
- 渐变背景色
- 用户头像圆圈（显示姓名首字母）
- 用户名称
- Total Balance标签
- 余额金额显示

### 2. 内容区域
- 白色卡片容器
- 两个Tab标签：Details 和 Settings

### 3. Details标签内容
显示以下账户信息：
- **Name**: 用户姓名
- **IBAN**: 国际银行账号（带复制按钮）
- **Account Number**: 账户号码（格式化显示，每4位一个空格）
- **Currency**: 货币类型
- **Account opening date**: 开户日期

### 4. 特殊功能
- IBAN号码旁边有复制按钮，点击后复制到剪贴板
- 显示成功复制的提示消息

## 技术实现

### 文件结构
```
lib/account/
├── bloc/
│   ├── account_details_bloc.dart     # 详情页面的Bloc
│   ├── account_details_event.dart    # 详情页面的Events
│   └── account_details_state.dart    # 详情页面的States
├── models/
│   └── account_details.dart          # 账户详情数据模型
├── pages/
│   ├── account_details_page.dart     # 详情页面UI
│   └── manage_page.dart              # 管理页面（已更新）
└── repositories/
    └── account_repository.dart       # 仓库（已更新）
```

### 数据模型
```dart
class AccountDetails {
  final String name;
  final String iban;
  final String accountNumber;
  final String currency;
  final String accountOpeningDate;
  final double totalBalance;
}
```

### 模拟数据
```dart
name: 'Steve Jobs'
iban: 'AE660963000091876250921'
accountNumber: '3000091010000001'
currency: 'AED'
accountOpeningDate: '1/ August/2023'
totalBalance: 1563716.25
```

## UI特性

### 颜色主题
- 背景色：`#F5F5F0`
- 主色调：橙色 `#FF6B35`
- 渐变色：米色/粉色系渐变
- 卡片背景：白色

### 组件特点
1. **可滚动顶部**：使用SliverAppBar实现可折叠的顶部区域
2. **TabBar切换**：Details和Settings两个标签页
3. **复制功能**：使用Clipboard API实现IBAN复制
4. **格式化显示**：账户号码和IBAN自动格式化，每4位添加空格

### 交互反馈
- 点击复制按钮显示SnackBar提示
- 页面加载时显示Loading状态
- 错误时显示错误信息和重试按钮

## 导航流程
```
Main Page
  ↓
Manage Page (点击Account卡片)
  ↓
Account Details Page
```

## Bloc状态管理

### Events
- `LoadAccountDetails`: 加载账户详情
- `RefreshAccountDetails`: 刷新账户详情

### States
- `AccountDetailsInitial`: 初始状态
- `AccountDetailsLoading`: 加载中
- `AccountDetailsLoaded`: 加载成功
- `AccountDetailsError`: 加载失败

## 使用方式

1. 运行应用
2. 点击主页的"Open Account Page"按钮
3. 进入Manage页面
4. 点击"Account"卡片
5. 查看Account Details页面
6. 可以点击IBAN旁边的复制按钮复制账号
7. 可以切换到Settings标签（当前为空白示例）

## 未来扩展
- Settings标签页内容
- 更多账户操作功能
- 交易历史记录
- 账户统计图表

