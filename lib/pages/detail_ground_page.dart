
import 'package:d_info/d_info.dart';
import 'package:d_view/d_view.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:futsal_now_mobile/config/app_assets.dart';
import 'package:futsal_now_mobile/config/app_colors.dart';
import 'package:futsal_now_mobile/config/app_constants.dart';
import 'package:futsal_now_mobile/config/app_format.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:futsal_now_mobile/config/app_response.dart';
import 'package:futsal_now_mobile/config/app_session.dart';
import 'package:futsal_now_mobile/config/failure.dart';
import 'package:futsal_now_mobile/config/nav.dart';
import 'package:futsal_now_mobile/datasources/booking_datasource.dart';
import 'package:futsal_now_mobile/datasources/sport_arena_datasource.dart';
import 'package:futsal_now_mobile/models/ground_model.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:futsal_now_mobile/models/user_model.dart';
import 'package:futsal_now_mobile/pages/payment_page.dart';
import 'package:futsal_now_mobile/providers/my_booking_provider.dart';
import 'package:futsal_now_mobile/providers/sport_arena_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';
import 'package:intl/intl.dart';

class DetailGroundPage extends ConsumerStatefulWidget {
  const DetailGroundPage({super.key, required this.ground});

  final GroundModel ground;

  @override
  ConsumerState<DetailGroundPage> createState() => _DetailGroundPageState();
}

class _DetailGroundPageState extends ConsumerState<DetailGroundPage> {
  late UserModel user;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController dateController = TextEditingController();
  TextEditingController startTimeController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();
  TextEditingController paymentMethodController = TextEditingController(text: 'BCA');

  double calculateTotalPrice(DateTime startTime, DateTime endTime) {
    return widget.ground.rentalPrice * (endTime.difference(startTime).inHours);
  }

  bookingNow() {
    if (dateController.text.isEmpty || startTimeController.text.isEmpty || endTimeController.text.isEmpty) {
      DInfo.toastError('One or more required fields are empty');
      setBookingStatus(ref, 'One or more required fields are empty');
      return;
    }

    DateTime selectedDate = DateFormat('yyyy-MM-dd').parse(dateController.text);
    DateTime startTime = DateFormat('HH:mm').parse(startTimeController.text);
    DateTime endTime = DateFormat('HH:mm').parse(endTimeController.text);

    if (startTime == null) {
      DInfo.toastError('One or more parsed DateTime fields are null');
      setBookingStatus(ref, 'One or more parsed DateTime fields are null');
      return;
    }

    double totalPrice = calculateTotalPrice(startTime, endTime);

    if (totalPrice <= 0) {
      DInfo.toastError('Total rental price is zero or negative');
      setBookingStatus(ref, 'Total rental price is zero or negative');
      return;
    }

    BookingDatasource.booking(
      widget.ground.sportArena.id.toString(),
      widget.ground.id.toString(),
      selectedDate.toString(),
      startTime.toString(),
      endTime.toString(),
      totalPrice.toDouble().toString(),
      paymentMethodController.text,
    ).then((value) {
      value.fold(
        (failure) {
          String newStatus = '';

          switch (failure.runtimeType) {
            case ServerFailure:
              setBookingStatus(ref, 'Server Error');
              break;
            case NotFoundFailure:
              setBookingStatus(ref, 'Error Not Found');
              break;
            case ForbiddenFailure:
              setBookingStatus(ref, 'You don\'t have access');
              break;
            case BadRequestFailure:
              setBookingStatus(ref, 'Bad Request');
              break;
            case InvalidInputFailure:
              var newStatus = 'Invalid Input';
              AppResponse.invalidInput(context, failure.message ?? '{}');
              setBookingStatus(ref, newStatus);
              break;
            case UnauthorisedFailure:
              newStatus = 'Unauthorized';
              DInfo.toastError(newStatus);
              break;
            default:
              newStatus = failure.message ?? '-';
              setBookingStatus(ref, newStatus);
              DInfo.toastError(newStatus);
              break;
          }
        },
        (result) {
          setBookingStatus(ref, 'Success');

          Nav.push(
            context,
            PaymentPage(
              snapToken: result['snap_token'],
              orderNumber: result['order_number'],
            ),
          );
        },
      );
    });
  }

  getGrounds(String sportArenaId, String groundId) {
    SportArenaDatasource.getGroundById(sportArenaId, groundId).then((value) {
      value.fold(
        (failure) {
          switch (failure.runtimeType) {
            case ServerFailure:
              setGroundStatus(ref, 'Server Error');
              break;
            case NotFoundFailure:
              setGroundStatus(ref, 'Error Not Found');
              break;
            case ForbiddenFailure:
              setGroundStatus(ref, 'You don\'t have access');
              break;
            case BadRequestFailure:
              setGroundStatus(ref, 'Bad Request');
              break;
            case UnauthorisedFailure:
              setGroundStatus(ref, 'Unauthorised');
              break;
            default:
              setGroundStatus(ref, 'Request Error');
              break;
          }
        },
        (result) {
          setGroundStatus(ref, 'Success');
        },
      );
    });
  }

  launchWA(BuildContext context, String number) async {
    bool? yes = await DInfo.dialogConfirmation(
      context,
      'Chat via Whatsapp',
      'Yes to confirm',
    );

    if (yes ?? false) {
      final link = WhatsAppUnilink(
        phoneNumber: number,
        text: "Hello, I want to booking a futsal filed",
      );

      if (await canLaunchUrl(link.asUri())) {
        launchUrl(
          link.asUri(),
          mode: LaunchMode.externalApplication,
        );
      }
    }
  }

  refresh() {
    getGrounds(
      widget.ground.sportArena.id.toString(),
      widget.ground.id.toString(),
    );
  }

  @override
  void initState() {
    refresh();

    AppSession.getUser().then((value) {
      setState(() {
        user = value!;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(0),
        children: [
          headerImage(context),
          DView.height(10),
          groupItemInfo(context),
          DView.height(20),
          description(),
          DView.height(20),
          DView.height(20),
          Container(
            height: 50,
            margin: const EdgeInsets.symmetric(horizontal: 24),
            child: ElevatedButton(
              onPressed: () {
                _showBookingForm(context);
              },
              child: const Text(
                'Booking',
                style: TextStyle(
                  height: 1,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          DView.height(20),
        ],
      ),
    );
  }

  void _showBookingForm(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DView.height(20),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: TextField(
                      controller: dateController,
                      decoration: const InputDecoration(labelText: 'Select Date'),
                      readOnly: true,
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2024),
                          lastDate: DateTime(2100),
                        );

                        if (pickedDate != null) {
                          String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);

                          setState(() {
                            dateController.text = formattedDate;
                          });
                        }
                      },
                    ),
                  ),
                  DView.height(20),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: TextField(
                      controller: startTimeController,
                      decoration: const InputDecoration(labelText: 'Start Time'),
                      readOnly: true,
                      onTap: () async {
                        TimeOfDay? pickedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );

                        if (pickedTime != null) {
                          // ignore: use_build_context_synchronously
                          String formattedTime = pickedTime.format(context);

                          setState(() {
                            startTimeController.text = formattedTime;
                          });
                        }
                      },
                    ),
                  ),
                  DView.height(20),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: TextField(
                      controller: endTimeController,
                      decoration: const InputDecoration(labelText: 'End Time'),
                      readOnly: true,
                      onTap: () async {
                        TimeOfDay? pickedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );

                        if (pickedTime != null) {
                          // ignore: use_build_context_synchronously
                          String formattedTime = pickedTime.format(context);

                          setState(() {
                            endTimeController.text = formattedTime;
                          });
                        }
                      },
                    ),
                  ),
                  DView.height(20),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Payment Method',
                      ),
                      value: paymentMethodController.text,
                      onChanged: (String? newValue) {
                        setState(() {
                          paymentMethodController.text = newValue!;
                        });
                      },
                      items: ['BCA', 'BNI'].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                  // DView.height(20),
                  // Container(
                  //   padding: const EdgeInsets.symmetric(horizontal: 14),
                  //   child: Text(
                  //     'Total Price: ${startTimeController.text.isNotEmpty && endTimeController.text.isNotEmpty ? calculateTotalPrice(
                  //         DateFormat('HH:mm').parse(startTimeController.text),
                  //         DateFormat('HH:mm').parse(endTimeController.text),
                  //       ) : 0.0}',
                  //     style: const TextStyle(
                  //       color: Colors.black87,
                  //       fontSize: 16,
                  //     ),
                  //   ),
                  // ),
                  DView.height(20),
                  Container(
                    height: 50,
                    margin: const EdgeInsets.symmetric(horizontal: 14),
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          Navigator.pop(context);

                          bookingNow();
                        }
                      },
                      child: const Text(
                        'Booking',
                        style: TextStyle(
                          height: 1,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  DView.height(20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Padding description() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DView.textTitle('Description', color: Colors.black87),
          DView.height(8),
          Text(
            widget.ground.description,
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Padding groupItemInfo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 26),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                itemInfo(
                  const Icon(
                    Icons.hourglass_bottom,
                    color: AppColor.primary,
                    size: 20,
                  ),
                  'Per Hour',
                ),
                DView.height(8),
                itemInfo(
                  const Icon(
                    Icons.stadium_outlined,
                    color: AppColor.primary,
                    size: 20,
                  ),
                  widget.ground.sportArena.name,
                ),
                DView.height(8),
                itemInfo(
                  const Icon(
                    Icons.location_on,
                    color: AppColor.primary,
                    size: 20,
                  ),
                  '${widget.ground.sportArena.district}, ${widget.ground.sportArena.city}',
                ),
                DView.height(8),
                GestureDetector(
                  onTap: () => launchWA(context, widget.ground.sportArena.waNumber),
                  child: itemInfo(
                    Image.asset(
                      AppAssets.wa,
                      width: 20,
                    ),
                    widget.ground.sportArena.waNumber,
                  ),
                ),
                DView.height(8),
                itemInfo(
                  const Icon(
                    Icons.people,
                    color: AppColor.primary,
                    size: 20,
                  ),
                  '${widget.ground.capacity.toString()} people',
                ),
                DView.height(8),
                itemInfo(
                  const Icon(
                    Icons.event_available_outlined,
                    color: AppColor.primary,
                    size: 20,
                  ),
                  widget.ground.isAvailable.toString() == 'true' ? 'Tersedia' : 'Tidak tersedia',
                ),
                DView.height(8),
              ],
            ),
          ),
          DView.width(16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                AppFormat.longPrice(widget.ground.rentalPrice),
                textAlign: TextAlign.right,
                style: const TextStyle(
                  height: 1,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColor.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget headerImage(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: AspectRatio(
        aspectRatio: 1,
        child: Stack(
          fit: StackFit.expand,
          children: [
            ImageSlideshow(
              width: double.infinity,
              height: 200,
              initialPage: 0,
              indicatorColor: Colors.blue,
              indicatorBackgroundColor: Colors.grey,
              onPageChanged: (value) {},
              autoPlayInterval: 3000,
              isLoop: true,
              children: widget.ground.image.map<Widget>(
                (filename) {
                  return ExtendedImage.network(
                    '${AppConstants.baseImageURL}/$filename',
                    fit: BoxFit.cover,
                    cache: true,
                    shape: BoxShape.rectangle,
                    loadStateChanged: (ExtendedImageState state) {
                      switch (state.extendedImageLoadState) {
                        case LoadState.loading:
                          return DView.loadingCircle();
                        case LoadState.completed:
                          return null;
                        case LoadState.failed:
                          return const Icon(Icons.error);
                      }
                    },
                  );
                },
              ).toList(),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: AspectRatio(
                aspectRatio: 2,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: const LinearGradient(
                      colors: [
                        Colors.black,
                        Colors.transparent,
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.ground.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      DView.height(8),
                      Row(
                        children: [
                          RatingBar.builder(
                            initialRating: widget.ground.rate ?? 0,
                            itemCount: 5,
                            allowHalfRating: true,
                            itemPadding: const EdgeInsets.all(0),
                            unratedColor: Colors.grey[300],
                            itemBuilder: (context, index) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            itemSize: 12,
                            onRatingUpdate: (value) {},
                            ignoreGestures: true,
                          ),
                          DView.width(4),
                          Text(
                            '(${widget.ground.rate})',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 36,
              left: 16,
              child: SizedBox(
                height: 36,
                child: FloatingActionButton.extended(
                  heroTag: 'fab-back-button',
                  onPressed: () => Navigator.pop(context),
                  backgroundColor: Colors.white,
                  icon: const Icon(Icons.navigate_before),
                  extendedIconLabelSpacing: 0,
                  extendedPadding: const EdgeInsets.only(left: 10, right: 16),
                  label: const Text(
                    'Back',
                    style: TextStyle(
                      height: 1,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container childOrder(String name) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.blue,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              height: 1,
            ),
          ),
          DView.width(4),
          const Icon(
            Icons.check_circle,
            color: Colors.white,
            size: 14,
          ),
        ],
      ),
    );
  }

  Widget itemInfo(Widget icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 30,
          height: 20,
          alignment: Alignment.centerLeft,
          child: icon,
        ),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
}
