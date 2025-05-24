import 'package:blood_plus/core/constants/app_colors.dart';
import 'package:blood_plus/core/language_helper/localization.dart';
import 'package:blood_plus/core/widgets/dialog_helper.dart';
import 'package:blood_plus/data/models/donation_event_model.dart';
import 'package:blood_plus/data/services/donation_event_service.dart';
import 'package:blood_plus/presentation/features/schedule/donation_form_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart' as dp;

class DonationEventScreen extends StatefulWidget {
  const DonationEventScreen({super.key});

  @override
  State<DonationEventScreen> createState() => _DonationEventScreenState();
}

class _DonationEventScreenState extends State<DonationEventScreen> {
  final DonationEventService _donationEventService = DonationEventService();
  List<DonationEvent> _events = [];
  int _currentPage = 1;
  int _pageSize = 5;
  bool _hasNextPage = false;
  bool _isLoading = false;

  final TextEditingController _searchLocationController = TextEditingController();
  final TextEditingController _searchOrganizationController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;
  final DateTime _currentDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _fetchDonationEvents();
  }

  Future<void> _fetchDonationEvents() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _donationEventService.getDonationEvents(
        pageNumber: _currentPage,
        pageSize: _pageSize,
        location: _searchLocationController.text.isNotEmpty ? _searchLocationController.text : null,
        startDate: _startDate?.toIso8601String().split('T')[0],
        endDate: _endDate?.toIso8601String().split('T')[0],
        organization: _searchOrganizationController.text.isNotEmpty ? _searchOrganizationController.text : null,
      );

      setState(() {
        if (_currentPage == 1) {
          _events = response.items;
        } else {
          _events.addAll(response.items);
        }
        _hasNextPage = response.hasNextPage;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  void _loadMore() {
    if (_hasNextPage && !_isLoading) {
      setState(() {
        _currentPage++;
      });
      _fetchDonationEvents();
    }
  }

  void _onSearchChanged() {
    setState(() {
      _currentPage = 1;
      _events.clear();
    });
    _fetchDonationEvents();
  }

  void _clearFilters() {
    setState(() {
      _searchLocationController.clear();
      _searchOrganizationController.clear();
      _startDate = null;
      _endDate = null;
      _currentPage = 1;
      _events.clear();
    });
    _fetchDonationEvents();
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final AppLocalizations localizations = AppLocalizations.of(context);
    dp.DatePicker.showDatePicker(
      context,
      showTitleActions: true,
      minTime: DateTime(2020),
      maxTime: DateTime(2030),
      onConfirm: (date) {
        if (date != _startDate) {
          setState(() {
            _startDate = date;
            _currentPage = 1;
            _events.clear();
          });
          _fetchDonationEvents();
        }
      },
      currentTime: _startDate ?? _currentDate,
      locale: dp.LocaleType.vi,
      theme: dp.DatePickerTheme(
        headerColor: AppColors.primaryRed,
        backgroundColor: AppColors.white,
        itemStyle: const TextStyle(
          color: AppColors.black,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
        doneStyle: const TextStyle(
          color: AppColors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        cancelStyle: const TextStyle(
          color: AppColors.black,
          fontSize: 16,
        ),
      ),
    );
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final AppLocalizations localizations = AppLocalizations.of(context);
    dp.DatePicker.showDatePicker(
      context,
      showTitleActions: true,
      minTime: DateTime(2020),
      maxTime: DateTime(2030),
      onConfirm: (date) {
        if (date != _endDate) {
          setState(() {
            _endDate = date;
            _currentPage = 1;
            _events.clear();
          });
          _fetchDonationEvents();
        }
      },
      currentTime: _endDate ?? _currentDate,
      locale: dp.LocaleType.vi,
      theme: dp.DatePickerTheme(
        headerColor: AppColors.primaryRed,
        backgroundColor: AppColors.white,
        itemStyle: const TextStyle(
          color: AppColors.black,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
        doneStyle: const TextStyle(
          color: AppColors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        cancelStyle: const TextStyle(
          color: AppColors.black,
          fontSize: 16,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchLocationController.dispose();
    _searchOrganizationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          localizations.translate('donation_events'),
          style: const TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.bold,
            fontFamily: 'Roboto',
          ),
        ),
        backgroundColor: AppColors.primaryRed,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Filter Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _searchLocationController,
                  onChanged: (value) => _onSearchChanged(),
                  decoration: InputDecoration(
                    hintText: localizations.translate('search_by_location'),
                    prefixIcon: const Icon(Icons.search, color: AppColors.primaryRed),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _searchOrganizationController,
                  onChanged: (value) => _onSearchChanged(),
                  decoration: InputDecoration(
                    hintText: localizations.translate('search_by_organization'),
                    prefixIcon: const Icon(Icons.business, color: AppColors.primaryRed),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _selectStartDate(context),
                        child: AbsorbPointer(
                          child: TextField(
                            controller: TextEditingController(
                              text: _startDate == null
                                  ? localizations.translate('select_start_date')
                                  : DateFormat('dd/MM/yyyy').format(_startDate!),
                            ),
                            decoration: InputDecoration(
                              hintText: localizations.translate('select_start_date'),
                              prefixIcon: const Icon(Icons.calendar_today, color: AppColors.primaryRed),
                              filled: true,
                              fillColor: Colors.grey.shade100,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _selectEndDate(context),
                        child: AbsorbPointer(
                          child: TextField(
                            controller: TextEditingController(
                              text: _endDate == null
                                  ? localizations.translate('select_end_date')
                                  : DateFormat('dd/MM/yyyy').format(_endDate!),
                            ),
                            decoration: InputDecoration(
                              hintText: localizations.translate('select_end_date'),
                              prefixIcon: const Icon(Icons.calendar_today, color: AppColors.primaryRed),
                              filled: true,
                              fillColor: Colors.grey.shade100,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 7),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: _clearFilters,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.lowerRed,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                    child: Text(
                      localizations.translate('clear_filters'),
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Event List
          Expanded(
            child: _events.isEmpty && _isLoading
                ? const Center(child: CircularProgressIndicator(color: AppColors.primaryRed))
                : _events.isEmpty
                ? Center(
              child: Text(
                localizations.translate('no_events_found'),
                style: const TextStyle(color: Colors.grey),
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: _events.length + (_hasNextPage ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _events.length) {
                  _loadMore();
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(color: AppColors.primaryRed),
                    ),
                  );
                }

                final event = _events[index];
                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  margin: const EdgeInsets.only(bottom: 16),
                  child: GestureDetector(
                    onTap: () {
                      DialogHelper.showLogoutConfirmationDialog(
                        context: context,
                        title: localizations.translate('schedule_donation'),
                        message: localizations.translate('confirm_schedule_donation'),
                        cancelButtonText: localizations.translate('cancel'),
                        confirmButtonText: localizations.translate('confirm'),
                        onConfirm: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DonationFormScreen(eventId: event.id),
                            ),
                          );
                        },
                        icon: Icons.calendar_today,
                        iconColor: AppColors.primaryRed,
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                          colors: [
                            AppColors.lowerRed.withOpacity(0.1),
                            AppColors.white,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Image.asset(
                                  'assets/images/logo.png',
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) => const Icon(
                                    Icons.bloodtype,
                                    color: AppColors.white,
                                    size: 50,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    event.title,
                                    style: const TextStyle(
                                      fontSize: 19,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.black,
                                      fontFamily: 'Roboto',
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    '${localizations.translate('location')}: ${event.location}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey.shade900,
                                    ),
                                  ),
                                  Text(
                                    '${localizations.translate('organization')}: ${event.organizationName}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey.shade900,
                                    ),
                                  ),
                                  Text(
                                    '${localizations.translate('date')}: ${event.getFormattedDate()}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey.shade900,
                                    ),
                                  ),
                                  Text(
                                    '${localizations.translate('time')}: ${event.getFormattedTime()}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey.shade900,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  LinearProgressIndicator(
                                    value: event.currentDonors / event.requiredDonors,
                                    backgroundColor: Colors.grey.shade200,
                                    valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryRed),
                                    minHeight: 7,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${localizations.translate('participants')} ${event.currentDonors} ${localizations.translate('of')} ${event.requiredDonors}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade600,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}