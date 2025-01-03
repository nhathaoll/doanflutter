import 'package:da_fllutter/databasehelper/SessionManager.dart';
import 'package:da_fllutter/screens/loginScreen.dart';
import 'package:da_fllutter/services/%20weather_service.dart';
import 'package:da_fllutter/widgets/%20weather_card.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good morning';
    } else if (hour < 18) {
      return 'Good afternoon';
    } else {
      return 'Good evening';
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = SessionManager().currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Home',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              await SessionManager().logout();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildGreetingCard(user),
          Expanded(child: _buildWeatherSection()),
        ],
      ),
    );
  }

  Widget _buildGreetingCard(user) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
      margin: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.indigo, Colors.blueAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.indigo.withOpacity(0.3),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            Icons.person,
            color: Colors.white,
            size: 48.0,
          ),
          const SizedBox(width: 16.0),
          Expanded(
            // Thêm Expanded để giới hạn nội dung văn bản
            child: Text(
              '${_getGreeting()}, ${user?.name ?? 'User'}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis, // Cắt bớt nếu vượt quá
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherSection() {
    return FutureBuilder<Map<String, dynamic>>(
      future: fetchWeather(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          final weatherData = snapshot.data!;
          final cityName = weatherData['name'];
          final temperature =
              '${(weatherData['main']['temp'] - 273.15).toStringAsFixed(1)}°C';
          final weatherDescription = weatherData['weather'][0]['description'];
          final weatherIcon =
              'https://openweathermap.org/img/wn/${weatherData['weather'][0]['icon']}@2x.png';

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: WeatherCard(
              cityName: cityName,
              temperature: temperature,
              weatherDescription: weatherDescription,
              weatherIcon: weatherIcon,
              humidity: '${weatherData['main']['humidity']}%',
              windSpeed: '${weatherData['wind']['speed']} m/s',
            ),
          );
        } else {
          return Center(child: Text('No data available'));
        }
      },
    );
  }
}
