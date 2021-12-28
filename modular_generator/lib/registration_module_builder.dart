import 'dart:convert';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:build/src/builder/build_step.dart';
import 'package:code_builder/code_builder.dart' as cb;
import 'package:dart_style/dart_style.dart';
import 'package:glob/glob.dart';
import 'package:modular/modular.dart';
import 'package:modular_generator/library_builder.dart';
import 'package:source_gen/source_gen.dart';

class RegistrationModuleBuilder
    extends GeneratorForAnnotation<RegistrationModule> {
  @override
  dynamic generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) async {
    final initializerName = annotation.read('initializerName').stringValue;

    final generateForDir = annotation
        .read('generateForDir')
        .listValue
        .map((e) => e.toStringValue());

    final dirPattern = generateForDir.length > 1
        ? '{${generateForDir.join(',')}}'
        : '${generateForDir.first}';

    final modularConfigFiles = Glob("$dirPattern/**.modular.json");
    final jsonData = <Map>[];

    await for (final id in buildStep.findAssets(modularConfigFiles)) {
      jsonData.addAll([...json.decode(await buildStep.readAsString(id))]);
    }

    final library =
        ModularLibraryBuilder(initializerName: initializerName).build(jsonData);

    final emitter = cb.DartEmitter(
      allocator: cb.Allocator.simplePrefixing(),
      orderDirectives: true,
      useNullSafetySyntax: true,
    );

    return DartFormatter().format(library.accept(emitter).toString());
  }
}

Builder registrationModuleBuilder(BuilderOptions options) {
  return LibraryBuilder(
    RegistrationModuleBuilder(),
    generatedExtension: '.module.g.dart',
  );
}
