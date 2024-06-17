import 'package:flutter/foundation.dart';

class FormFieldDropdownController<T> extends ValueNotifier<T?> {
  FormFieldDropdownController(this.initialValue, this.id) : super(initialValue);

  final T? initialValue;
  T? id;

  void reset() {
    value = null;
    id = null;
  }
}
