<?php
/**
 * HealthExpress AI - Doctor Controller
 * Live Doctor Discovery, Credentialing, Approvals & Schedules
 */

require_once __DIR__ . '/../config/database.php';
require_once __DIR__ . '/../helpers/Response.php';

class DoctorController {
    /**
     * Get All Doctors with Hospital Affiliation
     */
    public static function getAll(): void {
        $pdo = Database::getConnection();

        $query = "SELECT 
            d.*,
            COALESCE(h.name, 'Independent Practice') AS hospital_name,
            h.id AS hospital_id,
            h.city AS hospital_city
        FROM doctors d
        LEFT JOIN doctor_hospitals dh ON d.id = dh.doctor_id AND dh.is_primary = 1
        LEFT JOIN hospitals h ON dh.hospital_id = h.id
        ORDER BY d.created_at DESC";

        $stmt = $pdo->query($query);
        $doctors = $stmt->fetchAll();

        Response::json($doctors);
    }

    /**
     * Get Doctor Details by ID
     */
    public static function getById(string $id): void {
        $pdo = Database::getConnection();

        $stmt = $pdo->prepare("SELECT 
            d.*,
            COALESCE(h.name, 'Independent Practice') AS hospital_name,
            h.id AS hospital_id,
            h.address AS hospital_address,
            h.city AS hospital_city
        FROM doctors d
        LEFT JOIN doctor_hospitals dh ON d.id = dh.doctor_id AND dh.is_primary = 1
        LEFT JOIN hospitals h ON dh.hospital_id = h.id
        WHERE d.id = ?
        LIMIT 1");

        $stmt->execute([$id]);
        $doctor = $stmt->fetch();

        if (!$doctor) {
            Response::error('Doctor not found', 404);
        }

        // Fetch schedules
        $schedStmt = $pdo->prepare("SELECT * FROM doctor_schedules WHERE doctor_id = ? ORDER BY day_of_week ASC");
        $schedStmt->execute([$id]);
        $doctor['schedules'] = $schedStmt->fetchAll();

        Response::json($doctor);
    }

    /**
     * Toggle Doctor Online / Offline Availability
     */
    public static function toggleStatus(string $id): void {
        $body = json_decode(file_get_contents('php://input'), true);
        $isOnline = isset($body['is_online']) ? (int)$body['is_online'] : 1;

        $pdo = Database::getConnection();
        $stmt = $pdo->prepare("UPDATE doctors SET is_online = ? WHERE id = ?");
        $stmt->execute([$isOnline, $id]);

        Response::json(['id' => $id, 'is_online' => (bool)$isOnline], 200, 'Doctor status updated');
    }

    /**
     * Admin Verification & Approval of App-Registered Doctors
     */
    public static function updateVerificationStatus(string $id): void {
        $body = json_decode(file_get_contents('php://input'), true);
        $status = strtolower($body['status'] ?? 'verified');
        $notes = $body['notes'] ?? 'MCI Medical License Verified by Super Admin';

        if (!in_array($status, ['verified', 'pending', 'rejected'])) {
            Response::error('Invalid verification status', 400);
        }

        $pdo = Database::getConnection();

        // 1. Update doctor status
        $stmt = $pdo->prepare("UPDATE doctors SET verification_status = ? WHERE id = ?");
        $stmt->execute([$status, $id]);

        // 2. Audit Trail Log
        try {
            $auditStmt = $pdo->prepare("INSERT INTO audit_logs (id, user_id, action, details) VALUES (?, ?, ?, ?)");
            $logId = 'LOG-' . strtoupper(bin2hex(random_bytes(4)));
            $auditStmt->execute([
                $logId,
                'SUPER_ADMIN',
                'DOCTOR_CREDENTIAL_' . strtoupper($status),
                json_encode(['doctor_id' => $id, 'status' => $status, 'notes' => $notes, 'timestamp' => date('Y-m-d H:i:s')])
            ]);
        } catch (Exception $e) {
            // Non-blocking log failure
        }

        Response::json([
            'id' => $id,
            'verification_status' => $status,
            'notes' => $notes
        ], 200, "Doctor verification status updated to {$status}");
    }
}
