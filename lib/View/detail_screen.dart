import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {
  final String name;
  final String image;
  final int totalCases,
      totalRecovered,
      totalDeaths,
      active,
      critical,
      todayRecovered,
      test;

  const DetailScreen({
    Key? key,
    required this.name,
    required this.totalCases,
    required this.totalRecovered,
    required this.totalDeaths,
    required this.active,
    required this.critical,
    required this.todayRecovered,
    required this.test,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ss = MediaQuery.of(context).size;
    final isWeb = ss.width > 600;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.grey.shade900, Colors.black],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(context),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: ss.width * (isWeb ? 0.1 : 0.05),
                      vertical: ss.height * 0.02,
                    ),
                    child: Column(
                      children: [
                        _buildHeaderCard(ss, isWeb),
                        SizedBox(height: ss.height * 0.03),
                        _buildStatsCard(ss, isWeb),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.black,
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          Expanded(
            child: Text(
              name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 40), // To balance the back button
        ],
      ),
    );
  }

  Widget _buildHeaderCard(Size ss, bool isWeb) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: Colors.grey.shade800,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                image,
                height: isWeb ? ss.height * 0.2 : ss.height * 0.15,
                width: isWeb ? ss.width * 0.2 : ss.width * 0.3,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: isWeb ? 28 : 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Total Cases: $totalCases',
                    style: TextStyle(
                      fontSize: isWeb ? 18 : 16,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCard(Size ss, bool isWeb) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: Colors.grey.shade800,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'Detailed Statistics',
              style: TextStyle(
                fontSize: isWeb ? 24 : 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            _buildStatRow(
                'Total Recovered', totalRecovered, Colors.green, ss, isWeb),
            _buildStatRow('Total Deaths', totalDeaths, Colors.red, ss, isWeb),
            _buildStatRow('Active Cases', active, Colors.blue, ss, isWeb),
            _buildStatRow('Critical Cases', critical, Colors.orange, ss, isWeb),
            _buildStatRow(
                'Today Recovered', todayRecovered, Colors.teal, ss, isWeb),
            _buildStatRow('Total Tests', test, Colors.purple, ss, isWeb),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(
      String title, int value, Color color, Size ss, bool isWeb) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.5), width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: isWeb ? 18 : 16,
              fontWeight: FontWeight.w500,
              color: Colors.white70,
            ),
          ),
          Text(
            value.toString(),
            style: TextStyle(
              fontSize: isWeb ? 18 : 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
