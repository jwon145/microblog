#!/usr/bin/perl -w

use CGI qw/:all/;
use Digest::SHA1 qw(sha1_hex);

# to generate a password:
# perl -e "use Digest::SHA1 qw(sha1_hex); print sha1_hex('PASSWORD_GOES_HERE') . \"\n\";"
$pw	= '';
$file = 'posts.txt';

sub htmlHeader() {
    print header;
    print <<HTML;
<!DOCTYPE html>
<html>
	<head>
		<title>microblog</title>
		<meta charset="UTF-8">
        <link rel="stylesheet" type="text/css" href="/style.css" />
	</head>
	<body>
		<div id="main">
            <h1>microblog</h1>

HTML
}

sub htmlFooter() {
    print <<HTML;
		</div>
	</body>
</html>
HTML
}

htmlHeader();

if (!-e $file) {
    open($fh, '>', $file);
    print $fh localtime(time) . "\thello world\n";
    close($fh);
}

if (param('pw') and param('text') and sha1_hex(param('pw')) eq $pw) {
    open($fh, '>>', $file);
    print $fh localtime(time) . "\t" . param('text') . "\n";
    close($fh); 
}

open($fh, '<', $file);
foreach (reverse <$fh>) {
    $_ =~ /^(.+?)\t(.+)\n$/;
    print "<p>$2<time>$1</time></p>\n";
}
close($fh);
htmlFooter();
