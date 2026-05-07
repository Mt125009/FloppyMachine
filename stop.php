<?php
header('Content-Type: application/json; charset=utf-8');

$method = isset($_SERVER['REQUEST_METHOD']) ? $_SERVER['REQUEST_METHOD'] : '';

function send_json($statusLine, $data) {
    header($statusLine);
    echo json_encode($data);
    exit;
}

if ($method !== 'POST') {
    send_json('HTTP/1.1 405 Method Not Allowed', array('ok' => false, 'error' => 'method'));
}

$file = __DIR__ . DIRECTORY_SEPARATOR . 'stop.txt';
file_put_contents($file, date('c') . " - stop\n");

echo json_encode(array('ok' => true));