import 'package:flutter/material.dart';

/// Immutable snapshot captured when the job-report wizard is submitted —
/// what "Request received" and "Your booking" render from, independent of
/// the wizard controller's lifecycle. Mirrors the fields a real
/// `POST /customer/jobs` response would carry (see customer-api.yaml's
/// `Job` schema) plus a couple of UI-only extras (category icon/color,
/// mocked technician) that will come from the API once it's wired up.
class JobBookingSummary {
  const JobBookingSummary({
    required this.referenceCode,
    required this.categoryTitle,
    required this.categoryIcon,
    required this.categoryColor,
    required this.description,
    required this.addressLine,
    required this.postcode,
    required this.isEmergency,
    required this.isAsap,
    this.slotStart,
    this.slotEnd,
  });

  final String referenceCode;
  final String categoryTitle;
  final IconData categoryIcon;
  final Color categoryColor;
  final String description;
  final String addressLine;
  final String postcode;
  final bool isEmergency;
  final bool isAsap;
  final DateTime? slotStart;
  final DateTime? slotEnd;
}
