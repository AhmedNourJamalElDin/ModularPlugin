import 'package:modular/boot/boot_provider_registrar.dart';
import 'package:modular/event/event_provider_registrar.dart';

abstract class Module {
  BootProviderRegistrar bootProviderRegistrar;
  EventProviderRegistrar eventProviderRegistrar;

  Module(this.bootProviderRegistrar, this.eventProviderRegistrar);

  Future<void> boot();
}
