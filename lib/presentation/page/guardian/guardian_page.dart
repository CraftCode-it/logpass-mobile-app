import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logpass_me/domain/guardian/guardian.dart';
import 'package:logpass_me/presentation/page/guardian/guardian_cubit.dart';
import 'package:logpass_me/presentation/style/app_colors.dart';
import 'package:logpass_me/presentation/style/app_dimens.dart';
import 'package:logpass_me/presentation/style/app_typography.dart';
import 'package:logpass_me/presentation/widget/hooks/cubit_hooks.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

@RoutePage()
class GuardianPage extends HookWidget {
  final bool isMinor;

  const GuardianPage({Key? key, this.isMinor = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<GuardianCubit>();
    final state = useCubitBuilder<GuardianCubit, GuardianState>(cubit);
    final colors = useAppThemeColors();
    final typography = useAppTypography();

    useEffect(() {
      cubit.load();
      return null;
    }, [cubit]);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        title: Text('Opiekunowie', style: typography.h2),
        actions: [
          if (isMinor)
            IconButton(
              icon: const Icon(Icons.qr_code_scanner),
              tooltip: 'Dodaj opiekuna (skanuj QR)',
              onPressed: () => _openGuardianQrScanner(context, cubit),
            ),
        ],
      ),
      body: _buildBody(state, cubit, colors, typography),
    );
  }

  Widget _buildBody(
    GuardianState state,
    GuardianCubit cubit,
    AppThemeColors colors,
    AppTypography typography,
  ) {
    if (state is GuardianLoading || state is GuardianOperating) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state is GuardianError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: AppColors.error100),
            const SizedBox(height: 12),
            Text('Błąd: ${state.message}',
                style: typography.body1.copyWith(color: colors.secondaryText),
                textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: cubit.load, child: const Text('Spróbuj ponownie')),
          ],
        ),
      );
    }
    if (state is GuardianLoaded) {
      return ListView(
        padding: const EdgeInsets.all(AppDimens.l),
        children: [
          if (state.myGuardians.isEmpty && state.myMinors.isEmpty) ...[
            const SizedBox(height: 48),
            Icon(Icons.supervisor_account_outlined, size: 64, color: colors.lightText),
            const SizedBox(height: 16),
            Center(
              child: Text(
                isMinor ? 'Brak opiekunów' : 'Brak podopiecznych',
                style: typography.h7.copyWith(color: colors.secondaryText),
              ),
            ),
            const SizedBox(height: 8),
            if (isMinor)
              Center(
                child: Text(
                  'Skanuj QR kod opiekuna, aby go dodać',
                  style: typography.body1.copyWith(color: colors.lightText),
                  textAlign: TextAlign.center,
                ),
              ),
          ] else ...[
            if (state.myGuardians.isNotEmpty) ...[
              Text('Moi opiekunowie', style: typography.h6),
              const SizedBox(height: 8),
              ...state.myGuardians.map((g) => _GuardianCard(guardian: g, colors: colors, typography: typography)),
              const SizedBox(height: 24),
            ],
            if (state.myMinors.isNotEmpty) ...[
              Text('Moi podopieczni', style: typography.h6),
              const SizedBox(height: 8),
              ...state.myMinors.map((g) => _GuardianCard(
                    guardian: g,
                    colors: colors,
                    typography: typography,
                    isMinorCard: true,
                    onConfirm: () => cubit.confirmGuardian(g.id),
                    onReject: () => cubit.rejectGuardian(g.id),
                  )),
            ],
          ],
        ],
      );
    }
    return const SizedBox.shrink();
  }

  void _openGuardianQrScanner(BuildContext context, GuardianCubit cubit) async {
    final relationshipType = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Wybierz rodzaj relacji'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.family_restroom),
              title: const Text('Rodzic'),
              onTap: () => Navigator.of(ctx).pop('parent'),
            ),
            ListTile(
              leading: const Icon(Icons.supervised_user_circle),
              title: const Text('Opiekun prawny'),
              onTap: () => Navigator.of(ctx).pop('legal_guardian'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Anuluj'),
          ),
        ],
      ),
    );

    if (relationshipType == null) return;

    if (!context.mounted) return;
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => _GuardianQrScanPage(
          onScanned: (uuid) {
            Navigator.of(context).pop();
            cubit.addGuardian(uuid, relationshipType: relationshipType);
          },
        ),
      ),
    );
  }
}

class _GuardianCard extends StatelessWidget {
  final Guardian guardian;
  final AppThemeColors colors;
  final AppTypography typography;
  final bool isMinorCard;
  final VoidCallback? onConfirm;
  final VoidCallback? onReject;

  const _GuardianCard({
    required this.guardian,
    required this.colors,
    required this.typography,
    this.isMinorCard = false,
    this.onConfirm,
    this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    String statusLabel;
    switch (guardian.status) {
      case 'active':
        statusColor = AppColors.success100;
        statusLabel = 'Aktywny';
        break;
      case 'pending':
        statusColor = Colors.orange;
        statusLabel = 'Oczekuje';
        break;
      default:
        statusColor = AppColors.error100;
        statusLabel = 'Odwołany';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(AppDimens.m),
      decoration: BoxDecoration(
        color: colors.secondaryBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.dividerMedium),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.person_outline, color: colors.secondaryText),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(guardian.displayName, style: typography.h8),
                    if (guardian.relationshipType != null)
                      Text(
                        guardian.relationshipLabel,
                        style: typography.info2.copyWith(color: colors.lightText),
                      ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  statusLabel,
                  style: typography.info2.copyWith(color: statusColor),
                ),
              ),
            ],
          ),
          if (isMinorCard && guardian.isPending && (onConfirm != null || onReject != null)) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onReject,
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: AppColors.error100),
                      foregroundColor: AppColors.error100,
                    ),
                    child: const Text('Odrzuć'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onConfirm,
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.success100),
                    child: const Text('Zatwierdź'),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _GuardianQrScanPage extends StatefulWidget {
  final void Function(String uuid) onScanned;

  const _GuardianQrScanPage({required this.onScanned});

  @override
  State<_GuardianQrScanPage> createState() => _GuardianQrScanPageState();
}

class _GuardianQrScanPageState extends State<_GuardianQrScanPage> {
  bool _scanned = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Skanuj QR opiekuna')),
      body: MobileScanner(
        onDetect: (capture) {
          if (_scanned) return;
          final barcode = capture.barcodes.first;
          final raw = barcode.rawValue;
          if (raw == null) return;
          final uuidRegex = RegExp(
            r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$',
          );
          if (uuidRegex.hasMatch(raw)) {
            setState(() => _scanned = true);
            widget.onScanned(raw);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Nieprawidłowy QR kod — oczekiwano LogPass ID')),
            );
          }
        },
      ),
    );
  }
}
