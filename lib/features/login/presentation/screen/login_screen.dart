import 'dart:io';
import 'package:accompagnateur/features/login/presentation/bloc/login_bloc.dart';
import 'package:accompagnateur/service_locator.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widget/login_error_popover.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/screen_util.dart';
import '../widget/login_input.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController codeController;
  late TextEditingController pwdController;
  SharedPreferences preferences = locator();
  final _formKey = GlobalKey<FormState>();
  bool _isMounted = false;
  bool _showErrorPopover = false;
  String _errorMessage = "";

  @override
  void initState() {
    super.initState();
    codeController = TextEditingController();
    pwdController = TextEditingController();
    _isMounted = true;
  }

  @override
  void dispose() {
    _isMounted = false;
    codeController.dispose();
    pwdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(usecase: locator()),
      child: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            if (_isMounted) {
              Navigator.of(context).pushNamedAndRemoveUntil(
                AppRoutes.mainScreen,
                    (Route<dynamic> route) => false,
              );
            }
          } else if (state is LoginError) {
            if (_isMounted) {
              setState(() {
                _errorMessage = state.message;
                _showErrorPopover = true;
              });

              Future.delayed(Duration(seconds: 3), () {
                if (mounted) {
                  setState(() {
                    _showErrorPopover = false;
                  });
                }
              });
            }
          }
        },
        child: Scaffold(
          body: SafeArea(
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Container(
                    color: Colors.white,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: ScreenUtil.screenHeight / 15),
                            child: Center(
                              child: SvgPicture.asset(
                                "assets/images/logo_rond_bleu.svg",
                                height: ScreenUtil.screenHeight / 5,
                              ),
                            ),
                          ),
                          Container(
                            height: 120,
                            padding: const EdgeInsets.all(15.0),
                            child: AnimatedTextKit(
                              totalRepeatCount: 1,
                              animatedTexts: [
                                TypewriterAnimatedText(
                                  '''Bienvenu sur 5sur5sejour ! Veuillez saisir votre identifiant et votre mot de passe.''',
                                  textStyle: const TextStyle(
                                    fontFamily: AppStrings.fontName,
                                    fontSize: 20,
                                  ),
                                  cursor: "",
                                  speed: const Duration(milliseconds: 50),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                child: LoginInput(
                                  controller: codeController,
                                  labelText: "Code séjour",
                                  isPassword: false,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                child: LoginInput(
                                  controller: pwdController,
                                  labelText: "Mot de passe",
                                  isPassword: true,
                                ),
                              ),
                              LoginErrorPopover(
                                message: _errorMessage,
                                showError: _showErrorPopover,
                                onClose: () {
                                  setState(() {
                                    _showErrorPopover = false;
                                  });
                                },
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 10, left: 15, right: 15),
                            child: Builder(
                              builder: (context) {
                                return ElevatedButton(
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      BlocProvider.of<LoginBloc>(context).add(
                                        Login5sur5(
                                          userName: codeController.text.trim(),
                                          password: pwdController.text.trim(),
                                        ),
                                      );
                                    }
                                  },
                                  style: ButtonStyle(
                                    shape: MaterialStateProperty.resolveWith(
                                          (states) => RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                    fixedSize: MaterialStateProperty.resolveWith(
                                          (states) => Size.fromHeight(ScreenUtil.screenHeight / 15),
                                    ),
                                    elevation: MaterialStateProperty.resolveWith((states) => 5),
                                    backgroundColor: MaterialStateColor.resolveWith(
                                          (states) => AppColors.primaryColor,
                                    ),
                                  ),
                                  child: const Text(
                                    "Je me connecte",
                                    style: TextStyle(
                                      fontFamily: AppStrings.fontName,
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
