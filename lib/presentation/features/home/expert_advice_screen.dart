import 'package:blood_plus/core/constants/app_colors.dart';
import 'package:blood_plus/core/language_helper/localization.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:google_fonts/google_fonts.dart';

class ExpertAdviceScreen extends StatefulWidget {
  const ExpertAdviceScreen({Key? key}) : super(key: key);

  @override
  State<ExpertAdviceScreen> createState() => _ExpertAdviceScreenState();
}

class _ExpertAdviceScreenState extends State<ExpertAdviceScreen> {
  final List<ExpansionPanelItem> _items = [
    ExpansionPanelItem(
      header: 'who_can_donate',
      subtitle: 'who_can_donate_subtitle',
      icon: Icons.person,
      children: [
        _TipCard(
          title: 'who_can_donate',
          description: 'who_can_donate_desc',
        ),
      ],
    ),
    ExpansionPanelItem(
      header: 'before_donation',
      subtitle: 'before_donation_subtitle',
      icon: Icons.local_drink,
      children: [
        _TipCard(
          title: 'tip_hydrate',
          description: 'tip_hydrate_desc',
        ),
        _TipCard(
          title: 'tip_sleep',
          description: 'tip_sleep_desc',
        ),
      ],
    ),
    ExpansionPanelItem(
      header: 'eat_before_donation',
      subtitle: 'eat_before_donation_subtitle',
      icon: Icons.restaurant,
      children: [
        _TipCard(
          title: 'tip_eat_iron',
          description: 'tip_eat_iron_desc',
        ),
      ],
    ),
    ExpansionPanelItem(
      header: 'donation_process',
      subtitle: 'donation_process_subtitle',
      icon: Icons.medical_services,
      children: [
        _TipCard(
          title: 'donation_process',
          description: 'donation_process_desc',
        ),
      ],
    ),
    ExpansionPanelItem(
      header: 'after_donation',
      subtitle: 'after_donation_subtitle',
      icon: Icons.self_improvement,
      children: [
        _TipCard(
          title: 'tip_rest',
          description: 'tip_rest_desc',
        ),
      ],
    ),
    ExpansionPanelItem(
      header: 'how_often_donate',
      subtitle: 'how_often_donate_subtitle',
      icon: Icons.calendar_today,
      children: [
        _TipCard(
          title: 'how_often_donate',
          description: 'how_often_donate_desc',
        ),
      ],
    ),
    ExpansionPanelItem(
      header: 'donation_risks',
      subtitle: 'donation_risks_subtitle',
      icon: Icons.warning,
      children: [
        _TipCard(
          title: 'donation_risks',
          description: 'donation_risks_desc',
        ),
      ],
    ),
    ExpansionPanelItem(
      header: 'my_blood',
      subtitle: 'my_blood_subtitle', // Added in JSON if needed
      icon: Icons.science,
      children: [
        _TipCard(
          title: 'my_blood',
          description: 'my_blood_desc',
        ),
      ],
    ),
    ExpansionPanelItem(
      header: 'blood_component',
      subtitle: 'blood_component_subtitle', // Added in JSON if needed
      icon: Icons.bloodtype,
      children: [
        _TipCard(
          title: 'blood_component',
          description: 'blood_component_desc',
        ),
      ],
    ),
    ExpansionPanelItem(
      header: 'why_people_need_blood',
      subtitle: 'why_people_need_blood_subtitle', // Added in JSON if needed
      icon: Icons.medical_services,
      children: [
        _TipCard(
          title: 'why_people_need_blood',
          description: 'why_people_need_blood_desc',
        ),
      ],
    ),
    ExpansionPanelItem(
      header: 'current_blood',
      subtitle: 'current_blood_subtitle', // Added in JSON if needed
      icon: Icons.bar_chart,
      children: [
        _TipCard(
          title: 'current_blood',
          description: 'current_blood_desc',
        ),
      ],
    ),
    ExpansionPanelItem(
      header: 'why_need_id',
      subtitle: 'why_need_id_subtitle', // Added in JSON if needed
      icon: Icons.badge,
      children: [
        _TipCard(
          title: 'why_need_id',
          description: 'why_need_id_desc',
        ),
      ],
    ),
    ExpansionPanelItem(
      header: 'harmful_to_health',
      subtitle: 'harmful_to_health_subtitle', // Added in JSON if needed
      icon: Icons.health_and_safety,
      children: [
        _TipCard(
          title: 'harmful_to_health',
          description: 'harmful_to_health_desc',
        ),
      ],
    ),
    ExpansionPanelItem(
      header: 'benefits_for_voluntary',
      subtitle: 'benefits_for_voluntary_subtitle', // Added in JSON if needed
      icon: Icons.card_giftcard,
      children: [
        _TipCard(
          title: 'benefits_for_voluntary',
          description: 'benefits_for_voluntary_desc',
        ),
      ],
    ),
    ExpansionPanelItem(
      header: 'can_get_infected',
      subtitle: 'can_get_infected_subtitle', // Added in JSON if needed
      icon: Icons.shield,
      children: [
        _TipCard(
          title: 'can_get_infected',
          description: 'can_get_infected_desc',
        ),
      ],
    ),
    ExpansionPanelItem(
      header: 'prepare',
      subtitle: 'prepare_subtitle', // Added in JSON if needed
      icon: Icons.checklist,
      children: [
        _TipCard(
          title: 'prepare',
          description: 'prepare_desc',
        ),
      ],
    ),
    ExpansionPanelItem(
      header: 'delayed_blood_donation',
      subtitle: 'delayed_blood_donation_subtitle', // Added in JSON if needed
      icon: Icons.schedule,
      children: [
        _TipCard(
          title: 'delayed_blood_donation',
          description: 'delayed_blood_donation_desc',
        ),
      ],
    ),
    ExpansionPanelItem(
      header: 'have_covid_19',
      subtitle: 'have_covid_19_subtitle', // Added in JSON if needed
      icon: Icons.coronavirus,
      children: [
        _TipCard(
          title: 'have_covid_19',
          description: 'have_covid_19_desc',
        ),
      ],
    ),
    ExpansionPanelItem(
      header: 'feeling_unsafe',
      subtitle: 'feeling_unsafe_subtitle', // Added in JSON if needed
      icon: Icons.warning_amber,
      children: [
        _TipCard(
          title: 'feeling_unsafe',
          description: 'feeling_unsafe_desc',
        ),
      ],
    ),
    ExpansionPanelItem(
      header: 'feeling_unwell',
      subtitle: 'feeling_unwell_subtitle', // Added in JSON if needed
      icon: Icons.sick,
      children: [
        _TipCard(
          title: 'feeling_unwell',
          description: 'feeling_unwell_desc',
        ),
      ],
    ),
    ExpansionPanelItem(
      header: 'swelling_or_bruising',
      subtitle: 'swelling_or_bruising_subtitle', // Added in JSON if needed
      icon: Icons.healing,
      children: [
        _TipCard(
          title: 'swelling_or_bruising',
          description: 'swelling_or_bruising_desc',
        ),
      ],
    ),
  ];

  List<ExpansionPanelItem> _filteredItems = [];
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredItems = _items;
    _searchController.addListener(_filterItems);
  }

  void _filterItems() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredItems = _items.where((item) {
        final title = AppLocalizations.of(context).translate(item.header).toLowerCase();
        return title.contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context);
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: AppColors.primaryRed,
        elevation: 4,
        title: Text(
          localizations.translate('expert_advice'),
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 24),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(20, 20, 20, statusBarHeight + 20),
        child: Column(
          children: [
            // Tìm kiếm
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 12),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: localizations.translate('search_hint'),
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  fillColor: Colors.grey[200],
                  filled: true,
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: ExpansionPanelList(
                  expansionCallback: (int index, bool isExpanded) {
                    setState(() {
                      _filteredItems[index].isExpanded = !isExpanded;
                    });
                  },
                  children: _filteredItems.map<ExpansionPanel>((ExpansionPanelItem item) {
                    return ExpansionPanel(
                      headerBuilder: (context, isExpanded) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              item.isExpanded = !item.isExpanded;
                            });
                          },
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                            leading: Icon(item.icon, color: AppColors.primaryRed, size: 28),
                            title: ShaderMask(
                              shaderCallback: (bounds) => LinearGradient(
                                colors: [AppColors.primaryRed, AppColors.darkRed],
                              ).createShader(bounds),
                              child: Text(
                                localizations.translate(item.header),
                                style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                localizations.translate(item.subtitle),
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: Colors.grey[800],
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      body: Padding(
                        padding: const EdgeInsets.only(left: 48, top: 8, bottom: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: item.children,
                        ),
                      ),
                      isExpanded: item.isExpanded,
                      canTapOnHeader: true,
                    );
                  }).toList(),
                  dividerColor: Colors.transparent,
                  elevation: 2,
                  animationDuration: const Duration(milliseconds: 300),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ExpansionPanelItem {
  bool isExpanded;
  final String header;
  final String subtitle;
  final IconData icon;
  final List<Widget> children;

  ExpansionPanelItem({
    this.isExpanded = false,
    required this.header,
    required this.subtitle,
    required this.icon,
    required this.children,
  });
}

class _TipCard extends StatelessWidget {
  final String title;
  final String description;
  final String? image;

  const _TipCard({
    required this.title,
    required this.description,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, Colors.grey[50]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (image != null) ...[
              ClipRRect(
                borderRadius: const BorderRadius.horizontal(left: Radius.circular(15)),
                child: Image.asset(
                  image!,
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 16),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoSizeText(
                    localizations.translate(title),
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.black,
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 10),
                  AutoSizeText(
                    localizations.translate(description),
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[900],
                      height: 1.6,
                    ),
                    maxLines: 10,
                  ),
                ],
              ),
            ),
          ],
        ),
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
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, Colors.grey[100]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
            child: Image.asset(
              image,
              height: 160,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.black,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.location_on, color: Colors.grey, size: 18),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        address,
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          color: Colors.grey[800],
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