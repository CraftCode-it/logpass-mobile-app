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
    if (state is IdentityLoaded) {
      return _IdentityBody(
        profiles: state.profiles,
        activeProfileId: state.activeProfileId,
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
  final IdentityCubit cubit;

  const _IdentityBody({
    required this.profiles,
    required this.activeProfileId,
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

    return Column(
      children: [
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
    const predefined = {'private', 'work', 'fake'};
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
            child: const Text('Usuń', style: TextStyle(color: Colors.red)),
          ),
        ],
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

class _ProfileSwitcher extends StatelessWidget {
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
                label: Text(profile.displayName),
                selected: isActive,
                onSelected: (_) => onSelect(profile.id),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _FieldTile extends HookWidget {
  final IdentityField field;
  final void Function(String newValue)? onEdit;

  const _FieldTile({required this.field, this.onEdit});

  @override
  Widget build(BuildContext context) {
    final typography = useAppTypography();

    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(field.label,
          style: typography.info2.copyWith(color: Colors.grey)),
      subtitle: Text(
        field.value.isEmpty ? '—' : field.value,
        style: typography.body1,
      ),
      trailing: field.isLocked
          ? const Icon(Icons.lock_outline, size: 16, color: Colors.grey)
          : onEdit != null
              ? IconButton(
                  icon: const Icon(Icons.edit_outlined, size: 18),
                  onPressed: () => _showEditDialog(context),
                )
              : null,
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
