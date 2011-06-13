#!/usr/bin/perl -w

use CGI qw/:all/;
use Tie::File;
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

if (param('pw') and sha1_hex(param('pw')) eq $pw) {
    if (param('post')) {
        open($fh, '>>', $file);
        print $fh localtime(time) . "\t" . param('post') . "\n";
        close($fh); 
    } elsif (param('rm')) {
        if (param('rm') eq 'all') {
            tie my @file, 'Tie::File', $file;
            @file = ();
            untie @file;
        } elsif (param('rm') =~ /^\d+$/) {
            tie my @file, 'Tie::File', $file;
            splice @file, param('rm')-1, 1;
            untie @file;
        }
    }
}

open($fh, '<', $file);
foreach (reverse <$fh>) {
    $_ =~ /^(.+?)\t(.+)\n$/;
    print "<p>$2<time>$1</time></p>\n";
}
close($fh);
htmlFooter();
