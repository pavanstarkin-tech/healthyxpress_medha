<?php
/**
 * HealthExpress AI - Doctor Controller
 * Live Doctor Discovery, Credentialing & Schedules
 */

require_once __DIR__ . '/../config/database.php';
require_once __DIR__ . '/../helpers/Response.php';

class DoctorController {
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
        ORDER BY d.experience_years DESC";

        $stmt = $pdo->query($query);
        $doctors = $stmt->fetchAll();

        Response::json($doctors);
    }

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

    public static function toggleStatus(string $id): void {
        $body = json_decode(file_get_contents('php://input'), true);
        $isOnline = isset($body['is_online']) ? (int)$body['is_online'] : 1;

        $pdo = Database::getConnection();
        $stmt = $pdo->prepare("UPDATE doctors SET is_online = ? WHERE id = ?");
        $stmt->execute([$isOnline, $id]);

        Response::json(['id' => $id, 'is_online' => (bool)$isOnline], 200, 'Doctor status updated');
    }
}
