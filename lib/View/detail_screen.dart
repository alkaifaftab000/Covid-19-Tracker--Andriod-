import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailScreen extends StatefulWidget {
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
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ss = MediaQuery.of(context).size;
    final isWeb = ss.width > 600;

    return Scaffold(
      backgroundColor: Colors.grey.shade800,
      appBar: _buildAppBar(context),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: ss.width * (isWeb ? 0.1 : 0.05),
              vertical: 24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCountryHeader(ss, isWeb),
                const SizedBox(height: 24),
                _buildTotalCasesCard(ss, isWeb),
                const SizedBox(height: 24),
                _buildMainStats(ss, isWeb),
                const SizedBox(height: 24),
                _buildAdditionalStats(ss, isWeb),
              ],
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.grey.shade800,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        'Detailed View',
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 20 * 1.1,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
      systemOverlayStyle: SystemUiOverlayStyle.light,
    );
  }

  Widget _buildCountryHeader(Size ss, bool isWeb) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              widget.image,
              height: isWeb ? 120 : 80,
              width: isWeb ? 180 : 120,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.name,
                  style: GoogleFonts.poppins(
                    fontSize: (isWeb ? 28 : 24) * 1.1,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Last Updated: ${DateTime.now().toString().split('.')[0]}',
                  style: GoogleFonts.poppins(
                    fontSize: (isWeb ? 16 : 14) * 1.1,
                    color: Colors.grey.shade400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalCasesCard(Size ss, bool isWeb) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          tileMode: TileMode.decal,
          colors: [Colors.grey.shade400, Colors.grey.shade700],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.coronavirus_rounded,
                color: Colors.black,
                size: isWeb ? 28 : 24,
              ),
              const SizedBox(width: 8),
              Text(
                'Total Cases',
                style: GoogleFonts.poppins(
                  fontSize: (isWeb ? 20 : 18) * 1.1,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            widget.totalCases.toString(),
            style: GoogleFonts.poppins(
              fontSize: (isWeb ? 36 : 32) * 1.1,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainStats(Size ss, bool isWeb) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Recovered',
            widget.totalRecovered,
            Colors.green.shade600,
            ss,
            isWeb,
            Icons.health_and_safety_rounded,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            'Deaths',
            widget.totalDeaths,
            Colors.red.shade600,
            ss,
            isWeb,
            Icons.dangerous_rounded,
          ),
        ),
      ],
    );
  }

  Widget _buildAdditionalStats(Size ss, bool isWeb) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.analytics_rounded,
              color: Colors.white,
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(
              'Additional Statistics',
              style: GoogleFonts.poppins(
                fontSize: 20 * 1.1,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: isWeb ? 3 : 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: isWeb ? 1.5 : 1.3,
          children: [
            _buildStatCard(
              'Active',
              widget.active,
              Colors.orange.shade600,
              ss,
              isWeb,
              Icons.sick_rounded,
            ),
            _buildStatCard(
              'Critical',
              widget.critical,
              Colors.purple.shade600,
              ss,
              isWeb,
              Icons.emergency_rounded,
            ),
            _buildStatCard(
              'Recovered',
              widget.todayRecovered,
              Colors.teal.shade600,
              ss,
              isWeb,
              Icons.trending_up_rounded,
            ),
            _buildStatCard(
              'Tests',
              widget.test,
              Colors.blue.shade600,
              ss,
              isWeb,
              Icons.science_rounded,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(
      String title,
      int value,
      Color color,
      Size ss,
      bool isWeb,
      IconData icon,
      ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: color,
                size: isWeb ? 22 : 20,
              ),
              const SizedBox(width: 8),
              Text(
                overflow: TextOverflow.visible,
                title,
                style: GoogleFonts.poppins(
                  fontSize: (isWeb ? 18 : 16) * 1.1,
                  color: color,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value.toString(),
            style: GoogleFonts.poppins(
              fontSize: (isWeb ? 26 : 24) * 1.1,
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
