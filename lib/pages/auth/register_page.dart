import 'package:futsal_now_mobile/config/app_assets.dart';
import 'package:futsal_now_mobile/config/app_colors.dart';
import 'package:futsal_now_mobile/config/app_constants.dart';
import 'package:futsal_now_mobile/config/app_response.dart';
import 'package:futsal_now_mobile/config/failure.dart';
import 'package:futsal_now_mobile/datasources/user_datasource.dart';
import 'package:futsal_now_mobile/providers/register_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:d_input/d_input.dart';
import 'package:d_view/d_view.dart';
import 'package:d_button/d_button.dart';
import 'package:d_info/d_info.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final editName = TextEditingController();
  final editEmail = TextEditingController();
  final editPhone = TextEditingController();
  final editPassword = TextEditingController();
  final editPasswordConfirmation = TextEditingController();
  final formKey = GlobalKey<FormState>();

  execute() {
    bool validInput = formKey.currentState!.validate();
    if (!validInput) return;

    setRegisterStatus(ref, 'Loading');

    UserDatasource.register(
      editName.text,
      editEmail.text,
      editPhone.text,
      editPassword.text,
      editPasswordConfirmation.text,
    ).then((value) {
      String newStatus = '';

      value.fold(
        (failure) {
          switch (failure.runtimeType) {
            case ServerFailure:
              newStatus = 'Server Error';
              DInfo.toastError(newStatus);
              break;
            case NotFoundFailure:
              newStatus = 'Error Not Found';
              DInfo.toastError(newStatus);
              break;
            case ForbiddenFailure:
              newStatus = 'You Don\'t Have Access';
              DInfo.toastError(newStatus);
              break;
            case BadRequestFailure:
              newStatus = 'Bad Request';
              DInfo.toastError(newStatus);
              break;
            case InvalidInputFailure:
              newStatus = 'Invalid Input';
              AppResponse.invalidInput(context, failure.message ?? '{}');
              break;
            case UnauthorisedFailure:
              newStatus = 'Unauthorized';
              DInfo.toastError(newStatus);
              break;
            default:
              newStatus = 'Request Error';
              DInfo.toastError(newStatus);
              newStatus = failure.message ?? '-';
              break;
          }

          setRegisterStatus(ref, newStatus);
        },
        (result) {
          DInfo.toastSuccess('Register Success');

          setRegisterStatus(ref, 'Register Success');
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            AppAssets.bgAuth,
            fit: BoxFit.cover,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height / 1,
              decoration: const BoxDecoration(
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
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 60, 30, 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Column(
                    children: [
                      Text(
                        AppConstants.appName,
                        style: GoogleFonts.poppins(
                          fontSize: 40,
                          color: Colors.blue[900],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Container(
                        height: 5,
                        width: 40,
                        decoration: BoxDecoration(
                          color: AppColor.primary.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ],
                  ),
                ),
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      IntrinsicHeight(
                        child: Row(
                          children: [
                            AspectRatio(
                              aspectRatio: 1,
                              child: Material(
                                color: Colors.white70,
                                borderRadius: BorderRadius.circular(10),
                                child: const Icon(
                                  Icons.person,
                                  color: AppColor.primary,
                                ),
                              ),
                            ),
                            DView.width(10),
                            Expanded(
                              child: DInput(
                                controller: editName,
                                fillColor: Colors.white70,
                                hint: 'Name',
                                radius: BorderRadius.circular(10),
                                validator: (input) => input == '' ? "Don't empty" : null,
                              ),
                            ),
                          ],
                        ),
                      ),
                      DView.height(16),
                      IntrinsicHeight(
                        child: Row(
                          children: [
                            AspectRatio(
                              aspectRatio: 1,
                              child: Material(
                                color: Colors.white70,
                                borderRadius: BorderRadius.circular(10),
                                child: const Icon(
                                  Icons.email,
                                  color: AppColor.primary,
                                ),
                              ),
                            ),
                            DView.width(10),
                            Expanded(
                              child: DInput(
                                controller: editEmail,
                                fillColor: Colors.white70,
                                hint: 'Email',
                                radius: BorderRadius.circular(10),
                                validator: (input) => input == '' ? "Don't empty" : null,
                              ),
                            ),
                          ],
                        ),
                      ),
                      DView.height(16),
                      IntrinsicHeight(
                        child: Row(
                          children: [
                            AspectRatio(
                              aspectRatio: 1,
                              child: Material(
                                color: Colors.white70,
                                borderRadius: BorderRadius.circular(10),
                                child: const Icon(
                                  Icons.phone_android,
                                  color: AppColor.primary,
                                ),
                              ),
                            ),
                            DView.width(10),
                            Expanded(
                              child: DInput(
                                controller: editPhone,
                                fillColor: Colors.white70,
                                inputType: TextInputType.phone,
                                hint: 'Phone',
                                radius: BorderRadius.circular(10),
                                validator: (input) => input == '' ? "Don't empty" : null,
                              ),
                            ),
                          ],
                        ),
                      ),
                      DView.height(16),
                      IntrinsicHeight(
                        child: Row(
                          children: [
                            AspectRatio(
                              aspectRatio: 1,
                              child: Material(
                                color: Colors.white70,
                                borderRadius: BorderRadius.circular(10),
                                child: const Icon(
                                  Icons.lock,
                                  color: AppColor.primary,
                                ),
                              ),
                            ),
                            DView.width(10),
                            Expanded(
                              child: DInputPassword(
                                controller: editPassword,
                                fillColor: Colors.white70,
                                hint: 'Password',
                                radius: BorderRadius.circular(10),
                                validator: (input) => input == '' ? "Don't empty" : null,
                              ),
                            ),
                          ],
                        ),
                      ),
                      DView.height(16),
                      IntrinsicHeight(
                        child: Row(
                          children: [
                            AspectRatio(
                              aspectRatio: 1,
                              child: Material(
                                color: Colors.white70,
                                borderRadius: BorderRadius.circular(10),
                                child: const Icon(
                                  Icons.lock,
                                  color: AppColor.primary,
                                ),
                              ),
                            ),
                            DView.width(10),
                            Expanded(
                              child: DInputPassword(
                                controller: editPasswordConfirmation,
                                fillColor: Colors.white70,
                                hint: 'Password Confirmation',
                                radius: BorderRadius.circular(10),
                                validator: (input) => input == '' ? "Don't empty" : null,
                              ),
                            ),
                          ],
                        ),
                      ),
                      DView.height(16),
                      IntrinsicHeight(
                        child: Row(
                          children: [
                            AspectRatio(
                              aspectRatio: 1,
                              child: DButtonFlat(
                                onClick: () {
                                  Navigator.pop(context);
                                },
                                padding: const EdgeInsets.all(0),
                                radius: 10,
                                mainColor: Colors.white70,
                                child: const Text(
                                  'LOG',
                                  style: TextStyle(
                                    color: AppColor.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            DView.width(10),
                            Expanded(
                              child: Consumer(
                                builder: (_, wiRef, __) {
                                  String status = wiRef.watch(registerStatusProvider);

                                  if (status == 'Loading') {
                                    return DView.loadingCircle();
                                  }

                                  return ElevatedButton(
                                    onPressed: () => execute(),
                                    style: const ButtonStyle(
                                      alignment: Alignment.centerLeft,
                                    ),
                                    child: const Text('Register'),
                                  );
                                },
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
        ],
      ),
    );
  }
}
