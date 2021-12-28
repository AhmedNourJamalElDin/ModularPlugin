import 'package:analyzer/dart/element/element.dart';
import 'package:modular_generator/utils.dart';

class ModuleValidator {
  final ClassElement klass;

  const ModuleValidator(this.klass);

  void validate() {
    throwIf(klass.isAbstract, 'The class must not be abstract', element: klass);
    throwIf(klass.isMixin, 'The class must not be a mixin', element: klass);
    throwIf(klass.isEnum, 'The class must not be an enum', element: klass);

    var doesImplementModule = klass.allSupertypes.any((interfaceType) => interfaceType.element.name == 'Module');
    throwIf(!doesImplementModule, 'The class must implement Module class', element: klass);
    throwIf(klass.getMethod('boot') == null, 'The class must have boot method', element: klass);
  }
}