import '../models/invoice_model.dart';
import 'invoice_service.dart';

class AnalyticsService {
  static List<InvoiceModel> get invoices =>
      InvoiceService.getAllInvoices();

  static double get totalRevenue {
    return invoices.fold(
      0,
      (sum, invoice) => sum + invoice.grandTotal,
    );
  }

  static double get totalGstCollected {
    return invoices.fold(
      0,
      (sum, invoice) => sum + invoice.gstAmount,
    );
  }

  static int get totalInvoices {
    return invoices.length;
  }

  static double get todayRevenue {
    final now = DateTime.now();

    return invoices
        .where(
          (invoice) =>
              invoice.createdAt.day == now.day &&
              invoice.createdAt.month == now.month &&
              invoice.createdAt.year == now.year,
        )
        .fold(
          0,
          (sum, invoice) =>
              sum + invoice.grandTotal,
        );
  }

  static double get monthlyRevenue {
    final now = DateTime.now();

    return invoices
        .where(
          (invoice) =>
              invoice.createdAt.month ==
                  now.month &&
              invoice.createdAt.year ==
                  now.year,
        )
        .fold(
          0,
          (sum, invoice) =>
              sum + invoice.grandTotal,
        );
  }
}