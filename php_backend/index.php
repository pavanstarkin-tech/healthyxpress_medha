<?php
/**
 * HealthExpress AI - PHP 8+ Front Controller & REST Router
 * Hostinger Production Architecture
 */

require_once __DIR__ . '/middleware/CorsMiddleware.php';
require_once __DIR__ . '/helpers/Response.php';

// Apply CORS headers to every request
CorsMiddleware::handle();

// Controllers
require_once __DIR__ . '/controllers/AdminController.php';
require_once __DIR__ . '/controllers/AuthController.php';
require_once __DIR__ . '/controllers/HospitalController.php';
require_once __DIR__ . '/controllers/DoctorController.php';
require_once __DIR__ . '/controllers/AppointmentController.php';
require_once __DIR__ . '/controllers/PaymentController.php';
require_once __DIR__ . '/controllers/TelehealthController.php';
require_once __DIR__ . '/controllers/PharmacyController.php';
require_once __DIR__ . '/controllers/ConsentController.php';
require_once __DIR__ . '/controllers/ChatController.php';
require_once __DIR__ . '/controllers/HealthRecordController.php';
require_once __DIR__ . '/controllers/TicketController.php';
require_once __DIR__ . '/controllers/AiController.php';

// Parse Request URI and Method
$requestUri = $_SERVER['REQUEST_URI'];
$method = $_SERVER['REQUEST_METHOD'];

// Strip query string and base directory if applicable
$parsedUrl = parse_url($requestUri);
$path = rtrim($parsedUrl['path'], '/');

// Normalize API Path
if (strpos($path, '/api') !== false) {
    $path = substr($path, strpos($path, '/api'));
}

// -------------------------------------------------------------
// REST API ROUTING TABLE
// -------------------------------------------------------------

// Health Check
if ($path === '/api/health' && $method === 'GET') {
    require_once __DIR__ . '/config/database.php';
    try {
        $pdo = Database::getConnection();
        $pdo->query("SELECT 1");
        Response::json([
            'status'   => 'healthy',
            'database' => 'connected_live_mysql',
            'host'     => DB_HOST,
            'time'     => date('Y-m-d H:i:s')
        ]);
    } catch (Exception $e) {
        Response::error('Database unreachable: ' . $e->getMessage(), 500);
    }
}

// 1. Admin Operations & Ledgers
if ($path === '/api/admin/stats' && $method === 'GET') {
    AdminController::getStats();
}
if ($path === '/api/admin/hospital-rankings' && $method === 'GET') {
    AdminController::getHospitalRankings();
}
if ($path === '/api/admin/consultation-distribution' && $method === 'GET') {
    AdminController::getConsultationDistribution();
}
if ($path === '/api/admin/activity-logs' && $method === 'GET') {
    AdminController::getActivityLogs();
}
if ($path === '/api/users' && $method === 'GET') {
    AdminController::getUsers();
}
if ($path === '/api/payments' && $method === 'GET') {
    AdminController::getPayments();
}

// 2. Authentication & Aarogyasri
if ($path === '/api/auth/register' && $method === 'POST') {
    AuthController::register();
}
if (preg_match('#^/api/auth/aarogyasri/([^/]+)$#', $path, $matches) && $method === 'GET') {
    AuthController::getAarogyasriProfile($matches[1]);
}

// 3. Hospitals
if ($path === '/api/hospitals' && $method === 'GET') {
    HospitalController::getAll();
}
if ($path === '/api/hospitals' && $method === 'POST') {
    HospitalController::create();
}
if (preg_match('#^/api/hospitals/([^/]+)$#', $path, $matches) && $method === 'GET') {
    HospitalController::getById($matches[1]);
}

// 4. Doctors
if ($path === '/api/doctors' && $method === 'GET') {
    DoctorController::getAll();
}
if (preg_match('#^/api/doctors/([^/]+)/status$#', $path, $matches) && $method === 'PUT') {
    DoctorController::toggleStatus($matches[1]);
}
if (preg_match('#^/api/doctors/([^/]+)/verify$#', $path, $matches) && $method === 'PUT') {
    DoctorController::updateVerificationStatus($matches[1]);
}
if (preg_match('#^/api/doctors/([^/]+)$#', $path, $matches) && $method === 'GET') {
    DoctorController::getById($matches[1]);
}

// 5. Appointments
if ($path === '/api/appointments' && $method === 'GET') {
    AdminController::getAllAppointments();
}
if (preg_match('#^/api/appointments/user/([^/]+)$#', $path, $matches) && $method === 'GET') {
    AppointmentController::getUserAppointments($matches[1]);
}
if (preg_match('#^/api/appointments/doctor/([^/]+)$#', $path, $matches) && $method === 'GET') {
    AppointmentController::getDoctorAppointments($matches[1]);
}
if ($path === '/api/appointments/book' && $method === 'POST') {
    AppointmentController::book();
}
if (preg_match('#^/api/appointments/([^/]+)/reschedule$#', $path, $matches) && $method === 'PUT') {
    AppointmentController::reschedule($matches[1]);
}
if (preg_match('#^/api/appointments/([^/]+)/prescription$#', $path, $matches) && $method === 'PUT') {
    AppointmentController::issuePrescription($matches[1]);
}

// 6. Payments
if ($path === '/api/payments/create-order' && $method === 'POST') {
    PaymentController::createOrder();
}
if ($path === '/api/payments/verify' && $method === 'POST') {
    PaymentController::verifySignature();
}

// 7. Telehealth & Agora
if ($path === '/api/telehealth/generate-agora-token' && $method === 'POST') {
    TelehealthController::generateToken();
}

// 8. Pharmacy & 15-min Delivery
if ($path === '/api/pharmacy/medicines' && $method === 'GET') {
    PharmacyController::getMedicines();
}
if ($path === '/api/pharmacy/order' && $method === 'POST') {
    PharmacyController::createOrder();
}

// 9. ABDM QR Consent
if ($path === '/api/consent/generate-token' && $method === 'POST') {
    ConsentController::generateToken();
}
if ($path === '/api/consent/doctor-scan' && $method === 'POST') {
    ConsentController::doctorScan();
}

// 10. Chat
if ($path === '/api/chat/send' && $method === 'POST') {
    ChatController::sendMessage();
}
if ($path === '/api/chat/history' && $method === 'GET') {
    ChatController::getHistory();
}

// 11. Health Records & Progressive Onboarding
if ($path === '/api/health-records/upload' && $method === 'POST') {
    HealthRecordController::upload();
}
if (preg_match('#^/api/health-records/user/([^/]+)$#', $path, $matches) && $method === 'GET') {
    HealthRecordController::getUserRecords($matches[1]);
}
if ($path === '/api/health-records/onboarding/complete' && $method === 'PUT') {
    HealthRecordController::completeOnboarding();
}

// 12. Support Tickets
if ($path === '/api/tickets' && $method === 'GET') {
    TicketController::getAll();
}
if ($path === '/api/tickets' && $method === 'POST') {
    TicketController::create();
}

// 13. AI Triage
if ($path === '/api/ai/triage' && $method === 'POST') {
    AiController::triage();
}

// Fallback: 404 Route Not Found
Response::error("Endpoint not found: $method $path", 404);
