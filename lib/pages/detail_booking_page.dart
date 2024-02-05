import 'package:d_info/d_info.dart';
import 'package:d_view/d_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:futsal_now_mobile/config/app_assets.dart';
import 'package:futsal_now_mobile/config/app_colors.dart';
import 'package:futsal_now_mobile/config/app_format.dart';
import 'package:futsal_now_mobile/config/failure.dart';
import 'package:futsal_now_mobile/config/nav.dart';
import 'package:futsal_now_mobile/datasources/sport_arena_datasource.dart';
import 'package:futsal_now_mobile/models/booking_model.dart';
import 'package:futsal_now_mobile/pages/detail_sport_arena_page.dart';
import 'package:flutter/material.dart';
import 'package:futsal_now_mobile/pages/review_form.dart';
import 'package:futsal_now_mobile/providers/sport_arena_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';

class DetailBookingPage extends ConsumerStatefulWidget {
  const DetailBookingPage({Key? key, required this.booking}) : super(key: key);

  final BookingModel booking;

  @override
  ConsumerState<DetailBookingPage> createState() => _DetailBookingPageState();
}

class _DetailBookingPageState extends ConsumerState<DetailBookingPage> {
  bool hasReviewed = false;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(0),
        children: [
          headerCover(context),
          DView.height(10),
          Center(
            child: Container(
              width: 90,
              height: 4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.grey,
              ),
            ),
          ),
          DView.height(16),
          itemInfo(Icons.sell, AppFormat.longPrice(widget.booking.totalPrice)),
          divider(),
          itemInfo(Icons.event, AppFormat.fullDate(widget.booking.createdAt)),
          divider(),
          itemInfo(Icons.timelapse_outlined, '${widget.booking.startedAt} - ${widget.booking.endedAt}'),
          divider(),
          InkWell(
            onTap: () {
              Nav.push(context, DetailSportArenaPage(sportArena: widget.booking.ground.sportArena));
            },
            child: itemInfo(Icons.stadium_outlined, widget.booking.ground.sportArena.name),
          ),
          divider(),
          itemInfo(Icons.payment_outlined, widget.booking.paymentMethod),
          divider(),
          itemInfo(Icons.payments_outlined, '${widget.booking.paymentStatus} (Payment Status)'),
          divider(),
          GestureDetector(
            onTap: () => launchWA(context, widget.booking.ground.sportArena.waNumber),
            child: itemInfoWa(
              Image.asset(
                AppAssets.wa,
                width: 20,
              ),
              widget.booking.ground.sportArena.waNumber,
            ),
          ),
          divider(),
          if (widget.booking.orderStatus == 'finished' && widget.booking.paymentStatus == 'success')
            ReviewForm(
              onSubmit: (comment, rating) {
                if (kDebugMode) {
                  print('Comment: $comment, Rating: $rating');
                }

                SportArenaDatasource.submitReview(
                  widget.booking.ground.sportArena.id.toString(),
                  widget.booking.ground.id.toString(),
                  comment.toString(),
                  rating.toString(),
                ).then((value) {
                  setSubmitReviewtatus(ref, 'Loading');

                  value.fold(
                    (failure) {
                      switch (failure.runtimeType) {
                        case ServerFailure:
                          setSubmitReviewtatus(ref, 'Server Error');
                          break;
                        case NotFoundFailure:
                          setSubmitReviewtatus(ref, 'Not Found');
                          break;
                        case ForbiddenFailure:
                          setSubmitReviewtatus(ref, 'You don\'t have access');
                          break;
                        case BadRequestFailure:
                          setSubmitReviewtatus(ref, 'Bad request');
                          break;
                        case UnauthorisedFailure:
                          setSubmitReviewtatus(ref, 'Unauthorised');
                          break;
                        default:
                          setSubmitReviewtatus(ref, 'Request Error');
                          break;
                      }
                    },
                    (result) {
                      setSubmitReviewtatus(ref, 'Success');

                      setState(() {
                        hasReviewed = true; // Setelah memberikan ulasan, atur hasReviewed menjadi true
                      });
                    },
                  );
                });
              },
              hasReviewed: hasReviewed,
            )
        ],
      ),
    );
  }

  Widget itemInfoWa(Widget icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Row(
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
      ),
    );
  }

  Divider divider() {
    return Divider(
      indent: 30,
      endIndent: 30,
      color: Colors.grey[400],
    );
  }

  Widget itemInfo(IconData icon, String info) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppColor.primary,
          ),
          DView.width(10),
          Text(info)
        ],
      ),
    );
  }

  Widget itemDescription(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        children: [
          const Icon(
            Icons.abc,
            color: Colors.transparent,
          ),
          DView.width(10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.black54,
              ),
            ),
          )
        ],
      ),
    );
  }

  Padding headerCover(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: AspectRatio(
        aspectRatio: 1,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                AppAssets.emptyBG,
                fit: BoxFit.cover,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: AspectRatio(
                  aspectRatio: 2,
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black,
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 60,
                    vertical: 30,
                  ),
                  child: Text(
                    widget.booking.orderStatus,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 40,
                      height: 1,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 36,
                left: 16,
                right: 16,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'ID: ${widget.booking.orderNumber}',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        height: 1,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            blurRadius: 6,
                            color: Colors.black87,
                          ),
                        ],
                      ),
                    ),
                    FloatingActionButton.small(
                      heroTag: 'fab-back',
                      onPressed: () => Navigator.pop(context),
                      backgroundColor: Colors.white,
                      child: const Icon(Icons.arrow_back),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
