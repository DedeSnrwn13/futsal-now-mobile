import 'package:d_info/d_info.dart';
import 'package:d_view/d_view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:futsal_now_mobile/config/app_assets.dart';
import 'package:futsal_now_mobile/config/app_colors.dart';
import 'package:futsal_now_mobile/config/app_constants.dart';
import 'package:futsal_now_mobile/config/app_format.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:futsal_now_mobile/config/failure.dart';
import 'package:futsal_now_mobile/datasources/sport_arena_datasource.dart';
import 'package:futsal_now_mobile/models/ground_model.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:futsal_now_mobile/providers/sport_arena_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';
import 'package:carousel_slider/carousel_slider.dart';

class DetailGroundPage extends ConsumerStatefulWidget {
  const DetailGroundPage({super.key, required this.ground});

  final GroundModel ground;

  @override
  ConsumerState<DetailGroundPage> createState() => _DetailGroundPageState();
}

class _DetailGroundPageState extends ConsumerState<DetailGroundPage> {
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
              onPressed: () {},
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
            ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: CarouselSlider(
                options: CarouselOptions(
                  height: 400.0,
                  enlargeCenterPage: true,
                  autoPlay: true,
                  aspectRatio: 1,
                  onPageChanged: (index, reason) {
                    // Handle page change if needed
                  },
                ),
                items: widget.ground.image.map<Widget>((filename) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ExtendedImage.network(
                      '${AppConstants.baseImageURL}/${filename['filename']}',
                      fit: BoxFit.cover,
                      cache: true,
                      shape: BoxShape.rectangle,
                    ),
                  );
                }).toList(),
              ),
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
