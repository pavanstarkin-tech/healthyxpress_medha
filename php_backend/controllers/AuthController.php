<?php
/**
 * HealthExpress AI - Auth Controller
 * Minimal Registration (Name + Mobile) & Aarogyasri Lookups
 */

require_once __DIR__ . '/../config/database.php';
require_once __DIR__ . '/../helpers/Response.php';

class AuthController {
    public static function register(): void {
        $body = json_decode(file_get_contents('php://input'), true);

        $name = trim($body['name'] ?? '');
        $phone = trim($body['phone'] ?? $body['mobile'] ?? '');
        $email = trim($body['email'] ?? '');
        $role = trim($body['role'] ?? 'patient');

        if (empty($name) || empty($phone)) {
            Response::error('Name and Mobile number are required for minimal registration', 400);
        }

        $pdo = Database::getConnection();

        // Check if user already exists
        $stmt = $pdo->prepare("SELECT * FROM users WHERE phone = ? LIMIT 1");
        $stmt->execute([$phone]);
        $existing = $stmt->fetch();

        if ($existing) {
            Response::json($existing, 200, 'User already registered');
        }

        $userId = 'USR-' . rand(100000, 999999);
        $aarogyasriId = 'AROG' . rand(10000000, 99999999);

        $pdo->beginTransaction();
        try {
            $insertUser = $pdo->prepare("INSERT INTO users (id, name, phone, email, role, aarogyasri_id, created_at) VALUES (?, ?, ?, ?, ?, ?, NOW())");
            $insertUser->execute([$userId, $name, $phone, $email, $role, $aarogyasriId]);

            // Initial health profile
            $insertProfile = $pdo->prepare("INSERT INTO health_profiles (user_id, blood_group, completion_percent, created_at) VALUES (?, 'B+', 40, NOW())");
            $insertProfile->execute([$userId]);

            $pdo->commit();

            Response::json([
                'id'             => $userId,
                'name'           => $name,
                'phone'          => $phone,
                'email'          => $email,
                'role'           => $role,
                'aarogyasri_id'  => $aarogyasriId,
                'profile_percent'=> 40
            ], 201, 'Registration successful');
        } catch (Exception $e) {
            $pdo->rollBack();
            error_log("Register Error: " . $e->getMessage());
            Response::error('Registration failed. Please try again.', 500);
        }
    }

    public static function getAarogyasriProfile(string $aarogyasriId): void {
        $pdo = Database::getConnection();

        $stmt = $pdo->prepare("SELECT 
            u.id, u.name, u.phone, u.aarogyasri_id,
            hp.blood_group, hp.allergies, hp.past_surgeries, hp.current_medications, hp.completion_percent
        FROM users u
        LEFT JOIN health_profiles hp ON u.id = hp.user_id
        WHERE u.aarogyasri_id = ?
        LIMIT 1");

        $stmt->execute([$aarogyasriId]);
        $user = $stmt->fetch();

        if (!$user) {
            Response::error('Aarogyasri Health Pass ID not found', 404);
        }

        Response::json($user);
    }
}
