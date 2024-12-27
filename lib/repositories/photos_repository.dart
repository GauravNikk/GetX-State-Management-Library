import 'package:dio/dio.dart';
import '../models/photo.dart';

class PhotosRepository {
  final Dio _dio = Dio();

  Future<List<Photo>> fetchPhotos({required int page, required int limit}) async {
    final response = await _dio.get(
      'https://picsum.photos/v2/list',
      queryParameters: {'page': page, 'limit': limit},
    );
    return (response.data as List)
        .map((photoJson) => Photo.fromJson(photoJson))
        .toList();
  }
}
