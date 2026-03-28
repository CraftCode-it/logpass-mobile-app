import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logpass_me/domain/identity/identity_field.dart';
import 'package:logpass_me/domain/identity/identity_profile.dart';
import 'package:logpass_me/domain/identity/identity_profile_type.dart';
import 'package:logpass_me/presentation/page/identity/identity_cubit.dart';
import 'package:logpass_me/presentation/style/app_colors.dart';
import 'package:logpass_me/presentation/style/app_dimens.dart';
import 'package:logpass_me/presentation/style/app_typography.dart';
import 'package:logpass_me/presentation/widget/hooks/cubit_hooks.dart';

const _kMobywatelTestAccounts = [
  ('jan_kowalski', 'Jan Kowalski (1990, dorosły)'),
  ('anna_nowak', 'Anna Nowak (1997, dorosła)'),
  ('tomek_mlody', 'Tomek Młody (2008, nieletni)'),
  ('kasia_probierz', 'Kasia Probierz (2004, 21 lat)'),
  ('krystyna_seniorka', 'Krystyna Seniorka (1961)'),
];

@RoutePage()
class IdentityPage extends HookWidget {
  const IdentityPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<IdentityCubit>();
    final colors = useAppThemeColors();
    final typography = useAppTypography();

    useEffect(() {
      cubit.load();
      return null;
    }, [cubit]);

    final state = useCubitBuilder<IdentityCubit, IdentityState>(cubit);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        title: Text('Tożsamość', style: typography.h2),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddCustomProfileDialog(context, cubit),
            tooltip: 'Dodaj profil',
          ),
        ],
      ),
      body: _buildBody(state, cubit),
    );
  }

  Widget _buildBody(IdentityState state, IdentityCubit cubit) {
    if (state is IdentityVerifying) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Weryfikowanie przez mObywatel...'),
          ],
        ),
      );
    }
    if (state is IdentityLoaded) {
      return _IdentityBody(
        profiles: state.profiles,
        activeProfileId: state.activeProfileId,
        identityVerified: state.identityVerified,
        cubit: cubit,
      );
    }
    if (state is IdentityError) {
      return Center(child: Text('Błąd: ${state.message}'));
    }
    return const Center(child: CircularProgressIndicator());
  }

  void _showAddCustomProfileDialog(BuildContext context, IdentityCubit cubit) {
    final nameController = TextEditingController();
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Nowy profil'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(hintText: 'Nazwa profilu'),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Anuluj'),
          ),
          TextButton(
            onPressed: () {
              final name = nameController.text.trim();
              if (name.isNotEmpty) {
                cubit.addCustomProfile(name);
                Navigator.of(ctx).pop();
              }
            },
            child: const Text('Utwórz'),
          ),
        ],
      ),
    );
  }
}

class _IdentityBody extends HookWidget {
  final List<IdentityProfile> profiles;
  final String activeProfileId;
  final bool identityVerified;
  final IdentityCubit cubit;

  const _IdentityBody({
    required this.profiles,
    required this.activeProfileId,
    required this.identityVerified,
    required this.cubit,
  });

  @override
  Widget build(BuildContext context) {
    final colors = useAppThemeColors();
    final typography = useAppTypography();
    final activeProfile = profiles.firstWhere(
      (p) => p.id == activeProfileId,
      orElse: () => profiles.first,
    );

    final showMobywatel = activeProfile.type == IdentityProfileType.private ||
        activeProfile.type == IdentityProfileType.work;

    return Column(
      children: [
        // mObywatel section (only for Prywatny / Służbowy)
        if (showMobywatel)
          _MobywatelSection(
            cubit: cubit,
            verified: identityVerified,
            context: context,
          ),
        // Profile switcher
        _ProfileSwitcher(
          profiles: profiles,
          activeProfileId: activeProfileId,
          onSelect: cubit.setActiveProfile,
          onDelete: (id) => _confirmDelete(context, id, cubit),
        ),
        const Divider(height: 1),
        // Fields for the active profile
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimens.l,
              vertical: AppDimens.m,
            ),
            children: [
              ...activeProfile.fields.map((field) => _FieldTile(
                    field: field,
                    onEdit: field.isLocked
                        ? null
                        : (newValue) => cubit.updateField(
                            activeProfile.id, field.key, newValue),
                    onCopy: profiles.length > 1
                        ? () => _showCopyFieldDialog(
                              context,
                              cubit,
                              activeProfile,
                              profiles,
                              field.key,
                            )
                        : null,
                  )),
              const SizedBox(height: AppDimens.m),
              TextButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('Dodaj pole'),
                onPressed: () =>
                    _showAddFieldDialog(context, activeProfile.id, cubit),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _confirmDelete(BuildContext context, String profileId, IdentityCubit cubit) {
    const predefined = {'private', 'work', 'proxy'};
    if (predefined.contains(profileId)) return;
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Usuń profil'),
        content: const Text('Czy na pewno chcesz usunąć ten profil?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Anuluj'),
          ),
          TextButton(
            onPressed: () {
              cubit.deleteProfile(profileId);
              Navigator.of(ctx).pop();
            },
            child: const Text('Usuń', style: TextStyle(color: AppColors.error100)),
          ),
        ],
      ),
    );
  }

  void _showCopyFieldDialog(
    BuildContext context,
    IdentityCubit cubit,
    IdentityProfile sourceProfile,
    List<IdentityProfile> allProfiles,
    String fieldKey,
  ) {
    final targets = allProfiles.where((p) => p.id != sourceProfile.id).toList();
    showDialog<void>(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: const Text('Kopiuj pole do profilu'),
        children: targets.map((target) {
          return SimpleDialogOption(
            onPressed: () {
              cubit.copyFieldToProfile(sourceProfile.id, target.id, fieldKey);
              Navigator.of(ctx).pop();
            },
            child: Text(target.displayName),
          );
        }).toList(),
      ),
    );
  }

  void _showAddFieldDialog(
      BuildContext context, String profileId, IdentityCubit cubit) {
    final labelController = TextEditingController();
    final valueController = TextEditingController();
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Dodaj pole'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: labelController,
              decoration: const InputDecoration(labelText: 'Nazwa pola'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: valueController,
              decoration: const InputDecoration(labelText: 'Wartość'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Anuluj'),
          ),
          TextButton(
            onPressed: () {
              final label = labelController.text.trim();
              final value = valueController.text.trim();
              if (label.isNotEmpty) {
                final key = 'custom_${label.toLowerCase().replaceAll(' ', '_')}';
                cubit.addCustomField(profileId, key, label, value);
                Navigator.of(ctx).pop();
              }
            },
            child: const Text('Dodaj'),
          ),
        ],
      ),
    );
  }
}

class _ProfileSwitcher extends HookWidget {
  final List<IdentityProfile> profiles;
  final String activeProfileId;
  final void Function(String) onSelect;
  final void Function(String) onDelete;

  const _ProfileSwitcher({
    required this.profiles,
    required this.activeProfileId,
    required this.onSelect,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final colors = useAppThemeColors();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      height: 56,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppDimens.m, vertical: 8),
        itemCount: profiles.length,
        itemBuilder: (ctx, i) {
          final profile = profiles[i];
          final isActive = profile.id == activeProfileId;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onLongPress: profile.type == IdentityProfileType.custom
                  ? () => onDelete(profile.id)
                  : null,
              child: ChoiceChip(
                label: Text(
                  profile.displayName,
                  style: isActive
                      ? TextStyle(color: colors.textSpecial)
                      : TextStyle(color: colors.text),
                ),
                selected: isActive,
                selectedColor: colors.buttonFill,
                checkmarkColor: colors.textSpecial,
                backgroundColor: colors.background,
                side: BorderSide(color: colors.dividerMedium),
                onSelected: (_) => onSelect(profile.id),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _MobywatelSection extends HookWidget {
  final IdentityCubit cubit;
  final bool verified;
  final BuildContext context;

  const _MobywatelSection({
    required this.cubit,
    required this.verified,
    required this.context,
  });

  @override
  Widget build(BuildContext ctx) {
    final colors = useAppThemeColors();
    final typography = useAppTypography();

    if (verified) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: AppDimens.l, vertical: AppDimens.s),
        padding: const EdgeInsets.all(AppDimens.m),
        decoration: BoxDecoration(
          color: AppColors.success100.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.success100.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            const Icon(Icons.verified_user, color: AppColors.success100, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Zweryfikowano przez mObywatel',
                style: typography.body2.copyWith(color: AppColors.success100),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppDimens.l, vertical: AppDimens.s),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          icon: const Icon(Icons.account_balance),
          label: const Text('Zweryfikuj przez mObywatel'),
          onPressed: () => _showMobywatelDialog(context, cubit),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
    );
  }

  void _showMobywatelDialog(BuildContext ctx, IdentityCubit cubit) {
    showDialog<void>(
      context: ctx,
      builder: (dialogCtx) => SimpleDialog(
        title: const Text('Wybierz profil testowy mObywatel'),
        children: _kMobywatelTestAccounts.map((entry) {
          final (accountKey, label) = entry;
          return SimpleDialogOption(
            onPressed: () {
              Navigator.of(dialogCtx).pop();
              cubit.verifyMobywatel(accountKey);
            },
            child: Text(label),
          );
        }).toList(),
      ),
    );
  }
}

class _FieldTile extends HookWidget {
  final IdentityField field;
  final void Function(String newValue)? onEdit;
  final void Function()? onCopy;

  const _FieldTile({required this.field, this.onEdit, this.onCopy});

  @override
  Widget build(BuildContext context) {
    final colors = useAppThemeColors();
    final typography = useAppTypography();

    Widget? trailingWidget;
    if (field.isLocked) {
      trailingWidget = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (onCopy != null)
            IconButton(
              icon: Icon(Icons.copy_outlined, size: 18, color: colors.secondaryText),
              onPressed: onCopy,
              tooltip: 'Kopiuj do profilu',
            ),
          Icon(Icons.lock_outline, size: 16, color: colors.lightText),
        ],
      );
    } else if (onEdit != null || onCopy != null) {
      trailingWidget = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (onCopy != null)
            IconButton(
              icon: Icon(Icons.copy_outlined, size: 18, color: colors.secondaryText),
              onPressed: onCopy,
              tooltip: 'Kopiuj do profilu',
            ),
          if (onEdit != null)
            IconButton(
              icon: Icon(Icons.edit_outlined, size: 18, color: colors.secondaryText),
              onPressed: () => _showEditDialog(context),
            ),
        ],
      );
    }

    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(field.label,
          style: typography.info2.copyWith(color: colors.labelText)),
      subtitle: Text(
        field.value.isEmpty ? '—' : field.value,
        style: typography.body1.copyWith(color: colors.text),
      ),
      trailing: trailingWidget,
    );
  }

  void _showEditDialog(BuildContext context) {
    final controller = TextEditingController(text: field.value);
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Edytuj: ${field.label}'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(hintText: field.label),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Anuluj'),
          ),
          TextButton(
            onPressed: () {
              onEdit?.call(controller.text.trim());
              Navigator.of(ctx).pop();
            },
            child: const Text('Zapisz'),
          ),
        ],
      ),
    );
  }
}
