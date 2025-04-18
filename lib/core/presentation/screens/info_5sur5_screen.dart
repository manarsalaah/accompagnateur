import 'package:flutter/material.dart';
import 'package:accompagnateur/core/utils/app_colors.dart';

class Infos5Sur5Screen extends StatelessWidget {
  const Infos5Sur5Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        iconTheme: IconThemeData(
          color: Colors.white, // Change the back arrow color to white
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  "5sur5 Séjour",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "5sur5sejour est la plateforme sécurisée dédiée aux séjours scolaires, colonies, camps de vacances ou séjours à l'étranger.",
                style: TextStyle(fontSize: 16, color: Colors.black87),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 8),
              Text(
                "Notre plateforme 5sur5sejour.com vous permettra de déposer vos photos et vidéos, vos messages audio, et de localiser vos activités sur une carte. Les parents pourront suivre le séjour de leurs enfants grâce au code séjour que vous leur aurez transmis. Pour vous, un outil simple, intuitif et sécurisé. Pour les parents, un outil de création facile à utiliser pour des tirages de qualité.",
                style: TextStyle(fontSize: 16, color: Colors.black87),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 24),
              Text(
                "Contact",
                style: TextStyle(
                  color: AppColors.primaryColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.location_city, color: AppColors.primaryColor),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "Trust Conseils\n199 Avenue Francis de Pressensé\n69200 Vénissieux",
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.phone, color: AppColors.primaryColor),
                  const SizedBox(width: 8),
                  Text(
                    "05 36 28 29 30",
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.email, color: AppColors.primaryColor),
                  const SizedBox(width: 8),
                  Text(
                    "contact@5sur5sejour.com",
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
