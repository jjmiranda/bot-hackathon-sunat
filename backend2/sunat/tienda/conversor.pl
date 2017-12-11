# ----------------------------------
sub num2text {
# ----------------------------------
my ($num) = @_;

my $numero  = $num * 100;
my $decimal = substr($numero,length($numero)-2,2);
my $entero  = 1000000000 + substr($numero,0,length($numero)-2);
my $entero  = substr($entero,1,length($entero));

if ($entero > 1000000000) {
   print "Error : Max digits=9\n";
   exit;
}

my $millon  = substr($entero,0,3);
my $miles   = substr($entero,3,3);
my $cientos = substr($entero,6,3);

my ($strmillon,$strmiles,$strcientos,$strdecimos);

if ($millon ne '000') {
    $strmillon = block2text(substr($entero,0,3),"");
    $strmillon .= ($millon == 1) ? "MILLON " : "MILLONES ";
}

if ($miles ne '000') {
    $strmiles .= block2text(substr($entero,3,3),""). "MIL ";
}

if ($cientos ne '000') {
    $strcientos .= block2text(substr($entero,6,3),"");
}

if ($millon eq '000' and $miles eq '000' and $cientos eq '000') {
    $strdecimos = " ". $decimal ."/100 NUEVOS SOLES";
} else {
    $strdecimos = "Y ". $decimal . "/100 NUEVOS SOLES";
}

return($strmillon.$strmiles.$strcientos.$strdecimos);

}

# ----------------------------------
sub block2text {
# ----------------------------------
my ($num,$charfor) = @_;

my @tunidad   = ("","uno","dos","tres","cuatro","cinco","seis","siete","ocho","nueve");
my @tdecena1  = ("diez","once","doce","trece","catorce","quince","dieciseis","diecisiete","dieciocho","diecinueve");
my @tdecena2  = ("","","veinte","treinta","cuarenta","cincuenta","secenta","setenta","ochenta","noventa");
my @tcentena  = ("","ciento","doscientos","trescientos","cuatrocientos","quinientos","seiscientos","setecientos","ochocientos","novecientos");

my $charone = substr($num,0,1);
my $chartwo = substr($num,1,1);
my $chartre = substr($num,2,1);

my $numbertext = '';

# Primer digito del bloque: x00
$numbertext = $tcentena[$charone]. " ";

if ($charone == '1' and $chartwo == '0' and $chartre == '0') {
   $numbertext = "CIEN";
}

# Caso del bloque 0yz
if ($chartwo == '1') {
    $numbertext .= $tdecena1[$chartre]. " ";    # once ... diecinueve
} elsif ($chartwo == '2' and $chartre == '0') { # veinte
    $numbertext .= $tdecena2[$chartwo]. " ";
} elsif ($chartwo == '2' and $chartre > '0') {  # veinti
    $numbertext .= substr($tdecena2[$chartwo],0,length($tdecena2[$chartwo])-1)."I";
} elsif ($chartwo >'2' and $chartre != '0') {
    $numbertext .= $tdecena2[$chartwo].'I';     # treintai ... noventai
} else {
    $numbertext .= $tdecena2[$chartwo]. " ";
}

# Caso del bloque 00z
if ($charone == '0' and $chartwo =='0' and $chartre == '1') {
   $numbertext =  "UN ";
} elsif ($chartwo != '1' and $chartre) {
   $numbertext .= $tunidad[$chartre] . " ";
}

return (uc($numbertext));

}
1;