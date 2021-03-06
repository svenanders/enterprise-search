#!/usr/bin/perl

  use URI::URL;
#  use strict;
  use Parse::MediaWikiDump;


  binmode(STDOUT, ':utf8');
  binmode(STDERR, ':utf8');
    
  my $file = shift(@ARGV) or die "must specify a Mediawiki dump file";
  my $baseurl = shift(@ARGV) or die "must specify a base url";
  my $outfile = shift(@ARGV) or die "must specify a file";

  my $nrofthreads = 1;

  my $pages = Parse::MediaWikiDump::Pages->new($file);
  my $page;

  my $fileacces : shared = 0;

  open(OUT,">$outfile") or die($file);
  binmode(OUT, ':utf8');


my $count = 0;    
while(defined($page = $pages->page)) {
    	#main namespace only          

	#print $page->title, "\n"; 

	#print "namespace: " . $page->namespace . "\n";
	#print "redirect: " . $page->redirect . "\n";
 
    	next unless $page->namespace eq '';
	#next unless defined($page->namespace);
    	#next unless $page->redirect eq '';
	next if defined($page->redirect);
	#unless defined($page->categories);

	#print "aa\n";
	#print $page->title, "\n"; 
		
	#print "\tnamespace: " . $page->namespace . "\n";
	#print "\tredirect: " . $page->redirect . "\n";

	#legger til artikkelen selv
	my $wurl = $baseurl . $page->title;
	$wurl =~ s/ /_/g;
	#print "w: $wurl\n";
	printurl($wurl);
  
	#print "$wurl: ", length(${ $page->text }), "\n";	
	if (!defined($page->text) ) {
		next;
	}



	++$count;
  }

	close(OUT);


sub printurl {
	my($purl) = @_;

	$purl = ResulveUrl('http://www.boitho.com/addyourlink.htm.en',$purl);

	{

		lock($fileacces);

		#print "wiki: $purl\n";
		print OUT $purl, "\n";
	}
}

sub ResulveUrl {
        my($BaseUrl,$NyUrl) = @_;

        $link = new URI::URL $NyUrl;
        $FerdigUrl = $link->abs($BaseUrl);

        return $FerdigUrl;
}

