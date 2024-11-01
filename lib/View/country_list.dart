import 'package:covid_19_tracker/View/detail_screen.dart';
import 'package:covid_19_tracker/View/drop_down_view.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../Utils/state_services.dart';

class Countrylist extends StatefulWidget {
  const Countrylist({Key? key}) : super(key: key);

  @override
  State createState() => _CountrylistState();
}

class _CountrylistState extends State<Countrylist> {
  final TextEditingController _searchController = TextEditingController();
  final StateServices _state = StateServices();

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
            colors: [Colors.blueGrey.shade800, Colors.blueGrey.shade900],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(context, isWeb),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: ss.width * (isWeb ? 0.1 : 0.05),
                    vertical: ss.height * 0.02,
                  ),
                  child: Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    color: Colors.blueGrey.shade700,
                    child: Padding(
                      padding: EdgeInsets.all(ss.width * 0.03),
                      child: Column(
                        children: [
                          _buildSearchField(ss),
                          SizedBox(height: ss.height * 0.02),
                          Expanded(
                            child: FutureBuilder<List<dynamic>>(
                              future: _state.countryList(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return _buildShimmerList(ss);
                                } else {
                                  return _buildCountryList(snapshot, isWeb);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
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

  Widget _buildAppBar(BuildContext context, bool isWeb) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.blueGrey.shade900,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Country Wise Detail',
            style: TextStyle(
              color: Colors.white,
              fontSize: isWeb ? 24 : 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DropDownView()),
              );
            },
            icon: const Icon(Icons.arrow_drop_down_circle_sharp,
                color: Colors.white),
            label:
                const Text('DropDown', style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField(Size ss) {
    return Container(
      height: 60,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.grey.shade800,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TextFormField(
        controller: _searchController,
        cursorColor: Colors.white,
        onChanged: (value) {
          setState(() {});
        },
        decoration: InputDecoration(
          hintText: 'Search with Country Name..',
          prefixIcon: const Icon(Icons.search, color: Colors.white),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: ss.width * 0.03,
            vertical: ss.height * 0.015,
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerList(Size ss) {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade700,
          highlightColor: Colors.grey.shade500,
          child: Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: ListTile(
              leading:
                  const CircleAvatar(radius: 25, backgroundColor: Colors.white),
              title: Container(
                  height: 20, width: ss.width * 0.7, color: Colors.white),
              subtitle: Container(
                  height: 15, width: ss.width * 0.5, color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCountryList(AsyncSnapshot<List<dynamic>> snapshot, bool isWeb) {
    return ListView.builder(
      itemCount: snapshot.data!.length,
      itemBuilder: (context, index) {
        String name = snapshot.data![index]['country'];
        if (_searchController.text.isEmpty ||
            name.toLowerCase().contains(_searchController.text.toLowerCase())) {
          return _buildCountryCard(snapshot, index, isWeb);
        } else {
          return Container();
        }
      },
    );
  }

  Widget _buildCountryCard(
      AsyncSnapshot<List<dynamic>> snapshot, int index, bool isWeb) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: Colors.blueGrey.shade600,
      elevation: 4,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailScreen(
                name: snapshot.data![index]['country'],
                image: snapshot.data![index]['countryInfo']['flag'],
                totalCases: snapshot.data![index]['cases'],
                todayRecovered: snapshot.data![index]['recovered'],
                totalDeaths: snapshot.data![index]['deaths'],
                active: snapshot.data![index]['active'],
                totalRecovered: snapshot.data![index]['todayRecovered'],
                critical: snapshot.data![index]['critical'],
                test: snapshot.data![index]['tests'],
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  snapshot.data![index]['countryInfo']['flag'],
                  height: 60,
                  width: 60,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      snapshot.data![index]['country'],
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isWeb ? 18 : 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Total Cases: ${snapshot.data![index]['cases']}',
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'One Case Per',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  Text(
                    '${snapshot.data![index]['oneCasePerPeople']} People',
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
