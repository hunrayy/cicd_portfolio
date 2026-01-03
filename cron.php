<?php
$script = '/home/u892791683/domains/cicd_portfolio/script.sh';
$log    = '/home/u892791683/domains/cicd_portfolio/cron.log';

file_put_contents($log, "Cron ran at " . date('Y-m-d H:i:s') . "\n", 
FILE_APPEND);

$output = shell_exec("/bin/sh $script 2>&1");
file_put_contents($log, $output, FILE_APPEND);

