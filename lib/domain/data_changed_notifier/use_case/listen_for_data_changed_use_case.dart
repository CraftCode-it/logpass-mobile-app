import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/data_changed_notifier/data_changed_notifier.dart';
import 'package:logpass_me/domain/data_changed_notifier/data_changed_type.dart';

@injectable
class ListenForDataChangedUseCase {
  final DataChangedNotifier _notifier;

  ListenForDataChangedUseCase(this._notifier);

  Stream<DataChangedType> call(DataChangedType type) => _notifier.listenForType(type);
}
