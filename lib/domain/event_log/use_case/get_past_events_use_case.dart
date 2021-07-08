import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/event_log/past_event.dart';
import 'package:logpass_me/domain/incoming_actions/action_type.dart';

@injectable
class GetPastEventsUseCase {
  Future<List<PastEvent>> call() => Future.delayed(
        const Duration(seconds: 2),
        () => [
          PastEvent(
            serviceName: 'Facebook',
            logo:
                'https://mpng.subpng.com/20180328/ipq/kisspng-facebook-computer-icons-logo-facebook-icon-5abb9662cb8620.5532824215222431708336.jpg',
            actionType: ActionType.confirm(),
            dateTime: DateTime(2021),
          ),
          PastEvent(
            serviceName: 'Facebook',
            logo:
                'https://mpng.subpng.com/20180328/ipq/kisspng-facebook-computer-icons-logo-facebook-icon-5abb9662cb8620.5532824215222431708336.jpg',
            actionType: ActionType.authorize(),
            dateTime: DateTime(2020),
          ),
          PastEvent(
            serviceName: 'Facebook',
            logo:
                'https://mpng.subpng.com/20180328/ipq/kisspng-facebook-computer-icons-logo-facebook-icon-5abb9662cb8620.5532824215222431708336.jpg',
            actionType: ActionType.updateAccount(),
            dateTime: DateTime(2019),
          ),
        ],
      );
}
