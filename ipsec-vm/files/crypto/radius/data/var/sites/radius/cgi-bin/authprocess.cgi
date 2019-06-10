#!/usr/bin/perl 

use CGI;
use CGI::Carp qw(fatalsToBrowser);
use Authen::Radius;


my $q = new CGI;
my $user;
my $pass;
my $authmethod;

if ($q->param('Auth') eq 'Auth') {
  $user		  =esc($q->param('user'));
  $pass           =esc($q->param('pass'));
  $authmethod     =esc($q->param('authmethod'));
}
 
my $result;
my $authmsg;

$result = auth_radius($user,$pass) if ($authmethod eq "radius");  
if($result eq "1"){
        #success
        $authmsg = "Authentication Successful";
        }
        else{
        #fail
        $authmsg = "Authentication Failed";
        }
       
 
html_head();


html_line("$authmsg");


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

#Auth contra Radius Server

sub auth_radius {

my $r = new Authen::Radius(Host     => 'localhost', 
			   Secret   => 'testing123');
my $result = $r->check_pwd($_[0],$_[1]);
return $result; 
}                          
