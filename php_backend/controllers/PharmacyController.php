<?php
/**
 * HealthExpress AI - Pharmacy Controller
 * 15-Minute Doorstep Medicine Delivery & Orders
 */

require_once __DIR__ . '/../config/database.php';
require_once __DIR__ . '/../helpers/Response.php';

class PharmacyController {
    public static function getMedicines(): void {
        $pdo = Database::getConnection();

        $stmt = $pdo->query("SELECT * FROM medicines ORDER BY is_prescription_required ASC, name ASC");
        $medicines = $stmt->fetchAll();

        Response::json($medicines);
    }

    public static function createOrder(): void {
        $body = json_decode(file_get_contents('php://input'), true);

        $userId = $body['user_id'] ?? 'USR-101';
        $items = $body['items'] ?? [];
        $totalAmount = floatval($body['total_amount'] ?? 450.00);
        $deliveryAddress = $body['delivery_address'] ?? 'Road No 36, Jubilee Hills, Hyderabad';

        $orderId = 'MED-ORD-' . rand(10000, 99999);
        $etaMinutes = 15;

        Response::json([
            'order_id'         => $orderId,
            'user_id'          => $userId,
            'items'            => $items,
            'total_amount'     => $totalAmount,
            'delivery_address' => $deliveryAddress,
            'delivery_status'  => 'order_placed',
            'eta_minutes'      => $etaMinutes,
            'timeline'         => [
                ['status' => 'Order Placed', 'time' => date('h:i A'), 'completed' => true],
                ['status' => 'Pharmacy Packed', 'time' => date('h:i A', strtotime('+3 minutes')), 'completed' => false],
                ['status' => 'Rider Dispatched (Mapbox Live)', 'time' => date('h:i A', strtotime('+6 minutes')), 'completed' => false],
                ['status' => 'Delivered', 'time' => date('h:i A', strtotime("+{$etaMinutes} minutes")), 'completed' => false],
            ]
        ], 201, '15-min medicine delivery order initiated');
    }
}
