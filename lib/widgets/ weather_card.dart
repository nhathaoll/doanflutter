import 'package:flutter/material.dart';

class WeatherCard extends StatelessWidget {
  final String cityName;
  final String temperature;
  final String weatherDescription;
  final String weatherIcon;
  final String humidity;
  final String windSpeed;

  WeatherCard({
    required this.cityName,
    required this.temperature,
    required this.weatherDescription,
    required this.weatherIcon,
    required this.humidity,
    required this.windSpeed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      margin: const EdgeInsets.all(16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                cityName,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network(
                  weatherIcon,
                  width: 80,
                  height: 80,
                ),
                const SizedBox(width: 16),
                Text(
                  temperature,
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Center(
              child: Text(
                weatherDescription,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey[600],
                ),
              ),
            ),
            const Divider(height: 30, color: Colors.grey),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoTile(
                  icon: Icons.water_drop,
                  label: "Humidity",
                  value: "$humidity%",
                ),
                _buildInfoTile(
                  icon: Icons.wind_power,
                  label: "Wind",
                  value: "$windSpeed km/h",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(icon, color: Colors.blueAccent, size: 28),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 16, color: Colors.grey[700]),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
