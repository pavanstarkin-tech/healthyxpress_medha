import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/doctor_portal_provider.dart';

class DoctorEarningsScreen extends StatelessWidget {
  const DoctorEarningsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final doctorProv = context.watch<DoctorPortalProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Earnings & Payout Ledger', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.textPrimary)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Revenue Hero Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF065F46), Color(0xFF047857)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(color: const Color(0xFF047857).withValues(alpha: 0.3), blurRadius: 14, offset: const Offset(0, 6)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total Net Earnings', style: TextStyle(color: Colors.white70, fontSize: 13)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(8)),
                        child: const Text('+18% vs last week', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text('₹${doctorProv.todayEarnings.toInt()}', style: const TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 16),
                  const Divider(height: 1, color: Colors.white24),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _MiniRevItem(label: 'Weekly', amount: '₹${doctorProv.weeklyEarnings.toInt()}'),
                      _MiniRevItem(label: 'Monthly', amount: '₹${doctorProv.monthlyEarnings.toInt()}'),
                      _MiniRevItem(label: 'Payout Status', amount: 'Auto-Credited'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),

            // Revenue Ledger Breakdown
            const Text('Financial Breakdown', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: const [
                  _LedgerRow(label: 'Gross Consultations Total', amount: '₹28,450'),
                  SizedBox(height: 8),
                  _LedgerRow(label: 'Platform & Hospital Ops Fee (14%)', amount: '-₹3,950', isDeduction: true),
                  SizedBox(height: 8),
                  _LedgerRow(label: 'Taxes & TDS', amount: '-₹0', isDeduction: true),
                  SizedBox(height: 10),
                  Divider(height: 1, color: AppColors.border),
                  SizedBox(height: 10),
                  _LedgerRow(label: 'Net Settled to Bank Account', amount: '₹24,500', isTotal: true),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Consultation Payout History
            const Text('Recent Consultation Payouts', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            const SizedBox(height: 12),
            _PayoutItem(patient: 'Rahul Kumar', mode: 'In-Clinic Consultation', amount: '₹800', date: 'Today, 10:30 AM', status: 'Credited'),
            _PayoutItem(patient: 'Anita Sharma', mode: 'In-Clinic Consultation', amount: '₹800', date: 'Today, 12:00 PM', status: 'Credited'),
            _PayoutItem(patient: 'Suresh Rao', mode: 'Video Consultation', amount: '₹800', date: 'Today, 02:30 PM', status: 'Processing'),
            _PayoutItem(patient: 'Kavita Reddy', mode: 'Home Visit Consultation', amount: '₹1,200', date: 'Yesterday', status: 'Credited'),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _MiniRevItem extends StatelessWidget {
  final String label;
  final String amount;
  const _MiniRevItem({required this.label, required this.amount});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11)),
        const SizedBox(height: 2),
        Text(amount, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class _LedgerRow extends StatelessWidget {
  final String label;
  final String amount;
  final bool isDeduction;
  final bool isTotal;

  const _LedgerRow({
    required this.label,
    required this.amount,
    this.isDeduction = false,
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 14 : 13,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: isTotal ? AppColors.textPrimary : AppColors.textSecondary,
          ),
        ),
        Text(
          amount,
          style: TextStyle(
            fontSize: isTotal ? 16 : 13,
            fontWeight: isTotal ? FontWeight.w900 : FontWeight.bold,
            color: isDeduction ? AppColors.emergency : (isTotal ? const Color(0xFF0F766E) : AppColors.textPrimary),
          ),
        ),
      ],
    );
  }
}

class _PayoutItem extends StatelessWidget {
  final String patient;
  final String mode;
  final String amount;
  final String date;
  final String status;

  const _PayoutItem({
    required this.patient,
    required this.mode,
    required this.amount,
    required this.date,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(patient, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
              Text(mode, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
              Text(date, style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(amount, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: status == 'Credited' ? const Color(0xFFDCFCE7) : const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: status == 'Credited' ? AppColors.success : const Color(0xFFB45309),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
