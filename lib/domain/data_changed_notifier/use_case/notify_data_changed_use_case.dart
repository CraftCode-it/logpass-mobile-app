import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/data_changed_notifier/data_changed_notifier.dart';
import 'package:logpass_me/domain/data_changed_notifier/data_changed_type.dart';

@injectable
class NotifyDataChangedUseCase {
  final DataChangedNotifier _notifier;

  NotifyDataChangedUseCase(this._notifier);

  Future<void> call(DataChangedType type) async => _notifier.notify(type);
}
