import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../controllers/photos_controller.dart';
import '../repositories/photos_repository.dart';

class PhotosScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('GetX Staggered Grid')),
      body: GetBuilder<PhotosController>(
        init: PhotosController(repository: PhotosRepository()),
        builder: (controller) => PhotosList(),
      ),
    );
  }
}

class PhotosList extends StatelessWidget {
  final ScrollController _scrollController = ScrollController();

  PhotosList({Key? key}) : super(key: key) {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        Get.find<PhotosController>().fetchPhotos();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final controller = Get.find<PhotosController>();

      if (controller.photos.isEmpty && controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

       return Column(
        children: [
          Expanded(
            child: MasonryGridView.builder(
              controller: _scrollController,
              gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Number of columns
              ),
              mainAxisSpacing: 8.0,
              crossAxisSpacing: 8.0,
              itemCount: controller.photos.length,
              itemBuilder: (context, index) {
                final photo = controller.photos[index];
                return ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    photo.url,
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
          ),
          if (controller.isLoading.value && !controller.hasReachedMax.value)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
        ],
      );
    });
  }
}
