<?php
/**
 * HealthExpress AI - Pharmacy Controller
 * 15-Minute Doorstep Medicine Delivery & Location-Aware Fulfillment
 */

require_once __DIR__ . '/../config/database.php';
require_once __DIR__ . '/../helpers/Response.php';
require_once __DIR__ . '/../helpers/MapboxHelper.php';

class PharmacyController {
    /**
     * Get All Medicines with Location-Aware Delivery ETA
     */
    public static function getMedicines(): void {
        $pdo = Database::getConnection();

        $lat = isset($_GET['lat']) ? floatval($_GET['lat']) : (isset($_GET['latitude']) ? floatval($_GET['latitude']) : null);
        $lng = isset($_GET['lng']) ? floatval($_GET['lng']) : (isset($_GET['longitude']) ? floatval($_GET['longitude']) : null);

        $stmt = $pdo->query("SELECT * FROM medicines ORDER BY is_prescription_required ASC, name ASC");
        $medicines = $stmt->fetchAll();

        $deliveryEta = 15;
        $fulfillmentHub = 'Central Hyderabad Quick-Delivery Hub';

        if ($lat && $lng) {
            // Check distance to central fulfillment hub (Gachibowli hub @ 17.4400, 78.3489)
            $hubDistance = MapboxHelper::getDistanceKm($lat, $lng, 17.4400, 78.3489);
            $deliveryEta = max(10, min(30, intval(round($hubDistance * 2.2 + 8))));
            $fulfillmentHub = $hubDistance <= 5.0 ? 'Hyperlocal 15-Min Dark Store' : 'City Express Fulfillment Hub';
        }

        foreach ($medicines as &$m) {
            $m['delivery_eta_minutes'] = $deliveryEta;
            $m['delivery_label'] = "{$deliveryEta}-min Doorstep Delivery";
            $m['fulfillment_hub'] = $fulfillmentHub;
            $m['in_stock'] = true;
        }

        Response::json([
            'medicines'       => $medicines,
            'fulfillment_hub' => $fulfillmentHub,
            'eta_minutes'     => $deliveryEta
        ]);
    }

    /**
     * Create 15-Minute Medicine Delivery Order
     */
    public static function createOrder(): void {
        $body = json_decode(file_get_contents('php://input'), true) ?? [];

        $userId = $body['user_id'] ?? 'USR-101';
        $items = $body['items'] ?? [];
        $totalAmount = floatval($body['total_amount'] ?? 450.00);
        $deliveryAddress = $body['delivery_address'] ?? 'Road No 36, Jubilee Hills, Hyderabad';
        $lat = isset($body['latitude']) ? floatval($body['latitude']) : 17.4400;
        $lng = isset($body['longitude']) ? floatval($body['longitude']) : 78.3489;

        $orderId = 'MED-ORD-' . rand(10000, 99999);
        $etaMinutes = max(12, min(25, intval(round(MapboxHelper::getDistanceKm($lat, $lng, 17.4400, 78.3489) * 2.2 + 8))));

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
                ['status' => 'Rider Dispatched (Mapbox Live GPS)', 'time' => date('h:i A', strtotime('+6 minutes')), 'completed' => false],
                ['status' => 'Delivered to Doorstep', 'time' => date('h:i A', strtotime("+{$etaMinutes} minutes")), 'completed' => false],
            ]
        ], 201, '15-min medicine delivery order initiated');
    }
}
