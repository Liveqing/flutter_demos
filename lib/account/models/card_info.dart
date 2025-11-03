import 'package:equatable/equatable.dart';

class CardInfo extends Equatable {
  final String cardNumber;
  final String cardHolderName;
  final String expiryDate;
  final String cardType;
  final bool isActive;

  const CardInfo({
    required this.cardNumber,
    required this.cardHolderName,
    required this.expiryDate,
    this.cardType = 'VISA',
    this.isActive = true,
  });

  @override
  List<Object> get props =>
      [cardNumber, cardHolderName, expiryDate, cardType, isActive];

  String get maskedCardNumber {
    if (cardNumber.length < 4) return cardNumber;
    final lastFour = cardNumber.substring(cardNumber.length - 4);
    return '**** **** $lastFour';
  }

  String get lastFourDigits {
    if (cardNumber.length < 4) return cardNumber;
    return cardNumber.substring(cardNumber.length - 4);
  }
}

