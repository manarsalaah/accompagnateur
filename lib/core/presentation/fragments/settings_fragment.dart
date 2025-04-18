import 'package:accompagnateur/core/presentation/bloc/settings/settings_bloc.dart';
import 'package:accompagnateur/core/presentation/user_info_getter/user_info_getter_bloc.dart';
import 'package:accompagnateur/core/utils/app_colors.dart';
import 'package:accompagnateur/service_locator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../features/login/presentation/screen/login_screen.dart';
import '../../routes/app_routes.dart';
import '../../utils/app_strings.dart';
import '../screens/pdf_viewer_screen.dart';
import '../widgets/error_popover.dart';

class SettingsFragment extends StatefulWidget {
  const SettingsFragment({super.key});

  @override
  State<SettingsFragment> createState() => _SettingsFragmentState();
}

class _SettingsFragmentState extends State<SettingsFragment> {
  bool isSejourEditMode = false;
  bool isAccompagnateurEditMode = false;
  TextEditingController sejourCodeController = TextEditingController();
  TextEditingController sejourThemeController = TextEditingController();
  TextEditingController dateDebController = TextEditingController();
  TextEditingController dateFinController = TextEditingController();
  TextEditingController nbEnfantController = TextEditingController();
  TextEditingController nomController = TextEditingController();
  TextEditingController prenomController = TextEditingController();
  TextEditingController numeroController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadInitialValues();
  }

  Future<void> _loadInitialValues() async {
    SharedPreferences prefs = locator();
    sejourCodeController.text = prefs.getString(AppStrings.codeSejourKey)!;
    sejourThemeController.text = prefs.getString(AppStrings.themeSejourKey)!;
    dateDebController.text = prefs.getString(AppStrings.dateDebStringKey)!.substring(0, 11); // to get only yyyy-mm-dd
    dateFinController.text = prefs.getString(AppStrings.dateFinStringKey)!.substring(0, 11); // to get only yyyy-mm-dd
    nbEnfantController.text = prefs.getInt(AppStrings.nbEnfantKey)!.toString();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<SettingsBloc, SettingsState>(
          listener: (context, state) {
            if (state is SettingsError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  content: ErrorPopover(
                    message: state.errorMsg,
                    onClose: () {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    },
                  ),
                  duration: Duration(seconds: 3),
                ),
              );
            }
            if (state is UnAuthorized) {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                    (Route<dynamic> route) => false,
              );
            }
            if (state is DocumentDownloaded) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: AppColors.primaryColor,
                  content: Text(
                    "Document téléchargé avec succès",
                    style: TextStyle(color: Colors.white, fontFamily: AppStrings.fontName),
                  ),
                  duration: Duration(seconds: 2),
                ),
              );
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => PdfViewerScreen(pdfData: state.pdfData!,),
                ),
              );
            }
            if (state is EditSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: AppColors.primaryColor,
                  content: Text(
                    "Informations mises à jour avec succès",
                    style: TextStyle(color: Colors.white, fontFamily: AppStrings.fontName),
                  ),
                  duration: Duration(seconds: 2),
                ),
              );
              context.read<UserInfoGetterBloc>().add(GetUserInfo());
            }
          },
        ),
        BlocListener<UserInfoGetterBloc, UserInfoGetterState>(
          listener: (context, state) {
            if (state is Success) {
              emailController.text = state.email;
              nomController.text = state.nom;
              prenomController.text = state.prenom;
              numeroController.text = state.num;
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Infos de séjour",
                            style: TextStyle(fontSize: 16, color: AppColors.primaryColor),
                          ),
                          Visibility(
                            visible: false,
                            child: IconButton(
                              onPressed: () {
                                setState(() {
                                  isSejourEditMode = !isSejourEditMode;
                                });
                              },
                              icon: Icon(
                                isSejourEditMode ? Icons.edit_off : Icons.edit_outlined,
                                color: AppColors.primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: sejourCodeController,
                        enabled: isSejourEditMode,
                        decoration: InputDecoration(
                          labelText: "Code séjour",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: sejourThemeController,
                        enabled: isSejourEditMode,
                        decoration: InputDecoration(
                          labelText: "Thème du séjour",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: dateDebController,
                        enabled: isSejourEditMode,
                        decoration: InputDecoration(
                          labelText: "Date début du séjour",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: dateFinController,
                        enabled: isSejourEditMode,
                        decoration: InputDecoration(
                          labelText: "Date fin du séjour",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: nbEnfantController,
                        enabled: isSejourEditMode,
                        decoration: InputDecoration(
                          labelText: "Nombre d'enfant",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Infos accompagnateur",
                            style: TextStyle(fontSize: 16, color: AppColors.primaryColor),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                isAccompagnateurEditMode = !isAccompagnateurEditMode;
                              });
                            },
                            icon: Icon(
                              isAccompagnateurEditMode ? Icons.edit_off : Icons.edit_outlined,
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ],
                      ),
                      TextField(
                        controller: nomController,
                        enabled: isAccompagnateurEditMode,
                        decoration: InputDecoration(
                          labelText: "Nom de l'accompagnateur",
                          hintText: "Entrez le nom de l'accompagnateur",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: prenomController,
                        enabled: isAccompagnateurEditMode,
                        decoration: InputDecoration(
                          labelText: "Prénom de l'accompagnateur",
                          hintText: "Entrez le prénom de l'accompagnateur",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: numeroController,
                        enabled: isAccompagnateurEditMode,
                        decoration: InputDecoration(
                          labelText: "numéro de téléphone de l'accompagnateur",
                          hintText: "Entrez le numéro de téléphone de l'accompagnateur",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: emailController,
                        enabled: isAccompagnateurEditMode,
                        decoration: InputDecoration(
                          labelText: "Email de l'accompagnateur",
                          hintText: "Entrez l'email de l'accompagnateur",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {
                                BlocProvider.of<SettingsBloc>(context).add(DownloadPdf(type: 'accomp'));
                              },
                              icon: Icon(Icons.download, color: Colors.white),
                              label: Text(
                                "Télécharger document accompagnateur",
                                style: TextStyle(color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryColor,
                              ),
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton.icon(
                              onPressed: () {
                                BlocProvider.of<SettingsBloc>(context).add(DownloadPdf(type: 'parent'));
                              },
                              icon: Icon(Icons.download, color: Colors.white),
                              label: Text(
                                "Télécharger document parent",
                                style: TextStyle(color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryColor,
                              ),
                            ),
                           /* const SizedBox(height: 10),
                            ElevatedButton.icon(
                              onPressed: () async{
                                SharedPreferences preferences = locator();
                               await preferences.setBool(AppStrings.isConnectedKey, false);
                                Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.loginScreen,(Route<dynamic> route) => false);
                              },
                              icon: Icon(Icons.logout, color: Colors.white),
                              label: Text(
                                "Déconnecter",
                                style: TextStyle(color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryColor,
                              ),
                            ),*/
                            const SizedBox(height: 20),
                            Visibility(
                              visible: isSejourEditMode || isAccompagnateurEditMode,
                              child: ElevatedButton(
                                onPressed: () {
                                  BlocProvider.of<SettingsBloc>(context).add(EditUserInfo(prenom: prenomController.text.trim(), nom: nomController.text.trim(), num: numeroController.text.trim(), email: emailController.text.trim()));
                                  setState(() {
                                    isSejourEditMode = false;
                                    isAccompagnateurEditMode = false;
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryColor,
                                ),
                                child: Text(
                                  "Enregistrer",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}