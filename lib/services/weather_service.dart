
import 'package:dio/dio.dart';
import 'package:weather_app/models/weather_model.dart';

class WeatherService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.openweathermap.org/data/2.5/',
      queryParameters: {
        "appid": '887f6040190d783a7998db2ff92efe71',
        "lang": 'tr',
        "units": 'metric',
      },
    ),
  );

  Future<WeatherModel> getWeather(String city) async {
    final response = await _dio.get(
      'weather',
      queryParameters: {'q': city},
    );
    return WeatherModel.fromJson(response.data);
  }
}

