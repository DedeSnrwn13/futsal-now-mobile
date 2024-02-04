import 'package:d_view/d_view.dart';
import 'package:futsal_now_mobile/config/app_assets.dart';
import 'package:futsal_now_mobile/config/app_colors.dart';
import 'package:futsal_now_mobile/config/app_format.dart';
import 'package:futsal_now_mobile/config/nav.dart';
import 'package:futsal_now_mobile/models/booking_model.dart';
import 'package:futsal_now_mobile/pages/detail_sport_arena_page.dart';
import 'package:flutter/material.dart';

class DetailBookingPage extends StatelessWidget {
  const DetailBookingPage({super.key, required this.booking});

  final BookingModel booking;

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
          itemInfo(Icons.sell, AppFormat.longPrice(booking.totalPrice)),
          divider(),
          itemInfo(Icons.event, AppFormat.fullDate(booking.createdAt)),
          divider(),
          itemInfo(Icons.timelapse_outlined, '${booking.startedAt} - ${booking.endedAt}'),
          divider(),
          InkWell(
            onTap: () {
              Nav.push(context, DetailSportArenaPage(sportArena: booking.ground.sportArena));
            },
            child: itemInfo(Icons.stadium_outlined, booking.ground.sportArena.name),
          ),
          divider(),
          itemInfo(Icons.payment_outlined, booking.paymentMethod),
          divider(),
          itemInfo(Icons.payments_outlined, booking.paymentStatus),
          divider(),
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
                    booking.orderSatus,
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
                      'ID: ${booking.orderNumber}',
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
