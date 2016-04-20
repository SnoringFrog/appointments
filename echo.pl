#!/usr/bin/perl

use strict;
use warnings;
use CGI;
use DBI;
use JSON;

my $db_name = "appointments";

my $q = CGI->new;
my $db = DBI->connect("dbi:mysql:$db_name", 'root', '') or die "Database connection error";

# testing
#$q->param('q','est');
#get_appointments();
#exit;

if ($q->param()){
	if (length $q->param('getAppointments')) {
		get_appointments();
	} else { # form was submitted
		my $date = $q->param('date');
		my $time = $q->param('time');
		my $desc = $q->param('desc');

		update_database($date, $time, $desc);
	}
}
display_page($q);

sub get_appointments {
	my @results;

	# call the DB, select based on query
	my $sql = "SELECT * FROM $db_name";
	my $query = $q->param('q');
	if (length $query) {
		$sql = $sql . " WHERE INSTR(description, '$query')>0";
	}
	$sql = $sql . " ORDER BY time";

	my $prepared_sql = $db->prepare($sql);
	$prepared_sql->execute;	
	
	while (my $row = $prepared_sql->fetchrow_hashref) {
		push @results, $row;
	}

	print $q->header('application/json');
	print objToJson( { appointments => \@results } );

	exit;
}

sub update_database {
	my ($date, $time, $desc) = @_;
	if (length $date && length $time) {
		my $sql = "INSERT INTO $db_name(time,description) VALUES('$date $time','$desc')";

		my $prepared_sql = $db->prepare($sql);
		$prepared_sql->execute;	
	}
}

sub display_page {
	my ($q) = @_;
	print $q->header('text/html');
	print $q->start_html(-title => "AT&T Test",
		-style=>{'src'=>'/css/main.css'});

	print $q->start_form(-method=>'post',
		-action=>'/cgi-bin/echo.pl',
		-id=>'add_form');

	print $q->submit(-id=>'new_add', -name=>'new_add', -value=>'New');
	print $q->reset(-value=>'Cancel', -class=>'add', -id=>'cancel');
	print "<br class='add'>";

	print "<label for='date' class='add'>Date </label>";
	print "<input type='date' name='date' id='date' class='add' min='1000-01-01' max='9999-12-31' required>";
	print "<br class='add'>";

	print "<label for='time' class='add'>Time </label>";
	print "<input type='time' name='time' id='time' class='add' required>";
	print "<br class='add'>";

	print "<label for='desc' class='add'>Desc </label>";
	print $q->textfield(-name=>'desc', -id=>'desc', -class=>'add', -maxlength=>'255');
	print "<br class='add'>";

	print $q->end_form;

	print $q->br;

	print $q->start_form(-method=>'get',
		-id=>'search_form');

	print $q->textfield(-name=>'q',-id=>'q');
	print $q->submit(-name=>'new_add', -value=>'Search');

	print $q->end_form;
	
	print $q->br;

	print $q->div({-id=>'appointments'},'');
	print '<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.2.0/jquery.min.js"></script>';
	print '<script src="/js/main.js"></script>';

	print $q->end_html;
}
