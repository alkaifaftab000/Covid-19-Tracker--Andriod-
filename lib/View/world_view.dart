import 'package:covid_19_tracker/Model/all_model.dart';
import 'package:covid_19_tracker/View/country_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:google_fonts/google_fonts.dart'; // Import GoogleFonts
import '../Utils/state_services.dart';

class WorldView extends StatefulWidget {
  const WorldView({super.key});

  @override
  State<WorldView> createState() => _WorldViewState();
}

class _WorldViewState extends State<WorldView> with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 3),
    vsync: this,
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  final colorList = <Color>[
    const Color(0xFF6366F1), // Indigo
    const Color(0xFF34D399), // Emerald
    const Color(0xFFF87171), // Red
  ];

  @override
  Widget build(BuildContext context) {
    StateServices _state = StateServices();
    final ss = MediaQuery.of(context).size;
    final isWeb = ss.width > 600;

    return Scaffold(
      backgroundColor: Colors.grey.shade800,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade800,
        elevation: 0,
        title: Text(
          'COVID-19 Dashboard',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: _state.fetchWorld(),
        builder: (context, AsyncSnapshot<AllModel> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: SpinKitPulse(
                color: Colors.white,
                size: 50.0,
                controller: _controller,
              ),
            );
          }
          return SafeArea(
            child: Padding(
              padding: EdgeInsets.all(isWeb ? 24.0 : 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    color: Colors.grey.shade900,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                            'Global Statistics',
                            style: GoogleFonts.poppins(
                              color: Colors.grey.shade100,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Last Updated: ${DateTime.now().toString().substring(0, 10)}',
                            style: GoogleFonts.poppins(
                              color: Colors.grey.shade400,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return isWeb
                            ? buildWebLayout(snapshot.data!, constraints)
                            : buildMobileLayout(snapshot.data!, constraints);
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Countrylist(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade500,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.public),
                        const SizedBox(width: 8),
                        Text(
                          'View Countries',
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildWebLayout(AllModel data, BoxConstraints constraints) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: buildStatsGrid(data),
        ),
        const SizedBox(width: 24),
        Expanded(
          flex: 2,
          child: buildPieChartCard(data, constraints.maxWidth * 0.25),
        ),
      ],
    );
  }

  Widget buildMobileLayout(AllModel data, BoxConstraints constraints) {
    return SingleChildScrollView(
      child: Column(
        children: [
          buildPieChartCard(data, constraints.maxWidth * 0.7),
          const SizedBox(height: 16),
          buildStatsGrid(data),
        ],
      ),
    );
  }

  Widget buildStatsGrid(AllModel data) {
    return GridView.count(
      crossAxisCount: 2,
      childAspectRatio: 1.5,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        buildStatCard('Total Cases', data.cases.toString(), Icons.coronavirus,
            const Color(0xFF6366F1)),
        buildStatCard('Deaths', data.deaths.toString(), Icons.dangerous,
            const Color(0xFFF87171)),
        buildStatCard('Recovered', data.recovered.toString(), Icons.healing,
            const Color(0xFF34D399)),
        buildStatCard('Active', data.active.toString(), Icons.sick,
            const Color(0xFFFCD34D)),
        buildStatCard('Critical', data.critical.toString(), Icons.emergency,
            const Color(0xFFEC4899)),
        buildStatCard('Today Recovered', data.todayRecovered.toString(),
            Icons.trending_up, const Color(0xFF14B8A6)),
      ],
    );
  }

  Widget buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      color: Colors.grey.shade900,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              title,
              style: GoogleFonts.poppins(
                color: Colors.grey.shade300,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                value,
                style: GoogleFonts.poppins(
                  color: Colors.grey.shade100,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPieChartCard(AllModel data, double chartSize) {
    return Card(
      color: Colors.grey.shade900,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Case Distribution',
              style: GoogleFonts.poppins(
                color: Colors.grey.shade100,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            PieChart(
              dataMap: {
                'Total': double.parse(data.cases.toString()),
                'Recovered': double.parse(data.recovered.toString()),
                'Deaths': double.parse(data.deaths.toString()),
              },
              chartType: ChartType.ring,
              colorList: colorList,
              chartRadius: chartSize,
              centerText: "COVID-19\nStats",
              chartValuesOptions: const ChartValuesOptions(
                showChartValuesInPercentage: true,
                showChartValuesOutside: true,
                decimalPlaces: 1,
              ),
              legendOptions: LegendOptions(
                legendPosition: LegendPosition.bottom,
                legendTextStyle: GoogleFonts.poppins(
                  color: Colors.grey.shade300,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
