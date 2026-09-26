<?php
/**
 * CALMOS local deployment settings.
 * Values may be overridden with CALMOS_DB_* environment variables.
 */
return [
    'components' => [
        'db' => [
            'connectionString' => sprintf(
                'mysql:host=%s;port=%s;dbname=%s;',
                getenv('CALMOS_DB_HOST') ?: 'db',
                getenv('CALMOS_DB_PORT') ?: '3306',
                getenv('CALMOS_DB_NAME') ?: 'calmos_survey'
            ),
            'emulatePrepare' => true,
            'username' => getenv('CALMOS_DB_USER') ?: 'calmos',
            'password' => getenv('CALMOS_DB_PASSWORD') ?: 'calmos-local-only',
            'charset' => 'utf8mb4',
            'tablePrefix' => 'calmos_',
        ],
        'urlManager' => [
            'urlFormat' => 'path',
            'showScriptName' => true,
        ],
    ],
    'config' => [
        'admintheme' => 'CALMOS',
        'default_displayed_auth_method' => 'Authdb',
        // The core 2FA plugin is deliberately unavailable in this white-label deployment.
        'usePluginWhitelist' => true,
        'corePluginBlacklist' => ['TwoFactorAdminLogin'],
        'disablePluginUpload' => true,
        'debug' => 0,
    ],
];
