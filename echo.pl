#!/usr/bin/perl

use strict;
use warnings;
use CGI;
use DBI;

my $q = CGI->new;
my $db = DBI->connect('dbi:mysql:appointments', 'root', '') or die "Database connection error";


if ($q->param()){
	if (length $q->param('getAppointments')) {
		# return the JSON
	} else { # form was submitted
		#update the database
		update_database();
		display_page($q);
	}
	
} else {
	display_page($q);
}

sub update_database {
	
	# combine date/time into one field
	# get description
	# prep SQL
	# run query
}

sub display_page {
	my ($q) = @_;
	print $q->header('text/html');
	print $q->start_html(-title => "AT&T Test",
		-style=>{'src'=>'/css/main.css'});

	print $q->start_form(-method=>'post',
		-action=>'',
		-id=>'add_forma');

	print $q->submit(-name=>'new_add', -value=>'New');
	print $q->reset(-value=>'Cancel');
	print $q->br;

	print "<label for='date'>Date </label>";
	print $q->input(-type=>'date', -name=>'date', -id=>'date');
	print $q->br;

	print "<label for='time'>Time </label>";
	print $q->textfield(-name=>'time', -id=>'time');
	print $q->br;

	print "<label for='desc'>Desc </label>";
	print $q->textfield(-name=>'desc', -id=>'desc');
	print $q->br;

	print $q->end_form;

	print $q->br;

	print $q->start_form(-method=>'get',
		-action=>'/cgi-bin/echo.pl',
		-id=>'search_form');

	print $q->textfield(-name=>'query',-id=>'query');
	print $q->submit(-name=>'new_add', -value=>'Search');

	print $q->end_form;

	print $q->div({-id=>'appointments'},'');
	print '<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.2.0/jquery.min.js"></script>';
	print '<script src="/js/main.js"></script>';

	print $q->end_html;
}
