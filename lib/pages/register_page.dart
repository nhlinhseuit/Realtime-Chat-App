import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:mobie_ticket_app/const.dart';
import 'package:mobie_ticket_app/models/user_profile.dart';
import 'package:mobie_ticket_app/services/alert_service.dart';
import 'package:mobie_ticket_app/services/auth_service.dart';
import 'package:mobie_ticket_app/services/database_service.dart';
import 'package:mobie_ticket_app/services/media_service.dart';
import 'package:mobie_ticket_app/services/navigation_service.dart';
import 'package:mobie_ticket_app/services/storage_service.dart';
import 'package:mobie_ticket_app/widgets/custom_form_field.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GetIt _getIt = GetIt.instance;
  final GlobalKey<FormState> _registerFormKey = GlobalKey();

  late AuthService _authService;
  late NavigationService _navigationService;
  late AlertService _alertService;
  late MediaService _mediaService;
  late StorageService _storageService;
  late DatabaseService _databaseService;

  File? selectedImage;

  bool isLoading = false;

  String? email, password, name;

  @override
  void initState() {
    super.initState();
    _authService = _getIt.get<AuthService>();
    _navigationService = _getIt.get<NavigationService>();
    _alertService = _getIt.get<AlertService>();
    _mediaService = _getIt.get<MediaService>();
    _storageService = _getIt.get<StorageService>();
    _databaseService = _getIt.get<DatabaseService>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return SafeArea(
        child: Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 20,
      ),
      child: Column(
        children: [
          _headerText(),
          if (!isLoading) _registerForm(),
          if (!isLoading) _loginAccountLink(),
          if (isLoading)
            const Expanded(
                child: Center(
              child: CircularProgressIndicator(),
            ))
        ],
      ),
    ));
  }

  Widget _headerText() {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: const Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Let\'s get going!',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            'Register a account using the form below',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _registerForm() {
    return Container(
      height: MediaQuery.sizeOf(context).height * 0.6,
      margin: EdgeInsets.symmetric(
          vertical: MediaQuery.sizeOf(context).height * 0.05),
      child: Form(
        key: _registerFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _pfpSelectionField(),
            CustomFormField(
              onSaved: (value) {
                setState(() {
                  name = value;
                });
              },
              hintText: 'Name',
              validdationRegEx: nameValidationRegex,
              height: MediaQuery.sizeOf(context).height * 0.1,
            ),
            CustomFormField(
              onSaved: (value) {
                setState(() {
                  email = value;
                });
              },
              hintText: 'Email',
              validdationRegEx: emailValidationRegex,
              height: MediaQuery.sizeOf(context).height * 0.1,
            ),
            CustomFormField(
              onSaved: (value) {
                setState(() {
                  password = value;
                });
              },
              hintText: 'Password',
              obscureText: true,
              validdationRegEx: passwordValidationRegex,
              height: MediaQuery.sizeOf(context).height * 0.1,
            ),
            _registerButton(),
          ],
        ),
      ),
    );
  }

  Widget _pfpSelectionField() {
    return GestureDetector(
      onTap: () async {
        File? file = await _mediaService.getImageFromGallery();
        if (file != null) {
          setState(() {
            selectedImage = file;
          });
        }
      },
      child: CircleAvatar(
        radius: MediaQuery.sizeOf(context).width * 0.1,
        backgroundImage: selectedImage != null
            ? FileImage(selectedImage!)
            : const NetworkImage(placeholderPFP) as ImageProvider,
      ),
    );
  }

  Widget _registerButton() {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: MaterialButton(
        onPressed: () async {
          setState(() {
            isLoading = true;
          });
          try {
            if ((_registerFormKey.currentState?.validate() ?? false) &&
                selectedImage != null) {
              _registerFormKey.currentState?.save();

              // create user
              bool result = await _authService.signup(email!, password!);

              if (result) {
                // upload image then get url
                String? pfpUrl = await _storageService.uploadUserPfp(
                  file: selectedImage!,
                  uid: _authService.user!.uid,
                );

                if (pfpUrl != null) {
                  // store new user infor in database
                  await _databaseService.createUserProfile(
                    userProfile: UserProfile(
                      uid: _authService.user!.uid,
                      name: name,
                      pfpUrl: pfpUrl,
                    ),
                  );

                  _alertService.showToast(
                    text: 'User registered successfully!',
                    icon: Icons.check,
                  );

                  _navigationService.goBack();
                  _navigationService.pushReplacementNamed('/home');
                } else {
                  throw Exception('Unable to upload user profile picture');
                }
              } else {
                throw Exception('Unable to register new user!');
              }
            }
          } catch (e) {
            debugPrint('Register fail $e');
            _alertService.showToast(
              text: 'Failed to sign up, please try again!',
              icon: Icons.error,
            );
          }
          setState(() {
            isLoading = false;
          });
        },
        color: Theme.of(context).colorScheme.primary,
        child: const Text(
          'Register',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _loginAccountLink() {
    return Expanded(
        child: Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Text(
          'Don\'t have an account? ',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        GestureDetector(
          onTap: () {
            _navigationService.goBack();
          },
          child: const Text(
            'Log in',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    ));
  }
}
