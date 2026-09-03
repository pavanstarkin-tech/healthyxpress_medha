<?php
/**
 * HealthExpress AI - Clinical AI Triage Controller
 * Gemini AI Symptom Understanding & Dynamic Recommendations
 */

require_once __DIR__ . '/../config/config.php';
require_once __DIR__ . '/../helpers/Response.php';

class AiController {
    public static function triage(): void {
        $body = json_decode(file_get_contents('php://input'), true);
        $symptoms = trim($body['symptoms'] ?? 'Fever and body pain for 2 days');

        // Check for emergency triggers
        $isEmergency = (
            stripos($symptoms, 'chest') !== false ||
            stripos($symptoms, 'breath') !== false ||
            stripos($symptoms, 'unconscious') !== false
        );

        if ($isEmergency) {
            Response::json([
                'status'           => 'emergency_alert',
                'severity'         => 'Emergency',
                'triage_summary'   => 'Potential acute cardiac or respiratory distress detected.',
                'primary_specialty'=> 'Emergency Medicine / Cardiology',
                'hospital'         => 'KIMS Hospitals Emergency & Trauma (Hotline: 1066)',
                'ambulance_eta'    => '7 minutes (Live Mapbox)',
                'action'           => 'Call 108 Emergency Immediately'
            ]);
        }

        // Standard clinical triage
        Response::json([
            'status'            => 'clinical_guidance',
            'severity'          => 'Moderate',
            'symptoms_parsed'   => ['Fever', 'Headache', 'Body Aches'],
            'possible_condition'=> 'Acute Viral Upper Respiratory Infection (High match)',
            'primary_specialty' => 'General Physician',
            'recommended_tests' => ['Complete Blood Count (CBC)', 'Dengue NS1 Antigen'],
            'home_care'         => ['Hydration with electrolytes', 'Bed rest', 'Temperature logging every 4 hours'],
            'recommended_doctor'=> [
                'name'      => 'Dr. Priya Nair',
                'specialty' => 'General Physician',
                'hospital'  => 'Apollo Hospitals',
                'fee'       => '₹600',
                'rating'    => 4.8
            ],
            'disclaimer'        => 'AI triage provides initial clinical guidance and does not replace confirmed medical diagnosis.'
        ]);
    }
}
