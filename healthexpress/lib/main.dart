import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'providers/auth_provider.dart';
import 'providers/ai_assistant_provider.dart';
import 'providers/appointment_provider.dart';
import 'providers/pharmacy_provider.dart';
import 'providers/doctor_portal_provider.dart';
import 'providers/store_provider.dart';
import 'providers/offline_medical_slm_provider.dart';
import 'services/offline_health_grid_service.dart';
import 'services/explainable_clinical_ai_service.dart';
import 'services/emergency_medicine_hold_service.dart';
import 'services/government_scheme_service.dart';
import 'services/public_health_surveillance_service.dart';
import 'screens/common/splash_screen.dart';

import 'data/production_database.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  ProductionDatabase.syncWithLiveBackend();
  runApp(const SanjeevaniApp());
}

class SanjeevaniApp extends StatelessWidget {
  const SanjeevaniApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => AiAssistantProvider()),
        ChangeNotifierProvider(create: (_) => AppointmentProvider()),
        ChangeNotifierProvider(create: (_) => PharmacyProvider()),
        ChangeNotifierProvider(create: (_) => DoctorPortalProvider()),
        ChangeNotifierProvider(create: (_) => StoreProvider()),
        ChangeNotifierProvider(create: (_) => OfflineMedicalSlmProvider()),
        ChangeNotifierProvider(create: (_) => OfflineHealthGridService()),
        ChangeNotifierProvider(create: (_) => ExplainableClinicalAiService()),
        ChangeNotifierProvider(create: (_) => EmergencyMedicineHoldService()),
        ChangeNotifierProvider(create: (_) => GovernmentSchemeService()),
        ChangeNotifierProvider(create: (_) => PublicHealthSurveillanceService()),
      ],
      child: MaterialApp(
        title: 'Sanjeevani.AI',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const SplashScreen(),
      ),
    );
  }
}

/// Backward compatibility alias
typedef HealthExpressApp = SanjeevaniApp;
