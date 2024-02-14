import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rentify/features/user_profile/controller/user_profile_controller.dart';
import 'package:rentify/models/user_models.dart';

import '../../core/common/error_text.dart';
import '../../core/common/loader.dart';
import '../../models/review.dart';

class UserUI extends ConsumerStatefulWidget {
  const UserUI({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UserUIState();
}

class _UserUIState extends ConsumerState<UserUI> {
  int length = 0;
  double sum = 0;
  double calculateAverageRating(List<Review> reviews) {
    if (reviews.isEmpty) {
      return 0.0; // Default value for no ratings
    }
    length = reviews.length;
    double sum = reviews
        .map((review) => review.rating)
        .reduce((value, element) => value + element);
    return sum / reviews.length;
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(userFetchProvider).when(
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
                      'list of Users',
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
                              'Name',
                              style: TextStyle(
                                  fontSize: 17.sp, fontWeight: FontWeight.bold),
                            ),
                          ),
                          DataColumn(
                              label: Text('Email',
                                  style: TextStyle(
                                      fontSize: 17.sp,
                                      fontWeight: FontWeight.bold))),
                          DataColumn(
                              label: Text('Phone',
                                  style: TextStyle(
                                      fontSize: 17.sp,
                                      fontWeight: FontWeight.bold))),
                          DataColumn(
                              label: Text('Status',
                                  style: TextStyle(
                                      fontSize: 17.sp,
                                      fontWeight: FontWeight.bold))),
                          DataColumn(
                              label: Text('Review',
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

  List<DataRow> buildRows(List<UserModel> data, WidgetRef ref) {
    return data.asMap().entries.map((entry) {
      double sums = 0;
      final index = entry.key + 1; // Add 1 to start the index from 1
      final row = entry.value;
      if (row.reviews != null) {
        sums = calculateAverageRating(row.reviews!);
      }
      return DataRow(
        cells: [
          DataCell(
            Text(
              row.name.toString(),
              style: TextStyle(fontSize: 17.sp),
            ),
          ),
          DataCell(
            Text(
              row.email,
              style: TextStyle(fontSize: 17.sp),
            ),
          ),
          DataCell(
            Text(
              row.phoneNo,
              style: TextStyle(fontSize: 17.sp),
            ),
          ),
          DataCell(
            TextButton(
              onPressed: () {
                ref.read(userProfileControllerProvider.notifier).updateStatus(
                    id: row.id.toString(),
                    status: row.status == 'active' ? 'inactive' : 'active',
                    context: context);
              },
              child: Text(
                row.status.toString(),
                style: TextStyle(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w500,
                  color: row.status == 'active' ? Colors.green : Colors.red,
                ),
              ),
            ),
          ),
          DataCell(
            Text(
              sums.toString(),
              style: TextStyle(fontSize: 17.sp),
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
                // Navigator.of(context).push(
                //   MaterialPageRoute(
                //     builder: (context) {
                //       return RentalsDetailScreen(product: row);
                //     },
                //   ),
                // );
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
        ],
      );
    }).toList();
  }
}
