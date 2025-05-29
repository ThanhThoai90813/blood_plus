import 'package:blood_plus/core/constants/app_colors.dart';
import 'package:blood_plus/core/language_helper/localization.dart';
import 'package:blood_plus/data/manager/user_manager.dart';
import 'package:blood_plus/data/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'campaign_card.dart';
import 'progress_circle.dart';

class HeaderSection extends StatefulWidget {
  @override
  _HeaderSectionState createState() => _HeaderSectionState();
}

class _HeaderSectionState extends State<HeaderSection>
    with SingleTickerProviderStateMixin {
  final UserManager _userManager = UserManager();
  UserModel? _user;
  late AnimationController _shimmerController;
  late Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
    _shimmerAnimation = Tween<double>(begin: -1.0, end: 1.0).animate(
      CurvedAnimation(parent: _shimmerController, curve: Curves.easeInOut),
    );
    _loadUserInfo();
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  Future<void> _loadUserInfo() async {
    final userId = await _userManager.getUserId();
    if (userId != null) {
      final user = await _userManager.getUserInfo(userId);
      if (user != null) {
        setState(() {
          _user = user;
        });
      }
    }
  }

  String _truncateAddress(String? address, int maxLength) {
    if (address == null) return 'Loading...';
    if (address.length <= maxLength) return address;
    return '${address.substring(0, maxLength - 3)}...';
  }

  Widget _buildLoadingShimmer() {
    return AnimatedBuilder(
      animation: _shimmerAnimation,
      builder: (context, child) {
        return Container(
          width: 74,
          height: 74,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.1),
                Colors.white.withOpacity(0.3),
                Colors.white.withOpacity(0.1),
              ],
              stops: [
                0.0,
                _shimmerAnimation.value,
                1.0,
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final AppLocalizations localizations = AppLocalizations.of(context);

    return Container(
      padding: EdgeInsets.fromLTRB(24, statusBarHeight + 24, 24, 32),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryRed,
            Color(0xFFE53E3E),
            Color(0xFFD53F41),
          ],
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 15,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Hero(
                tag: 'profile_image',
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: _user?.userImage != null
                        ? FadeInImage(
                      placeholder: const AssetImage('assets/images/profile.jpg'),
                      image: _user!.userImage!.startsWith('http')
                          ? NetworkImage(_user!.userImage!)
                          : const AssetImage('assets/images/profile.jpg') as ImageProvider,
                      width: 74,
                      height: 74,
                      fit: BoxFit.cover,
                      imageErrorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          'assets/images/profile.jpg',
                          width: 74,
                          height: 74,
                          fit: BoxFit.cover,
                        );
                      },
                    )
                        : _buildLoadingShimmer(),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _user?.name ?? 'Loading...',
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        height: 1.2,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: Colors.white70,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            _truncateAddress(_user?.address, 25),
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.white70,
                              fontWeight: FontWeight.w400,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.notifications_outlined,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: CampaignCard(
                  title: localizations.translate('donation_times'),
                  subtitle: (_user?.donationCount ?? 0).toString(),
                  image: 'assets/images/blood.png',
                  color: Colors.orange,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ProgressCircle(
                  daysLeft: 40,
                  totalDays: 90,
                  label: localizations.translate('days_left'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}