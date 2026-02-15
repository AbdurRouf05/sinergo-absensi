import 'package:get/get.dart';

class GanasManager extends GetxController {
  final isGanasActive = false.obs;
  final ganasNotes = ''.obs;

  void activateGanas(bool active) {
    isGanasActive.value = active;
    if (!active) {
      ganasNotes.value = '';
    }
  }

  bool get isValid =>
      !isGanasActive.value || ganasNotes.value.trim().length >= 5;

  String? get validationError {
    if (isGanasActive.value && ganasNotes.value.trim().length < 5) {
      return 'Deskripsi tugas minimal 5 karakter.';
    }
    return null;
  }
}
