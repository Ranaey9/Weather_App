
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather_app/constants/city_data.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/services/weather_service.dart';
import 'package:weather_app/widgets/weather_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  final WeatherService _weatherService = WeatherService();
  
  String? secilenSehir;
  Future<WeatherModel>? weatherFuture;

  void _searchFromBar() {
    if (_searchController.text.isNotEmpty) {
      _fetchWeather(_searchController.text);
      FocusScope.of(context).unfocus();
    }
  }

  void _selectFromGrid(String sehir) {
    _searchController.text = sehir;
    _fetchWeather(sehir);
  }

  void _fetchWeather(String sehir) {
    setState(() {
      secilenSehir = sehir;
      weatherFuture = _weatherService.getWeather(sehir);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Hava Durumu',
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600, color: const Color(0xFF1E293B)),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          // --- Arama Çubuğu ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                onSubmitted: (value) => _searchFromBar(),
                decoration: InputDecoration(
                  hintText: "Şehir Ara...",
                  hintStyle: GoogleFonts.poppins(color: Colors.grey[400]),
                  border: InputBorder.none,
                  prefixIcon: const Icon(Icons.search, color: Colors.blueAccent),
                  contentPadding: const EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
          ),

          // --- Sonuç Gösterim Alanı (FutureBuilder) ---
          if (weatherFuture != null)
            FutureBuilder(
              future: weatherFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.all(30.0),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                if (snapshot.hasError) {
                  return Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text("Şehir bulunamadı!",
                        style: GoogleFonts.poppins(color: Colors.red)),
                  );
                }
                if (snapshot.hasData) {
                  return WeatherCard(weatherModel: snapshot.data!);
                }
                return const SizedBox();
              },
            ),

          // --- "Tüm Şehirler" Başlığı ---
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Tüm Şehirler",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
              ),
            ),
          ),

          // --- Şehirler Grid Listesi ---
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: 10,
                crossAxisCount: 3,
                mainAxisSpacing: 10,
                childAspectRatio: 2.0,
              ),
              // Burada oluşturduğumuz CityData.sehirler listesini kullanıyoruz
              itemCount: CityData.sehirler.length,
              itemBuilder: (BuildContext context, int index) {
                final String currentCity = CityData.sehirler[index];
                final bool isSelected = currentCity == secilenSehir;
                
                return GestureDetector(
                  onTap: () => _selectFromGrid(currentCity),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.blueAccent : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: isSelected ? null : Border.all(color: Colors.grey.shade200),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        currentCity,
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                          color: isSelected ? Colors.white : Colors.black87,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

