import 'package:code_builder/code_builder.dart';

const _bootProviderRegistrarImport =
    'package:modular/boot/boot_provider_registrar.dart';
const _eventProviderRegistrarImport =
    'package:modular/event/event_provider_registrar.dart';
const _eventBusImport =
    'package:modular/event.dart';

const _bootProviderRegistrar = Reference('bootProviderRegistrar');
const _eventProviderRegistrar = Reference('eventProviderRegistrar');
const _eventBus = Reference('eventBus', _eventBusImport);

class ModularLibraryBuilder {
  final String initializerName;

  ModularLibraryBuilder({
    required this.initializerName,
  });

  Library build(List<Map> jsonData) {
    jsonData.sort((item1, item2) => item1['order'] - item2['order']);

    // final eventBusInitialization = const Reference('EventBus', _eventBusImport)
    //     .newInstance([]).assignFinal('eventBus');
    final bootProviderInitialization =
        const Reference('BootProviderRegistrar', _bootProviderRegistrarImport)
            .newInstance([]).assignFinal('bootProviderRegistrar');
    final eventProviderInitialization =
        const Reference('EventProviderRegistrar', _eventProviderRegistrarImport)
            .newInstance([]).assignFinal('eventProviderRegistrar');

    final calls = <Code>[
      bootProviderInitialization.statement,
      eventProviderInitialization.statement,
    ];

    for (var item in jsonData) {
      final reference = Reference(item['name'], 'package:' + item['uri']);
      calls.add(
        reference
            .newInstance([
              _bootProviderRegistrar,
              _eventProviderRegistrar,
            ])
            .property('boot')
            .call([])
            .awaited
            .statement,
      );
    }

    calls.addAll([
      _bootProviderRegistrar.property('boot').call([]).awaited.statement,
      _eventProviderRegistrar.property('boot').call([
        _eventBus,
      ]).awaited.statement,
    ]);

    final initMethod = Method(
      (b) => b
        ..name = initializerName
        ..modifier = MethodModifier.async
        ..body = Block(
          (b) => b..statements.addAll(calls),
        )
        ..returns = TypeReference(
          (b) => b
            ..symbol = 'Future'
            ..types.add(const Reference('void')),
        ),
    );

    return Library((b) => b
      ..body.addAll([
        initMethod,
      ]));
  }
}
