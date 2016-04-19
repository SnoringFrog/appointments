#!/usr/bin/perl

use strict;
use warnings;
use CGI;
use DBI;

my $db_name = "appointments";

my $q = CGI->new;
my $db = DBI->connect("dbi:mysql:$db_name", 'root', '') or die "Database connection error";


if ($q->param()){
	if (length $q->param('getAppointments')) {
		# return the JSON
		exit
	} else { # form was submitted
		my $date = $q->param('date');
		my $time = $q->param('time');
		my $desc = $q->param('desc');

		update_database($date, $time, $desc);
	}
}
display_page($q);

sub update_database {
	my ($date, $time, $desc) = @_;
	my $sql = "INSERT INTO $db_name(time,description) VALUES('$date $time','$desc')";

	my $prepared_sql = $db->prepare($sql);
	$prepared_sql->execute;	
}

sub display_page {
	my ($q) = @_;
	print $q->header('text/html');
	print $q->start_html(-title => "AT&T Test",
		-style=>{'src'=>'/css/main.css'});

	print $q->start_form(-method=>'post',
		-action=>'/cgi-bin/echo.pl',
		-id=>'add_forma');

	print $q->submit(-name=>'new_add', -value=>'New');
	print $q->reset(-value=>'Cancel');
	print $q->br;

	print "<label for='date'>Date </label>";
	print "<input type='date' name='date' id='date' min='1753-01-01' max='9999-12-31'>";
	print $q->br;

	print "<label for='time'>Time </label>";
	print "<input type='time' name='time' id='time'>";
	print $q->br;

	print "<label for='desc'>Desc </label>";
	print $q->textfield(-name=>'desc', -id=>'desc');
	print $q->br;

	print $q->end_form;

	print $q->br;

	print $q->start_form(-method=>'get',
		-id=>'search_form');

	print $q->textfield(-name=>'q',-id=>'q');
	print $q->submit(-name=>'new_add', -value=>'Search');

	print $q->end_form;

	print $q->div({-id=>'appointments'},'');
	print '<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.2.0/jquery.min.js"></script>';
	print '<script src="/js/main.js"></script>';

	print $q->end_html;
}
