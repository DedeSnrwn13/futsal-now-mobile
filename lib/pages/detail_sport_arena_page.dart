import 'dart:developer';

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
import 'package:futsal_now_mobile/config/nav.dart';
import 'package:futsal_now_mobile/datasources/sport_arena_datasource.dart';
import 'package:futsal_now_mobile/models/ground_model.dart';
import 'package:futsal_now_mobile/models/sport_arena_model.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:futsal_now_mobile/pages/detail_ground_page.dart';
import 'package:futsal_now_mobile/providers/sport_arena_provider.dart';
import 'package:futsal_now_mobile/widgets/error_background.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';

class DetailSportArenaPage extends ConsumerStatefulWidget {
  const DetailSportArenaPage({super.key, required this.sportArena});

  final SportArenaModel sportArena;

  @override
  ConsumerState<DetailSportArenaPage> createState() => _DetailSportArenaPageState();
}

class _DetailSportArenaPageState extends ConsumerState<DetailSportArenaPage> {
  getGrounds(String sportArenaId) {
    SportArenaDatasource.readGrounds(sportArenaId).then((value) {
      value.fold(
        (failure) {
          switch (failure.runtimeType) {
            case ServerFailure:
              setSportArenaGroundStatus(ref, 'Server Error');
              break;
            case NotFoundFailure:
              setSportArenaGroundStatus(ref, 'Error Not Found');
              break;
            case ForbiddenFailure:
              setSportArenaGroundStatus(ref, 'You don\'t have access');
              break;
            case BadRequestFailure:
              setSportArenaGroundStatus(ref, 'Bad Request');
              break;
            case UnauthorisedFailure:
              setSportArenaGroundStatus(ref, 'Unauthorised');
              break;
            default:
              setSportArenaGroundStatus(ref, 'Request Error');
              break;
          }
        },
        (result) {
          setSportArenaGroundStatus(ref, 'Success');

          List data = result['data'];
          List<GroundModel> grounds = data.map((e) => GroundModel.fromJson(e)).toList();

          ref.read(sportArenaGroundListProvider.notifier).setData(grounds);
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
    getGrounds(widget.sportArena.id.toString());
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
          category(),
          DView.height(20),
          description(),
          DView.height(20),
          grounds(context),
          DView.height(20),
        ],
      ),
    );
  }

  Consumer grounds(BuildContext context) {
    return Consumer(
      builder: (_, wiRef, __) {
        List<GroundModel> list = wiRef.watch(sportArenaGroundListProvider);

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DView.textTitle('Grounds', color: Colors.black),
                  DView.textAction(() => refresh(), text: 'Refresh', size: 14, color: AppColor.primary),
                ],
              ),
            ),
            DView.height(8),
            if (list.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: ErrorBackground(
                  ratio: 1.2,
                  message: 'No Ground Yet',
                ),
              ),
            if (list.isNotEmpty)
              SizedBox(
                height: 250,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    GroundModel item = list[index];

                    return GestureDetector(
                      onTap: () {
                        Nav.push(context, DetailGroundPage(ground: item));
                      },
                      child: Container(
                        margin: EdgeInsets.fromLTRB(
                          index == 0 ? 30 : 10,
                          0,
                          index == list.length - 1 ? 30 : 10,
                          0,
                        ),
                        width: 200,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: ExtendedImage.network(
                                '${AppConstants.baseImageURL}/${item.imgThumbnail}',
                                fit: BoxFit.cover,
                                cache: true,
                                shape: BoxShape.rectangle,
                                //cancelToken: cancellationToken,
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                height: 150,
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                  ),
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.transparent,
                                      Colors.black,
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              left: 8,
                              bottom: 8,
                              right: 8,
                              child: Column(
                                children: [
                                  Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                                    padding: const EdgeInsets.all(8),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.name,
                                          style: GoogleFonts.ptSans(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        ),
                                        DView.height(4),
                                        Row(
                                          children: [
                                            RatingBar.builder(
                                              initialRating: item.rate ?? 0,
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
                                              '(${item.rate})',
                                              style: const TextStyle(
                                                color: Colors.black87,
                                                fontSize: 11,
                                              ),
                                            ),
                                          ],
                                        ),
                                        DView.height(4),
                                        Text(
                                          AppFormat.longPrice(item.rentalPrice),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              )
          ],
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
            widget.sportArena.description,
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Padding category() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DView.textTitle('Category', color: Colors.black87),
          DView.height(8),
          Wrap(
            children: [
              'Outdoor',
            ].map((e) {
              return Chip(
                label: Text(e, style: const TextStyle(height: 1)),
                side: const BorderSide(color: AppColor.primary),
                backgroundColor: Colors.white,
                visualDensity: const VisualDensity(vertical: -4),
              );
            }).toList(),
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
                    Icons.location_on,
                    color: AppColor.primary,
                    size: 20,
                  ),
                  '${widget.sportArena.district}, ${widget.sportArena.city}',
                ),
                DView.height(8),
                GestureDetector(
                  onTap: () => launchWA(context, widget.sportArena.waNumber),
                  child: itemInfo(
                    Image.asset(
                      AppAssets.wa,
                      width: 20,
                    ),
                    widget.sportArena.waNumber,
                  ),
                ),
                DView.height(8),
                itemInfo(
                  const Icon(
                    Icons.email,
                    color: AppColor.primary,
                    size: 20,
                  ),
                  widget.sportArena.email ?? "-",
                ),
                DView.height(8),
                itemInfo(
                  const Icon(
                    Icons.timer_sharp,
                    color: AppColor.primary,
                    size: 20,
                  ),
                  'Open: ${widget.sportArena.openTime}',
                ),
                DView.height(8),
                itemInfo(
                  const Icon(
                    Icons.timer,
                    color: AppColor.primary,
                    size: 20,
                  ),
                  'Close: ${widget.sportArena.closeTime}',
                ),
                DView.height(8),
                itemInfo(
                  const Icon(
                    Icons.map_outlined,
                    color: AppColor.primary,
                    size: 20,
                  ),
                  'Map Link: ${widget.sportArena.mapLink}',
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
                AppFormat.longPrice(widget.sportArena.price),
                textAlign: TextAlign.right,
                style: const TextStyle(
                  height: 1,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColor.primary,
                ),
              ),
              const Text('avg per ground'),
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
              child: ExtendedImage.network(
                '${AppConstants.baseImageURL}/${widget.sportArena.image}',
                fit: BoxFit.cover,
                cache: true,
                shape: BoxShape.rectangle,
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
                        widget.sportArena.name,
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
                            initialRating: widget.sportArena.rate,
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
                            '(${widget.sportArena.rate})',
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
