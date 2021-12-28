class RegistrationModule {
  /// Only files exist in provided directories will be processed
  final List<String> generateForDir;

  /// if true relative imports will be used where possible
  /// defaults to true
  final bool preferRelativeImports;

  /// generated initializer name
  /// defaults to $initRegistrationModule
  final String initializerName;

  /// default constructor
  const RegistrationModule({
    this.generateForDir = const ['lib'],
    this.preferRelativeImports = true,
    this.initializerName = r'$initRegistrationModule',
  });
}

/// const instance of [RegistrationModule]
/// with default arguments
const registrationModuleInit = RegistrationModule();
