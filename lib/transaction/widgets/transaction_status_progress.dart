import 'package:flutter/material.dart';
import '../models/transaction.dart';

class TransactionStatusProgress extends StatelessWidget {
  final TransactionProgressStatus currentStatus;

  const TransactionStatusProgress({
    super.key,
    required this.currentStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      //padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status Labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatusText('Initiated', TransactionProgressStatus.initiated),
              _buildStatusText('Processed', TransactionProgressStatus.processed),
              _buildStatusText('In-Transit', TransactionProgressStatus.inTransit),
              _buildStatusText('Credited', TransactionProgressStatus.credited),
            ],
          ),
          const SizedBox(height: 8),
          
          // Custom Progress Bar with precise alignment
          _buildCustomProgressBar(),
        ],
      ),
    );
  }

  Widget _buildStatusText(String label, TransactionProgressStatus status) {
    final isActive = _getStatusIndex(status) <= _getStatusIndex(currentStatus);
    final isCurrentStatus = status == currentStatus;
    
    return Expanded(
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: isCurrentStatus ? FontWeight.w600 : FontWeight.w400,
          color: isActive 
              ? (isCurrentStatus ? const Color(0xFFFF6B35) : Colors.black)
              : Colors.grey[400],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildCustomProgressBar() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final totalWidth = constraints.maxWidth;
        final stepWidth = 24.0;
        
        // 计算每个状态文字区域的宽度（均匀分布）
        final sectionWidth = totalWidth / 4;
        
        // 每个图标应该在其对应文字区域的中心
        final step1Center = sectionWidth / 2;
        final step2Center = sectionWidth * 1.5;
        final step3Center = sectionWidth * 2.5;
        final step4Center = sectionWidth * 3.5;
        
        return SizedBox(
          height: 24,
          child: Stack(
            children: [
              // 连接线 - 从图标中心到图标中心
              Positioned(
                left: step1Center,
                top: 11,
                child: Container(
                  width: step2Center - step1Center,
                  height: 2,
                  decoration: BoxDecoration(
                    color: _getStatusIndex(currentStatus) > 0 
                        ? const Color(0xFFFF6B35) 
                        : Colors.grey[300],
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
              ),
              Positioned(
                left: step2Center,
                top: 11,
                child: Container(
                  width: step3Center - step2Center,
                  height: 2,
                  decoration: BoxDecoration(
                    color: _getStatusIndex(currentStatus) > 1 
                        ? const Color(0xFFFF6B35) 
                        : Colors.grey[300],
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
              ),
              Positioned(
                left: step3Center,
                top: 11,
                child: Container(
                  width: step4Center - step3Center,
                  height: 2,
                  decoration: BoxDecoration(
                    color: _getStatusIndex(currentStatus) > 2 
                        ? const Color(0xFFFF6B35) 
                        : Colors.grey[300],
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
              ),
              
              // 图标 - 在每个文字区域的中心
              Positioned(
                left: step1Center - stepWidth / 2,
                top: 0,
                child: _buildProgressStep(TransactionProgressStatus.initiated),
              ),
              Positioned(
                left: step2Center - stepWidth / 2,
                top: 0,
                child: _buildProgressStep(TransactionProgressStatus.processed),
              ),
              Positioned(
                left: step3Center - stepWidth / 2,
                top: 0,
                child: _buildProgressStep(TransactionProgressStatus.inTransit),
              ),
              Positioned(
                left: step4Center - stepWidth / 2,
                top: 0,
                child: _buildProgressStep(TransactionProgressStatus.credited),
              ),
            ],
          ),
        );
      },
    );
  }


  Widget _buildProgressStep(TransactionProgressStatus status) {
    final isCompleted = _getStatusIndex(status) < _getStatusIndex(currentStatus);
    final isCurrent = status == currentStatus;
    final isActive = isCompleted || isCurrent;

    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? const Color(0xFFFF6B35) : Colors.grey[300],
        border: isCurrent ? Border.all(
          color: const Color(0xFFFF6B35),
          width: 2,
        ) : null,
      ),
      child: isCompleted 
          ? const Icon(
              Icons.check,
              color: Colors.white,
              size: 16,
            )
          : isCurrent
              ? Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                )
              : null,
    );
  }


  int _getStatusIndex(TransactionProgressStatus status) {
    switch (status) {
      case TransactionProgressStatus.initiated:
        return 0;
      case TransactionProgressStatus.processed:
        return 1;
      case TransactionProgressStatus.inTransit:
        return 2;
      case TransactionProgressStatus.credited:
        return 3;
    }
  }
}
