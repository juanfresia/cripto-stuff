#!/usr/bin/perl 

use CGI;
use CGI::Carp qw(fatalsToBrowser);
use DBI;

###########%DB%#############
$db="radius";            #
$host="localhost";         #
$port="3306";              #
$dbuser="radius";    #
$dbpass="radius123";     #
############################

my $q = new CGI;
my $user;
my $pass;

if ($q->param('Create') eq 'Create') {
  $user		  =esc($q->param('user'));
  $pass           =esc($q->param('pass'));
}
 
#connect to database

my $dbh= DBI->connect ("DBI:mysql:database=$db:host=$host",
                          $dbuser,
                          $dbpass)or die "Can't connect to database: $DBI::errstr\n";

#prepare the query

my $sth = $dbh->prepare('insert into radcheck(username, attribute, value) values (?,?,?);') 
			or die $dbh->errstr;#arreglar esto para que de errores via hatml response
#execute the query

$sth->execute($user,Password,$pass)
			or die $sth->errstr;
$sth->finish;
$dbh->disconnect;

html_head();


html_line("$user se agrego con exito a la lista de usuarios permitidos");

html_end();




#########################################
#             FUNCIONES                 #
#########################################

#escapea caracteres raros
sub esc {
        my ($ref) = @_;
        $ref =~ s/([^a-zA-Z0-9])/\\$&/g;
        return $ref;
}

#Imprime header de html
sub html_head {
        print "Content-type: text/html", "\n\n";
        print "<HTML>", "\n";
        print "<HEAD><TITLE>Test-auth</TITLE></HEAD>", "\n";
        print "<BODY>", "\n";
        print "<H1>66.69 CRIPTOGRAF&Iacute;A Y SEGURIDAD INFORM&Aacute;TICA</H1>", "<HR>", "\n";
}

#Imprime una linea de 
sub html_line {
        my ($line) = @_;
        print "<H2>$line</H2>","\n";
}


#Imprime end de html

sub html_end {
                print "<HR>","</BODY></HTML>", "\n";
}


