import 'package:get/get.dart';
import '../models/photo.dart';
import '../repositories/photos_repository.dart';

class PhotosController extends GetxController {
  final PhotosRepository repository;
  PhotosController({required this.repository});

  var photos = <Photo>[].obs;
  var isLoading = false.obs;
  var hasReachedMax = false.obs;

  int _page = 1;
  final int _limit = 20;

  @override
  void onInit() {
    super.onInit();
    fetchPhotos();
  }

  Future<void> fetchPhotos() async {
    if (isLoading.value || hasReachedMax.value) return;

    isLoading.value = true;
    try {
      final newPhotos = await repository.fetchPhotos(page: _page, limit: _limit);

      if (newPhotos.isEmpty) {
        hasReachedMax.value = true;
      } else {
        photos.addAll(newPhotos);
        _page++;
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to load photos: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
