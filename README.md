# Modular Plugin

Some implementation of [my plugin generator](https://github.com/AhmedNourJamalElDin/my-plugin-generator) plugin.

This plugin helps you in:

1. Creating modules
2. Booting the modules
3. Having EventBus ready using `event_bus` package


## Get Started

1. Install the plugin (via GitHub)
2. Create classes that implements `Module` and annotated with `@RegisterModule()`
3. Create a function that is annotated `@RegistrationModule()`
4. Call that function in your main method or splash screen


## How It Works:

It does the following:

1. reads the source code 
2. finds all classes (**X**) annotated with @RegisterModule() and implements `Module` abstract class.
3. finds the function (**Y**) annotated with @RegistrationModule()
4. generate a `.module.g.dart` file next to the file container **Y** where it creates a function that
    1. create an instance of all **X** classes
    2. call boot methods of each of these classes ordered by `order` paramters

Now you need to call **Y** in your main method or splash screen but make sure you don't call variable initialized in the modules before calling **Y**.
