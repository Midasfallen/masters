import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:service_platform/core/models/api/auto_proposal_model.dart';
import 'package:service_platform/core/providers/api/auto_proposals_provider.dart';
import 'package:service_platform/core/theme/app_colors.dart';
import 'package:service_platform/core/theme/app_sizes.dart';
import 'package:intl/intl.dart';

class AutoProposalsScreen extends ConsumerStatefulWidget {
  const AutoProposalsScreen({super.key});

  @override
  ConsumerState<AutoProposalsScreen> createState() => _AutoProposalsScreenState();
}

class _AutoProposalsScreenState extends ConsumerState<AutoProposalsScreen>
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
      appBar: AppBar(
        title: const Text('Рекомендации'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => _showSettings(),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _generateProposals(),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Активные'),
            Tab(text: 'Все'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          _ActiveProposalsTab(),
          _AllProposalsTab(),
        ],
      ),
    );
  }

  void _showSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ProposalSettingsScreen(),
      ),
    );
  }

  Future<void> _generateProposals() async {
    try {
      final proposals = await ref
          .read(autoProposalNotifierProvider.notifier)
          .generateProposals();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Сгенерировано ${proposals.length} предложений'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

/// Active Proposals Tab
class _ActiveProposalsTab extends ConsumerWidget {
  const _ActiveProposalsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final proposalsAsync = ref.watch(activeProposalsListProvider);

    return proposalsAsync.when(
      data: (proposals) {
        if (proposals.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.lightbulb_outline, size: 64, color: Colors.grey),
                const SizedBox(height: AppSizes.paddingMd),
                const Text(
                  'Нет активных рекомендаций',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: AppSizes.paddingMd),
                ElevatedButton.icon(
                  onPressed: () {
                    ref.read(autoProposalNotifierProvider.notifier).generateProposals();
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Сгенерировать'),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(activeProposalsListProvider);
          },
          child: ListView.separated(
            padding: const EdgeInsets.all(AppSizes.paddingMd),
            itemCount: proposals.length,
            separatorBuilder: (context, index) =>
                const SizedBox(height: AppSizes.paddingMd),
            itemBuilder: (context, index) {
              final proposal = proposals[index];
              return _ProposalCard(proposal: proposal);
            },
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: AppSizes.paddingMd),
            Text('Ошибка: $error'),
            const SizedBox(height: AppSizes.paddingMd),
            ElevatedButton(
              onPressed: () => ref.invalidate(activeProposalsListProvider),
              child: const Text('Повторить'),
            ),
          ],
        ),
      ),
    );
  }
}

/// All Proposals Tab
class _AllProposalsTab extends ConsumerWidget {
  const _AllProposalsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final proposalsAsync = ref.watch(autoProposalsListProvider);

    return proposalsAsync.when(
      data: (proposals) {
        if (proposals.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.inbox_outlined, size: 64, color: Colors.grey),
                SizedBox(height: AppSizes.paddingMd),
                Text(
                  'Нет предложений',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(autoProposalsListProvider);
          },
          child: ListView.separated(
            padding: const EdgeInsets.all(AppSizes.paddingMd),
            itemCount: proposals.length,
            separatorBuilder: (context, index) =>
                const SizedBox(height: AppSizes.paddingMd),
            itemBuilder: (context, index) {
              final proposal = proposals[index];
              return _ProposalCard(proposal: proposal);
            },
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: AppSizes.paddingMd),
            Text('Ошибка: $error'),
            const SizedBox(height: AppSizes.paddingMd),
            ElevatedButton(
              onPressed: () => ref.invalidate(autoProposalsListProvider),
              child: const Text('Повторить'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Proposal Card Widget
class _ProposalCard extends ConsumerWidget {
  const _ProposalCard({required this.proposal});

  final AutoProposalModel proposal;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final master = proposal.master;
    final service = proposal.service;

    return Card(
      elevation: AppSizes.elevation2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status Badge
          if (proposal.status != ProposalStatus.pending)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.paddingSm,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: _getStatusColor(proposal.status),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppSizes.radiusMd),
                  bottomRight: Radius.circular(AppSizes.radiusMd),
                ),
              ),
              child: Text(
                _getStatusText(proposal.status),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

          Padding(
            padding: const EdgeInsets.all(AppSizes.paddingMd),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Master Info
                if (master != null)
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundImage: master.avatarUrl != null
                            ? NetworkImage(master.avatarUrl!)
                            : null,
                        child: master.avatarUrl == null
                            ? Text(
                                '${master.firstName[0]}${master.lastName[0]}',
                                style: const TextStyle(fontSize: 16),
                              )
                            : null,
                      ),
                      const SizedBox(width: AppSizes.paddingMd),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${master.firstName} ${master.lastName}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if (master.rating != null)
                              Row(
                                children: [
                                  const Icon(Icons.star, size: 16, color: Colors.amber),
                                  const SizedBox(width: 4),
                                  Text(
                                    master.rating!.toStringAsFixed(1),
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),

                const SizedBox(height: AppSizes.paddingMd),

                // Service Info
                if (service != null) ...[
                  Text(
                    service.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        '${service.price.toStringAsFixed(0)} ₽',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: AppSizes.paddingMd),
                      Text(
                        '${service.durationMinutes} мин',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],

                const SizedBox(height: AppSizes.paddingMd),

                // Match Score
                Row(
                  children: [
                    const Icon(Icons.thumb_up_outlined, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      'Совместимость: ${proposal.matchScore}%',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),

                const SizedBox(height: AppSizes.paddingSm),

                // Match Reasons
                if (proposal.matchReasons.reasons.isNotEmpty) ...[
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: proposal.matchReasons.reasons
                        .take(3)
                        .map((reason) => Chip(
                              label: Text(
                                reason,
                                style: const TextStyle(fontSize: 12),
                              ),
                              backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                            ))
                        .toList(),
                  ),
                ],

                const SizedBox(height: AppSizes.paddingSm),

                // Expires At
                Text(
                  'Действует до: ${DateFormat('dd.MM.yyyy HH:mm').format(proposal.expiresAt)}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),

                // Action Buttons
                if (proposal.status == ProposalStatus.pending) ...[
                  const SizedBox(height: AppSizes.paddingMd),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _acceptProposal(context, ref),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Принять'),
                        ),
                      ),
                      const SizedBox(width: AppSizes.paddingSm),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => _rejectProposal(ref),
                          child: const Text('Отклонить'),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(ProposalStatus status) {
    switch (status) {
      case ProposalStatus.accepted:
        return Colors.green;
      case ProposalStatus.rejected:
        return Colors.red;
      case ProposalStatus.expired:
        return Colors.grey;
      case ProposalStatus.pending:
        return Colors.blue;
    }
  }

  String _getStatusText(ProposalStatus status) {
    switch (status) {
      case ProposalStatus.accepted:
        return 'Принято';
      case ProposalStatus.rejected:
        return 'Отклонено';
      case ProposalStatus.expired:
        return 'Истекло';
      case ProposalStatus.pending:
        return 'Ожидает';
    }
  }

  Future<void> _acceptProposal(BuildContext context, WidgetRef ref) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: proposal.proposedDatetime ?? DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
    );

    if (pickedDate != null && context.mounted) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(
          proposal.proposedDatetime ?? DateTime.now(),
        ),
      );

      if (pickedTime != null && context.mounted) {
        final proposedDatetime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        try {
          final result = await ref
              .read(autoProposalNotifierProvider.notifier)
              .acceptProposal(
                proposal.id,
                AcceptProposalDto(proposedDatetime: proposedDatetime),
              );

          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Предложение принято. Бронирование создано: ${result['booking_id']}'),
                backgroundColor: Colors.green,
              ),
            );
          }
        } catch (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Ошибка: $e'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      }
    }
  }

  Future<void> _rejectProposal(WidgetRef ref) async {
    try {
      await ref.read(autoProposalNotifierProvider.notifier).rejectProposal(proposal.id);
    } catch (e) {
      // Error handling в provider
    }
  }
}

/// Proposal Settings Screen (будет реализовано позже)
class ProposalSettingsScreen extends StatelessWidget {
  const ProposalSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Настройки рекомендаций'),
      ),
      body: const Center(
        child: Text('Настройки в разработке'),
      ),
    );
  }
}
