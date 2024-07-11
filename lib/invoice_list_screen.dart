import 'package:flutter/material.dart';
import 'package:interview/database_controller.dart';
import 'package:sqflite/sqflite.dart';

class InvoiceListScreen extends StatelessWidget {
  const InvoiceListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: FutureBuilder<Database?>(
            future: DatabaseHelper.instance.database,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                Database database = snapshot.data!;
                return FutureBuilder(
                  future: database.query(DatabaseHelper.table),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      List<Map<String, dynamic>> data = snapshot.data!;
                      return ListView.separated(
                        padding: const EdgeInsets.all(20),
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          return Row(
                            children: [
                              Text(
                                data[index][DatabaseHelper.columnId].toString(),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      data[index]
                                          [DatabaseHelper.columnProductName],
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      data[index]
                                          [DatabaseHelper.columnExpiryDate],
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        '${data[index][DatabaseHelper.columnPrice]}\$',
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        '${data[index][DatabaseHelper.columnQuantity]} Item',
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    'total: ${data[index][DatabaseHelper.columnTotal]}',
                                  )
                                ],
                              ),
                            ],
                          );
                        },
                        separatorBuilder: (context, index) {
                          return const Divider(height: 40);
                        },
                      );
                    }
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
