/// Mirrors the backend's `QuotationLineType` enum exactly (customer-api.yaml
/// / technician-api.yaml). `visitFee` carries a negative `unitPricePence` —
/// it's a credit for an evaluation visit already paid for.
enum QuotationLineType { labour, materials, callOut, visitFee, other }

class QuotationLineItem {
  const QuotationLineItem({
    required this.type,
    required this.typeLabel,
    required this.description,
    required this.quantity,
    required this.unitPricePence,
    required this.totalPence,
  });

  final QuotationLineType type;
  final String typeLabel;
  final String description;
  final double quantity;
  final int unitPricePence;
  final int totalPence;
}

enum QuotationPricingType { fixed, hourly }

/// Mirrors the backend's `QuotationVersion` schema field-for-field (see
/// customer/customer-api.yaml) so wiring this to
/// `GET /customer/jobs/{job}/quotation` later is a straight decode, not a
/// redesign.
class Quotation {
  const Quotation({
    required this.id,
    required this.number,
    required this.pricingType,
    required this.pricingTypeLabel,
    required this.isEstimate,
    required this.lineItems,
    required this.netPence,
    required this.vatPence,
    required this.totalPence,
    required this.vatRatePercent,
    this.customerNotes,
    this.sentAt,
    this.validUntil,
    this.hasExpired = false,
  });

  final int id;
  final int number;
  final QuotationPricingType pricingType;
  final String pricingTypeLabel;
  final bool isEstimate;
  final List<QuotationLineItem> lineItems;

  final int netPence;
  final int vatPence;
  final int totalPence;
  final double vatRatePercent;

  final String? customerNotes;
  final DateTime? sentAt;
  final DateTime? validUntil;

  /// Use this rather than comparing [validUntil] to now — the API works it
  /// out server-side against its own clock (see conventions.md).
  final bool hasExpired;
}
