import 'package:event_bus/event_bus.dart';

abstract class EventProvider {
  Future<void> boot(EventBus eventBus);
}
