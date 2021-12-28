import 'package:modular/boot/boot_provider.dart';

class BootProviderRegistrar {
  final _providers = <BootProvider>[];

  void addBootProvider(BootProvider provider) {
    _providers.add(provider);
  }

  Future<void> boot() async {
    for (var provider in _providers) {
      await provider.boot();
    }
  }
}
