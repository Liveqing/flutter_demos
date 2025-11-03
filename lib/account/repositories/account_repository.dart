import '../models/account_info.dart';
import '../models/card_info.dart';
import '../models/account_details.dart';

class AccountRepository {
  // 模拟网络延迟
  static const Duration _delay = Duration(milliseconds: 800);

  // 模拟账户数据
  static const AccountInfo _accountData = AccountInfo(
    accountNumber: '3000091010000001',
    totalBalance: 1563716.25,
    currency: 'AED',
  );

  // 模拟卡片数据
  static const CardInfo _cardData = CardInfo(
    cardNumber: '4532123456785631',
    cardHolderName: 'Steve Jobs',
    expiryDate: '10/26',
    cardType: 'VISA',
    isActive: true,
  );

  // 模拟账户详情数据
  static const AccountDetails _accountDetailsData = AccountDetails(
    name: 'Steve Jobs',
    iban: 'AE660963000091876250921',
    accountNumber: '3000091010000001',
    currency: 'AED',
    accountOpeningDate: '1/ August/2023',
    totalBalance: 1563716.25,
  );

  Future<AccountInfo> getAccountInfo() async {
    // 模拟网络延迟
    await Future.delayed(_delay);
    return _accountData;
  }

  Future<CardInfo> getCardInfo() async {
    // 模拟网络延迟
    await Future.delayed(_delay);
    return _cardData;
  }

  Future<Map<String, dynamic>> getAccountData() async {
    // 模拟网络延迟
    await Future.delayed(_delay);
    return {
      'account': _accountData,
      'card': _cardData,
    };
  }

  Future<AccountDetails> getAccountDetails() async {
    // 模拟网络延迟
    await Future.delayed(_delay);
    return _accountDetailsData;
  }
}

