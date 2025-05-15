import 'package:blood_plus/core/constants/app_colors.dart';
import 'package:blood_plus/core/localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class InformationScreen extends StatefulWidget {
  const InformationScreen({Key? key}) : super(key: key);

  @override
  State<InformationScreen> createState() => _InformationScreenState();
}

class _InformationScreenState extends State<InformationScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, String>> emergencyNumbers = [
    {'name': 'Holy Family Red Crescent', 'number': '16226'},
    {'name': 'Bangladesh Red Crescent Blood Bank', 'number': '01811-458537'},
    {'name': 'Quantum Blood Bank', 'number': '01714-010869'},
    {'name': 'Shandhani, DMC', 'number': '01819284878'},
    {'name': 'Police Blood Bank', 'number': '01320-037333'},
    {'name': 'Bangladesh Blood Bank', 'number': '01850-077185'},
  ];

  final List<Map<String, String>> donateHospitals = [
    {
      'name': 'BIRDEM General Hospital',
      'address': 'Eskaton Garden Road',
      'phone': '(+88) 02 55165760-94',
    },
    {
      'name': 'BSMMU',
      'address': 'Shahbag, Dhaka',
      'phone': '(+88) 02 55165760-94',
    },
    {
      'name': 'Dhaka Medical College',
      'address': 'Secretariat Rd, Dhaka - 1000',
      'phone': '+880775016984',
    },
    {
      'name': 'Evercare Hospital',
      'address': 'Bashundhara R/A, Dhaka - 1229',
      'phone': '+8809666-710678',
    },
    {
      'name': 'Kurmitola General Hospital',
      'address': 'Tongi Diversion Rd, Dhaka - 1229',
      'phone': '+880255062388',
    },
    {
      'name': 'Square Hospital',
      'address': 'Panthapath, Dhaka - 1205',
      'phone': '+8809610-010616',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).translate('cannot_make_call')),
          backgroundColor: AppColors.darkRed,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          localizations.translate('information'),
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            color: AppColors.black,
            fontSize: 20,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: AppColors.black),
            onPressed: () {},
          ),
        ],
        backgroundColor: AppColors.white,
        elevation: 2,
        shadowColor: Colors.grey.withOpacity(0.2),
      ),
      body: Column(
        children: [
          // Custom TabBar
          Container(
            color: AppColors.white,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: TabBar(
              controller: _tabController,
              labelStyle: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 14, // Reduced font size
              ),
              unselectedLabelStyle: GoogleFonts.poppins(
                fontWeight: FontWeight.w400,
                fontSize: 14,
              ),
              indicator: BoxDecoration(
                color: AppColors.primaryRed,
                borderRadius: BorderRadius.circular(20),
              ),
              labelColor: AppColors.white,
              unselectedLabelColor: AppColors.black.withOpacity(0.6),
              labelPadding: const EdgeInsets.symmetric(horizontal: 8),
              tabs: [
                Tab(text: localizations.translate('emergency_number_hotline')),
                Tab(text: localizations.translate('donate_blood')),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildEmergencyTab(localizations),
                _buildDonateTab(localizations),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyTab(AppLocalizations localizations) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Bar
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: localizations.translate('search'),
              hintStyle: GoogleFonts.poppins(color: Colors.grey[500]),
              prefixIcon: const Icon(Icons.search, color: AppColors.primaryRed),
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            ),
            style: GoogleFonts.poppins(fontSize: 16),
            onChanged: (value) => setState(() {}),
          ),
          const SizedBox(height: 16),
          // Section Header
          Text(
            localizations.translate('emergency_contacts'),
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.black,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              physics: const ClampingScrollPhysics(),
              itemCount: emergencyNumbers.length,
              itemBuilder: (context, index) {
                final emergency = emergencyNumbers[index];
                if (_searchController.text.isNotEmpty &&
                    !emergency['name']!
                        .toLowerCase()
                        .contains(_searchController.text.toLowerCase())) {
                  return const SizedBox.shrink();
                }
                return FadeTransition(
                  opacity: CurvedAnimation(
                    parent: AlwaysStoppedAnimation(1.0),
                    curve: Curves.easeIn,
                  ),
                  child: _buildEmergencyCard(emergency, localizations),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDonateTab(AppLocalizations localizations) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Bar
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: localizations.translate('search'),
              hintStyle: GoogleFonts.poppins(color: Colors.grey[500]),
              prefixIcon: const Icon(Icons.search, color: AppColors.primaryRed),
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            ),
            style: GoogleFonts.poppins(fontSize: 16),
            onChanged: (value) => setState(() {}),
          ),
          const SizedBox(height: 16),
          // Section Header
          Text(
            localizations.translate('donation_centers'),
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.black,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              physics: const ClampingScrollPhysics(),
              itemCount: donateHospitals.length,
              itemBuilder: (context, index) {
                final hospital = donateHospitals[index];
                if (_searchController.text.isNotEmpty &&
                    !hospital['name']!
                        .toLowerCase()
                        .contains(_searchController.text.toLowerCase())) {
                  return const SizedBox.shrink();
                }
                return FadeTransition(
                  opacity: CurvedAnimation(
                    parent: AlwaysStoppedAnimation(1.0),
                    curve: Curves.easeIn,
                  ),
                  child: _buildHospitalCard(hospital, localizations),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyCard(Map<String, String> emergency, AppLocalizations localizations) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.only(bottom: 12),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
            colors: [
              AppColors.white,
              Colors.grey[50]!,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListTile(
          leading: CircleAvatar(
            radius: 20, // Reduced size
            backgroundColor: AppColors.primaryRed.withOpacity(0.1),
            child: const Icon(
              Icons.local_hospital,
              color: AppColors.primaryRed,
              size: 24,
            ),
          ),
          title: Text(
            emergency['name']!,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 15, // Reduced font size
              color: AppColors.black,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            emergency['number']!,
            style: GoogleFonts.poppins(
              color: Colors.grey[600],
              fontSize: 13, // Reduced font size
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: IconButton(
            icon: const Icon(Icons.call, color: Colors.green, size: 22), // Reduced size
            onPressed: () => _makePhoneCall(emergency['number']!),
            constraints: const BoxConstraints(), // Remove default padding
            padding: EdgeInsets.zero,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          dense: true, // Reduce vertical spacing
        ),
      ),
    );
  }

  Widget _buildHospitalCard(Map<String, String> hospital, AppLocalizations localizations) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.only(bottom: 12),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
            colors: [
              AppColors.white,
              Colors.grey[50]!,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListTile(
          leading: CircleAvatar(
            radius: 20, // Reduced size
            backgroundColor: AppColors.blue.withOpacity(0.1),
            child: const Icon(
              Icons.local_hospital,
              color: AppColors.blue,
              size: 24,
            ),
          ),
          title: Text(
            hospital['name']!,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 15, // Reduced font size
              color: AppColors.black,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                hospital['address']!,
                style: GoogleFonts.poppins(
                  color: Colors.grey[600],
                  fontSize: 13, // Reduced font size
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (hospital['phone'] != null)
                Row(
                  children: [
                    const Icon(Icons.phone, color: Colors.grey, size: 12),
                    const SizedBox(width: 4),
                    Flexible( // Wrap phone number in Flexible
                      child: Text(
                        hospital['phone']!,
                        style: GoogleFonts.poppins(
                          color: Colors.grey[600],
                          fontSize: 13,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.location_on, color: AppColors.blue, size: 22),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(localizations.translate('location_not_implemented')),
                      backgroundColor: AppColors.darkRed,
                      behavior: SnackBarBehavior.floating,
                      margin: const EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  );
                },
                constraints: const BoxConstraints(),
                padding: EdgeInsets.zero,
              ),
              IconButton(
                icon: const Icon(Icons.call, color: Colors.green, size: 22),
                onPressed: () => _makePhoneCall(hospital['phone']!),
                constraints: const BoxConstraints(),
                padding: EdgeInsets.zero,
              ),
            ],
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          dense: true, // Reduce vertical spacing
        ),
      ),
    );
  }
}