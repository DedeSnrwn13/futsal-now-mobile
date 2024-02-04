import 'package:d_info/d_info.dart';
import 'package:d_input/d_input.dart';
import 'package:d_view/d_view.dart';
import 'package:futsal_now_mobile/config/app_constants.dart';
import 'package:futsal_now_mobile/config/app_format.dart';
import 'package:futsal_now_mobile/config/app_response.dart';
import 'package:futsal_now_mobile/config/app_session.dart';
import 'package:futsal_now_mobile/config/failure.dart';
import 'package:futsal_now_mobile/config/nav.dart';
import 'package:futsal_now_mobile/datasources/booking_datasource.dart';
import 'package:futsal_now_mobile/models/booking_model.dart';
import 'package:futsal_now_mobile/models/user_model.dart';
import 'package:futsal_now_mobile/pages/detail_booking_page.dart';
import 'package:futsal_now_mobile/providers/my_booking_provider.dart';
import 'package:futsal_now_mobile/widgets/error_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grouped_list/grouped_list.dart';

class MyBookingView extends ConsumerStatefulWidget {
  const MyBookingView({super.key});

  @override
  ConsumerState<MyBookingView> createState() => _MyBookingViewState();
}

class _MyBookingViewState extends ConsumerState<MyBookingView> {
  late UserModel user;

  getMyBooking() {
    BookingDatasource.history().then((value) {
      value.fold(
        (failure) {
          switch (failure.runtimeType) {
            case ServerFailure:
              setMyBookingStatus(ref, 'Server Error');
              break;
            case NotFoundFailure:
              setMyBookingStatus(ref, 'Error Not Found');
              break;
            case ForbiddenFailure:
              setMyBookingStatus(ref, 'You don\'t have access');
              break;
            case BadRequestFailure:
              setMyBookingStatus(ref, 'Bad Request');
              break;
            case UnauthorisedFailure:
              setMyBookingStatus(ref, 'Unauthorised');
              break;
            default:
              setMyBookingStatus(ref, 'Request Error');
              break;
          }
        },
        (result) {
          setMyBookingStatus(ref, 'Success');

          List data = result['data'];
          List<BookingModel> bookings = data.map((e) => BookingModel.fromJson(e)).toList();

          ref.read(myBookingListProvider.notifier).setData(bookings);
        },
      );
    });
  }

  dialogCancel() {
    final editLaundryID = TextEditingController();
    final editClaimCode = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        return Form(
          key: formKey,
          child: SimpleDialog(
            titlePadding: const EdgeInsets.all(16),
            contentPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            title: const Text('Claim Laundry'),
            children: [
              DInput(
                controller: editLaundryID,
                title: 'Laundry ID',
                radius: BorderRadius.circular(10),
                validator: (input) => input == '' ? "Don't empty" : null,
                inputType: TextInputType.number,
              ),
              DView.height(8),
              DInput(
                controller: editClaimCode,
                title: 'Claim Code',
                radius: BorderRadius.circular(10),
                validator: (input) => input == '' ? "Don't empty" : null,
                inputType: TextInputType.text,
              ),
              DView.height(20),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    Navigator.pop(context);

                    cancelNow(editLaundryID.text, editClaimCode.text);
                  }
                },
                child: const Text('Claim Now'),
              ),
              DView.height(8),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
            ],
          ),
        );
      },
    );
  }

  cancelNow(String id, String claimCode) {
    BookingDatasource.cancelById(id).then((value) {
      value.fold(
        (failure) {
          switch (failure.runtimeType) {
            case ServerFailure:
              DInfo.toastError('Server Error');
              break;
            case NotFoundFailure:
              DInfo.toastError('Error Not Found');
              break;
            case ForbiddenFailure:
              DInfo.toastError('You don\'t have access');
              break;
            case BadRequestFailure:
              DInfo.toastError('Laundry has been claimed');
              break;
            case InvalidInputFailure:
              AppResponse.invalidInput(context, failure.message ?? '{}');
              break;
            case UnauthorisedFailure:
              DInfo.toastError('Unauthorised');
              break;
            default:
              DInfo.toastError('Request Error');
              break;
          }
        },
        (result) {
          DInfo.toastSuccess('Claim Success');
          getMyBooking();
        },
      );
    });
  }

  @override
  void initState() {
    AppSession.getUser().then((value) {
      user = value!;
      getMyBooking();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        header(),
        categories(),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async => getMyBooking(),
            child: Consumer(
              builder: (_, wiRef, __) {
                String statusList = wiRef.watch(myBookingStatusProvider);
                String statusCategory = wiRef.watch(myBookingCategoryProvider);
                List<BookingModel> listBackup = wiRef.watch(myBookingListProvider);

                if (statusList == '') return DView.loadingCircle();

                if (statusList != 'Success') {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(30, 0, 30, 80),
                    child: ErrorBackground(
                      ratio: 16 / 9,
                      message: statusList,
                    ),
                  );
                }

                List<BookingModel> list = [];

                if (statusCategory == 'All') {
                  list = List.from(listBackup);
                } else {
                  list = listBackup.where((element) => element.orderSatus == statusCategory).toList();
                }

                if (list.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(30, 30, 30, 80),
                    child: Stack(
                      children: [
                        const ErrorBackground(
                          ratio: 16 / 9,
                          message: 'Empty',
                        ),
                        IconButton(
                          onPressed: () => getMyBooking(),
                          icon: const Icon(
                            Icons.refresh,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return GroupedListView<BookingModel, String>(
                  padding: const EdgeInsets.fromLTRB(30, 0, 30, 80),
                  elements: list,
                  groupBy: (element) => AppFormat.justDate(element.createdAt),
                  order: GroupedListOrder.DESC,
                  itemComparator: (element1, element2) {
                    return element2.createdAt.compareTo(element1.createdAt);
                  },
                  groupSeparatorBuilder: (value) => Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: Colors.grey[400]!),
                      ),
                      margin: const EdgeInsets.only(top: 24, bottom: 20),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      child: Text(
                        AppFormat.shorDate(value),
                      ),
                    ),
                  ),
                  itemBuilder: (context, booking) {
                    return GestureDetector(
                      onTap: () {
                        Nav.push(
                          context,
                          DetailBookingPage(
                            booking: booking,
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    booking.ground.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                                DView.width(16),
                                Text(
                                  AppFormat.longPrice(booking.totalPrice),
                                  textAlign: TextAlign.end,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                            DView.height(12),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Consumer categories() {
    return Consumer(builder: (_, wiRef, __) {
      String categorySelected = wiRef.watch(myBookingCategoryProvider);

      return SizedBox(
        height: 30,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: AppConstants.orderStatus.length,
          itemBuilder: (context, index) {
            String category = AppConstants.orderStatus[index];

            return Padding(
              padding: EdgeInsets.only(
                left: index == 0 ? 30 : 8,
                right: index == AppConstants.orderStatus.length - 1 ? 30 : 8,
              ),
              child: InkWell(
                onTap: () {
                  setMyBookingCategory(ref, category);
                },
                borderRadius: BorderRadius.circular(30),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: category == categorySelected ? Colors.blue : Colors.grey[400]!,
                    ),
                    color: category == categorySelected ? Colors.blue : Colors.transparent,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  alignment: Alignment.center,
                  child: Text(
                    category,
                    style: TextStyle(
                      height: 1,
                      color: category == categorySelected ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      );
    });
  }

  Padding header() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 60, 30, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'My Laundry',
            style: GoogleFonts.montserrat(
              fontSize: 24,
              color: Colors.blue,
              fontWeight: FontWeight.w600,
            ),
          ),
          Transform.translate(
            offset: const Offset(0, -8),
            child: OutlinedButton.icon(
              onPressed: () => dialogCancel(),
              icon: const Icon(Icons.add),
              label: const Text(
                'Claim',
                style: TextStyle(height: 1),
              ),
              style: ButtonStyle(
                shape: MaterialStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                padding: const MaterialStatePropertyAll(
                  EdgeInsets.fromLTRB(8, 2, 16, 2),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
