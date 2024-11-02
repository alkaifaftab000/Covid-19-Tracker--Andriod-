import 'package:covid_19_tracker/View/detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import '../Utils/state_services.dart';

class Countrylist extends StatefulWidget {
  const Countrylist({super.key});

  @override
  State<Countrylist> createState() => CountrylistState();
}

class CountrylistState extends State<Countrylist> {
  final TextEditingController _searchController = TextEditingController();
  final StateServices _state = StateServices();

  @override
  Widget build(BuildContext context) {
    final ss = MediaQuery.of(context).size;
    final isWeb = ss.width > 600;

    return Scaffold(
      backgroundColor: Colors.grey.shade800,
      body: Column(
        children: [
          _buildAppBar(context, isWeb),
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(
                horizontal: ss.width * (isWeb ? 0.1 : 0.03),
                vertical: ss.height * 0.02,
              ),
              child: Column(
                children: [
                  _buildSearchField(ss),
                  SizedBox(height: ss.height * 0.02),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
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
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, bool isWeb) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade800,

      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.public,
                color: Colors.blue.shade300,
                size: isWeb ? 32 : 24),
            const SizedBox(width: 12),
            Text(
              'Global COVID-19 Tracker',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: isWeb ? 24 : 20,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField(Size ss) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: Colors.grey.shade700,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: _searchController,
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 16,
        ),
        onChanged: (value) => setState(() {}),
        decoration: InputDecoration(
          hintText: 'Search countries...',
          hintStyle: GoogleFonts.poppins(
            color: Colors.grey.shade400,
            fontSize: 16,
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: Colors.grey.shade400,
            size: 24,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerList(Size ss) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: 8,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade700,
          highlightColor: Colors.grey.shade600,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade700,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 20,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: ss.width * 0.4,
                        height: 16,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCountryList(AsyncSnapshot<List<dynamic>> snapshot, bool isWeb) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: snapshot.data!.length,
      itemBuilder: (context, index) {
        String name = snapshot.data![index]['country'];
        if (_searchController.text.isEmpty ||
            name.toLowerCase().contains(_searchController.text.toLowerCase())) {
          return _buildCountryCard(snapshot, index, isWeb);
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildCountryCard(
      AsyncSnapshot<List<dynamic>> snapshot, int index, bool isWeb) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade700,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
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
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
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
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: isWeb ? 18 : 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Total Cases: ${snapshot.data![index]['cases'].toString().replaceAllMapped(
                          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                              (Match m) => '${m[1]},',
                        )}',
                        style: GoogleFonts.poppins(
                          color: Colors.grey.shade300,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '1:${snapshot.data![index]['oneCasePerPeople']}',
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}