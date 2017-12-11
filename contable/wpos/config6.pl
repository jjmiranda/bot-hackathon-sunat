#***********************************************************************
# Restaurant Web Pos                                                   *
# ===========================                                          *
# Copyright (c) 2005 by Alonso Rejas                                   *
# alonso.rejas@gmail.com                                               *
#                                                                      *
# This program is free software. You can redistribute it and/or modify *
# it under the terms of the GNU General Public License as published by *
# the Free Software Foundation; either version 2 of the License.       *
#***********************************************************************
# config6.pl

use strict; 
use CGI qw(:standard escape escapeHTML);

if (!defined(param('opt'))) {
   HKZ33::loginform("C O N F I G U R A C I O N&nbsp;&nbsp;&nbsp;V6");
} elsif (param('opt') eq 'session_login') {
   HKZ33::autenticate('config6.pl','config');
} elsif (param('opt') eq 'start') {
        CNF33::main_config();
} else {
       main('config'); 
}

# -----------------------------------------------------------
sub main {
# -----------------------------------------------------------
my ($sess_name) = @_;

#my @names = param;
#foreach (@names) { print $_ , " = ",param($_), "<br>"; }

if (!HKZ33::checksession('config')) { exit; }

my $style = HKZ33::get_sessiondata('cssname','config');
my $themes = "/themes/". $style. ".css";

print header();
print start_html(-title=>'Configuracion',-style=>{-src=> "$themes"},-script => {-language=>'javascript',-src=> "/includes/chkent.js"},-class=>$style."PageBODY",-marginwidth  => "0",-marginheight => "0",-leftmargin   => "0",-topmargin    => "0",-link=>'#000000',-vlink=>'#000000',-alink=>'#000000',-onLoad=>'',-background => "/images/papelfondo.jpg");

if (param('opt') eq 'backup') {
        CNF33::backup();
        exit;
} elsif (param('opt') eq 'restore') {
        CNF33::restore();
        exit;
} elsif (param('opt') eq 'setparam') {
        CNF33::setparam();
        exit;
} elsif (param('opt') eq 'settienda') {
        CNF33::settienda();
        exit;
} elsif (param('opt') eq 'setprintqueue') {
        CNF33::setprintqueue();
        exit;
} elsif (param('opt') eq 'top_main') {
        CNF33::top_main();
        exit;
} elsif (param('opt') eq 'top_config') {
        CNF33::top_config();
        exit;
} elsif (param('opt') eq 'showdeps') {
        CNF33::showdeps(); 
        exit;
} elsif (param('opt') eq 'depcolor') {
        CNF33::depcolor(); 
        exit;
} elsif (param('opt') eq 'savedepno') {
        CNF33::savedepno();
        CNF33::showdeps();   
        exit;
} elsif (param('opt') eq 'editdepno') {
        CNF33::editdepno();
        exit;
} elsif (param('opt') eq 'movedpto') {
        CNF33::movedpto();
        CNF33::showdeps();   
        exit;
} elsif (param('opt') eq 'edittblitem') {
        CNF33::edittblitem();
        exit;
} elsif (param('opt') eq 'savetblitem') {
        CNF33::savetblitem();
        CNF33::editdepno();  
        exit;
} elsif (param('opt') eq 'cuentas') {
        CNF33::cuentas();
        exit;
} elsif (param('opt') eq 'showcreditcards') {
        CNF33::showcreditcards();
        exit;
} elsif (param('opt') eq 'listusers') {
        CNF33::listusers();
        exit;
} elsif (param('opt') eq 'newuser') { 
        CNF33::newuser();
        exit;
} elsif (param('opt') eq 'edituser') { 
        CNF33::edituser();
        exit;
} elsif (param('opt') eq 'saveuser') { 
        CNF33::saveuser();
        CNF33::listusers();
        exit;
} elsif (param('opt') eq 'logout') {
        HKZ33::session_logout('config');
        print redirect("/wpos/config6.pl");
        exit;
} elsif (param('opt') eq 'producto') {
        CNF33::producto();
        exit;
} elsif (param('opt') eq 'report') {
        CNF33::DoReport();
        exit;
} elsif (param('opt') eq 'edittblmemo') {
        CNF33::edittblmemo();
        exit;
}elsif (param('opt') eq 'savetblmemo') {
        CNF33::savetblmemo();
        CNF33::editdepno();  
        exit;
} 

print end_html();

}
