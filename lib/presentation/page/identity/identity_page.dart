import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logpass_me/domain/identity/identity_field.dart';
import 'package:logpass_me/domain/identity/identity_profile.dart';
import 'package:logpass_me/domain/identity/identity_profile_type.dart';
import 'package:logpass_me/generated/local_keys.g.dart';
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

    useCubitListener<IdentityCubit, IdentityState>(cubit, (cubit, state, ctx) {
      if (state is IdentityVerified) {
        ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
          content: Text(
            'Zapisano: ${state.firstName} ${state.lastName}, '
            'DOB: ${state.dob}, PESEL: ${state.pesel}',
          ),
          duration: const Duration(seconds: 5),
        ));
        cubit.load();
      }
    });

    final state = useCubitBuilder<IdentityCubit, IdentityState>(cubit);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        title: Text(LocaleKeys.identity_title.tr(), style: typography.h2),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddCustomProfileDialog(context, cubit),
            tooltip: LocaleKeys.identity_addProfileTooltip.tr(),
          ),
        ],
      ),
      body: _buildBody(state, cubit),
    );
  }

  Widget _buildBody(IdentityState state, IdentityCubit cubit) {
    if (state is IdentityVerifying || state is IdentityVerified) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(LocaleKeys.identity_verifyingMobywatel.tr()),
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
      return Center(child: Text(LocaleKeys.identity_error.tr(namedArgs: {'message': state.message})));
    }
    return const Center(child: CircularProgressIndicator());
  }

  void _showAddCustomProfileDialog(BuildContext context, IdentityCubit cubit) {
    final nameController = TextEditingController();
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(LocaleKeys.identity_newProfileTitle.tr()),
        content: TextField(
          controller: nameController,
          decoration: InputDecoration(hintText: LocaleKeys.identity_profileNameHint.tr()),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(LocaleKeys.identity_cancel.tr()),
          ),
          TextButton(
            onPressed: () {
              final name = nameController.text.trim();
              if (name.isNotEmpty) {
                cubit.addCustomProfile(name);
                Navigator.of(ctx).pop();
              }
            },
            child: Text(LocaleKeys.identity_create.tr()),
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
                label: Text(LocaleKeys.identity_addField.tr()),
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
        title: Text(LocaleKeys.identity_deleteProfileTitle.tr()),
        content: Text(LocaleKeys.identity_deleteProfileContent.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(LocaleKeys.identity_cancel.tr()),
          ),
          TextButton(
            onPressed: () {
              cubit.deleteProfile(profileId);
              Navigator.of(ctx).pop();
            },
            child: Text(LocaleKeys.identity_delete.tr(), style: const TextStyle(color: AppColors.error100)),
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
                      ? TextStyle(color: colors.buttonFilledText)
                      : TextStyle(color: colors.text),
                ),
                selected: isActive,
                selectedColor: colors.buttonFill,
                checkmarkColor: colors.buttonFilledText,
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

  const _MobywatelSection({
    required this.cubit,
    required this.verified,
  });

  @override
  Widget build(BuildContext context) {
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
                LocaleKeys.identity_mobywatelVerified.tr(),
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
          label: Text(LocaleKeys.identity_mobywatelVerifyButton.tr()),
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
        title: Text(LocaleKeys.identity_mobywatelDialogTitle.tr()),
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
        title: Text(LocaleKeys.identity_editField.tr(namedArgs: {'label': field.label})),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(hintText: field.label),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(LocaleKeys.identity_cancel.tr()),
          ),
          TextButton(
            onPressed: () {
              onEdit?.call(controller.text.trim());
              Navigator.of(ctx).pop();
            },
            child: Text(LocaleKeys.identity_fieldEditSave.tr()),
          ),
        ],
      ),
    );
  }
}
