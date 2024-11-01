import 'package:covid_19_tracker/Model/all_model.dart';
import 'package:covid_19_tracker/View/country_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pie_chart/pie_chart.dart';

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
    const Color(0xff4285f4),
    const Color(0xff1aa260),
    const Color(0xffde5246),
  ];

  @override
  Widget build(BuildContext context) {
    StateServices _state = StateServices();
    final ss = MediaQuery.of(context).size;
    final isWeb = ss.width > 600;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blueGrey.shade900, Colors.black],
          ),
        ),
        child: FutureBuilder(
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
            } else {
              return SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Global COVID-19 Statistics',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            return isWeb
                                ? buildWebLayout(snapshot.data!, constraints)
                                : buildMobileLayout(
                                    snapshot.data!, constraints);
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.map, color: Colors.white),
                          label: const Text(
                            'Track Countries',
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.teal,
                              backgroundColor: Colors.tealAccent.shade700,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              minimumSize: const Size(220, 70)),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Countrylist()));
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget buildWebLayout(AllModel data, BoxConstraints constraints) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: buildInfoCard(data),
        ),
        const SizedBox(width: 20),
        Expanded(
          flex: 1,
          child: buildPieChartCard(data, constraints.maxWidth * 0.3),
        ),
      ],
    );
  }

  Widget buildMobileLayout(AllModel data, BoxConstraints constraints) {
    return SingleChildScrollView(
      child: Column(
        children: [
          buildPieChartCard(data, constraints.maxWidth * 0.6),
          const SizedBox(height: 20),
          buildInfoCard(data),
        ],
      ),
    );
  }

  Widget buildPieChartCard(AllModel data, double chartSize) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: Colors.blueGrey.shade800,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: PieChart(
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
          ),
          legendOptions: const LegendOptions(
            legendPosition: LegendPosition.bottom,
            legendTextStyle: TextStyle(color: Colors.white70),
          ),
        ),
      ),
    );
  }

  Widget buildInfoCard(AllModel data) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: Colors.blueGrey.shade700,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            buildInfoRow(
                'Total Cases', data.cases.toString(), Icons.coronavirus),
            buildInfoRow('Deaths', data.deaths.toString(), Icons.dangerous),
            buildInfoRow('Recovered', data.recovered.toString(), Icons.healing),
            buildInfoRow('Active', data.active.toString(), Icons.sick),
            buildInfoRow('Critical', data.critical.toString(), Icons.emergency),
            buildInfoRow('Today Recovered', data.todayRecovered.toString(),
                Icons.trending_up),
          ],
        ),
      ),
    );
  }

  Widget buildInfoRow(String title, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.white70, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w500),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
                color: Colors.white70, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class ReusableRow extends StatelessWidget {
  final String title;
  final String value;

  const ReusableRow({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 5, left: 10, right: 10),
        child: Column(children: [
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text(title), Text(value)])
        ]));
  }
}
