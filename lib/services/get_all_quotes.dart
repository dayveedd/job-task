
import 'package:dio/dio.dart';
import 'package:job_task/model/quote_model.dart';

class QuoteRepository {
  final Dio dio;

  QuoteRepository(this.dio);

  Future<List<QuoteModel>> getAllQuotes() async {
    try {
      final response = await dio.get(
        '/quotes',
      );
      final data = response.data;
      final List quotesJson = data['results'];
      // for logging response
      print(response);
      return quotesJson.map((json) => QuoteModel.fromJson(json)).toList();
    } on DioException catch (e) {
      // for logging any error encountered
      print(e.error);
      print(e.response);
      // bloc goes to the error state and displays the error page for refreshing
      throw Exception('Failed to get quotes: ${e.response}');
    }
  }
}
