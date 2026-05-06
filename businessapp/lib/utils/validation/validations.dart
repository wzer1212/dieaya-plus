import 'package:get/get.dart';

class Validation {
  /// Validates that the field is not empty
  static String? notEmpty(String value, String fieldKey) {
    if (value.trim().isEmpty) {
      return '${fieldKey.tr} ${'field_required'.tr}';
    }
    return null;
  }

  /// Validates that the field is a number
  static String? mustBeNumber(String value, String fieldKey) {
    if (num.tryParse(value) == null) {
      return '${fieldKey.tr} ${'must_be_number'.tr}';
    }
    return null;
  }
}
