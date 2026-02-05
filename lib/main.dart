import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:google_fonts/google_fonts.dart';

void main() => runApp(const weatherApp());

// ignore: camel_case_types
class weatherApp extends StatelessWidget {
  const weatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(title: 'Material App', home: HomePage());
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> sehirler = [
    'Adana', 'Adıyaman', 'Afyonkarahisar', 'Ağrı', 'Aksaray', 'Amasya',
    'Ankara', 'Antalya', 'Ardahan', 'Artvin', 'Aydın', 'Balıkesir',
    'Bartın', 'Batman', 'Bayburt', 'Bilecik', 'Bingöl', 'Bitlis',
    'Bolu', 'Burdur', 'Bursa', 'Çanakkale', 'Çankırı', 'Çorum',
    'Denizli', 'Diyarbakır', 'Düzce', 'Edirne', 'Elazığ', 'Erzincan',
    'Erzurum', 'Eskişehir', 'Gaziantep', 'Giresun', 'Gümüşhane', 'Hakkari',
    'Hatay', 'Iğdır', 'Isparta', 'İstanbul', 'İzmir', 'Kahramanmaraş',
    'Karabük', 'Karaman', 'Kars', 'Kastamonu', 'Kayseri', 'Kilis',
    'Kırıkkale', 'Kırklareli', 'Kırşehir', 'Kocaeli', 'Konya', 'Kütahya',
    'Malatya', 'Manisa', 'Mardin', 'Mersin', 'Muğla', 'Muş',
    'Nevşehir', 'Niğde', 'Ordu', 'Osmaniye', 'Rize', 'Sakarya',
    'Samsun', 'Şanlıurfa', 'Siirt', 'Sinop', 'Şırnak', 'Sivas',
    'Tekirdağ', 'Tokat', 'Trabzon', 'Tunceli', 'Uşak', 'Van',
    'Yalova', 'Yozgat', 'Zonguldak',
  ];

  String? secilenSehir;
  Future<WeatherModel>? weatherFuture;

  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.openweathermap.org/data/2.5/',
      queryParameters: {
        "appid": '887f6040190d783a7998db2ff92efe71',
        "lang": 'tr',
        "units": 'metric',
      },
    ),
  );

  void selectedCity(String sehir) {
    setState(() {
      secilenSehir = sehir;
      weatherFuture = getWeather(sehir);
    });
  }

  Future<WeatherModel> getWeather(String secilenSehir) async {
    final response = await dio.get(
      'weather',
      queryParameters: {'q': secilenSehir},
    );
    var model = WeatherModel.fromJson(response.data);
    debugPrint(model.main?.temp.toString());
    return model;
  }

  Widget _buildWeatherCard(WeatherModel weatherModel) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              weatherModel.name ?? "Şehir Yok",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              "${weatherModel.main?.temp?.round()}°",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text(weatherModel.weather?.first.description ?? 'Değer Bulunamadı !'),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    const Icon(Icons.water_drop),
                    const SizedBox(height: 4),
                    Text(weatherModel.main?.humidity?.round().toString() ?? "-"),
                  ],
                ),
                const SizedBox(width: 32),
                Column(
                  children: [
                    const Icon(Icons.air),
                    const SizedBox(height: 4),
                    Text(weatherModel.wind?.speed?.round().toString() ?? "-"),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Weather App')),
      backgroundColor: const Color.fromARGB(255, 250, 249, 249),
      body: Column(
        children: [
          if (weatherFuture != null)
            FutureBuilder(
              future: weatherFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                }
                if (snapshot.hasData) {
                  return _buildWeatherCard(snapshot.data!);
                }
                return const SizedBox();
              },
            ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: 12,
                crossAxisCount: 2,
                mainAxisSpacing: 12,
              ),
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () => selectedCity(sehirler[index]),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(
                            255,
                            206,
                            206,
                            206,
                          // ignore: deprecated_member_use
                          ).withOpacity(0.5),
                          spreadRadius: 3,
                          blurRadius: 5,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        sehirler[index],
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                );
              },
              itemCount: sehirler.length,
            ),
          ),
        ],
      ),
    );
  }
}