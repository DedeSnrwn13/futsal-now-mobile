// ignore_for_file: file_names

import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:futsal_now_mobile/config/app_assets.dart';
import 'package:futsal_now_mobile/config/app_colors.dart';
import 'package:futsal_now_mobile/config/app_response.dart';
import 'package:futsal_now_mobile/config/app_session.dart';
import 'package:futsal_now_mobile/config/failure.dart';
import 'package:futsal_now_mobile/config/nav.dart';
import 'package:futsal_now_mobile/datasources/user_datasource.dart';
import 'package:futsal_now_mobile/models/user_model.dart';
import 'package:futsal_now_mobile/pages/auth/login_page.dart';
import 'package:flutter/material.dart';
import 'package:d_view/d_view.dart';
import 'package:futsal_now_mobile/providers/user_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:d_info/d_info.dart';

class AccountView extends ConsumerStatefulWidget {
  const AccountView({super.key});

  @override
  ConsumerState<AccountView> createState() => _AccountViewState();
}

class _AccountViewState extends ConsumerState<AccountView> {
  final GlobalKey<FormState> _formKeyFeedback = GlobalKey<FormState>();
  final TextEditingController bodyController = TextEditingController();
  double rating = 0.0;

  logout(BuildContext context) {
    DInfo.dialogConfirmation(
      context,
      'Logout',
      'You sure want to logout?',
      textNo: 'Cancel',
    ).then((yes) {
      if (yes ?? false) {
        AppSession.removeUser();
        AppSession.removeBearerToken();
        Nav.replace(context, const LoginPage());
      }
    });
  }

  submitFeedback(String body, double rate) {
    UserDatasource.feedback(
      body,
      rate,
    ).then((value) {
      value.fold(
        (failure) {
          String newStatus = '';

          switch (failure.runtimeType) {
            case ServerFailure:
              setfeedbackStatus(ref, 'Server Error');
              break;
            case NotFoundFailure:
              setfeedbackStatus(ref, 'Error Not Found');
              break;
            case ForbiddenFailure:
              setfeedbackStatus(ref, 'You don\'t have access');
              break;
            case BadRequestFailure:
              setfeedbackStatus(ref, 'Bad Request');
              break;
            case InvalidInputFailure:
              var newStatus = 'Invalid Input';
              AppResponse.invalidInput(context, failure.message ?? '{}');
              setfeedbackStatus(ref, newStatus);
              break;
            case UnauthorisedFailure:
              newStatus = 'Unauthorized';
              DInfo.toastError(newStatus);
              break;
            default:
              newStatus = failure.message ?? '-';
              setfeedbackStatus(ref, newStatus);
              DInfo.toastError(newStatus);
              break;
          }
        },
        (result) {
          setfeedbackStatus(ref, 'Success');
          DInfo.toastSuccess(result['message']);
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AppSession.getUser(),
      builder: (context, snapshot) {
        if (snapshot.data == null) return DView.loadingCircle();

        UserModel user = snapshot.data!;

        return ListView(
          padding: const EdgeInsets.all(0),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 60, 30, 30),
              child: Text(
                'Account',
                style: GoogleFonts.montserrat(
                  fontSize: 24,
                  color: Colors.blue,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 70,
                    child: AspectRatio(
                      aspectRatio: 3 / 4,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          AppAssets.profile,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  DView.width(16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Name',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        DView.height(4),
                        Text(
                          user.name,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                        ),
                        DView.height(12),
                        const Text(
                          'Email',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        DView.height(4),
                        Text(
                          user.email,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            DView.height(10),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 30),
              onTap: () {},
              dense: true,
              horizontalTitleGap: 0,
              leading: const Icon(Icons.image),
              title: const Text('Change Profile'),
              trailing: const Icon(Icons.navigate_next),
            ),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 30),
              onTap: () {},
              dense: true,
              horizontalTitleGap: 0,
              leading: const Icon(Icons.edit),
              title: const Text('Edit Account'),
              trailing: const Icon(Icons.navigate_next),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: OutlinedButton(
                onPressed: () => logout(context),
                child: const Text('Logout'),
              ),
            ),
            DView.height(30),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                'Settings',
                style: TextStyle(
                  height: 1,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 30),
              onTap: () {},
              dense: true,
              horizontalTitleGap: 0,
              leading: const Icon(Icons.edit),
              title: const Text('Dark Mode'),
              trailing: Switch(
                activeColor: AppColor.primary,
                value: false,
                onChanged: (value) {},
              ),
            ),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 30),
              onTap: () {},
              dense: true,
              horizontalTitleGap: 0,
              leading: const Icon(Icons.translate),
              title: const Text('Language'),
              trailing: const Icon(Icons.navigate_next),
            ),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 30),
              onTap: () {},
              dense: true,
              horizontalTitleGap: 0,
              leading: const Icon(Icons.notifications),
              title: const Text('Notification'),
              trailing: const Icon(Icons.navigate_next),
            ),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 30),
              onTap: () {
                showAboutDialog(
                  context: context,
                  applicationIcon: const Icon(
                    Icons.feedback,
                    size: 50,
                    color: AppColor.primary,
                  ),
                  children: [
                    Form(
                      key: _formKeyFeedback,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: bodyController,
                            decoration: const InputDecoration(labelText: 'Feedback Body'),
                            maxLines: 3,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Feedback body is required';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          RatingBar.builder(
                            initialRating: rating,
                            minRating: 0,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemSize: 30,
                            itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                            itemBuilder: (context, index) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (newRating) {
                              setState(() {
                                rating = newRating;
                              });
                            },
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              if (_formKeyFeedback.currentState!.validate()) {
                                Navigator.pop(context);

                                submitFeedback(bodyController.text, rating);
                              }
                            },
                            child: const Text('Submit Feedback'),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
              dense: true,
              horizontalTitleGap: 0,
              leading: const Icon(Icons.feedback),
              title: const Text('Feedback'),
              trailing: const Icon(Icons.navigate_next),
            ),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 30),
              onTap: () {},
              dense: true,
              horizontalTitleGap: 0,
              leading: const Icon(Icons.support_agent),
              title: const Text('Support'),
              trailing: const Icon(Icons.navigate_next),
            ),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 30),
              onTap: () {
                showAboutDialog(
                  context: context,
                  applicationIcon: const Icon(
                    Icons.sports_soccer_outlined,
                    size: 50,
                    color: AppColor.primary,
                  ),
                  applicationName: 'FutsalNow',
                  applicationVersion: 'v1.0.0',
                  children: [
                    const Text('Application for booking futsal fields. \n===========================\n Develop by: Dede Sunarwan'),
                  ],
                );
              },
              dense: true,
              horizontalTitleGap: 0,
              leading: const Icon(Icons.info),
              title: const Text('About'),
              trailing: const Icon(Icons.navigate_next),
            ),
          ],
        );
      },
    );
  }
}
