class InvoiceNumberHelper {
  static String generate(
    int nextNumber,
  ) {
    return 'INV-${nextNumber.toString().padLeft(4, '0')}';
  }
}