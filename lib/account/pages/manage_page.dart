import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/account_bloc.dart';
import '../bloc/account_event.dart';
import '../bloc/account_state.dart';
import '../repositories/account_repository.dart';
import 'account_details_page.dart';

class ManagePage extends StatelessWidget {
  const ManagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          AccountBloc(AccountRepository())..add(LoadAccountData()),
      child: const ManagePageView(),
    );
  }
}

class ManagePageView extends StatelessWidget {
  const ManagePageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F0),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F5F0),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Manage',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<AccountBloc, AccountState>(
        builder: (context, state) {
          if (state is AccountLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is AccountError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    state.message,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<AccountBloc>().add(LoadAccountData());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is AccountLoaded) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Total Balance Section
                  const Text(
                    'Total Balance',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${state.accountInfo.currency} ${state.accountInfo.formattedBalance}',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Account Section
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AccountDetailsPage(),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Account',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  state.accountInfo.accountNumber,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(
                            Icons.arrow_forward_ios,
                            color: Color(0xFFFF6B35),
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Card Section
                  const Text(
                    'Card',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Card Design
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        height: 200,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFFE8D5C4),
                              Color(0xFFF5E6D8),
                              Color(0xFFE8C8A8),
                            ],
                          ),
                        ),
                        child: Stack(
                          children: [
                            // Chip and Contactless Icon
                            Positioned(
                              left: 24,
                              top: 24,
                              child: Row(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      color: Colors.amber.withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: const Icon(
                                      Icons.credit_card,
                                      size: 20,
                                      color: Colors.black45,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Icon(
                                    Icons.contactless,
                                    size: 28,
                                    color: Colors.black.withOpacity(0.3),
                                  ),
                                ],
                              ),
                            ),

                            // VISA Logo (using text as placeholder)
                            Positioned(
                              right: 24,
                              top: 24,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.9),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  'VISA',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1A1F71),
                                    letterSpacing: 2,
                                  ),
                                ),
                              ),
                            ),

                            // Card Number
                            Positioned(
                              left: 24,
                              top: 100,
                              child: Row(
                                children: [
                                  Text(
                                    state.cardInfo.maskedCardNumber,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black.withOpacity(0.7),
                                      letterSpacing: 2,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Icon(
                                    Icons.remove_red_eye,
                                    size: 20,
                                    color: Colors.black.withOpacity(0.4),
                                  ),
                                ],
                              ),
                            ),

                            // Card Holder Name and Expiry
                            Positioned(
                              left: 24,
                              bottom: 24,
                              right: 24,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        state.cardInfo.cardHolderName,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black.withOpacity(0.8),
                                        ),
                                      ),
                                      Text(
                                        state.cardInfo.expiryDate,
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.black.withOpacity(0.5),
                                        ),
                                      ),
                                    ],
                                  ),
                                  // Circle decoration (representing user avatar or icon)
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          const Color(0xFFFF6B35)
                                              .withOpacity(0.8),
                                          const Color(0xFFFF8C5A)
                                              .withOpacity(0.6),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Manage Card Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle manage card action
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Manage card functionality'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2C2C2C),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Manage card',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

