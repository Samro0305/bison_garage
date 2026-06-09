import 'package:flutter_riverpod/flutter_riverpod.dart';


import 'invoice_provider.dart';

class ServiceAnalytics {
final String serviceName;
final int count;
final double revenue;

const ServiceAnalytics({
required this.serviceName,
required this.count,
required this.revenue,
});
}

final topServicesProvider =
    Provider<List<ServiceAnalytics>>((ref) {
final List invoices =
ref.watch(invoiceProvider);

final Map<String, ServiceAnalytics> services =
{};

for (final invoice in invoices) {
for (final service in invoice.services) {
final name = service.serviceName.trim();

  if (name.isEmpty) continue;

  if (services.containsKey(name)) {
    final existing = services[name]!;

    services[name] = ServiceAnalytics(
      serviceName: name,
      count: existing.count + 1,
      revenue:
          existing.revenue + service.amount,
    );
  } else {
    services[name] = ServiceAnalytics(
      serviceName: name,
      count: 1,
      revenue: service.amount,
    );
  }
}

}

final List<ServiceAnalytics> sorted =
services.values.toList()
..sort(
(a, b) =>
b.revenue.compareTo(
a.revenue,
),
);

return sorted.take(5).toList();
});

final topServiceProvider =
Provider<ServiceAnalytics?>((ref) {
final services =
ref.watch(topServicesProvider);

if (services.isEmpty) {
return null;
}

return services.first;
});