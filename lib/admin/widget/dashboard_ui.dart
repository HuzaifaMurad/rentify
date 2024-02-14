import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:rentify/core/constants/constants.dart';
import 'package:rentify/models/product.dart';

import '../../core/common/error_text.dart';
import '../../core/common/loader.dart';
import '../../features/add_product/controller/product_controller.dart';
import '../../features/rental/screens/widget/rentals_detail.dart';

class DashBoardUI extends ConsumerStatefulWidget {
  const DashBoardUI({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DashBoardUIState();
}

class _DashBoardUIState extends ConsumerState<DashBoardUI> {
  List<Map<String, dynamic>> dynamicData = [
    {
      'product': 'Shoe',
      'date': '7 February, 2024',
      'price': 'Rs 1300',
      'status': 'Active',
      'reports': '0'
    },
    {
      'product': 'Shirt',
      'date': '8 February, 2024',
      'price': 'Rs 800',
      'status': 'Inactive',
      'reports': '1'
    },
    {
      'product': 'Pants',
      'date': '9 February, 2024',
      'price': 'Rs 1500',
      'status': 'Active',
      'reports': '2'
    },
  ];
  @override
  Widget build(BuildContext context) {
    return ref.watch(renalPostsProvider).when(
          data: (data) {
            return Align(
              child: Container(
                alignment: Alignment.topLeft,
                padding: EdgeInsets.all(20.sp),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Recently Listed Products',
                      style: GoogleFonts.raleway(
                        fontSize: 25.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                    Container(
                      color: Colors.white,
                      padding: EdgeInsets.all(20.sp),
                      child: DataTable(
                        headingRowHeight: 50.sp,
                        columns: [
                          DataColumn(
                            label: Text(
                              'Product',
                              style: TextStyle(
                                  fontSize: 17.sp, fontWeight: FontWeight.bold),
                            ),
                          ),
                          DataColumn(
                              label: Text('Date',
                                  style: TextStyle(
                                      fontSize: 17.sp,
                                      fontWeight: FontWeight.bold))),
                          DataColumn(
                              label: Text('Price',
                                  style: TextStyle(
                                      fontSize: 17.sp,
                                      fontWeight: FontWeight.bold))),
                          DataColumn(
                              label: Text('Status',
                                  style: TextStyle(
                                      fontSize: 17.sp,
                                      fontWeight: FontWeight.bold))),
                          DataColumn(
                            label: Text(
                              'Reports',
                              style: TextStyle(
                                  fontSize: 17.sp, fontWeight: FontWeight.bold),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'View',
                              style: TextStyle(
                                  fontSize: 17.sp, fontWeight: FontWeight.bold),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Remove',
                              style: TextStyle(
                                  fontSize: 17.sp, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                        rows: buildRows(data,
                            ref), // Use a function to generate rows dynamically
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          error: (error, stackTrace) {
            return ErrorText(
              errorText: error.toString(),
            );
          },
          loading: () => const Loader(),
        );
  }

  List<DataRow> buildRows(List<Product> data, WidgetRef ref) {
    return data.asMap().entries.map((entry) {
      final index = entry.key + 1; // Add 1 to start the index from 1
      final row = entry.value;
      return DataRow(
        cells: [
          DataCell(
            Text(
              row.title.toString(),
              style: TextStyle(fontSize: 17.sp),
            ),
          ),
          DataCell(
            Text(
              DateFormat('d MMMM yyyy').format(row.postedDate!),
              style: TextStyle(fontSize: 17.sp),
            ),
          ),
          DataCell(
            Text(
              row.price.toString(),
              style: TextStyle(fontSize: 17.sp),
            ),
          ),
          DataCell(
            TextButton(
              onPressed: () {
                ref.read(addProductControllerProvider.notifier).updateStatus(
                    id: row.id.toString(),
                    status: row.status == 'active' ? 'inactive' : 'active',
                    context: context);
              },
              child: Text(
                row.status.toString(),
                style: TextStyle(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w500,
                    color: row.status == 'active' ? Colors.green : Colors.red),
              ),
            ),
          ),
          DataCell(
            GestureDetector(
              onTap: () {
                if (row.report != null) {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return Container(
                        height: 300,
                        padding: EdgeInsets.all(20.sp),
                        child: ListView.builder(
                          itemCount: row.report!.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(row.report![index].reason),
                                  const Divider(),
                                ],
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                }
              },
              child: Text(
                row.report != null ? row.report!.length.toString() : '0',
                style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w500),
              ),
            ),
          ),
          DataCell(
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return RentalsDetailScreen(product: row);
                    },
                  ),
                );
              },
              child: Text(
                'show',
                style: TextStyle(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          DataCell(
            ElevatedButton(
              onPressed: () {
                ref
                    .read(addProductControllerProvider.notifier)
                    .deleteProduct(id: row.id!, context: context);
              },
              child: Text(
                'Remove',
                style: TextStyle(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      );
    }).toList();
  }
}
