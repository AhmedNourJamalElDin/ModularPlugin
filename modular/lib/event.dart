import 'package:event_bus/event_bus.dart';

final eventBus = EventBus();


void event(dynamic event) {
  eventBus.fire(event);
}
