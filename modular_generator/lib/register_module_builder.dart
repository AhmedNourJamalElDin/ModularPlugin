import 'dart:async';
import 'dart:convert';

import 'package:build/build.dart';
import 'package:build/src/builder/build_step.dart';
import 'package:modular/modular.dart';
import 'package:modular_generator/module_validator.dart';
import 'package:source_gen/source_gen.dart';

const _registerModuleTypeChecker = TypeChecker.fromRuntime(RegisterModule);

class RegisterModuleBuilder extends Generator {
  @override
  FutureOr<String?> generate(
    LibraryReader library,
    BuildStep buildStep,
  ) async {
    var output = <Map>[];
    for (var klass in library.classes) {
      if (!_registerModuleTypeChecker.hasAnnotationOfExact(klass)) {
        continue;
      }

      ModuleValidator(klass).validate();

      final registerModule =
          _registerModuleTypeChecker.firstAnnotationOfExact(klass);
      final reader = ConstantReader(registerModule);
      final order = reader.peek('order')?.intValue;

      output.add({
        'name': klass.name,
        'uri': klass.source.uri.path,
        'order': order,
      });
    }

    return output.isEmpty ? null : jsonEncode(output);
  }
}

Builder registerModuleBuilder(BuilderOptions options) {
  return LibraryBuilder(
    RegisterModuleBuilder(),
    formatOutput: (generated) => generated.replaceAll(RegExp(r'//.*|\s'), ''),
    generatedExtension: '.modular.json',
  );
}
