import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:logpass_me/core/di/di_config.dart';
import 'package:logpass_me/domain/guardian/guardian.dart';
import 'package:logpass_me/domain/guardian/guardian_repository.dart';
import 'package:logpass_me/generated/local_keys.g.dart';
import 'package:logpass_me/presentation/style/app_colors.dart';

/// Dialog shown to a minor user when they need guardian authorization
/// to complete a verification request on a 18+ service.
///
/// Returns true if guardian approved, false/null otherwise.
class GuardianAuthorizationDialog extends StatefulWidget {
  final String serviceName;
  final String action;
  final String? verifierName;

  const GuardianAuthorizationDialog({
    Key? key,
    required this.serviceName,
    required this.action,
    this.verifierName,
  }) : super(key: key);

  @override
  State<GuardianAuthorizationDialog> createState() => _GuardianAuthorizationDialogState();
}

class _GuardianAuthorizationDialogState extends State<GuardianAuthorizationDialog> {
  static const _timeoutMinutes = 5;
  static const _pollIntervalSeconds = 2;

  final GuardianRepository _guardianRepo = getIt<GuardianRepository>();

  List<Guardian> _guardians = [];
  Guardian? _selectedGuardian;
  bool _isLoading = true;
  bool _isSending = false;
  bool _isWaiting = false;
  String? _errorMessage;
  String? _authRequestId;
  int _secondsRemaining = _timeoutMinutes * 60;

  Timer? _countdownTimer;
  Timer? _pollTimer;

  @override
  void initState() {
    super.initState();
    _loadGuardians();
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _pollTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadGuardians() async {
    try {
      final guardians = await _guardianRepo.getMyGuardians();
      setState(() {
        _guardians = guardians.where((g) => g.isActive).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = LocaleKeys.guardianAuth_errorLoad.tr(namedArgs: {'error': e.toString()});
        _isLoading = false;
      });
    }
  }

  Future<void> _sendAuthorizationRequest() async {
    if (_selectedGuardian == null) return;
    setState(() {
      _isSending = true;
      _errorMessage = null;
    });
    try {
      final authId = await _guardianRepo.requestAuthorization(
        guardianId: _selectedGuardian!.userId,
        serviceName: widget.serviceName,
        action: widget.action,
      );
      setState(() {
        _authRequestId = authId;
        _isSending = false;
        _isWaiting = true;
        _secondsRemaining = _timeoutMinutes * 60;
      });
      _startCountdown();
      _startPolling();
    } catch (e) {
      setState(() {
        _isSending = false;
        _errorMessage = LocaleKeys.guardianAuth_errorSend.tr(namedArgs: {'error': e.toString()});
      });
    }
  }

  void _startCountdown() {
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        _secondsRemaining--;
      });
      if (_secondsRemaining <= 0) {
        timer.cancel();
        _pollTimer?.cancel();
        if (mounted) Navigator.of(context).pop(false);
      }
    });
  }

  void _startPolling() {
    _pollTimer = Timer.periodic(
      const Duration(seconds: _pollIntervalSeconds),
      (timer) async {
        if (!mounted || _authRequestId == null) {
          timer.cancel();
          return;
        }
        try {
          final status = await _guardianRepo.pollAuthorizationStatus(_authRequestId!);
          if (status == 'approved') {
            timer.cancel();
            _countdownTimer?.cancel();
            if (mounted) Navigator.of(context).pop(true);
          } else if (status == 'rejected' || status == 'expired') {
            timer.cancel();
            _countdownTimer?.cancel();
            if (mounted) Navigator.of(context).pop(false);
          }
        } catch (_) {
          // Continue polling on transient errors
        }
      },
    );
  }

  String _formatTime(int totalSeconds) {
    final m = totalSeconds ~/ 60;
    final s = totalSeconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  static const _primaryColor = AppColors.primary100;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: _isWaiting ? _buildWaitingView(context) : _buildSelectionView(context),
      ),
    );
  }

  Widget _buildSelectionView(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.supervisor_account, color: _primaryColor),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                LocaleKeys.guardianAuth_title.tr(),
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          LocaleKeys.guardianAuth_body.tr(
            namedArgs: {'serviceName': widget.verifierName ?? widget.serviceName},
          ),
          style: theme.textTheme.bodyMedium,
        ),
        const SizedBox(height: 16),
        if (_isLoading)
          const Center(child: CircularProgressIndicator())
        else if (_guardians.isEmpty)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.error100.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              LocaleKeys.guardianAuth_noGuardians.tr(),
              style: theme.textTheme.bodySmall?.copyWith(color: AppColors.error100),
            ),
          )
        else
          ..._guardians.map((g) => RadioListTile<Guardian>(
                value: g,
                groupValue: _selectedGuardian,
                onChanged: (v) => setState(() => _selectedGuardian = v),
                title: Text(g.displayName, style: theme.textTheme.bodyMedium),
                subtitle: Text(
                  LocaleKeys.guardianAuth_activeGuardian.tr(),
                  style: theme.textTheme.bodySmall,
                ),
                contentPadding: EdgeInsets.zero,
                dense: true,
              )),
        if (_errorMessage != null) ...[
          const SizedBox(height: 8),
          Text(
            _errorMessage!,
            style: theme.textTheme.bodySmall?.copyWith(color: AppColors.error100),
          ),
        ],
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(LocaleKeys.guardianAuth_cancel.tr()),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: (_selectedGuardian == null || _isSending || _isLoading)
                  ? null
                  : _sendAuthorizationRequest,
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                elevation: 0,
              ),
              child: _isSending
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.secondary),
                    )
                  : Text(
                      LocaleKeys.guardianAuth_send.tr(),
                      style: const TextStyle(color: AppColors.secondary),
                    ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildWaitingView(BuildContext context) {
    final theme = Theme.of(context);
    final progress = _secondsRemaining / (_timeoutMinutes * 60);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.hourglass_top, size: 48, color: _primaryColor),
        const SizedBox(height: 16),
        Text(
          LocaleKeys.guardianAuth_waitingTitle.tr(),
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Text(
          LocaleKeys.guardianAuth_waitingBody.tr(
            namedArgs: {'guardianName': _selectedGuardian?.displayName ?? ''},
          ),
          style: theme.textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 80,
              height: 80,
              child: CircularProgressIndicator(
                value: progress,
                strokeWidth: 6,
                backgroundColor: AppColors.primary10,
                color: _secondsRemaining > 60 ? _primaryColor : AppColors.error100,
              ),
            ),
            Text(
              _formatTime(_secondsRemaining),
              style: theme.textTheme.titleSmall,
            ),
          ],
        ),
        const SizedBox(height: 20),
        TextButton(
          onPressed: () {
            _pollTimer?.cancel();
            _countdownTimer?.cancel();
            Navigator.of(context).pop(false);
          },
          child: Text(LocaleKeys.guardianAuth_cancel.tr()),
        ),
      ],
    );
  }
}
