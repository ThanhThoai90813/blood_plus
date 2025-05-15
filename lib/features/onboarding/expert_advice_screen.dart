import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/localization.dart';

class ExpertAdviceScreen extends StatelessWidget {
  const ExpertAdviceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context);
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: Colors.grey[100], // A softer background
      appBar: AppBar(
        backgroundColor: AppColors.primaryRed,
        elevation: 2, // Add a subtle shadow
        title: Text(
          localizations.translate('expert_advice'),
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white), // Use iOS style back arrow
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView( // Use SingleChildScrollView for better scroll handling
        padding: EdgeInsets.fromLTRB(16, 16, 16, statusBarHeight + 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              title: localizations.translate('before_donation'),
              subtitle: localizations.translate('before_donation_subtitle'),
              children: [
                _TipCard(
                  title: localizations.translate('tip_hydrate'),
                  description: localizations.translate('tip_hydrate_desc'),
                  image: 'assets/images/banner.jpg',
                ),
                const SizedBox(height: 12),
                _TipCard(
                  title: localizations.translate('tip_sleep'),
                  description: localizations.translate('tip_sleep_desc'),
                  image: 'assets/images/news1.jpg',
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildSection(
              title: localizations.translate('eat_before_donation'),
              subtitle: localizations.translate('eat_before_donation_subtitle'),
              children: [
                _TipCard(
                  title: localizations.translate('tip_eat_iron'),
                  description: localizations.translate('tip_eat_iron_desc'),
                  image: 'assets/images/profile.jpg',
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildSection(
              title: localizations.translate('after_donation'),
              subtitle: localizations.translate('after_donation_subtitle'),
              children: [
                _TipCard(
                  title: localizations.translate('tip_rest'),
                  description: localizations.translate('tip_rest_desc'),
                  image: 'assets/images/news2.jpg',
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildSection(
              title: localizations.translate('information'),
              subtitle: 'Learn about our partnered medical centers for blood donation.',
              children: [
                _MedicalFacilityCard(
                  name: 'Chợ Rẫy Hospital',
                  address: '201B Nguyễn Chí Thanh, District 5, HCM',
                  image: 'assets/images/news1.jpg',
                ),
                const SizedBox(height: 12),
                _MedicalFacilityCard(
                  name: 'Blood Transfusion Center',
                  address: '118 Hồng Bàng, District 5, HCM',
                  image: 'assets/images/news1.jpg',
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required String subtitle,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: GoogleFonts.poppins(
            fontSize: 17,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 16),
        ...children,
      ],
    );
  }
}

class _TipCard extends StatelessWidget {
  final String title;
  final String description;
  final String image;

  const _TipCard({
    required this.title,
    required this.description,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12), // Slightly less rounded
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3), // Softer shadow
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center, // Align items vertically in the center
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0), // Add some padding around the image
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10), // Slightly rounded image
              child: Image.asset(
                image,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoSizeText(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w500, // Slightly lighter bold
                      color: AppColors.black,
                    ),
                    maxLines: 1,
                  ),
                  const SizedBox(height: 8),
                  AutoSizeText(
                    description,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      color: Colors.grey[800],
                      height: 1.4, // Improve line spacing
                    ),
                    maxLines: 3,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MedicalFacilityCard extends StatelessWidget {
  final String name;
  final String address;
  final String image;

  const _MedicalFacilityCard({
    required this.name,
    required this.address,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4, // Slightly stronger elevation
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.asset(
              image,
              height: 140, // Adjust image height
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16), // More padding inside
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, color: Colors.grey, size: 16),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        address,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}