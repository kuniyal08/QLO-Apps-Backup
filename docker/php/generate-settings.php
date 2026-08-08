<?php

$settingsPath = '/var/www/html/config/settings.inc.php';
$definitions = array(
    '_DB_SERVER_' => getenv('DB_HOST').':'.getenv('DB_PORT'),
    '_DB_NAME_' => getenv('DB_NAME'),
    '_DB_USER_' => getenv('DB_USER'),
    '_DB_PASSWD_' => getenv('DB_PASSWD'),
    '_DB_PREFIX_' => getenv('DB_PREFIX'),
    '_MYSQL_ENGINE_' => getenv('MYSQL_ENGINE'),
    '_PS_CACHING_SYSTEM_' => 'CacheMemcache',
    '_PS_CACHE_ENABLED_' => '0',
    '_COOKIE_KEY_' => getenv('COOKIE_KEY'),
    '_COOKIE_IV_' => getenv('COOKIE_IV'),
    '_NEW_COOKIE_KEY_' => getenv('NEW_COOKIE_KEY'),
    '_PS_CREATION_DATE_' => getenv('PS_CREATION_DATE'),
);

$contents = "<?php\n";
foreach ($definitions as $name => $value) {
    $contents .= sprintf("define('%s', %s);\n", $name, var_export($value, true));
}

$contents .= sprintf(
    "if (!defined('_PS_VERSION_'))\n    define('_PS_VERSION_', %s);\n",
    var_export(getenv('PS_VERSION'), true)
);
$contents .= sprintf(
    "define('_QLOAPPS_VERSION_', %s);\n",
    var_export(getenv('QLOAPPS_VERSION'), true)
);

if (file_put_contents($settingsPath, $contents, LOCK_EX) === false) {
    fwrite(STDERR, "Unable to write config/settings.inc.php.\n");
    exit(1);
}
