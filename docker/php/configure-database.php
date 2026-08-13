<?php

$dbHost = getenv('DB_HOST') ?: 'db';
$dbPort = (int) (getenv('DB_PORT') ?: 3306);
$dbName = getenv('DB_NAME') ?: 'qloapps';
$dbUser = getenv('DB_USER') ?: 'qloapps';
$dbPassword = getenv('DB_PASSWD') ?: '';
$dbPrefix = getenv('DB_PREFIX') ?: 'qlo_';
$shopDomain = trim((string) getenv('SHOP_DOMAIN'));

if (!preg_match('/^[a-zA-Z0-9_]+$/', $dbPrefix)) {
    fwrite(STDERR, "DB_PREFIX contains unsupported characters.\n");
    exit(1);
}

if ($shopDomain !== '' && !preg_match('/^[a-zA-Z0-9.-]+(?::[0-9]{1,5})?$/', $shopDomain)) {
    fwrite(STDERR, "SHOP_DOMAIN must be a hostname with an optional port, without a scheme or path.\n");
    exit(1);
}

$dsn = sprintf('mysql:host=%s;port=%d;dbname=%s;charset=utf8mb4', $dbHost, $dbPort, $dbName);
$pdo = null;

for ($attempt = 1; $attempt <= 60; ++$attempt) {
    try {
        $pdo = new PDO($dsn, $dbUser, $dbPassword, array(
            PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
            PDO::ATTR_EMULATE_PREPARES => false,
        ));
        break;
    } catch (PDOException $exception) {
        if ($attempt === 60) {
            fwrite(STDERR, "Database did not become ready: ".$exception->getMessage()."\n");
            exit(1);
        }
        sleep(2);
    }
}

$shopUrlTable = $dbPrefix.'shop_url';
$configurationTable = $dbPrefix.'configuration';
$tableCheck = $pdo->prepare(
    'SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = ? AND table_name = ?'
);
$tableCheck->execute(array($dbName, $shopUrlTable));

if (!(int) $tableCheck->fetchColumn()) {
    fwrite(STDERR, "QloApps database is empty. Restore a database dump before starting the web service.\n");
    exit(1);
}

if ($shopDomain !== '') {
    $shopUpdate = $pdo->prepare(
        'UPDATE `'.$shopUrlTable.'` SET `domain` = ?, `domain_ssl` = ? WHERE `main` = 1'
    );
    $shopUpdate->execute(array($shopDomain, $shopDomain));

    $configurationUpdate = $pdo->prepare(
        'UPDATE `'.$configurationTable.'` SET `value` = ? '
        .'WHERE `name` IN (\'PS_SHOP_DOMAIN\', \'PS_SHOP_DOMAIN_SSL\')'
    );
    $configurationUpdate->execute(array($shopDomain));

    // Behind the Codespaces TLS-terminating proxy the forwarded Host carries
    // its port and X-Forwarded-Proto is unreliable, so https/http canonical
    // checks never settle (302 and 301 loops). Disable both app-level
    // redirection mechanisms for forwarded hosts; the proxy handles the
    // public https face. Local http-only stacks keep their seeded behaviour.
    if (strpos($shopDomain, '.app.github.dev') !== false) {
        $redirectOff = $pdo->prepare(
            'UPDATE `'.$configurationTable.'` SET `value` = \'0\' '
            .'WHERE `name` IN (\'PS_SSL_ENABLED\', \'PS_SSL_ENABLED_EVERYWHERE\', \'PS_CANONICAL_REDIRECT\')'
        );
        $redirectOff->execute();
    }

    fwrite(STDOUT, "[qloapps] canonical domain set to ".$shopDomain."\n");
}

// Switch the front theme via qlo_theme + qlo_shop.id_theme (PS 1.7 model).
$themeName = trim((string) getenv('THEME_NAME'));
if ($themeName !== '' && is_dir('/var/www/html/themes/'.$themeName)) {
    $themeTable = $dbPrefix.'theme';
    $themeSelect = $pdo->prepare('SELECT `id_theme` FROM `'.$themeTable.'` WHERE `directory` = ?');
    $themeSelect->execute(array($themeName));
    $idTheme = (int) $themeSelect->fetchColumn();
    if (!$idTheme) {
        $themeInsert = $pdo->prepare(
            'INSERT INTO `'.$themeTable.'` '
            .'(`name`, `directory`, `responsive`, `default_left_column`, `default_right_column`, `product_per_page`) '
            .'VALUES (?, ?, 1, 1, 0, 12)'
        );
        $themeInsert->execute(array($themeName, $themeName));
        $idTheme = (int) $pdo->lastInsertId();
        fwrite(STDOUT, "[qloapps] registered theme ".$themeName." (id_theme=".$idTheme.")\n");
    }
    $shopSelect = $pdo->prepare('SELECT MIN(`id_shop`) FROM `'.$dbPrefix.'shop` WHERE `active` = 1');
    $shopSelect->execute();
    $idShop = (int) $shopSelect->fetchColumn();
    if ($idShop) {
        $shopUpdate = $pdo->prepare('UPDATE `'.$dbPrefix.'shop` SET `id_theme` = ? WHERE `id_shop` = ?');
        $shopUpdate->execute(array($idTheme, $idShop));
        fwrite(STDOUT, "[qloapps] front theme set to ".$themeName."\n");
    }
} elseif ($themeName !== '') {
    fwrite(STDERR, "[qloapps] THEME_NAME ".$themeName." has no themes/ directory; keeping current theme.\n");
}
