import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/invoice_model.dart';

class FirestoreInvoiceService {
  static final _firestore =
      FirebaseFirestore.instance;

  static final _invoiceCollection =
      _firestore.collection('invoices');

static Future<String>
    generateNextInvoiceNumber() async {

  final counterRef =
      FirebaseFirestore.instance
          .collection('counters')
          .doc('invoice_counter');

  return FirebaseFirestore.instance
      .runTransaction(
    (transaction) async {

      final snapshot =
          await transaction.get(
        counterRef,
      );

      if (!snapshot.exists) {
        throw Exception(
          'invoice_counter document not found',
        );
      }

      final currentNumber =
          (snapshot.get('lastNumber') as num)
              .toInt();

      final nextNumber =
          currentNumber + 1;

      transaction.update(
        counterRef,
        {
          'lastNumber': nextNumber,
        },
      );

      return 'INV-${nextNumber.toString().padLeft(4, '0')}';
    },
  );
}

  static Future<void> saveInvoice(
    InvoiceModel invoice,
  ) async {
    await _invoiceCollection
        .doc(invoice.invoiceId)
        .set(invoice.toMap());
  }

  static Future<void> updateInvoice(
    InvoiceModel invoice,
  ) async {
    await _invoiceCollection
        .doc(invoice.invoiceId)
        .update(invoice.toMap());
  }

  static Future<void> deleteInvoice(
    String invoiceId,
  ) async {
    await _invoiceCollection
        .doc(invoiceId)
        .delete();
  }

  static Future<void>
      clearAllInvoices() async {
    final snapshot =
        await _invoiceCollection.get();

    for (final doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }

  static Future<List<InvoiceModel>>
      getAllInvoices() async {
    final snapshot =
        await _invoiceCollection.get();

    final invoices = snapshot.docs
        .map(
          (doc) => InvoiceModel.fromMap(
            doc.data(),
          ),
        )
        .toList();

    invoices.sort(
      (a, b) {
        final aNum = int.tryParse(
              a.invoiceNumber.replaceAll(
                'INV-',
                '',
              ),
            ) ??
            0;

        final bNum = int.tryParse(
              b.invoiceNumber.replaceAll(
                'INV-',
                '',
              ),
            ) ??
            0;

        return bNum.compareTo(aNum);
      },
    );

    return invoices;
  }

  static Stream<List<InvoiceModel>>
      getInvoicesStream() {
    return _invoiceCollection
        .snapshots()
        .map(
      (snapshot) {
        final invoices = snapshot.docs
            .map(
              (doc) =>
                  InvoiceModel.fromMap(
                doc.data(),
              ),
            )
            .toList();

        invoices.sort(
          (a, b) {
            final aNum = int.tryParse(
                  a.invoiceNumber.replaceAll(
                    'INV-',
                    '',
                  ),
                ) ??
                0;

            final bNum = int.tryParse(
                  b.invoiceNumber.replaceAll(
                    'INV-',
                    '',
                  ),
                ) ??
                0;

            return bNum.compareTo(aNum);
          },
        );

        return invoices;
      },
    );
  }
}