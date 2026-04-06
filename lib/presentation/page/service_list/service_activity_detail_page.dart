import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logpass_me/core/di/di_config.dart';
import 'package:logpass_me/data/activity/activity_api_data_source.dart';
import 'package:logpass_me/domain/activity/service_activity.dart';
import 'package:logpass_me/generated/local_keys.g.dart';
import 'package:logpass_me/presentation/style/app_colors.dart';
import 'package:logpass_me/presentation/style/app_dimens.dart';
import 'package:logpass_me/presentation/style/app_typography.dart';
import 'package:logpass_me/presentation/widget/checkbox/loader.dart';

class ServiceActivityDetailPage extends HookWidget {
  final String serviceName;

  const ServiceActivityDetailPage({required this.serviceName, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = useAppThemeColors();
    final typography = useAppTypography();
    final activities = useState<List<ServiceActivity>>([]);
    final isLoading = useState(true);

    useEffect(() {
      final ds = getIt<ActivityApiDataSource>();
      ds.getActivity(service: serviceName, limit: 100).then((result) {
        activities.value = result;
        isLoading.value = false;
      }).catchError((_) {
        isLoading.value = false;
      });
      return null;
    }, const []);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.codeContainerBackground,
        iconTheme: IconThemeData(color: colors.logoSpecial),
        title: Text(
          serviceName,
          style: typography.h6.copyWith(color: colors.logoSpecial),
        ),
        elevation: 0,
      ),
      body: isLoading.value
          ? const Center(child: Loader())
          : activities.value.isEmpty
              ? Center(
                  child: Text(
                    LocaleKeys.serviceList_noActiveSessions.tr(),
                    style: typography.body1.copyWith(color: colors.secondaryText),
                  ),
                )
              : _ActivityContent(
                  activities: activities.value,
                  colors: colors,
                  typography: typography,
                ),
    );
  }
}

class _ActivityContent extends StatelessWidget {
  final List<ServiceActivity> activities;
  final AppThemeColors colors;
  final AppTypography typography;

  const _ActivityContent({
    required this.activities,
    required this.colors,
    required this.typography,
  });

  @override
  Widget build(BuildContext context) {
    final sharedDataFields = _collectUniqueSharedData(activities);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimens.l),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (sharedDataFields.isNotEmpty) ...[
            Text(
              LocaleKeys.serviceActivityDetail_sharedDataHeader.tr(),
              style: typography.h8,
            ),
            const SizedBox(height: AppDimens.m),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppDimens.m),
              decoration: BoxDecoration(
                color: colors.secondaryBackground,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: colors.dividerMedium),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: sharedDataFields.map((field) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Icon(
                          _iconForField(field),
                          size: 16,
                          color: colors.buttonFill,
                        ),
                        const SizedBox(width: AppDimens.s),
                        Text(
                          field,
                          style: typography.body2.copyWith(color: colors.text),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: AppDimens.xl),
          ],
          Text(
            LocaleKeys.serviceActivityDetail_historyHeader.tr(),
            style: typography.h8,
          ),
          const SizedBox(height: AppDimens.m),
          ...activities.map((a) => _ActivityRow(
                activity: a,
                colors: colors,
                typography: typography,
              )),
        ],
      ),
    );
  }

  List<String> _collectUniqueSharedData(List<ServiceActivity> activities) {
    final fields = <String>{};
    for (final a in activities) {
      final details = a.details;
      if (details == null) continue;
      if (details['shared_first_name'] == true ||
          details['first_name'] != null) {
        fields.add(LocaleKeys.serviceActivityDetail_fieldFirstName.tr());
      }
      if (details['shared_last_name'] == true || details['last_name'] != null) {
        fields.add(LocaleKeys.serviceActivityDetail_fieldLastName.tr());
      }
      if (details['shared_dob'] == true || details['dob'] != null) {
        fields.add(LocaleKeys.serviceActivityDetail_fieldDob.tr());
      }
      if (details['shared_pesel'] == true || details['pesel_masked'] != null) {
        fields.add(LocaleKeys.serviceActivityDetail_fieldPesel.tr());
      }
      if (details['shared_address'] == true || details['address'] != null) {
        fields.add(LocaleKeys.serviceActivityDetail_fieldAddress.tr());
      }
      // request_type as fallback signal
      final requestType = details['request_type'] as String? ??
          details['type'] as String? ?? '';
      if (requestType == 'age_18' || requestType == 'age') {
        fields.add(LocaleKeys.serviceActivityDetail_fieldAge18.tr());
      } else if (requestType == 'identity') {
        fields.add(LocaleKeys.serviceActivityDetail_fieldFirstName.tr());
        fields.add(LocaleKeys.serviceActivityDetail_fieldLastName.tr());
      }
      // status field used as verification proof type
      final status = details['status'] as String? ?? '';
      if (status == 'fulfilled' && fields.isEmpty) {
        if (a.actionType == 'age_18' || a.actionType == 'verification') {
          fields.add(LocaleKeys.serviceActivityDetail_fieldAge18.tr());
        } else if (a.actionType == 'identity') {
          fields.add(LocaleKeys.serviceActivityDetail_fieldFirstName.tr());
          fields.add(LocaleKeys.serviceActivityDetail_fieldLastName.tr());
        }
      }
    }
    return fields.toList();
  }

  IconData _iconForField(String fieldLabel) {
    if (fieldLabel.contains('18') || fieldLabel.contains('wiek') ||
        fieldLabel.contains('Age') || fieldLabel.contains('age')) {
      return Icons.cake_outlined;
    }
    if (fieldLabel.contains('PESEL') || fieldLabel.contains('pesel')) {
      return Icons.badge_outlined;
    }
    if (fieldLabel.contains('adres') || fieldLabel.contains('Address')) {
      return Icons.home_outlined;
    }
    return Icons.person_outlined;
  }
}

class _ActivityRow extends StatelessWidget {
  final ServiceActivity activity;
  final AppThemeColors colors;
  final AppTypography typography;

  const _ActivityRow({
    required this.activity,
    required this.colors,
    required this.typography,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimens.s),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: AppDimens.l,
            height: AppDimens.l,
            decoration: BoxDecoration(
              color: colors.buttonFill.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _iconForAction(activity.actionType),
              size: 16,
              color: colors.buttonFill,
            ),
          ),
          const SizedBox(width: AppDimens.m),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _labelForAction(activity.actionType),
                  style: typography.body3,
                ),
                Text(
                  _formatDate(activity.createdAt),
                  style: typography.info2.copyWith(color: colors.secondaryText),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _iconForAction(String actionType) {
    switch (actionType) {
      case 'identity':
        return Icons.person_outlined;
      case 'age_18':
      case 'verification':
        return Icons.verified_user_outlined;
      case 'login':
        return Icons.login_outlined;
      default:
        return Icons.shield_outlined;
    }
  }

  String _labelForAction(String actionType) {
    switch (actionType) {
      case 'identity':
        return LocaleKeys.home_recentActivityActionIdentity.tr();
      case 'age_18':
      case 'verification':
        return LocaleKeys.home_recentActivityActionAge.tr();
      default:
        return LocaleKeys.home_recentActivityActionVerification.tr();
    }
  }

  String _formatDate(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inDays == 0) {
      return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    }
    return '${dt.day}.${dt.month.toString().padLeft(2, '0')}.${dt.year}';
  }
}
