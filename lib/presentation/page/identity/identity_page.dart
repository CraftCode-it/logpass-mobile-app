import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logpass_me/core/identity/brand_catalog.dart';
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
  ('ola_dziecko', 'Ola Dziecko (2011, 13 lat)'),
  ('zosia_mloda', 'Zosia Młoda (2013, 12 lat)'),
  ('marek_junior', 'Marek Junior (2015, 10 lat)'),
  ('kasia_probierz', 'Kasia Probierz (2004, 21 lat)'),
  ('krystyna_seniorka', 'Krystyna Seniorka (1961)'),
];

const _kPredefinedDataFields = [
  IdentityFieldKey.firstName,
  IdentityFieldKey.lastName,
  IdentityFieldKey.dateOfBirth,
  IdentityFieldKey.email,
  IdentityFieldKey.phone,
  IdentityFieldKey.addressCity,
  IdentityFieldKey.addressStreet,
  IdentityFieldKey.addressPostalCode,
  IdentityFieldKey.invoiceData,
];

const _kPredefinedPreferenceFields = [
  IdentityFieldKey.adultContentOptIn,
  IdentityFieldKey.alcoholCategory,
  IdentityFieldKey.alcoholBrand,
  IdentityFieldKey.tobaccoCategory,
  IdentityFieldKey.cigaretteBrand,
];

const _kUniqueDataFieldKeys = {
  IdentityFieldKey.firstName,
  IdentityFieldKey.lastName,
  IdentityFieldKey.dateOfBirth,
  IdentityFieldKey.peselMasked,
  IdentityFieldKey.email,
  IdentityFieldKey.phone,
  IdentityFieldKey.address,
  IdentityFieldKey.addressCity,
  IdentityFieldKey.addressStreet,
  IdentityFieldKey.addressPostalCode,
  IdentityFieldKey.invoiceData,
};

const _kUniquePreferenceFieldKeys = {
  IdentityFieldKey.adultContentOptIn,
  IdentityFieldKey.alcoholCategory,
  IdentityFieldKey.alcoholBrand,
  IdentityFieldKey.tobaccoCategory,
  IdentityFieldKey.cigaretteBrand,
};

const _kMultiPreferenceFieldKeys = {
  IdentityFieldKey.alcoholCategory,
  IdentityFieldKey.alcoholBrand,
  IdentityFieldKey.tobaccoCategory,
  IdentityFieldKey.cigaretteBrand,
};

Set<String> _splitMultiValue(String raw) {
  return raw
      .split(',')
      .map((value) => value.trim())
      .where((value) => value.isNotEmpty)
      .toSet();
}

String _joinMultiValue(Set<String> values) {
  final ordered = values.toList()..sort();
  return ordered.join(', ');
}

Set<String> _normalizePreferenceSelection(Set<String> values) {
  if (values.contains('bez preferencji')) return {'bez preferencji'};
  final filtered = {...values}..remove('bez preferencji');
  return filtered;
}

List<String> _brandsForAlcoholCategories(Set<String> categories) {
  final source = categories.isEmpty
      ? <String>{BrandCatalog.alcoholCategories.first}
      : categories;
  final values = <String>{};
  for (final category in source) {
    values.addAll(BrandCatalog.alcoholBrandsForCategory(category));
  }
  return values.toList();
}

List<String> _brandsForTobaccoCategories(Set<String> categories) {
  final source = categories.isEmpty
      ? <String>{BrandCatalog.tobaccoCategories.first}
      : categories;
  final values = <String>{};
  for (final category in source) {
    values.addAll(BrandCatalog.tobaccoBrandsForCategory(category));
  }
  return values.toList();
}

String _customKeyFromLabel(String label, String prefix) {
  final slug = label
      .trim()
      .toLowerCase()
      .replaceAll(RegExp(r'[^a-z0-9ąćęłńóśźż]+', unicode: true), '_')
      .replaceAll(RegExp(r'_+'), '_')
      .replaceAll(RegExp(r'^_|_$'), '');
  return '${prefix}_${slug.isEmpty ? DateTime.now().millisecondsSinceEpoch : slug}';
}

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
                    _openAddFieldScreen(context, activeProfile, cubit),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _confirmDelete(BuildContext context, String profileId, IdentityCubit cubit) {
    const predefined = {'private', 'work', 'proxy', 'adult'};
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
    final isProxySource = sourceProfile.type == IdentityProfileType.proxy;
    final targets = allProfiles.where((p) {
      if (p.id == sourceProfile.id) return false;
      if (isProxySource &&
          (p.type == IdentityProfileType.private ||
           p.type == IdentityProfileType.work)) return false;
      return true;
    }).toList();
    if (targets.isEmpty) return;
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

  Future<void> _openAddFieldScreen(
      BuildContext context, IdentityProfile activeProfile, IdentityCubit cubit) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => _IdentityFieldAddPage(
          profile: activeProfile,
          cubit: cubit,
        ),
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
              onPressed: () => _openEditScreen(context),
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

  Future<void> _openEditScreen(BuildContext context) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => _IdentityFieldEditPage(
          field: field,
          onEdit: onEdit,
        ),
      ),
    );
  }

}

class _IdentityFieldAddPage extends HookWidget {
  final IdentityProfile profile;
  final IdentityCubit cubit;

  const _IdentityFieldAddPage({
    required this.profile,
    required this.cubit,
  });

  @override
  Widget build(BuildContext context) {
    final colors = useAppThemeColors();
    final typography = useAppTypography();
    final labelController = useTextEditingController();
    final valueController = useTextEditingController();
    final customValueController = useTextEditingController();
    final searchController = useTextEditingController();
    final searchQuery = useState('');
    final fieldKind = useState('data');
    final valueKind = useState('predefined');
    final selectedKey = useState('');
    final selectedValue = useState('');
    final selectedMultiValues = useState<Set<String>>({});
    final selectedAlcoholCategories = useState<Set<String>>({});
    final selectedTobaccoCategories = useState<Set<String>>({});

    final existingKeys = profile.fields.map((field) => field.key).toSet();
    final availableDataFields = _kPredefinedDataFields.where((key) {
      if (_kUniqueDataFieldKeys.contains(key) && existingKeys.contains(key)) {
        return false;
      }
      if (key == IdentityFieldKey.address &&
          (existingKeys.contains(IdentityFieldKey.addressCity) ||
              existingKeys.contains(IdentityFieldKey.addressStreet) ||
              existingKeys.contains(IdentityFieldKey.addressPostalCode))) {
        return false;
      }
      if ((key == IdentityFieldKey.addressCity ||
              key == IdentityFieldKey.addressStreet ||
              key == IdentityFieldKey.addressPostalCode) &&
          existingKeys.contains(IdentityFieldKey.address)) {
        return false;
      }
      return true;
    }).toList();
    final availablePreferenceFields = _kPredefinedPreferenceFields.where((key) {
      if (_kUniquePreferenceFieldKeys.contains(key) && existingKeys.contains(key)) {
        return false;
      }
      return true;
    }).toList();

    final fieldKeys = fieldKind.value == 'preferences'
        ? availablePreferenceFields
        : availableDataFields;
    if (!fieldKeys.contains(selectedKey.value)) {
      selectedKey.value = fieldKeys.isEmpty ? '' : fieldKeys.first;
      selectedValue.value = '';
      selectedMultiValues.value = {};
    }
    final catalogValues = selectedKey.value == IdentityFieldKey.alcoholBrand
        ? _brandsForAlcoholCategories(selectedAlcoholCategories.value)
        : selectedKey.value == IdentityFieldKey.cigaretteBrand
            ? _brandsForTobaccoCategories(selectedTobaccoCategories.value)
            : BrandCatalog.valuesFor(selectedKey.value) ?? const <String>[];
    final visibleCatalogValues = catalogValues
        .where((value) =>
            value.toLowerCase().contains(searchQuery.value.toLowerCase()))
        .toList();
    final isMultiValueField = _kMultiPreferenceFieldKeys.contains(selectedKey.value);
    if (catalogValues.isNotEmpty &&
        !isMultiValueField &&
        selectedValue.value.isEmpty &&
        valueKind.value == 'predefined') {
      selectedValue.value = catalogValues.first;
    }
    if (catalogValues.isNotEmpty && isMultiValueField && selectedMultiValues.value.isEmpty) {
      selectedMultiValues.value = {catalogValues.first};
    }

    Future<void> submit() async {
      final isPredefined = valueKind.value == 'predefined';
      if (isPredefined && selectedKey.value.isEmpty) return;
      final label = isPredefined
          ? IdentityFieldKey.label(selectedKey.value)
          : labelController.text.trim();
      final key = isPredefined
          ? selectedKey.value
          : _customKeyFromLabel(
              label,
              fieldKind.value == 'preferences' ? 'pref' : 'custom',
            );
      final value = isPredefined
          ? (isMultiValueField
              ? _joinMultiValue(
                  _normalizePreferenceSelection(
                    selectedMultiValues.value.map((item) {
                      if (item == BrandCatalog.customValue) {
                        return customValueController.text.trim();
                      }
                      return item;
                    }).where((item) => item.isNotEmpty).toSet(),
                  ),
                )
              : (selectedValue.value == BrandCatalog.customValue
                  ? customValueController.text.trim()
                  : (catalogValues.isEmpty
                      ? valueController.text.trim()
                      : selectedValue.value)))
          : valueController.text.trim();
      if (label.isEmpty || value.isEmpty) return;
      if (isPredefined && selectedKey.value == IdentityFieldKey.alcoholBrand) {
        final categoryValue = _joinMultiValue(
          _normalizePreferenceSelection(selectedAlcoholCategories.value),
        );
        if (!existingKeys.contains(IdentityFieldKey.alcoholCategory) &&
            categoryValue.isNotEmpty) {
          await cubit.addCustomField(
            profile.id,
            IdentityFieldKey.alcoholCategory,
            IdentityFieldKey.label(IdentityFieldKey.alcoholCategory),
            categoryValue,
          );
        }
      }
      if (isPredefined && selectedKey.value == IdentityFieldKey.cigaretteBrand) {
        final categoryValue = _joinMultiValue(
          _normalizePreferenceSelection(selectedTobaccoCategories.value),
        );
        if (!existingKeys.contains(IdentityFieldKey.tobaccoCategory) &&
            categoryValue.isNotEmpty) {
          await cubit.addCustomField(
            profile.id,
            IdentityFieldKey.tobaccoCategory,
            IdentityFieldKey.label(IdentityFieldKey.tobaccoCategory),
            categoryValue,
          );
        }
      }
      await cubit.addCustomField(profile.id, key, label, value);
      if (!context.mounted) return;
      Navigator.of(context).pop();
    }

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        title: Text('identity.addFieldTitle'.tr(), style: typography.h2),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppDimens.l),
        children: [
          _IdentitySectionTitle(title: 'identity.fieldKindTitle'.tr()),
          const SizedBox(height: AppDimens.s),
          _LogPassToggleGroup(
            options: [
              _ToggleOption(value: 'data', label: 'identity.fieldKindData'.tr()),
              _ToggleOption(
                  value: 'preferences', label: 'identity.fieldKindPreferences'.tr()),
            ],
            selectedValue: fieldKind.value,
            onChanged: (selection) {
              fieldKind.value = selection;
              selectedKey.value = '';
              selectedValue.value = '';
              selectedMultiValues.value = {};
              searchController.clear();
              searchQuery.value = '';
            },
          ),
          const SizedBox(height: AppDimens.l),
          _IdentitySectionTitle(title: 'identity.valueKindTitle'.tr()),
          const SizedBox(height: AppDimens.s),
          _LogPassToggleGroup(
            options: [
              _ToggleOption(
                  value: 'predefined', label: 'identity.valueKindPredefined'.tr()),
              _ToggleOption(value: 'custom', label: 'identity.valueKindCustom'.tr()),
            ],
            selectedValue: valueKind.value,
            onChanged: (selection) {
              valueKind.value = selection;
              selectedValue.value = '';
              selectedMultiValues.value = {};
              searchController.clear();
              searchQuery.value = '';
            },
          ),
          const SizedBox(height: AppDimens.l),
          if (valueKind.value == 'predefined') ...[
            DropdownButtonFormField<String>(
              value: selectedKey.value.isEmpty ? null : selectedKey.value,
              decoration: InputDecoration(labelText: 'identity.fieldLabel'.tr()),
              items: fieldKeys
                  .map((key) =>
                      DropdownMenuItem(value: key, child: Text(IdentityFieldKey.label(key))))
                  .toList(),
              onChanged: (value) {
                if (value == null) return;
                selectedKey.value = value;
                selectedValue.value = '';
                selectedMultiValues.value = {};
                searchController.clear();
                searchQuery.value = '';
                if (value == IdentityFieldKey.alcoholBrand) {
                  selectedAlcoholCategories.value = {};
                }
                if (value == IdentityFieldKey.cigaretteBrand) {
                  selectedTobaccoCategories.value = {};
                }
              },
            ),
            if (fieldKeys.isEmpty) ...[
              const SizedBox(height: AppDimens.s),
              Text(
                'identity.noFieldsToAdd'.tr(),
                style: typography.info2.copyWith(color: colors.secondaryText),
              ),
            ],
            const SizedBox(height: AppDimens.s),
            if (selectedKey.value == IdentityFieldKey.alcoholBrand) ...[
              _IdentitySectionTitle(title: 'identity.alcoholCategoryFirst'.tr()),
              const SizedBox(height: AppDimens.xs),
              _MultiSelectList(
                options: BrandCatalog.alcoholCategories
                    .where((value) => value != BrandCatalog.customValue)
                    .toList(),
                selectedValues: selectedAlcoholCategories.value,
                onChanged: (values) {
                  selectedAlcoholCategories.value = values;
                  selectedMultiValues.value = {};
                  searchController.clear();
                  searchQuery.value = '';
                },
              ),
              const SizedBox(height: AppDimens.s),
            ],
            if (selectedKey.value == IdentityFieldKey.cigaretteBrand) ...[
              _IdentitySectionTitle(title: 'identity.tobaccoCategoryFirst'.tr()),
              const SizedBox(height: AppDimens.xs),
              _MultiSelectList(
                options: BrandCatalog.tobaccoCategories
                    .where((value) => value != BrandCatalog.customValue)
                    .toList(),
                selectedValues: selectedTobaccoCategories.value,
                onChanged: (values) {
                  selectedTobaccoCategories.value = values;
                  selectedMultiValues.value = {};
                  searchController.clear();
                  searchQuery.value = '';
                },
              ),
              const SizedBox(height: AppDimens.s),
            ],
            if (catalogValues.isNotEmpty)
              selectedKey.value == IdentityFieldKey.adultContentOptIn
                  ? DropdownButtonFormField<String>(
                      value: catalogValues.contains(selectedValue.value)
                          ? selectedValue.value
                          : catalogValues.first,
                      decoration: InputDecoration(labelText: 'identity.valueLabel'.tr()),
                      items: catalogValues
                          .map((value) =>
                              DropdownMenuItem(value: value, child: Text(value)))
                          .toList(),
                      onChanged: (value) {
                        if (value == null) return;
                        selectedValue.value = value;
                      },
                    )
                  : isMultiValueField
                      ? Column(
                          children: [
                            TextField(
                              controller: searchController,
                              decoration: InputDecoration(
                                labelText: 'identity.searchValueLabel'.tr(),
                                prefixIcon: const Icon(Icons.search),
                              ),
                              onChanged: (value) {
                                searchQuery.value = value;
                              },
                            ),
                            const SizedBox(height: AppDimens.s),
                            _MultiSelectList(
                              options: visibleCatalogValues,
                              selectedValues: selectedMultiValues.value,
                              onChanged: (values) {
                                selectedMultiValues.value =
                                    _normalizePreferenceSelection(values);
                              },
                              height: 220,
                            ),
                          ],
                        )
                  : Column(
                      children: [
                        TextField(
                          controller: searchController,
                          decoration: InputDecoration(
                            labelText: 'identity.searchValueLabel'.tr(),
                            prefixIcon: const Icon(Icons.search),
                          ),
                          onChanged: (value) {
                            searchQuery.value = value;
                          },
                        ),
                        const SizedBox(height: AppDimens.s),
                        SizedBox(
                          height: 200,
                          child: ListView(
                            children: visibleCatalogValues
                                .map((value) => RadioListTile<String>(
                                      value: value,
                                      groupValue: selectedValue.value,
                                      title: Text(value),
                                      onChanged: (v) {
                                        if (v == null) return;
                                        selectedValue.value = v;
                                      },
                                    ))
                                .toList(),
                          ),
                        ),
                      ],
                    )
            else
              TextField(
                controller: valueController,
                decoration: InputDecoration(labelText: 'identity.valueLabel'.tr()),
              ),
            if (selectedValue.value == BrandCatalog.customValue) ...[
              const SizedBox(height: AppDimens.s),
              TextField(
                controller: customValueController,
                decoration:
                    InputDecoration(labelText: 'identity.customValueLabel'.tr()),
              ),
            ],
            if (isMultiValueField &&
                selectedMultiValues.value.contains(BrandCatalog.customValue)) ...[
              const SizedBox(height: AppDimens.s),
              TextField(
                controller: customValueController,
                decoration:
                    InputDecoration(labelText: 'identity.customValueLabel'.tr()),
              ),
            ],
          ] else ...[
            TextField(
              controller: labelController,
              decoration:
                  InputDecoration(labelText: 'identity.customFieldNameLabel'.tr()),
            ),
            const SizedBox(height: AppDimens.s),
            TextField(
              controller: valueController,
              decoration: InputDecoration(labelText: 'identity.valueLabel'.tr()),
            ),
          ],
          const SizedBox(height: AppDimens.l),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: colors.buttonFill,
              foregroundColor: colors.buttonFilledText,
            ),
            onPressed: submit,
            child: Text('identity.addFieldAction'.tr()),
          ),
        ],
      ),
    );
  }
}

class _IdentityFieldEditPage extends HookWidget {
  final IdentityField field;
  final void Function(String newValue)? onEdit;

  const _IdentityFieldEditPage({
    required this.field,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final colors = useAppThemeColors();
    final typography = useAppTypography();
    final controller = useTextEditingController(text: field.value);
    final searchController = useTextEditingController();
    final searchQuery = useState('');
    final customValueController = useTextEditingController(
      text: BrandCatalog.valuesFor(field.key)?.contains(field.value) == false
          ? field.value
          : '',
    );
    final selectedAlcoholCategories = useState<Set<String>>({});
    final selectedTobaccoCategories = useState<Set<String>>({});
    final selectedMultiValues = useState<Set<String>>(_splitMultiValue(field.value));
    final isMultiValueField = _kMultiPreferenceFieldKeys.contains(field.key);
    if (isMultiValueField && selectedMultiValues.value.isEmpty) {
      selectedMultiValues.value = {field.value}.where((value) => value.isNotEmpty).toSet();
    }
    if (field.key == IdentityFieldKey.alcoholBrand &&
        selectedAlcoholCategories.value.isEmpty &&
        selectedMultiValues.value.isNotEmpty) {
      selectedAlcoholCategories.value = selectedMultiValues.value
          .where((value) => value != BrandCatalog.customValue)
          .map(BrandCatalog.alcoholCategoryForBrand)
          .toSet();
    }
    if (field.key == IdentityFieldKey.cigaretteBrand &&
        selectedTobaccoCategories.value.isEmpty &&
        selectedMultiValues.value.isNotEmpty) {
      selectedTobaccoCategories.value = selectedMultiValues.value
          .where((value) => value != BrandCatalog.customValue)
          .map(BrandCatalog.tobaccoCategoryForBrand)
          .toSet();
    }

    List<String>? currentOptions() {
      if (field.key == IdentityFieldKey.alcoholBrand) {
        return _brandsForAlcoholCategories(selectedAlcoholCategories.value);
      }
      if (field.key == IdentityFieldKey.cigaretteBrand) {
        return _brandsForTobaccoCategories(selectedTobaccoCategories.value);
      }
      return BrandCatalog.valuesFor(field.key);
    }

    final options = currentOptions();
    final selectedValue = useState(
      options != null && options.contains(field.value)
          ? field.value
          : (options?.first ?? field.value),
    );

    final query = searchQuery.value.toLowerCase();
    final filteredOptions = options == null
        ? const <String>[]
        : options.where((value) => value.toLowerCase().contains(query)).toList();
    final visibleOptions = [
      ...filteredOptions,
      if (options != null && !filteredOptions.contains(BrandCatalog.customValue))
        BrandCatalog.customValue,
    ];

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        title: Text(
          'identity.editFieldTitle'.tr(namedArgs: {'label': field.label}),
          style: typography.h2,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppDimens.l),
        children: [
          if (options == null)
            TextField(
              controller: controller,
              autofocus: true,
              decoration: InputDecoration(labelText: field.label),
            )
          else if (field.key == IdentityFieldKey.adultContentOptIn)
            DropdownButtonFormField<String>(
              value: options.contains(selectedValue.value)
                  ? selectedValue.value
                  : options.first,
              decoration: InputDecoration(labelText: 'identity.valueLabel'.tr()),
              items: options
                  .map((value) => DropdownMenuItem(value: value, child: Text(value)))
                  .toList(),
              onChanged: (value) {
                if (value == null) return;
                selectedValue.value = value;
              },
            )
          else ...[
            if (field.key == IdentityFieldKey.alcoholBrand) ...[
              _IdentitySectionTitle(title: 'identity.alcoholCategoryFirst'.tr()),
              const SizedBox(height: AppDimens.xs),
              _MultiSelectList(
                options: BrandCatalog.alcoholCategories
                    .where((value) => value != BrandCatalog.customValue)
                    .toList(),
                selectedValues: selectedAlcoholCategories.value,
                onChanged: (values) {
                  selectedAlcoholCategories.value = values;
                  searchController.clear();
                  searchQuery.value = '';
                },
              ),
              const SizedBox(height: AppDimens.s),
            ],
            if (field.key == IdentityFieldKey.cigaretteBrand) ...[
              _IdentitySectionTitle(title: 'identity.tobaccoCategoryFirst'.tr()),
              const SizedBox(height: AppDimens.xs),
              _MultiSelectList(
                options: BrandCatalog.tobaccoCategories
                    .where((value) => value != BrandCatalog.customValue)
                    .toList(),
                selectedValues: selectedTobaccoCategories.value,
                onChanged: (values) {
                  selectedTobaccoCategories.value = values;
                  searchController.clear();
                  searchQuery.value = '';
                },
              ),
              const SizedBox(height: AppDimens.s),
            ],
            TextField(
              controller: searchController,
              autofocus: true,
              decoration: InputDecoration(
                labelText: 'identity.searchValueLabel'.tr(),
                prefixIcon: const Icon(Icons.search),
              ),
                              onChanged: (value) {
                                searchQuery.value = value;
                              },
            ),
            const SizedBox(height: AppDimens.s),
            if (isMultiValueField)
              _MultiSelectList(
                options: visibleOptions,
                selectedValues: selectedMultiValues.value,
                onChanged: (values) {
                  selectedMultiValues.value = _normalizePreferenceSelection(values);
                },
                height: 220,
              )
            else
              SizedBox(
                height: 220,
                child: ListView(
                  children: visibleOptions
                      .map((value) => RadioListTile<String>(
                            value: value,
                            groupValue: selectedValue.value,
                            title: Text(value),
                            onChanged: (v) {
                              if (v == null) return;
                              selectedValue.value = v;
                            },
                          ))
                      .toList(),
                ),
              ),
            if ((isMultiValueField &&
                    selectedMultiValues.value.contains(BrandCatalog.customValue)) ||
                (!isMultiValueField &&
                    selectedValue.value == BrandCatalog.customValue)) ...[
              const SizedBox(height: AppDimens.s),
              TextField(
                controller: customValueController,
                decoration: InputDecoration(labelText: 'identity.customValueLabel'.tr()),
              ),
            ],
          ],
          const SizedBox(height: AppDimens.l),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: colors.buttonFill,
              foregroundColor: colors.buttonFilledText,
            ),
            onPressed: () {
              final value = options == null
                  ? controller.text.trim()
                  : isMultiValueField
                      ? _joinMultiValue(_normalizePreferenceSelection(
                          selectedMultiValues.value.map((item) {
                            if (item == BrandCatalog.customValue) {
                              return customValueController.text.trim();
                            }
                            return item;
                          }).where((item) => item.isNotEmpty).toSet(),
                        ))
                      : (selectedValue.value == BrandCatalog.customValue
                          ? customValueController.text.trim()
                          : selectedValue.value);
              if (value.isEmpty) return;
              onEdit?.call(value);
              Navigator.of(context).pop();
            },
            child: Text(LocaleKeys.identity_fieldEditSave.tr()),
          ),
        ],
      ),
    );
  }
}

class _IdentitySectionTitle extends HookWidget {
  final String title;

  const _IdentitySectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    final colors = useAppThemeColors();
    final typography = useAppTypography();
    return Text(
      title,
      style: typography.info2.copyWith(
        color: colors.labelText,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _ToggleOption {
  final String value;
  final String label;

  const _ToggleOption({
    required this.value,
    required this.label,
  });
}

class _LogPassToggleGroup extends HookWidget {
  final List<_ToggleOption> options;
  final String selectedValue;
  final ValueChanged<String> onChanged;

  const _LogPassToggleGroup({
    required this.options,
    required this.selectedValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = useAppThemeColors();
    final typography = useAppTypography();
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.zero,
        border: Border.all(color: colors.dividerMedium),
      ),
      child: Row(
        children: options.asMap().entries.map((entry) {
          final index = entry.key;
          final option = entry.value;
          final selected = option.value == selectedValue;
          return Expanded(
            child: InkWell(
              onTap: () => onChanged(option.value),
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: selected ? colors.buttonFill : colors.background,
                  borderRadius: BorderRadius.zero,
                  border: index == 0
                      ? null
                      : Border(
                          left: BorderSide(
                            color: colors.dividerMedium,
                          ),
                        ),
                ),
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  option.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: typography.info2.copyWith(
                    color: selected ? colors.buttonFilledText : colors.text,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _MultiSelectList extends HookWidget {
  final List<String> options;
  final Set<String> selectedValues;
  final ValueChanged<Set<String>> onChanged;
  final double height;

  const _MultiSelectList({
    required this.options,
    required this.selectedValues,
    required this.onChanged,
    this.height = 200,
  });

  @override
  Widget build(BuildContext context) {
    final colors = useAppThemeColors();
    return SizedBox(
      height: height,
      child: ListView(
        children: options
            .map((value) => CheckboxListTile(
                  dense: true,
                  value: selectedValues.contains(value),
                  title: Text(value),
                  controlAffinity: ListTileControlAffinity.leading,
                  checkColor: colors.buttonFilledText,
                  activeColor: colors.buttonFill,
                  onChanged: (checked) {
                    final next = {...selectedValues};
                    if (checked == true) {
                      next.add(value);
                    } else {
                      next.remove(value);
                    }
                    onChanged(next);
                  },
                ))
            .toList(),
      ),
    );
  }
}
