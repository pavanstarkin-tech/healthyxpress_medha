<?php
/**
 * HealthExpress AI - Central Configuration
 * Hostinger Production Ready
 */

// Error reporting: Log errors without dumping to client
ini_set('display_errors', 0);
ini_set('log_errors', 1);
error_reporting(E_ALL);

// Database Credentials (from Hostinger environment or defaults)
define('DB_HOST', getenv('DB_HOST') ?: '147.93.101.73');
define('DB_PORT', getenv('DB_PORT') ?: '3306');
define('DB_NAME', getenv('DB_NAME') ?: 'u170253497_healthexpress');
define('DB_USER', getenv('DB_USER') ?: 'u170253497_healthexpress');
define('DB_PASS', getenv('DB_PASSWORD') ?: 'Healthxpress_1234567');

// Razorpay Live Credentials
define('RAZORPAY_KEY_ID', getenv('RAZORPAY_KEY_ID') ?: 'rzp_live_StBUehIpeULYuL');
define('RAZORPAY_KEY_SECRET', getenv('RAZORPAY_KEY_SECRET') ?: '');

// Agora WebRTC Credentials
define('AGORA_APP_ID', getenv('AGORA_APP_ID') ?: '');
define('AGORA_APP_CERTIFICATE', getenv('AGORA_APP_CERTIFICATE') ?: '');

// Gemini AI API Key
define('GEMINI_API_KEY', getenv('GEMINI_API_KEY') ?: '');

// Mapbox Public Token
define('MAPBOX_ACCESS_TOKEN', getenv('MAPBOX_ACCESS_TOKEN') ?: 'pk.eyJ1IjoicGhpbGlwbGFza2kiLCJhIjoiY203M3N0aDJ3MHZpZzJrczh2ZXJreTFqciJ9');
