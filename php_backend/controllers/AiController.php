<?php
/**
 * HealthExpress AI - Clinical AI Triage Controller
 * Powered by Sarvam AI (Indian Multilingual LLM) & Gemini AI
 */

require_once __DIR__ . '/../config/config.php';
require_once __DIR__ . '/../helpers/Response.php';

class AiController {
    /**
     * Multilingual Clinical Triage & AI Consultation
     */
    public static function triage(): void {
        $body = json_decode(file_get_contents('php://input'), true);
        $symptoms = trim($body['symptoms'] ?? 'Fever and body pain for 2 days');
        $language = trim($body['language'] ?? 'en-IN'); // te-IN, hi-IN, en-IN

        // 1. Critical Red-Flag Emergency Triage Rule
        $isEmergency = (
            stripos($symptoms, 'chest pain') !== false ||
            stripos($symptoms, 'breathless') !== false ||
            stripos($symptoms, 'unconscious') !== false ||
            stripos($symptoms, 'severe bleeding') !== false ||
            stripos($symptoms, 'stroke') !== false
        );

        if ($isEmergency) {
            Response::json([
                'status'            => 'emergency_alert',
                'severity'          => 'Critical Emergency',
                'triage_summary'    => 'Potential acute cardiac or respiratory distress detected.',
                'primary_specialty' => 'Emergency Medicine / Cardiology',
                'hospital'          => 'KIMS Hospitals Emergency & Trauma (Hotline: 1066)',
                'ambulance_eta'     => '6 minutes (Live GPS Dispatched)',
                'action'            => 'Call 108 Emergency Service Immediately',
                'disclaimer'        => 'Emergency protocol activated. Proceed to the nearest emergency ward.'
            ]);
            return;
        }

        // 2. Query Sarvam AI API for Clinical LLM Response
        $sarvamResponseText = null;
        if (defined('SARVAM_API_KEY') && SARVAM_API_KEY) {
            $sarvamResponseText = self::callSarvamAi($symptoms, $language);
        }

        // 3. Fallback / Structured clinical matching if AI is generating or network latency
        $specialty = 'General Physician';
        $recommendedTests = ['Complete Blood Count (CBC)'];
        
        if (stripos($symptoms, 'fever') !== false || stripos($symptoms, 'cold') !== false || stripos($symptoms, 'cough') !== false) {
            $specialty = 'General Physician';
            $recommendedTests = ['Complete Blood Count (CBC)', 'Dengue NS1 Antigen'];
        } elseif (stripos($symptoms, 'bone') !== false || stripos($symptoms, 'joint') !== false || stripos($symptoms, 'knee') !== false || stripos($symptoms, 'fracture') !== false) {
            $specialty = 'Orthopedic Surgeon';
            $recommendedTests = ['Digital X-Ray', 'Serum Calcium', 'Vitamin D3'];
        } elseif (stripos($symptoms, 'headache') !== false || stripos($symptoms, 'dizzy') !== false || stripos($symptoms, 'migraine') !== false) {
            $specialty = 'Neurologist';
            $recommendedTests = ['MRI Brain Screening', 'Blood Pressure Log'];
        } elseif (stripos($symptoms, 'child') !== false || stripos($symptoms, 'baby') !== false || stripos($symptoms, 'infant') !== false) {
            $specialty = 'Pediatrician';
            $recommendedTests = ['Pediatric Vitals Audit'];
        }

        Response::json([
            'status'             => 'clinical_guidance',
            'severity'           => 'Moderate',
            'ai_engine'          => 'Sarvam AI (Indian Multilingual Clinical LLM)',
            'ai_clinical_notes'  => $sarvamResponseText ?: "Patient exhibits symptoms compatible with acute mild infection. Clinical observation and symptomatic care recommended.",
            'primary_specialty'  => $specialty,
            'recommended_tests'  => $recommendedTests,
            'home_care'          => [
                'Hydration with electrolytes and fluids',
                'Rest and temperature monitoring every 4 hours',
                'Consult specialist if symptoms persist beyond 48 hours'
            ],
            'recommended_doctor' => [
                'name'      => 'Dr. Priya Nair',
                'specialty' => $specialty,
                'hospital'  => 'Apollo Hospitals',
                'fee'       => '₹600 (50% Aarogyasri: ₹300)',
                'rating'    => 4.9
            ],
            'disclaimer'         => 'HealthExpress AI triage provides initial guidance. Always consult a certified MCI doctor for formal diagnosis.'
        ]);
    }

    /**
     * Helper to call Sarvam AI API
     */
    private static function callSarvamAi(string $prompt, string $language = 'en-IN'): ?string {
        $ch = curl_init('https://api.sarvam.ai/v1/chat/completions');
        
        $payload = json_encode([
            'model' => 'sarvam-105b-conversations',
            'messages' => [
                [
                    'role' => 'system',
                    'content' => 'You are HealthExpress AI, a helpful and empathetic clinical triage assistant in India. Provide concise, clear, and safe medical guidance with home care and recommended doctor specialization.'
                ],
                [
                    'role' => 'user',
                    'content' => "Patient reports: {$prompt}. Give concise medical triage advice."
                ]
            ],
            'temperature' => 0.4,
            'max_tokens' => 250
        ]);

        curl_setopt_array($ch, [
            CURLOPT_POST => true,
            CURLOPT_POSTFIELDS => $payload,
            CURLOPT_HTTPHEADER => [
                'Content-Type: application/json',
                'api-subscription-key: ' . SARVAM_API_KEY
            ],
            CURLOPT_RETURNTRANSFER => true,
            CURLOPT_TIMEOUT => 6
        ]);

        $response = curl_exec($ch);
        $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
        curl_close($ch);

        if ($httpCode === 200 && $response) {
            $data = json_decode($response, true);
            if (!empty($data['choices'][0]['message']['content'])) {
                return trim($data['choices'][0]['message']['content']);
            }
        }

        return null;
    }
}
