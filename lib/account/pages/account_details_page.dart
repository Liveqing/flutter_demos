import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/account_details_bloc.dart';
import '../bloc/account_details_event.dart';
import '../bloc/account_details_state.dart';
import '../repositories/account_repository.dart';

class AccountDetailsPage extends StatelessWidget {
  const AccountDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          AccountDetailsBloc(AccountRepository())..add(LoadAccountDetails()),
      child: const AccountDetailsView(),
    );
  }
}

class AccountDetailsView extends StatefulWidget {
  const AccountDetailsView({super.key});

  @override
  State<AccountDetailsView> createState() => _AccountDetailsViewState();
}

class _AccountDetailsViewState extends State<AccountDetailsView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F0),
      body: BlocBuilder<AccountDetailsBloc, AccountDetailsState>(
        builder: (context, state) {
          if (state is AccountDetailsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is AccountDetailsError) {
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
                      context.read<AccountDetailsBloc>().add(
                        LoadAccountDetails(),
                      );
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is AccountDetailsLoaded) {
            return Column(
              children: [
                // Custom AppBar
                Container(
                  color: const Color(0xFFF5F5F0),
                  child: SafeArea(
                    bottom: false,
                    child: Column(
                      children: [
                        // Top Bar with back button and title
                        Container(
                          height: 56,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Row(
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.arrow_back_ios,
                                  color: Colors.black87,
                                  size: 20,
                                ),
                                onPressed: () => Navigator.pop(context),
                              ),
                              const Expanded(
                                child: Text(
                                  'Account Details',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 48),
                            ],
                          ),
                        ),
                        // Header content
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 24),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                const Color(0xFFE8D5C4).withOpacity(0.3),
                                const Color(0xFFF5E6D8).withOpacity(0.3),
                                const Color(0xFFE8C8A8).withOpacity(0.3),
                              ],
                            ),
                          ),
                          child: Column(
                            children: [
                              // Avatar Circle
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      const Color(0xFFFFB4A2),
                                      const Color(0xFFFFC4B3),
                                    ],
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    state.accountDetails.initials,
                                    style: const TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              // Name
                              Text(
                                state.accountDetails.name,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 8),
                              // Total Balance Label
                              const Text(
                                'Total Balance',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 4),
                              // Balance Amount
                              Text(
                                '${state.accountDetails.currency} ${state.accountDetails.formattedBalance}',
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Content
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        // Account Label
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'Account',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Account Section
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16),
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Tab Bar
                              TabBar(
                                controller: _tabController,
                                indicatorColor: Colors.black87,
                                indicatorWeight: 0,
                                indicator: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(45),
                                  border: Border.all(
                                    width: 10,
                                    color: Colors.grey,
                                  ),
                                ),
                                labelColor: Colors.black87,
                                unselectedLabelColor: Colors.grey,
                                labelStyle: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                                unselectedLabelStyle: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                ),
                                tabs: const [
                                  Tab(text: 'Details'),
                                  Tab(text: 'Settings'),
                                ],
                              ),

                              // Tab Content
                              SizedBox(
                                height: 400,
                                child: TabBarView(
                                  controller: _tabController,
                                  children: [
                                    // Details Tab
                                    _buildDetailsTab(state.accountDetails),
                                    // Settings Tab
                                    _buildSettingsTab(),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildDetailsTab(accountDetails) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailItem(label: 'Name', value: accountDetails.name),
          const SizedBox(height: 20),
          _buildDetailItem(
            label: 'IBAN',
            value: accountDetails.iban,
            showCopyButton: true,
          ),
          const SizedBox(height: 20),
          _buildDetailItem(
            label: 'Account Number',
            value: accountDetails.formattedAccountNumber,
          ),
          const SizedBox(height: 20),
          _buildDetailItem(label: 'Currency', value: accountDetails.currency),
          const SizedBox(height: 20),
          _buildDetailItem(
            label: 'Account opening date',
            value: accountDetails.accountOpeningDate,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildSettingsItem(
            icon: Icons.description_outlined,
            title: 'Account statements',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Account statements'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          _buildSettingsItem(
            icon: Icons.people_outline,
            title: 'Manage beneficiaries',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Manage beneficiaries'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          _buildSettingsItem(
            icon: Icons.credit_card_outlined,
            title: 'Manage standing instruction',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Manage standing instruction'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          _buildSettingsItem(
            icon: Icons.report_problem_outlined,
            title: 'Dispute transaction',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Dispute transaction'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
          ),
          const SizedBox(height: 32),
          // Close Account Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                _showCloseAccountDialog();
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: const BorderSide(color: Colors.grey, width: 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Close Account',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(icon, size: 24, color: Colors.grey[600]),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }

  void _showCloseAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Close Account'),
        content: const Text(
          'Are you sure you want to close this account? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Account close request submitted'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: const Text(
              'Close Account',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem({
    required String label,
    required String value,
    bool showCopyButton = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (showCopyButton)
              InkWell(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: value));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('IBAN copied to clipboard'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF6B35).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.copy,
                    size: 20,
                    color: Color(0xFFFF6B35),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
