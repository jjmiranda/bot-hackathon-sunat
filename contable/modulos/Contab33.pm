package Contab33;
use strict;
use CGI qw(:standard escape escapeHTML);
#use CGI qw(:standard);
use LWP::UserAgent;

# -------------------------------------------------------
sub connectdb {
# -------------------------------------------------------
return (WebDB33::connect433(cookie('database')));
}

# -------------------------------------------------------
sub opensession {
# -------------------------------------------------------
my ($dbh) = @_;
return (WebDB33::Session433->open($dbh,cookie('contab'),cookie('database')));
}

# -----------------------------------------------------------
sub get_sessiondata {
# -----------------------------------------------------------
my ($stdata) = @_;
my $ret = undef;
if (defined(cookie('contab'))) {
    my $sess_ref = undef;
    my $dbh = connectdb();
    if ($sess_ref = opensession()) {
        $ret = $sess_ref->{$stdata};
        $sess_ref->close();
    }
}
return ($ret);
}

# -------------------------------------------------------
sub editcuenta {
# -------------------------------------------------------
my ($sth,$dbh,$ref);
$dbh = connectdb();
my ($sth9,$dbh9,$ref9);
$dbh9 = WebDB33::connect433('ruc');
#my @names = param;
#foreach (@names) { print $_ , " = ",param($_), "<br>"; }

my $sql;
my $style = get_sessiondata('cssname');
my $user  = get_sessiondata('user');

my @checknum     = param('checknum');
my @cta          = param('cta');
my @cccod        = param('cccod');
my @dsc          = param('dsc');
my @scuenta      = param('scuenta');
my @tipo         = param('tipo');

my @tcuenta      = param('tcuenta');
my @destino      = param('destino');

my $seccion      = param('seccion');
my $subcta       = param('subcta');

my $correo  = param('correo');
my $telefono  = param('telefono');
my $celular  = param('celular');

my $cuenta       = param('cuenta');
my $dsc          = param('dsc');
my $ruc          = param('ruc');
my $memo         = param('memo');
my $rvflag       = param('rvflag');
my $rcflag       = param('rcflag');
my $cccod        = param('cccod');
my $chequera     = param('chequera');
my $cheque_del   = param('cheque_del');
my $cheque_al    = param('cheque_al');
my $cheque_num   = param('cheque_num');
my $cta_dfc_g    = param('cta_dfc_g');
my $cta_dfc_p    = param('cta_dfc_p');
my $cta_tax_1    = param('cta_tax_1');
my $cta_tax_2    = param('cta_tax_2');
my $tax_1_per    = param('tax_1_per');
my $tax_2_per    = param('tax_2_per');
my $cta_d_1      = param('cta_d_1');
my $cta_h_1      = param('cta_h_1');
my $moneda       = param('moneda');

# Clasificacion del Balance
my %options0  = ("0" => "Activo", "1" => "Pasivo","2" => "Capital", "3" => "Ingresos","4" => "Costo de Venta","5" => "Gastos","6" => "Transferencia","7" => "Destino","8" => "Resultados","9" => "Orden");




# --------------------------------------
# Mantenimiento de cuentas creadas por el usuario 
# --------------------------------------

if (param('optx') eq 'addtcuenta') {

    if (param('opty') eq 'save') {
       my $count = 0;
       my $err;
       foreach my $k (@tcuenta) {
               # Actulizar la cuenta
               $dbh->do("REPLACE cc_tcuenta(tcuenta,dsc,cuenta,destino) VALUES (?,?,?,?)",undef,$k,$dsc[$count],$scuenta[$count],$destino[$count]) or ($err=$DBI::errstr);
               print $err,"<br>" if ($err);
             
       }
    }


    # **************
    # Paginador
    # **************
    my $lpp = 10;   # lineas por pagina
                                                                                                                            
    # Calcula el numero de paginas
    $sql = "SELECT count(*) as records FROM cc_tcuenta";
    my $records = $dbh->selectrow_array ($sql);
    my $pages = int($records/$lpp) + (($records % $lpp > 0) ? 1 : 0);
    my $firstpage = (param('param1') eq '') ? 1 : param('param1');
    my $lastpage  = ($firstpage + $lpp < $pages) ?  $firstpage + $lpp : $pages;
    my $offset    = (param('offset') eq '') ? 0 : param('offset');
    my $pageno    = ($offset + $lpp)  / $lpp;   # Pagina actual
    # **************

    my $sql="SELECT tcuenta ,dsc,cuenta,destino FROM cc_tcuenta  ORDER BY tcuenta LIMIT $offset,$lpp";
    $sth = $dbh->prepare($sql);
    $sth->execute();

    print start_form();

    # Despliega las cuentas principales
    print "<br><table border=0 cellpadding=2 cellspacing=2 align=center>";
    print Tr(td({-colspan=>"4",-align=>"center"},b("Lista de tipificacion de cuentas").img({-src=>"/images/spacer.gif",-alt=>"spacer.gif",-width=>"20",-height=>"1"}).a({-href=>"?opt=editcuenta&optx=addtcuenta&opty=add",-target=>"inferior",-title=>"Agregar Tipos"}).img({-src=>"/images/increment.png",-alt=>"increment.png"}) ));
    print Tr({-align=>"center",-bgcolor=>"#FFAF55"},td("&nbsp;"),td({-width=>"300"},b("Nombre del tipo")),td(b("Cuenta")),td(b("Destino")) );

    while ($ref = $sth->fetchrow_hashref()) {
          if (grep (/^$ref->{'tcuenta'}$/,@checknum)) {
             print Tr({-class=>$style."lkitem"},td({-align=>"center"},textfield(-name=>"tcuenta",-value=>$ref->{'tcuenta'},-class=>$style."NoInput",-size=>"2",-maxlength=>"2",-OnFocus=>"blur();")),td(textfield(-name=>"dsc",-value=>$ref->{'dsc'},-size=>"60",-maxlength=>"60") ),td(textfield(-name=>"scuenta",-value=>$ref->{'cuenta'},-size=>"7",-maxlength=>"7") ),td(textfield(-name=>"destino",-value=>$ref->{'destino'},-size=>"7",-maxlength=>"7") )  );
          } else {
             print Tr({-class=>$style."lkitem"},td(checkbox(-name=>"checknum",-value=>$ref->{'tcuenta'},-label =>"",-checked=>0)),td({-width=>"300"},$ref->{'dsc'}),td({-align=>"center"},$ref->{'cuenta'}),td({-align=>"center"},$ref->{'destino'}) );
          }
    }
    #print Tr({-bgcolor=>"#FFAF55"},td("&nbsp;"),td("&nbsp;"),td("&nbsp;"),td("&nbsp;"),td("&nbsp;"));

    if (param('opty') eq 'add') {
       print Tr({-class=>$style."FieldCaptionTD"},td({-align=>"center"},textfield(-name=>"tcuenta",-value=>"",-size=>"2",-maxlength=>"2")),td({-align=>"center"},textfield(-name=>"dsc",-value=>"",-size=>"60",-maxlength=>"60")),td(textfield(-name=>"scuenta",-value=>"",-size=>"7",-maxlength=>"7")),td(textfield(-name=>"destino",-value=>"",-size=>"7",-maxlength=>"7",-onchange=>"document.forms[0].opty.value='save';submit();")));
    } 

    print "</table>";

    # **************
    # Paginador
    # **************
    if ($pages > 1) {
       talonpaginador($firstpage,$lastpage,$lpp,$pageno,$pages,"?opt=editcuenta&optx=tcuenta");
    }

    if (param('opty') eq 'mod' or param('opty') eq 'add') {
       print br(),table({-align=>"center"},Tr({-align=>"center"},td(button(-class=>$style."Button",-value=>"Aceptar",-onclick=>"document.forms[0].opty.value='save';submit();"))));
    } else {
       print br(),table({-align=>"center"},Tr({-align=>"center"},td({-colspan=>"2"},"Con los seleccionados")),Tr({-align=>"center"},td(button(-class=>$style."Button",-value=>"Modificar",-onclick=>"document.forms[0].opty.value='mod';submit();"))));
    } 
    
    my $offset = param('offset');
    my $param1 = param('param1');

    print hidden(-name=>"opt",-value=>"editcuenta",-override=>1);
    print hidden(-name=>"optx",-value=>"addtcuenta",-override=>1);
    print hidden(-name=>"opty",-value=>"",-override=>1);
    print hidden(-name=>"offset",-value=>"$offset",-override=>1);
    print hidden(-name=>"param1",-value=>"$param1",-override=>1);

    print end_form();

    print "<center><a href='?opt=anexos' target='inferior' title='Regresar'>".img({-src=>"/images/return.png",-border=>"0",-alt=>"return.png"})."</a></center>";

    return;
}

# --------------------------------------
# Mantenimiento de anexos II
# --------------------------------------
if (param('optx') eq 'addanexo') {
my $mensaje="";
    if (param('opty') eq 'save') {
        my $err;

if ($cuenta eq '05'){
				my $dbh0 = connectdb();
			my $largocaracter = $dbh0->selectrow_array("select length(cuenta) as largo from cc_anexo where tipo_anexo='05' order by largo DESC limit 1");

	my $dbh1 = connectdb();
#	my ($cuentaactual,$siguientecuenta) = $dbh1->selectrow_array("select COUNT(*) as totalcuenta, (COUNT(*)+1) as siguientecuenta  from cc_anexo where tipo_anexo='05'");
  my ($siguientecuenta) = $dbh1->selectrow_array("select (SUBSTR(cuenta,7,7)+1) as cadena   from cc_anexo where tipo_anexo='05' and length(cuenta)='$largocaracter' order by cadena DESC limit 1");
                
	if (param('optw') eq 'ingresar'){
	#	 print "$siguientecuenta: se ingreso cuenta: $cuenta con ruc: $ruc y se :".param('optw') ; 
	if ($siguientecuenta){
  	$dbh->do("REPLACE cc_anexo(tipo_anexo,cuenta,dsc,referencia,ndoc,telefono,celular,email) VALUES (?,?,?,?,?,?,?,?)",undef,$cuenta,'121000'.$siguientecuenta,$dsc,$memo,$ruc,$telefono,$celular,$correo) or ($err=$DBI::errstr);
 
  }else{
		$dbh->do("REPLACE cc_anexo(tipo_anexo,cuenta,dsc,referencia,ndoc,telefono,celular,email) VALUES (?,?,?,?,?,?,?,?)",undef,$cuenta,'1210001',$dsc,$memo,$ruc,$telefono,$celular,$correo) or ($err=$DBI::errstr);
 
	}

	$dbh9->do("REPLACE ruc(ruc,nombre,direccion) VALUES (?,?,?)",undef,$ruc,$dsc,$memo);
    $mensaje = "<b><center>Se registro el siguiente anexo : $dsc</center></b>";
	}else{
		print "<br>se actualizo nombre: $dsc con cuenta : ".param('rucreal');
		#$dbh->do("REPLACE cc_anexo(tipo_anexo,cuenta,dsc,referencia,moneda,ndoc,defectodesc,telefono,celular,email) VALUES (?,?,?,?,?,?,?,?,?,?)",undef,$cuenta,$ruc,$dsc,$memo,$moneda,$ruc,$desccliente,$telefono,$celular,$correo) or ($err=$DBI::errstr);
    $dbh->do("UPDATE cc_anexo SET dsc='$dsc', ndoc='$ruc', referencia='$memo', telefono='$telefono', celular='$celular', email='$correo'    WHERE cuenta='".param('rucreal')."'");
  $mensaje = "<b><center>Se actualizo el siguiente anexo : $dsc</center></b>";
	
		}
	
}else{
	if ($cuenta eq '09'){
			my $dbh2 = connectdb();
			my ($sth2,$ref2);
			#my ($cuentaactual1,$siguientecuenta1) = $dbh2->selectrow_array("select COUNT(*) as totalcuenta, (COUNT(*)+1) as siguientecuenta  from cc_anexo where tipo_anexo='09'");
   if (param('optw') eq 'ingresar'){
    #$dbh->do("REPLACE cc_anexo(tipo_anexo,cuenta,dsc,referencia,moneda,ndoc) VALUES (?,?,?,?,?,?)",undef,$cuenta,'421200'.$siguientecuenta1,$dsc,$memo,$moneda,$ruc) or ($err=$DBI::errstr);
      $sth2 = $dbh2->prepare("SELECT dsc,referencia FROM cc_anexo WHERE tipo_anexo='09' and ndoc='$ruc'");
      $sth2->execute();
      $ref2 = $sth2->fetchrow_hashref();
      if ($sth2->rows) {
   $mensaje = "<b><center>El registro:$ruc es utilizado para: ". $ref2->{'dsc'} ." - " . $ref2->{'referencia'} . "</center></b>";
    } else{
    	my $cuenta42= "421200" . ($dbh->selectrow_array("SELECT (CAST(SUBSTR(cuenta,7) AS UNSIGNED)) as numero FROM cc_anexo WHERE tipo_anexo='09' ORDER BY numero DESC LIMIT 1") + 1);
  	    $dbh->do("INSERT INTO cc_anexo(cuenta,dsc,referencia,ndoc,tipo_anexo,moneda) VALUES ('$cuenta42','".$dsc."','".$memo."','$ruc','$cuenta','$moneda')") or ($err=$DBI::errstr);
          
    	 $mensaje = "<b><center>Se registro el siguiente anexo : $dsc</center></b>";
    	}
      	
      	            
                      

	
  }else{
  	 $dbh->do("UPDATE cc_anexo SET dsc='$dsc', ndoc='$ruc' , referencia='$memo'  WHERE cuenta='".param('rucreal')."'");
  
  	$mensaje = "<b><center>Se actualizo el siguiente anexo : $dsc</center></b>";
	
  	}
 
		
	}else{
		$dbh->do("REPLACE cc_anexo(tipo_anexo,cuenta,dsc,referencia,moneda,ndoc) VALUES (?,?,?,?,?,?)",undef,$cuenta,$ruc,$dsc,$memo,$moneda,$ruc) or ($err=$DBI::errstr);
      $mensaje = "<b><center>Registro correcto para anexo : $dsc</center></b>";
	
		}
	
	  
	} 
        
        print $err,"<br>" if ($err);
             print $mensaje;
             print "<br><center><a href='?opt=anexos&seccion=$seccion&offset=".param('offset')."&param1=".param('param1')."' target='inferior' title='Regresar'>".img({-src=>"/images/return.png",-border=>"0",-alt=>"return.png"})."</a></center>";

    	#print redirect("?opt=anexos&seccion=$seccion&offset=".param('offset')."&param1=".param('param1'));
      return;
    }

    if(param('opty') eq "show"){
	 my $sql = "SELECT tipo_anexo,cuenta,dsc,referencia,moneda FROM cc_anexo WHERE cuenta='".param('cuenta')."'";
	   ($cuenta,$ruc,$dsc,$memo,$moneda) = $dbh->selectrow_array($sql);


    }

 if (param('opty') eq 'delete') {
        my $err;

        $dbh->do("DELETE from cc_anexo  WHERE ndoc='$ruc'")or ($err=$DBI::errstr);
        print $err,"<br>" if ($err);
             $mensaje = "<b><center>Se elimino el siguiente anexo : $dsc</center></b>";
	 print $mensaje;
             print "<br><center><a href='?opt=anexos&seccion=$seccion&offset=".param('offset')."&param1=".param('param1')."' target='inferior' title='Regresar'>".img({-src=>"/images/return.png",-border=>"0",-alt=>"return.png"})."</a></center>";

    	#print redirect("?opt=anexos&seccion=$seccion&offset=".param('offset')."&param1=".param('param1'));
	return;
    }


    # **************
    # Paginador
    # **************
    my $lpp = 10;   # lineas por pagina
                                                                                                                            
    # Calcula el numero de paginas
    $sql = "SELECT count(*) as records FROM cc_tipoanexo";
    my $records = $dbh->selectrow_array ($sql);
    my $pages = int($records/$lpp) + (($records % $lpp > 0) ? 1 : 0);
    my $firstpage = (param('param1') eq '') ? 1 : param('param1');
    my $lastpage  = ($firstpage + $lpp < $pages) ?  $firstpage + $lpp : $pages;
    my $offset    = (param('offset') eq '') ? 0 : param('offset');
    my $pageno    = ($offset + $lpp)  / $lpp;   # Pagina actual
    # **************

    my $sql="SELECT cuenta AS cta,dsc FROM cc_tipoanexo  ORDER BY cuenta LIMIT $offset,$lpp";
    $sth = $dbh->prepare($sql);
    $sth->execute();



####
#### Despliega la cuenta
####

 $cuenta=$seccion;

my $tipo=1;
my %options = ("0" => "Nuevos Soles", "1" => "Dolares Americanos");


my $ndocreal = numdocreal($ruc);
print "RUC: $ruc ,cuenta: $cuenta -> ndoc:".numdocreal($ruc);
print start_form();

print "<br><table border=0 cellpadding=2 cellspacing=2 align=center class=".$style."FormTABLE>";
print Tr(td({-colspan=>"2",-class=>$style."FormHeaderFont"},b("Registro de anexos")));

# Detalle en cabecera del formulario
if ($tipo eq '0' or $tipo eq '1' or $tipo eq '2') { # Detalle de cuentas de balance
   print Tr({-class=>$style."FieldCaptionTD"},td(b("Anexo")),td(table(Tr(td(b($cuenta)),td("&nbsp;&nbsp;") ))));
print hidden(-name=>"moneda",-value=>"0",-override=>1);
   if ($chequera eq '1') {
      print Tr({-class=>$style."FieldCaptionTD"},td(b("Chequera")),td(table(Tr(td(b("Del&nbsp;:&nbsp;")),td(textfield(-name=>"cheque_del",-value=>$cheque_del,-size=>"10",-maxlength=>"10")),td(b("Al&nbsp;:&nbsp;")),td(textfield(-name=>"cheque_al",-value=>$cheque_al,-size=>"10",-maxlength=>"10")),td(b("Actual&nbsp;:&nbsp;")),td(textfield(-name=>"cheque_num",-value=>$cheque_num,-size=>"10",-maxlength=>"10"))))) );
   } 

} else {
   print Tr({-class=>$style."FieldCaptionTD"},td(b("Cuenta")),td(b($cuenta)));
   print hidden(-name=>"moneda",-value=>"0",-override=>1);
}

# Detalle de Ruc en Cuentas por Cobrar y Cuentas por Pagar
if (substr($cuenta,0,2) eq '05' or substr($cuenta,0,2) eq '09') {
   print Tr({-class=>$style."FieldCaptionTD"},td(b("Ruc")),td(textfield(-name=>"ruc",-value=>$ndocreal,-size=>"11",-maxlength=>"11")));
}
else
{
 # Todas las cuentas
 print Tr({-class=>$style."FieldCaptionTD"},td(b("Codigo ")),td(textfield(-name=>"ruc",-value=>$ruc,-size=>"18",-maxlength=>"18")));
}
print Tr({-class=>$style."FieldCaptionTD"},td(b("Nombre del anexo")),td(textfield(-name=>"dsc",-value=>$dsc,-size=>"50",-maxlength=>"50")));
print Tr({-class=>$style."FieldCaptionTD"},td(b("Referencia")),td(textfield(-name=>"memo",-value=>$memo,-size=>"50",-maxlength=>"50")));
#if (substr($cuenta,0,2) eq '05' or substr($cuenta,0,2) eq '09') {
if (substr($cuenta,0,2) eq '05') {	
	my $dbh2 = connectdb();
	my ($telefono1,$celular1,$correo1) = $dbh->selectrow_array("select telefono,celular,email from cc_anexo WHERE cuenta='$ruc'");
 
print Tr({-class=>$style."FieldCaptionTD"},td(b("Telefono")),td(textfield(-name=>"telefono",-value=>$telefono1,-size=>"11",-maxlength=>"11")));
print Tr({-class=>$style."FieldCaptionTD"},td(b("Celular")),td(textfield(-name=>"celular",-value=>$celular1,-size=>"11",-maxlength=>"11")));
print Tr({-class=>$style."FieldCaptionTD"},td(b("Correo")),td(textfield(-name=>"correo",-value=>$correo1,-size=>"50",-maxlength=>"50")));
}
# Botones 
if (param('optz') eq 'add') {
    print Tr({-class=>$style."FieldCaptionTD",-align=>"center"},td({-colspan=>"2"},button(-class=>$style."Button",-value=>"Aceptar",-onclick=>"document.forms[0].optx.value='addanexo';document.forms[0].opty.value='save';document.forms[0].optw.value='ingresar';submit();")));
} else {
    print Tr({-class=>$style."FieldCaptionTD",-align=>"center"},td({-colspan=>"2"},table(Tr(td(button(-class=>$style."Button",-value=>"Guardar Cambios",-onclick=>"document.forms[0].optx.value='addanexo';document.forms[0].opty.value='save';document.forms[0].optw.value='actualiza';document.forms[0].rucreal.value='$ruc';submit();")),td(button(-class=>$style."Button",-value=>"Eliminar esta cuenta",-onclick=>"document.forms[0].optx.value='addanexo';document.forms[0].opty.value='delete';submit();"))))));
}

print "</table>";

print hidden(-name=>"opt",-value=>"editcuenta",-override=>1);
print hidden(-name=>"optx",-value=>"addanexo",-override=>1);
print hidden(-name=>"opty",-value=>"",-override=>1);
print hidden(-name=>"optw",-value=>"",-override=>1);
print hidden(-name=>"ruc",-value=>"",-override=>1);
print hidden(-name=>"rucreal",-value=>"",-override=>1);
print hidden(-name=>"chequera",-value=>"$chequera",-override=>1);
print hidden(-name=>"cheque_del",-value=>"$cheque_del",-override=>1);
print hidden(-name=>"cheque_al",-value=>"$cheque_al",-override=>1);
print hidden(-name=>"cheque_num",-value=>"$cheque_num",-override=>1);
print hidden(-name=>"seccion",-value=>$seccion,-override=>1);
print hidden(-name=>"subcta",-value=>$subcta,-override=>1);
print hidden(-name=>"cuenta",-value=>$cuenta,-override=>1);

print hidden(-name=>"cta_d_1",-value=>"$cta_d_1",-override=>1);
print hidden(-name=>"cta_h_1",-value=>"$cta_h_1",-override=>1);

my $offset = param('offset');
my $param1 = param('param1');
print hidden(-name=>"offset",-value=>"$offset",-override=>1);
print hidden(-name=>"param1",-value=>"$param1",-override=>1);

print end_form();



    print "<center><a href='?opt=anexos' target='inferior' title='Regresar'>".img({-src=>"/images/return.png",-border=>"0",-alt=>"return.png"})."</a></center>";

    return;
}

# --------------------------------------
# Mantenimiento de anexos 
# --------------------------------------
if (param('optx') eq 'anexo') {

    if (param('opty') eq 'save') {
       my $count = 0;
       my $err;
       foreach my $k (@cta) {
               # Actulizar la cuenta
               $dbh->do("REPLACE cc_tipoanexo(cuenta,dsc,scuenta) VALUES (?,?,?)",undef,$k,$dsc[$count],$scuenta[$count]) or ($err=$DBI::errstr);
               print $err,"<br>" if ($err);
              $count++;
       }
    }

    # **************
    # Paginador
    # **************
    my $lpp = 10;   # lineas por pagina
                                                                                                                            
    # Calcula el numero de paginas
    $sql = "SELECT count(*) as records FROM cc_tipoanexo";
    my $records = $dbh->selectrow_array ($sql);
    my $pages = int($records/$lpp) + (($records % $lpp > 0) ? 1 : 0);
    my $firstpage = (param('param1') eq '') ? 1 : param('param1');
    my $lastpage  = ($firstpage + $lpp < $pages) ?  $firstpage + $lpp : $pages;
    my $offset    = (param('offset') eq '') ? 0 : param('offset');
    my $pageno    = ($offset + $lpp)  / $lpp;   # Pagina actual
    # **************

    my $sql="SELECT cuenta AS cta,dsc,scuenta FROM cc_tipoanexo  ORDER BY cuenta LIMIT $offset,$lpp";
    $sth = $dbh->prepare($sql);
    $sth->execute();

    print start_form();

    # Despliega las cuentas principales
    print "<br><table border=0 cellpadding=2 cellspacing=2 align=center>";
    print Tr(td({-colspan=>"4",-align=>"center"},b("Lista de anexos").img({-src=>"/images/spacer.gif",-alt=>"spacer.gif",-width=>"20",-height=>"1"}).a({-href=>"?opt=editcuenta&optx=anexo&opty=add",-target=>"inferior",-title=>"Agregar anexo"}).img({-src=>"/images/increment.png",-alt=>"increment.png"}) ));
    print Tr({-align=>"center",-bgcolor=>"#FFAF55"},td("&nbsp;"),td(b("Codigo")),td({-width=>"300"},b("Nombre del anexo")),td({-width=>"20"},b("Cuenta")));

    while ($ref = $sth->fetchrow_hashref()) {
          if (grep (/^$ref->{'cta'}$/,@checknum)) {
             print Tr({-class=>$style."lkitem"},td("&nbsp;"),td({-align=>"center"},textfield(-name=>"cta",-value=>$ref->{'cta'},-class=>$style."NoInput",-size=>"2",-maxlength=>"2",-OnFocus=>"blur();")),td(textfield(-name=>"dsc",-value=>$ref->{'dsc'},-size=>"42",-maxlength=>"50") ), td(textfield(-name=>"scuenta",-value=>$ref->{'scuenta'},-size=>"7",-maxlength=>"7") ));
          } else {
             print Tr({-class=>$style."lkitem"},td(checkbox(-name=>"checknum",-value=>$ref->{'cta'},-label =>"",-checked=>0)),td({-align=>"center"},$ref->{'cta'}),td({-width=>"300"},$ref->{'dsc'}),td({-width=>"20"},$ref->{'scuenta'}));
          }
    }
    print Tr({-bgcolor=>"#FFAF55"},td("&nbsp;"),td("&nbsp;"),td("&nbsp;"),td("&nbsp;"),td("&nbsp;"));

    if (param('opty') eq 'add') {
       print Tr({-class=>$style."FieldCaptionTD"},td("&nbsp;"),td({-align=>"center"},textfield(-name=>"cta",-value=>"",-size=>"2",-maxlength=>"2")),td(textfield(-name=>"dsc",-value=>"",-size=>"42",-maxlength=>"50")), td(textfield(-name=>"scuenta",-value=>"",-size=>"7",-maxlength=>"7",-onchange=>"document.forms[0].opty.value='save';submit();")));
    } 

    print "</table>";

    # **************
    # Paginador
    # **************
    if ($pages > 1) {
       talonpaginador($firstpage,$lastpage,$lpp,$pageno,$pages,"?opt=editcuenta&optx=anexo");
    }

    if (param('opty') eq 'mod' or param('opty') eq 'add') {
       print br(),table({-align=>"center"},Tr({-align=>"center"},td(button(-class=>$style."Button",-value=>"Aceptar",-onclick=>"document.forms[0].opty.value='save';submit();"))));
    } else {
       print br(),table({-align=>"center"},Tr({-align=>"center"},td({-colspan=>"2"},"Con los seleccionados")),Tr({-align=>"center"},td(button(-class=>$style."Button",-value=>"Modificar",-onclick=>"document.forms[0].opty.value='mod';submit();"))));
    } 
    
    my $offset = param('offset');
    my $param1 = param('param1');

    print hidden(-name=>"opt",-value=>"editcuenta",-override=>1);
    print hidden(-name=>"optx",-value=>"anexo",-override=>1);
    print hidden(-name=>"opty",-value=>"",-override=>1);
    print hidden(-name=>"offset",-value=>"$offset",-override=>1);
    print hidden(-name=>"param1",-value=>"$param1",-override=>1);

    print end_form();

    print "<center><a href='?opt=anexos' target='inferior' title='Regresar'>".img({-src=>"/images/return.png",-border=>"0",-alt=>"return.png"})."</a></center>";

    return;
}

# --------------------------------------
# Mantenimiento de anexos II
# --------------------------------------
if (param('optx') eq 'addanexo') {

    if (param('opty') eq 'save') {
        my $err;

        $dbh->do("REPLACE cc_anexo(tipo_anexo,cuenta,dsc,referencia,moneda) VALUES (?,?,?,?,?)",undef,$cuenta,$ruc,$dsc,$memo,$moneda) or ($err=$DBI::errstr);
        print $err,"<br>" if ($err);
             
    	print redirect("?opt=anexos&seccion=$seccion&offset=".param('offset')."&param1=".param('param1'));
	return;
    }

    if(param('opty') eq "show")
     {
	 my $sql = "SELECT tipo_anexo,cuenta,dsc,referencia,moneda FROM cc_anexo WHERE cuenta='".param('cuenta')."'";
	   ($cuenta,$ruc,$dsc,$memo,$moneda) = $dbh->selectrow_array($sql);
    }

 if (param('opty') eq 'delete') {
        my $err;

        $dbh->do("DELETE from cc_anexo  WHERE cuenta='$ruc'")or ($err=$DBI::errstr);
        print $err,"<br>" if ($err);
             
    	print redirect("?opt=anexos&seccion=$seccion&offset=".param('offset')."&param1=".param('param1'));
	return;
    }


    # **************
    # Paginador
    # **************
    my $lpp = 10;   # lineas por pagina
                                                                                                                            
    # Calcula el numero de paginas
    $sql = "SELECT count(*) as records FROM cc_tipoanexo";
    my $records = $dbh->selectrow_array ($sql);
    my $pages = int($records/$lpp) + (($records % $lpp > 0) ? 1 : 0);
    my $firstpage = (param('param1') eq '') ? 1 : param('param1');
    my $lastpage  = ($firstpage + $lpp < $pages) ?  $firstpage + $lpp : $pages;
    my $offset    = (param('offset') eq '') ? 0 : param('offset');
    my $pageno    = ($offset + $lpp)  / $lpp;   # Pagina actual
    # **************

    my $sql="SELECT cuenta AS cta,dsc FROM cc_tipoanexo  ORDER BY cuenta LIMIT $offset,$lpp";
    $sth = $dbh->prepare($sql);
    $sth->execute();



####
#### Despliega la cuenta
####

 $cuenta=$seccion;

my $tipo=1;
my %options = ("0" => "Nuevos Soles", "1" => "Dolares Americanos");

print start_form();

print "<br><table border=0 cellpadding=2 cellspacing=2 align=center class=".$style."FormTABLE>";
print Tr(td({-colspan=>"2",-class=>$style."FormHeaderFont"},b("Registro de anexos")));

# Detalle en cabecera del formulario
if ($tipo eq '0' or $tipo eq '1' or $tipo eq '2') { # Detalle de cuentas de balance
   print Tr({-class=>$style."FieldCaptionTD"},td(b("Anexo")),td(table(Tr(td(b($cuenta)),td("&nbsp;&nbsp;") ))));
print hidden(-name=>"moneda",-value=>"0",-override=>1);
   if ($chequera eq '1') {
      print Tr({-class=>$style."FieldCaptionTD"},td(b("Chequera")),td(table(Tr(td(b("Del&nbsp;:&nbsp;")),td(textfield(-name=>"cheque_del",-value=>$cheque_del,-size=>"10",-maxlength=>"10")),td(b("Al&nbsp;:&nbsp;")),td(textfield(-name=>"cheque_al",-value=>$cheque_al,-size=>"10",-maxlength=>"10")),td(b("Actual&nbsp;:&nbsp;")),td(textfield(-name=>"cheque_num",-value=>$cheque_num,-size=>"10",-maxlength=>"10"))))) );
   } 

} else {
   print Tr({-class=>$style."FieldCaptionTD"},td(b("Cuenta")),td(b($cuenta)));
   print hidden(-name=>"moneda",-value=>"0",-override=>1);
}

# Detalle de Ruc en Cuentas por Cobrar y Cuentas por Pagar
if (substr($cuenta,0,2) eq '05' or substr($cuenta,0,2) eq '09') {
   print Tr({-class=>$style."FieldCaptionTD"},td(b("Ruc")),td(textfield(-name=>"ruc",-value=>$ruc,-size=>"11",-maxlength=>"11")));
}
else
{
 # Todas las cuentas
 print Tr({-class=>$style."FieldCaptionTD"},td(b("Codigo ")),td(textfield(-name=>"ruc",-value=>$ruc,-size=>"18",-maxlength=>"18")));
}
print Tr({-class=>$style."FieldCaptionTD"},td(b("Nombre del anexo")),td(textfield(-name=>"dsc",-value=>$dsc,-size=>"50",-maxlength=>"50")));
print Tr({-class=>$style."FieldCaptionTD"},td(b("Referencia")),td(textfield(-name=>"memo",-value=>$memo,-size=>"50",-maxlength=>"50")));

# Botones 
if (param('optz') eq 'add') {
    print Tr({-class=>$style."FieldCaptionTD",-align=>"center"},td({-colspan=>"2"},button(-class=>$style."Button",-value=>"Aceptar",-onclick=>"document.forms[0].optx.value='addanexo';document.forms[0].opty.value='save';submit();")));
} else {
    print Tr({-class=>$style."FieldCaptionTD",-align=>"center"},td({-colspan=>"2"},table(Tr(td(button(-class=>$style."Button",-value=>"Guardar Cambios",-onclick=>"document.forms[0].optx.value='addanexo';document.forms[0].opty.value='save';submit();")),td(button(-class=>$style."Button",-value=>"Eliminar esta cuenta",-onclick=>"document.forms[0].optx.value='addanexo';document.forms[0].opty.value='delete';submit();"))))));
}

print "</table>";

print hidden(-name=>"opt",-value=>"editcuenta",-override=>1);
print hidden(-name=>"optx",-value=>"addanexo",-override=>1);
print hidden(-name=>"opty",-value=>"",-override=>1);
print hidden(-name=>"ruc",-value=>"",-override=>1);
print hidden(-name=>"chequera",-value=>"$chequera",-override=>1);
print hidden(-name=>"cheque_del",-value=>"$cheque_del",-override=>1);
print hidden(-name=>"cheque_al",-value=>"$cheque_al",-override=>1);
print hidden(-name=>"cheque_num",-value=>"$cheque_num",-override=>1);
print hidden(-name=>"seccion",-value=>$seccion,-override=>1);
print hidden(-name=>"subcta",-value=>$subcta,-override=>1);
print hidden(-name=>"cuenta",-value=>$cuenta,-override=>1);

print hidden(-name=>"cta_d_1",-value=>"$cta_d_1",-override=>1);
print hidden(-name=>"cta_h_1",-value=>"$cta_h_1",-override=>1);

my $offset = param('offset');
my $param1 = param('param1');
print hidden(-name=>"offset",-value=>"$offset",-override=>1);
print hidden(-name=>"param1",-value=>"$param1",-override=>1);

print end_form();



    print "<center><a href='?opt=anexos' target='inferior' title='Regresar'>".img({-src=>"/images/return.png",-border=>"0",-alt=>"return.png"})."</a></center>";

    return;
}

# --------------------------------------
# Mantenimiento Cuentas Principales (XX)
# --------------------------------------
if (param('optx') eq 'seccion') {

    if (param('opty') eq 'save') {
       my $count = 0;
       my $err;
       foreach my $k (@cta) {
               # Actulizar la cuenta
               $dbh->do("REPLACE cc_cuentas(cuenta,dsc,tipo) VALUES (?,?,?)",undef,$k."0000",$dsc[$count],$tipo[$count]) or ($err=$DBI::errstr);
               print $err,"<br>" if ($err);
               # Actualizar la columna tipo en toda la clase
               $dbh->do("UPDATE cc_cuentas SET tipo=".$tipo[$count]." WHERE substring(cuenta,1,2) = '$k' AND substring(cuenta,3,4) != '0000'"); 
               $count++;
               print $err,"<br>" if ($err);
       }
    }

    # **************
    # Paginador
    # **************
    my $lpp = 10;   # lineas por pagina
                                                                                                                            
    # Calcula el numero de paginas
    $sql = "SELECT count(*) as records FROM cc_cuentas WHERE substring(cuenta,3,1)='0'";
    my $records = $dbh->selectrow_array ($sql);
    my $pages = int($records/$lpp) + (($records % $lpp > 0) ? 1 : 0);
    my $firstpage = (param('param1') eq '') ? 1 : param('param1');
    my $lastpage  = ($firstpage + $lpp < $pages) ?  $firstpage + $lpp : $pages;
    my $offset    = (param('offset') eq '') ? 0 : param('offset');
    my $pageno    = ($offset + $lpp)  / $lpp;   # Pagina actual
    # **************

    my $sql="SELECT substring(cuenta,1,2) AS cta,tipo,dsc FROM cc_cuentas WHERE substring(cuenta,3,1)='0' ORDER BY cuenta LIMIT $offset,$lpp";
    $sth = $dbh->prepare($sql);
    $sth->execute();

    print start_form();

    # Despliega las cuentas principales
    print "<br><table border=0 cellpadding=2 cellspacing=2 align=center>";
    print Tr(td({-colspan=>"4",-align=>"center"},b("Cuentas Principales").img({-src=>"/images/spacer.gif",-alt=>"spacer.gif",-width=>"20",-height=>"1"}).a({-href=>"?opt=editcuenta&optx=seccion&opty=add",-target=>"inferior",-title=>"Agregar Cuenta Principal"}).img({-src=>"/images/increment.png",-alt=>"increment.png"}) ));
    print Tr({-align=>"center",-bgcolor=>"#FFAF55"},td("&nbsp;"),td(b("Cuenta")),td({-width=>"300"},b("Nombre de la Cuenta Principal"),td(b("Tipo"))));

    while ($ref = $sth->fetchrow_hashref()) {
          if (grep (/^$ref->{'cta'}$/,@checknum)) {
             print Tr({-class=>$style."lkitem"},td("&nbsp;"),td({-align=>"center"},textfield(-name=>"cta",-value=>$ref->{'cta'},-class=>$style."NoInput",-size=>"2",-maxlength=>"2",-OnFocus=>"blur();")),td(textfield(-name=>"dsc",-value=>$ref->{'dsc'},-size=>"42",-maxlength=>"50")),td(scrolling_list(-name =>"tipo",-values=>["0","1","2","3","4","5","6","7","8","9"],-labels=>\%options0,-size =>1,-multiple=>0,-default=>["$ref->{'tipo'}"])));
          } else {
             print Tr({-class=>$style."lkitem"},td(checkbox(-name=>"checknum",-value=>$ref->{'cta'},-label =>"",-checked=>0)),td({-align=>"center"},$ref->{'cta'}),td({-width=>"300"},$ref->{'dsc'}),td($options0{$ref->{'tipo'}}));
          }
    }
    print Tr({-bgcolor=>"#FFAF55"},td("&nbsp;"),td("&nbsp;"),td("&nbsp;"),td("&nbsp;"));

    if (param('opty') eq 'add') {
       print Tr({-class=>$style."FieldCaptionTD"},td("&nbsp;"),td({-align=>"center"},textfield(-name=>"cta",-value=>"",-size=>"2",-maxlength=>"2")),td(textfield(-name=>"dsc",-value=>"",-size=>"42",-maxlength=>"50",-onchange=>"document.forms[0].opty.value='save';submit();")),td(scrolling_list(-name =>"tipo",-values=>["0","1","2","3"],-labels=>\%options0,-size =>1,-multiple=>0)));
    } 

    print "</table>";

    # **************
    # Paginador
    # **************
    if ($pages > 1) {
       talonpaginador($firstpage,$lastpage,$lpp,$pageno,$pages,"?opt=editcuenta&optx=seccion");
    }

    if (param('opty') eq 'mod' or param('opty') eq 'add') {
       print br(),table({-align=>"center"},Tr({-align=>"center"},td(button(-class=>$style."Button",-value=>"Aceptar",-onclick=>"document.forms[0].opty.value='save';submit();"))));
    } else {
       print br(),table({-align=>"center"},Tr({-align=>"center"},td({-colspan=>"2"},"Con los seleccionados")),Tr({-align=>"center"},td(button(-class=>$style."Button",-value=>"Modificar",-onclick=>"document.forms[0].opty.value='mod';submit();"))));
    } 
    
    my $offset = param('offset');
    my $param1 = param('param1');

    print hidden(-name=>"opt",-value=>"editcuenta",-override=>1);
    print hidden(-name=>"optx",-value=>"seccion",-override=>1);
    print hidden(-name=>"opty",-value=>"",-override=>1);
    print hidden(-name=>"offset",-value=>"$offset",-override=>1);
    print hidden(-name=>"param1",-value=>"$param1",-override=>1);

    print end_form();

    print "<center><a href='?opt=listcuentas' target='inferior' title='Regresar'>".img({-src=>"/images/return.png",-border=>"0",-alt=>"return.png"})."</a></center>";

    return;
}

# ----------------------------------
# Mantenimiento de Sub Cuentas (XXX)
# ----------------------------------
if (param('optx') eq 'subcta') {

    if (param('opty') eq 'save') {
       my $cta     = sprintf("%03d",param('cta'))."000";
       my $dsc     = param('dsc');

       # El tipo de cuenta debe ser heredado de su cuenta principal
       my $tipo = $dbh->selectrow_array("SELECT tipo FROM cc_cuentas WHERE cuenta='".substr($cta,0,2)."0000'");
               
       # -- Modifica datos de la subcuenta --
       $dbh->do("REPLACE cc_cuentas(cuenta,tipo,dsc) VALUES (?,?,?)",undef,$cta,$tipo,$dsc) or (my $err=$DBI::errstr);
       print $err,"<br>" if ($err);

       # -- Modifica el campo cccod en toda la subcuenta --
       modifica_operaciones($cta,$cccod);
    }

    my %options  = ("0" => "No", "1" => "Si");
    my $sql="SELECT substring(cuenta,1,3) AS cta,dsc,cccod FROM cc_cuentas WHERE substring(cuenta,1,2) = '".substr($seccion,0,2)."' AND substring(cuenta,3,1) !='0' AND substring(cuenta,4,3)='000' ORDER BY cuenta";
    #print $sql,"<br>";

    $sth = $dbh->prepare($sql);
    $sth->execute();

    print start_form();

    print "<br><table border=0 cellpadding=2 cellspacing=2 align=center>";
    print Tr(td({-colspan=>"4",-align=>"center",-class=>$style."lkitem"},b("Sub-Cuentas Clase&nbsp;". substr($seccion,0,2)).img({-src=>"/images/spacer.gif",-alt=>"spacer.gif",-width=>"20",-height=>"1"}).a({-href=>"?opt=editcuenta&optx=subcta&opty=add&seccion=$seccion",-target=>"inferior",-title=>"Agregar Sub-Cuenta"}).img({-src=>"/images/increment.png",-alt=>"increment.png"}) ));
    print Tr({-bgcolor=>"#FFAF55",-class=>$style."lkitem",-align=>"center"},td({-width=>"30"},"&nbsp;"),td(b("SubCuenta")),td({-width=>"300"},b("Nombre de la Sub Cuenta")));

    while ($ref = $sth->fetchrow_hashref()) {

          if (grep (/^$ref->{'cta'}$/,@checknum)) {
             print Tr({-class=>$style."lkitem"},td("&nbsp;"),td({-align=>"center"},textfield(-name=>"cta",-value=>"$ref->{'cta'}",-override=>"1",-class=>$style."NoInput",-size=>"3",-maxlength=>"3",-OnFocus=>"blur();")),td({-width=>"300"},textfield(-name=>"dsc",-value=>$ref->{'dsc'},-size=>"42",-maxlength=>"50")));
          } else {
             print Tr({-class=>$style."lkitem"},td({-align=>"center"},checkbox(-name=>"checknum",-value=>$ref->{'cta'},-label =>"",-checked=>0,-onclick=>"document.forms[0].cta.value=$ref->{'cta'};document.forms[0].opty.value='mod';submit();")),td({-align=>"center"},$ref->{'cta'}),td({-width=>"300"},$ref->{'dsc'}));
          }
    }

    if (param('opty') eq 'add') {
       # Incrementa la cuenta en 1 respecto a 1a ultima subcuenta de la clase 'XX'
       my $cuenta = $dbh->selectrow_array("SELECT cuenta FROM cc_cuentas WHERE substring(cuenta,1,2) = '".substr($seccion,0,2)."' AND substring(cuenta,4,3)='000' ORDER BY cuenta DESC LIMIT 1");
       my $digit = scalar(substr($cuenta,2,1)) + 1;
       if ($digit >=1 and $digit <=9) {
           my $cta = substr($cuenta,0,2) . $digit. '000';
           print Tr({-class=>$style."FieldCaptionTD"},td("&nbsp;"),td({-align=>"center"},textfield(-name=>"cta",-value=>$cta,-size=>"3",-maxlength=>"3",-class=>$style."NoInput",-OnFocus=>"blur();")),td({-width=>"300"},textfield(-name=>"dsc",-value=>"",-size=>"42",-maxlength=>"50",-onchange=>"document.forms[0].cta.value=$cta;document.forms[0].opty.value='save';submit();")));
       }
    } 

    print Tr({-bgcolor=>"#FFAF55"},td("&nbsp;"),td("&nbsp;"),td("&nbsp;"));

    print "</table>";

    if (param('opty') eq 'add') {
       print br(),table({-align=>"center"},Tr({-align=>"center"},td(button(-class=>$style."Button",-value=>"Aceptar",-onclick=>"document.forms[0].opty.value='save';submit();"))));
    }

    if (param('opty') eq 'mod') {
       print br(),table({-align=>"center"},Tr({-align=>"center"},td(button(-class=>$style."Button",-value=>"Aceptar",-onclick=>"document.forms[0].opty.value='save';submit();"))));
    } 
    
    print hidden(-name=>"opt",-value=>"editcuenta",-override=>1);
    print hidden(-name=>"optx",-value=>"subcta",-override=>1);
    print hidden(-name=>"opty",-value=>"",-override=>1);
    print hidden(-name=>"seccion",-value=>$seccion,-override=>1);
    print hidden(-name=>"subcta",-value=>$subcta,-override=>1);
    print hidden(-name=>"cta",-value=>"",-override=>1);
    print end_form();

    print "<center><a href='?opt=listcuentas&seccion=$seccion&subcta=$subcta' target='inferior' title='Regresar'>".img({-src=>"/images/return.png",-border=>"0",-alt=>"return.png"})."</a></center>";

    return;
}

# --------------------------------------------
# Mantenimiento de cuentas de la clase 'XXXXXX'
# --------------------------------------------
if (param('optx') eq 'save') {

   my $err;
   # El tipo de cuenta debe ser heredado de su cuenta principal
   my $sql = "SELECT tipo FROM cc_cuentas WHERE cuenta='".substr($cuenta,0,2)."0000'";
   my $tipo = $dbh->selectrow_array($sql);

   $dbh->do("REPLACE cc_cuentas(cuenta,dsc,tipo,ruc,memo,rvflag,rcflag,cccod,chequera,cheque_del,cheque_al,cheque_num,cta_dfc_g,cta_dfc_p,cta_tax_1,tax_1_per,cta_tax_2,tax_2_per,cta_d_1,cta_h_1,moneda) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",undef,$cuenta,$dsc,$tipo,$ruc,$memo,$rvflag,$rcflag,$cccod,$chequera,$cheque_del,$cheque_al,$cheque_num,$cta_dfc_g,$cta_dfc_p,$cta_tax_1,$tax_1_per,$cta_tax_2,$tax_2_per,$cta_d_1,$cta_h_1,$moneda) or ($err=$DBI::errstr);
   print $err,"<br>" if ($err);

   #print "chequera=$chequera";
   #print $cuenta,"-",$dsc,"-",$tipo,"-",$memo,"-",$rvflag,"-",$rcflag,"-",$cccod,"-",$cta_dfc_g,"-",$cta_dfc_p,"-",$cta_tax_1,"-",$tax_1_per,"-",$cta_tax_2,"-",$tax_2_per,"-",$cta_d_1,"-",$cta_h_1,"-",$moneda;

   print redirect("?opt=listcuentas&subcta=$subcta&seccion=$seccion&offset=".param('offset')."&param1=".param('param1'));
   return;
}

if (param('optx') eq 'delete') {
    # Si no existen hijos eliminar al padre
    my $sql="SELECT count(*) AS records FROM cc_diariodet WHERE cuenta='".param('cuenta')."'";
    if (!$dbh->selectrow_array($sql)) {
        $dbh->do("DELETE FROM cc_cuentas WHERE cuenta='".param('cuenta')."'");
        print redirect("?opt=listcuentas&subcta=$subcta&seccion=$seccion");
        return;
    } else {
        print "<div align=center class=".$style."Error>No se puede eliminar esta cuenta, tiene referencias.</div>";
    }
}

if (param('optx') eq 'change_flag') {
   $dbh->do("UPDATE cc_cuentas SET chequera='". ((param('cheque_flag') eq '0') ? '1' : '0')."' WHERE cuenta='".param('cuenta')."'");
}

# Presenta los datos de la cuenta
# Es una cuenta de banco ?
my $chequera = $dbh->selectrow_array("SELECT chequera FROM cc_cuentas WHERE cuenta ='".substr(param('cuenta'),0,3)."000'");

my ($cuenta,$dsc,$tipo,$ruc,$memo,$rvflag,$rcflag,$cccod,$cheque_del,$cheque_al,$cheque_num,$cta_dfc_g,$cta_dfc_p,$cta_tax_1,$tax_1_per,$cta_tax_2,$tax_2_per,$cta_d_1,$cta_h_1,$moneda);

if (param('optx') eq 'add') {
    # Incrementa la cuenta en 1 respecto a 1a ultima subcuenta de la clase 'XXX'
    my $sql = "SELECT cuenta FROM cc_cuentas WHERE substring(cuenta,1,3) like '".param('subcta')."%' ORDER BY cuenta DESC LIMIT 1";
    my $digit = scalar(substr($dbh->selectrow_array($sql),3,3)) + 1;
    if ($digit >=1 and $digit <=999) { # Rango de 001 a 999
        $cuenta = param('subcta') . sprintf("%03d",$digit);
    } else {                           # Excede la capacidad del campo
        return;
    }
} else {
   my $sql = "SELECT cuenta,dsc,tipo,ruc,memo,rvflag,rcflag,cccod,cheque_del,cheque_al,cheque_num,cta_dfc_g,cta_dfc_p,cta_tax_1,tax_1_per,cta_tax_2,tax_2_per,cta_d_1,cta_h_1,moneda FROM cc_cuentas WHERE cuenta='".param('cuenta')."'";
   ($cuenta,$dsc,$tipo,$ruc,$memo,$rvflag,$rcflag,$cccod,$cheque_del,$cheque_al,$cheque_num,$cta_dfc_g,$cta_dfc_p,$cta_tax_1,$tax_1_per,$cta_tax_2,$tax_2_per,$cta_d_1,$cta_h_1,$moneda) = $dbh->selectrow_array($sql);
}

####
#### Despliega la cuenta
####

my %options = ("0" => "Nuevos Soles", "1" => "Dolares Americanos");

print start_form();

print "<br><table border=0 cellpadding=2 cellspacing=2 align=center class=".$style."FormTABLE>";
print Tr(td({-colspan=>"2",-class=>$style."FormHeaderFont"},b("Registro de Cuenta")));

# Detalle en cabecera del formulario
if ($tipo eq '0' or $tipo eq '1' or $tipo eq '2') { # Detalle de cuentas de balance
   print Tr({-class=>$style."FieldCaptionTD"},td(b("Cuenta")),td(table(Tr(td(b($cuenta)),td("&nbsp;&nbsp;"),td(b("Moneda:")),td(scrolling_list(-name =>"moneda",-values=>["0","1"],-labels=>\%options,-size=>1,-multiple=>0,-default=>["$moneda"])) ))));
   if ($chequera eq '1') {
      print Tr({-class=>$style."FieldCaptionTD"},td(b("Chequera")),td(table(Tr(td(b("Del&nbsp;:&nbsp;")),td(textfield(-name=>"cheque_del",-value=>$cheque_del,-size=>"10",-maxlength=>"10")),td(b("Al&nbsp;:&nbsp;")),td(textfield(-name=>"cheque_al",-value=>$cheque_al,-size=>"10",-maxlength=>"10")),td(b("Actual&nbsp;:&nbsp;")),td(textfield(-name=>"cheque_num",-value=>$cheque_num,-size=>"10",-maxlength=>"10"))))) );
   } 

} else {
   print Tr({-class=>$style."FieldCaptionTD"},td(b("Cuenta")),td(b($cuenta)));
   print hidden(-name=>"moneda",-value=>"0",-override=>1);
}

# Detalle de Ruc en Cuentas por Cobrar y Cuentas por Pagar
if (substr($cuenta,0,2) eq '12' or substr($cuenta,0,2) eq '42') {
   print Tr({-class=>$style."FieldCaptionTD"},td(b("Ruc")),td(textfield(-name=>"ruc",-value=>$ruc,-size=>"11",-maxlength=>"11")));
}

# Todas las cuentas
print Tr({-class=>$style."FieldCaptionTD"},td(b("Nombre de la Cuenta")),td(textfield(-name=>"dsc",-value=>$dsc,-size=>"50",-maxlength=>"50")));
print Tr({-class=>$style."FieldCaptionTD"},td(b("Memo")),td(textfield(-name=>"memo",-value=>$memo,-size=>"50",-maxlength=>"50")));

# Detalle de cuentas de transferencia
if ($tipo eq '5') {
   my $cta_d_1 = (defined(param('cta_d_1'))) ? param('cta_d_1') : $cta_d_1;
   my $cta_h_1 = (defined(param('cta_h_1'))) ? param('cta_h_1') : $cta_h_1;
   print Tr({-class=>$style."FieldCaptionTD"},td(b("Cuentas de destino")),td(table({-border=>"0",-width=>"100%"},Tr(td({-width=>"100"},"Cuenta Debe:"),td(CuentaNameScroll('cta_d_1','94','95','1',$cta_d_1))),Tr(td("Cuenta Haber:"),td(CuentaNameScroll('cta_d_1','79','79','1',$cta_d_1))) )) );
}                                                                                                                            
# Cuentas afecto a impuestos
my $cta_tax_1 = (defined(param('cta_tax_1'))) ? param('cta_tax_1') : $cta_tax_1;
my $cta_tax_2 = (defined(param('cta_tax_2'))) ? param('cta_tax_2') : $cta_tax_2;
print Tr({-class=>$style."FieldCaptionTD"},td(b("Afecto al Impuesto")),td(table({-border=>"0",-width=>"100%"},Tr(td({-width=>"100"},"Cuenta Debe:"),td(CuentaNameScroll('cta_tax_1','40','40','1',$cta_tax_1))),Tr(td("Cuenta Haber:"),td(CuentaNameScroll('cta_tax_2','67','67','1',$cta_tax_2))),Tr(td("Tasa"),td(textfield(-name=>"tax_1_per",-value=>$tax_1_per,-size=>"7",-maxlength=>"7"))) )) );

# Si es una cuenta en moneda extranjera
#if ($ref->{'moneda'} eq '1') {  
#    print Tr({-class=>$style."FieldCaptionTD"},td("Diferencia de Cambio"),td(table(Tr(td({-width=>"70"},"Ganancias:"),td(textfield(-name=>"cta_dfc_g",-value=>$ref->{'cta_dfc_g'},-size=>"7",-maxlength=>"7"),td({-width=>"70"},"P&eacute;rdidas:"),td(textfield(-name=>"cta_dfc_p",-value=>$ref->{'cta_dfc_p'},-size=>"7",-maxlength=>"7")) )))));
#}

# Botones 
if (param('optx') eq 'add') {
    print Tr({-class=>$style."FieldCaptionTD",-align=>"center"},td({-colspan=>"2"},button(-class=>$style."Button",-value=>"Aceptar",-onclick=>"document.forms[0].optx.value='save';submit();")));
} else {
    print Tr({-class=>$style."FieldCaptionTD",-align=>"center"},td({-colspan=>"2"},table(Tr(td(button(-class=>$style."Button",-value=>"Guardar Cambios",-onclick=>"document.forms[0].optx.value='save';submit();")),td(button(-class=>$style."Button",-value=>"Eliminar esta cuenta",-onclick=>"document.forms[0].optx.value='delete';submit();"))))));
}

print "</table>";

print hidden(-name=>"opt",-value=>"editcuenta",-override=>1);
print hidden(-name=>"optx",-value=>"",-override=>1);
print hidden(-name=>"opty",-value=>"",-override=>1);
print hidden(-name=>"ruc",-value=>"",-override=>1);
print hidden(-name=>"chequera",-value=>"$chequera",-override=>1);
print hidden(-name=>"cheque_del",-value=>"$cheque_del",-override=>1);
print hidden(-name=>"cheque_al",-value=>"$cheque_al",-override=>1);
print hidden(-name=>"cheque_num",-value=>"$cheque_num",-override=>1);
print hidden(-name=>"seccion",-value=>$seccion,-override=>1);
print hidden(-name=>"subcta",-value=>$subcta,-override=>1);
print hidden(-name=>"cuenta",-value=>$cuenta,-override=>1);

print hidden(-name=>"cta_d_1",-value=>"$cta_d_1",-override=>1);
print hidden(-name=>"cta_h_1",-value=>"$cta_h_1",-override=>1);

my $offset = param('offset');
my $param1 = param('param1');
print hidden(-name=>"offset",-value=>"$offset",-override=>1);
print hidden(-name=>"param1",-value=>"$param1",-override=>1);

print end_form();
my $link = "?opt=listcuentas&subcta=$subcta&seccion=$seccion&offset=$offset&param1=$param1";
print "<center><a href='$link' target='inferior' title='Regresar'>".img({-src=>"/images/return.png",-border=>"0",-alt=>"return.png"})."</a></center>";

}

# ------jimmy: captura el numero de documento en cc_anexo, basado en la cuenta
sub numdocreal{
	my ($cuenta) = @_;
	my $dbh = connectdb();
	
my $ndoc =	$dbh->selectrow_array("select ndoc from cc_anexo WHERE cuenta = '$cuenta'");
return($ndoc);
	
	}
	

# -----------------------------------------------------------
sub modifica_operaciones {
# -----------------------------------------------------------
my ($subcta,$cccod) = @_;

my $dbh = connectdb();
$dbh->do("UPDATE cc_cuentas SET cccod='$cccod' WHERE substring(cuenta,1,3) = '$subcta'") or (my $err=$DBI::errstr);
print $err,"<br>" if ($err);

}

# -----------------------------------------------------------
sub SeccionScroll {
# -----------------------------------------------------------
my ($default) = @_;

my (%labels,@names);
my ($ref,$sth,$dbh);
$dbh = connectdb();
$sth = $dbh->prepare("SELECT cuenta,dsc FROM cc_cuentas WHERE substring(cuenta,3,1)='0' ORDER BY cuenta");
$sth->execute();
while ($ref = $sth->fetchrow_hashref()) {
       $labels{$ref->{'cuenta'}} = substr($ref->{'cuenta'},0,2)."-".$ref->{'dsc'};
       push(@names,$ref->{'cuenta'});
}
                                                                                                                            
my $style  = get_sessiondata('cssname');

my $depstr;
$depstr = "<table border=0 cellspacing=0 cellpadding=0 class=".$style."FormTABLE>";
$depstr .= Tr({-class=>$style."FieldCaptionTD"},td({-align=>"center"},scrolling_list(-class=>$style."Select",-name=>"seccion",-values=>\@names,-labels=>\%labels,-default=>"$default",-size=>"1",-onchange=>"submit();")));
$depstr .= "</table>";
return($depstr);

}
# -----------------------------------------------------------
sub AnexosScroll {
# -----------------------------------------------------------
my ($default) = @_;

my (%labels,@names);
my ($ref,$sth,$dbh);
$dbh = connectdb();
$sth = $dbh->prepare("SELECT cuenta,dsc FROM cc_tipoanexo  ORDER BY cuenta");
$sth->execute();
while ($ref = $sth->fetchrow_hashref()) {
       $labels{$ref->{'cuenta'}} = substr($ref->{'cuenta'},0,2)."-".$ref->{'dsc'};
       push(@names,$ref->{'cuenta'});
}
                                                                                                                            
my $style  = get_sessiondata('cssname');

my $depstr;
$depstr = "<table border=0 cellspacing=0 cellpadding=0 class=".$style."FormTABLE>";
$depstr .= Tr({-class=>$style."FieldCaptionTD"},td({-align=>"center"},scrolling_list(-class=>$style."Select",-name=>"seccion",-values=>\@names,-labels=>\%labels,-default=>"$default",-size=>"1",-onchange=>"submit();")));
$depstr .= "</table>";
return($depstr);

}

# ----------------------------------------------------------------------
sub CuentaScroll {
# ----------------------------------------------------------------------
my ($default,$option,$name,$desde,$hasta) = @_;
                                         
my (%labels,@names);
my ($ref,$sth,$dbh);
$dbh = connectdb();
                                         
my $sql;
if (!$desde and !$hasta) {
   $sql="SELECT cuenta FROM cc_cuentas WHERE substring(cuenta,4,3) != '000' ORDER BY cuenta";
} else {
   $sql="SELECT cuenta FROM cc_cuentas WHERE substring(cuenta,4,3) != '000' AND substring(cuenta,1,2) >= '$desde' AND substring(cuenta,1,2) <= '$hasta' ORDER BY cuenta";
}
                                         
$sth=$dbh->prepare($sql);
$sth->execute();
                                         
$labels{""} = "";
push(@names,"");
while ($ref = $sth->fetchrow_hashref()) {
       $labels{$ref->{'cuenta'}} = $ref->{'cuenta'};
       push(@names,$ref->{'cuenta'});
}
                                         
my $style  = get_sessiondata('cssname');
                                         
my $depstr;
my $event = ($option ne '') ? "document.forms[0].optx.value='$option';submit();" : "";
$depstr = "<table border=0 cellspacing=0 cellpadding=0 class=".$style."FormTABLE>";
$depstr .= Tr({-class=>$style."FieldCaptionTD"},td({-align=>"center"},scrolling_list(-class=>$style."Select",-name=>"$name",-values=>\@names,-labels=>\%labels,-default=>"$default",-size=>"1",-onchange=>"$event")));
$depstr .= "</table>";
return($depstr)
 
}

# -----------------------------------------------------------
sub SubCuentaScroll {
# -----------------------------------------------------------
my ($principal) = @_;

my (%labels,@names);
my ($ref,$sth,$dbh);
$dbh = connectdb();
my $sql = "SELECT substring(cuenta,1,3) AS subcta,dsc FROM cc_cuentas WHERE cuenta like '$principal%' AND substring(cuenta,3,1) != '0' AND substring(cuenta,4,3) = '000' ORDER BY cuenta";
$sth = $dbh->prepare($sql);
$sth->execute();
while ($ref = $sth->fetchrow_hashref()) {
       $labels{$ref->{'subcta'}} = $ref->{'subcta'}."-".$ref->{'dsc'};
       push(@names,$ref->{'subcta'});
}
my $style  = get_sessiondata('cssname');

my $depstr;
$depstr = "<table border=0 cellspacing=0 cellpadding=0 class=".$style."FormTABLE>";
$depstr .= Tr({-class=>$style."FieldCaptionTD"},td({-align=>"center"},scrolling_list(-class=>$style."Select",-name=>"subcta",-values=>\@names,-labels=>\%labels,-size=>"1",-onchange=>"submit();")));
my ($ref,$sth,$dbh);
$depstr .= "</table>";
return($depstr);
}

# -----------------------------------------------------------
sub DespliegaCuentas {
# -----------------------------------------------------------
my $style = get_sessiondata('cssname');

#my @names = param;
#foreach (@names) { print $_ , " = ",param($_), "<br>"; }

my ($sql,$start,$seccion,$subcta);

my ($ref,$sth,$dbh);
$dbh = connectdb();

if (param('opty') eq 'pc') {  # Vista preliminar del plan de cuentas
    page_header("ridged_paper.png","","");
    my $sql = "SELECT substring(cuenta,1,2) AS cta,dsc FROM cc_cuentas WHERE substring(cuenta,3,4)='0000' ORDER BY cta";
    $sth = $dbh->prepare($sql);
    $sth->execute();

    print "<br><table width=750 border=0 cellpadding=2 cellspacing=2 align=center>";
    print Tr(td({-colspan=>"4",-align=>"center",-class=>$style."lkitem"},b("Plan de Cuentas")));
    print Tr({-class=>$style."lkitem",-bgcolor=>"lightgreen",-align=>"center"},td({-width=>"50"},b("Cuenta")),td(b("Nombre de la Cuenta")),td({-width=>"100"},b("Debe")),td({-width=>"100"},b("Haber")) );
                                                                                                                            
    while ($ref = $sth->fetchrow_hashref()) {
          print Tr({-class=>$style."lkitem"},td({-align=>"center"},b($ref->{'cta'})),td($ref->{'dsc'}),td("&nbsp;"),td("&nbsp;"));
    }

    print "</table>";
    print "<br><center><a href='javascript:window.print();' title='Imprimir Plan de Cuentas'>".img({-src=>"/images/printer.png",-border=>"0",-alt=>"printer.png"})."</a></center>";
    print end_html();

    return;
}

if (param('opty') eq 'save') {
   my $err;
   # El tipo de cuenta debe ser heredado de su cuenta principal
   my $sql = "SELECT tipo FROM cc_cuentas WHERE cuenta='".substr(param('cta'),0,2)."0000'";
   #print $sql;
   $sth = $dbh->prepare($sql);
   $sth->execute();
   $ref = $sth->fetchrow_hashref();
   $dbh->do("REPLACE cc_cuentas(cuenta,tipo,dsc,memo,moneda) VALUES (?,?,?,?,?)",undef,param('cta'),$ref->{'tipo'},param('dsc'),param('memo'),param('moneda')) or ($err=$DBI::errstr);
   print $err,"<br>" if ($err);
}

if (defined(param('subcta'))) {
   if (substr(param('seccion'),0,2) eq substr(param('subcta'),0,2)) { # No hubo cambio de cuenta principal
      # Query para desplegar la clase 'XXX'
      $sql = "SELECT cuenta,dsc,memo,moneda FROM cc_cuentas WHERE cuenta like '".param('subcta')."%' AND substring(cuenta,4,3) !='000'";
      $subcta = param('subcta');
   } else {                                                           # hubo cambio de cuenta principal
      # Busca la primera subcuenta de la nueva cuenta principal
      $subcta = $dbh->selectrow_array("SELECT substring(cuenta,1,3) AS subcta FROM cc_cuentas WHERE cuenta like '".substr(param('seccion'),0,2)."%' AND substring(cuenta,3,1) !='0' AND substring(cuenta,4,3) = '000' ORDER BY cuenta LIMIT 1");
      if ($subcta ne '') {
          $sql = "SELECT cuenta,dsc,memo,moneda FROM cc_cuentas WHERE cuenta like '$subcta%' AND substring(cuenta,4,3) != '000'";
      }
   }
} else {  # No esta definido param('subcta') -> Ocurre al Inicio -> toma la primera cuenta, la primera subcuenta
   # Si despues de 2 busquedas consecutivas en principales sin subcuentas 
   # la rutina cae por aqui : pendiente
   # Toma la primera cuenta principal
   $sql="SELECT substring(cuenta,1,2) AS start FROM cc_cuentas WHERE substring(cuenta,3,4)='0000' ORDER BY cuenta LIMIT 1";
   $sth = $dbh->prepare($sql);
   $sth->execute();
   $ref = $sth->fetchrow_hashref();
   $start = $ref->{'start'};
   # Toma la primera subcuenta
   $sql = "SELECT substring(cuenta,1,3) AS subcta FROM cc_cuentas WHERE substring(cuenta,1,2)='$start' AND substring(cuenta,3,1) != '0' AND substring(cuenta,4,3) != '000' ORDER BY cuenta LIMIT 1";
   $sth = $dbh->prepare($sql);
   $sth->execute();
   $ref = $sth->fetchrow_hashref();
   $subcta = $ref->{'subcta'};
   # Query para desplegar la clase 'XXX'
   $sql = "SELECT cuenta,dsc,memo,moneda FROM cc_cuentas WHERE cuenta like '$subcta%' AND substring(cuenta,4,3) !='000'";
}

$seccion = (defined(param('seccion'))) ? param('seccion') : $start."0000";

print start_form(-action=>url(),-target=>"inferior");

# Selector de secciones y subcuentas
print "<table align=center border=0 cellspacing=0 cellpadding=2>";
print "<tr>";
print "<td><b>Cuenta Principal:&nbsp;</b></td><td>".SeccionScroll($seccion)."</td><td><img src='/images/spacer.gif' alt='spacer.gif' width=10 height=1></td><td class=".$style."lkitem><a href='?opt=editcuenta&optx=seccion' target='inferior' title='Cuentas Principales'>".img({-src=>"/images/increment.png",-alt=>"increment.png"})."</a></td><td><td><img src='/images/spacer.gif' alt='spacer.gif' width=10 height=1></td><td><b>Sub-Cuenta:&nbsp;</b></td><td>".SubCuentaScroll(substr($seccion,0,2))."</td>";
print "<td><img src='/images/spacer.gif' alt='spacer.gif' width=10 height=1><td class=".$style."lkitem><a href='?opt=editcuenta&optx=subcta&seccion=$seccion&subcta=$subcta' target='inferior' title='Sub-Cuentas'>".img({-src=>"/images/increment.png",-alt=>"increment.png"})."</a></td>";

print "</tr>";
print "</table>";

my $cta;

if (length($sql) == 0) {

   print "<br><table border=0 align=center cellspacing=2 cellpadding=2 class=".$style."FormTABLE>";
   print "<tr><td class=".$style."Error>No existen Sub-Cuentas de la clase ". substr(param('seccion'),0,2). "</td></tr>";
   print "</table>";

} else {

# Despliega la lista de subcuentas de la clase 'XXX'

print "<div align=center>".a({-href=>"?opt=listcuentas&opty=pc",-onclick=>"window.open('?opt=listcuentas&opty=pc','pcw','scrollbars=yes,resizable=yes,width=800,height=600');return false;"},"Plan de Cuentas")."</div>";

print "<table border=0 align=center cellspacing=2 cellpadding=2>";
print Tr({-class=>$style."lkitem"},td({-colspan=>"3",-align=>"center"},table(Tr(td(b("Sub Cuentas Clase&nbsp;".$subcta."&nbsp;")),td("<a href='?opt=editcuenta&optx=add&subcta=$subcta&seccion=$seccion' target='inferior' title='Sub-Cuentas'>".img({-src=>"/images/increment.png",-alt=>"increment.png"})."</a>")))));
print Tr({-class=>$style."lkitem",-bgcolor=>"#FFAF55",-align=>"center"},td({-width=>"70"},b("Cuenta")),td({-width=>"300"},b("Nombre de la Cuenta")),td(b("Moneda")));
                                                                                                                            
my $pages = 1;
my ($lpp,$firstpage,$lastpage,$offset,$pageno);

if (defined(param('nombrecta')) and param('nombrecta') ne '') {
   $sql .= " AND dsc like '%".param('nombrecta')."%' ORDER BY cuenta";
} else {

   # **************
   # Paginador
   # **************
   $lpp = 12;   # lineas por pagina
   $sth = $dbh->prepare($sql);
   $sth->execute();
   my $records = $sth->rows;
   $pages = int($records/$lpp) + (($records % $lpp > 0) ? 1 : 0);
   $firstpage = (param('param1') eq '') ? 1 : param('param1');
   $lastpage  = ($firstpage + $lpp < $pages) ?  $firstpage + $lpp : $pages;
   $offset    = (param('offset') eq '') ? 0 : param('offset');
   $pageno    = ($offset + $lpp)  / $lpp;   # Pagina actual
   # **************
   $sql .= " ORDER BY cuenta LIMIT $offset,$lpp";
}

$sth = $dbh->prepare($sql);
$sth->execute();
#print $sql,"<br>";

while ($ref = $sth->fetchrow_hashref()) {
    my $moneda = ($ref->{'moneda'} eq '0') ? "Nuevos Soles" : "Dolares Americanos";
    print "<tr class=".$style."lkitem>";
    print "<td width=100 align=center><a href='?opt=editcuenta&cuenta=$ref->{'cuenta'}&subcta=$subcta&seccion=$seccion&offset=".param('offset')."&param1=".param('param1')."' title='Modificar Cuentas' target='inferior'>$ref->{'cuenta'}</a></td>\n";
    print "<td width=200>$ref->{'dsc'}</td>";
    print "<td>$moneda</td>";
    print "</tr>\n";
}
print Tr({-class=>$style."lkitem",-bgcolor=>"#FFAF55"},td("&nbsp;"),td("&nbsp;"),td("&nbsp;"));
                                                                                                                            
print "</table>\n";

# **************
# Paginador
# **************
if ($pages > 1) {
   talonpaginador($firstpage,$lastpage,$lpp,$pageno,$pages,"?opt=listcuentas&subcta=$subcta&seccion=$seccion");
}

# Buscar
print start_form();
print "<br><table align=center>";
print "<tr><td class=".$style."lkitem><b>Buscar por nombre de cuenta</b></td>";
print "<td>".textfield(-name=>"nombrecta",-value=>"",-override=>"1",-size=>"10",-maxlength=>"20",-onchange=>"submit();")."<td></td></tr>";
print "</table>";
print hidden(-name=>"opt",-value=>"listcuentas",-override=>1);
print end_form();

}

if (param('opty') eq 'add') {
    print br(),table({-align=>"center"},Tr({-align=>"center"},td(button(-class=>$style."Button",-value=>"Aceptar",-onclick=>"document.forms[0].opty.value='save';submit();"))));
} 

print hidden(-name=>"opt" ,-value=>"listcuentas",-override=>"1");
print hidden(-name=>"opty",-value=>"",-override=>"1");
print hidden(-name=>"memo",-value=>"",-override=>"1");
print hidden(-name=>"cta" ,-value=>$cta,-override=>"1");

print end_form();

}
# -----------------------------------------------------------
sub DespliegaAnexos {
# -----------------------------------------------------------
my $style = get_sessiondata('cssname');

#my @names = param;
#foreach (@names) { print $_ , " = ",param($_), "<br>"; }

my ($sql,$start,$seccion,$subcta);

my ($ref,$sth,$dbh);
$dbh = connectdb();

if (param('opty') eq 'pc') {  # Vista preliminar del plan de cuentas
    page_header("ridged_paper.png","","");
    my $sql = "SELECT cuenta as cta,dsc FROM cc_tipoanexo ORDER BY cta";
    $sth = $dbh->prepare($sql);
    $sth->execute();

    print "<br><table width=450 border=0 cellpadding=2 cellspacing=2 align=center>";
    print Tr(td({-colspan=>"2",-align=>"center",-class=>$style."lkitem"},b("Lista de anexos")));
    print Tr({-class=>$style."lkitem",-bgcolor=>"lightgreen",-align=>"center"},td({-width=>"50"},b("Codigo")),td(b("Nombre del anexo")));
                                                                                                                            
    while ($ref = $sth->fetchrow_hashref()) {
          print Tr({-class=>$style."lkitem"},td({-align=>"center"},b($ref->{'cta'})),td($ref->{'dsc'}));
    }

    print "</table>";
    print "<br><center><a href='javascript:window.print();' title='Imprimir lista de anexos'>".img({-src=>"/images/printer.png",-border=>"0",-alt=>"printer.png"})."</a></center>";
    print end_html();

    return;
}

if (param('opty') eq 'save') {
   my $err;
   # El tipo de cuenta debe ser heredado de su cuenta principal
   $dbh->do("REPLACE cc_cuentas(cuenta,tipo,dsc,memo,moneda) VALUES (?,?,?,?,?)",undef,param('cta'),$ref->{'tipo'},param('dsc'),param('memo'),param('moneda')) or ($err=$DBI::errstr);
   print $err,"<br>" if ($err);
}

if (substr(param('seccion'),0,2)) { # No hubo cambio de cuenta principal

    if(defined(param('nombrecta'))){
	   $sql = "SELECT cuenta,dsc,referencia,ndoc,moneda,tipo_anexo FROM cc_anexo WHERE tipo_anexo = '".param('seccion')."' AND dsc LIKE '%". param('nombrecta'). "%'";
      
    }else{
    	$sql = "SELECT cuenta,dsc,referencia,ndoc,moneda,tipo_anexo FROM cc_anexo WHERE tipo_anexo = '".param('seccion')."' ";
      
    	}
      
      
      $subcta = param('subcta');
   } else {                                                           # hubo cambio de cuenta principal
      # Busca la primera subcuenta de la nueva cuenta principal
     $sql = "SELECT cuenta,dsc,referencia,ndoc,moneda,tipo_anexo FROM cc_anexo WHERE tipo_anexo='01' ";
     
   }


$seccion = (defined(param('seccion'))) ? param('seccion') : $start."01";

print start_form(-action=>url(),-target=>"inferior");

# Selector de secciones y subcuentas
print "<table align=center border=0 cellspacing=0 cellpadding=2>";
print "<tr>";
print "<td><b>Anexos:&nbsp;</b></td><td>".AnexosScroll($seccion)."</td><td><img src='/images/spacer.gif' alt='spacer.gif' width=10 height=1></td><td class=".$style."lkitem><a href='?opt=editcuenta&optx=anexo' target='inferior' title='Anexos'>".img({-src=>"/images/increment.png",-alt=>"increment.png"})."</a></td><td><td><img src='/images/spacer.gif' alt='spacer.gif' width=10 height=1></td>";

print "</tr>";
print "</table>";

my $cta;



# Despliega la lista de subcuentas de la clase 'XXX'
print "<div align=center>".a({-href=>"?opt=anexos&opty=pc",-onclick=>"window.open('?opt=anexos&opty=pc','pcw','scrollbars=yes,resizable=yes,width=800,height=600');return false;"},"Lista de anexo")."</div>";
print "<table border=0 align=center cellspacing=2 cellpadding=2>";
print Tr({-class=>$style."lkitem"},td({-colspan=>"3",-align=>"center"},table(Tr(td(b(" + Anexo de &nbsp;".$seccion."&nbsp;")),td("<a href='?opt=editcuenta&optx=addanexo&optz=add&seccion=$seccion' target='inferior' title='Agregar anexos'>".img({-src=>"/images/increment.png",-alt=>"increment.png"})."</a>")))));

print Tr({-class=>$style."lkitem",-bgcolor=>"#FFAF55",-align=>"center"},td({-width=>"70"},b("Codigo")),td({-width=>"300"},b("Nombre del anexo")),td({-width=>"300"},b("Referencia")));
                                                                                                                            
my $pages = 1;
my ($lpp,$firstpage,$lastpage,$offset,$pageno);



   # **************
   # Paginador
   # **************
   $lpp = 50;   # lineas por pagina
   $sth = $dbh->prepare($sql);
   $sth->execute();
   my $records = $sth->rows;
   $pages = int($records/$lpp) + (($records % $lpp > 0) ? 1 : 0);
   $firstpage = (param('param1') eq '') ? 1 : param('param1');
   $lastpage  = ($firstpage + $lpp < $pages) ?  $firstpage + $lpp : $pages;
   $offset    = (param('offset') eq '') ? 0 : param('offset');
   $pageno    = ($offset + $lpp)  / $lpp;   # Pagina actual
   # **************
   $sql .= " ORDER BY cuenta LIMIT $offset,$lpp";



$sth = $dbh->prepare($sql);
$sth->execute();
#print $sql,"<br>";

while ($ref = $sth->fetchrow_hashref()) {
   
    print "<tr class=".$style."lkitem>";
    print "<td width=100 align=center><a href='?opt=editcuenta&optx=addanexo&opty=show&cuenta=$ref->{'cuenta'}&seccion=$seccion&offset=".param('offset')."&param1=".param('param1')."' title='Modificar anexo' target='inferior'>$ref->{'cuenta'}</a></td>\n";
    print "<td width=200>$ref->{'dsc'}</td>";
    print "<td>$ref->{'referencia'}</td>";
    print "</tr>\n";
}
print Tr({-class=>$style."lkitem",-bgcolor=>"#FFAF55"},td("&nbsp;"),td("&nbsp;"),td("&nbsp;"));
                                                                                                                            
print "</table>\n";

# **************
# Paginador
# **************
if ($pages > 1) {
   talonpaginador($firstpage,$lastpage,$lpp,$pageno,$pages,"?opt=anexos&subcta=$subcta&seccion=$seccion");
}

# Buscar
print start_form();
print "<br><table align=center>";
print "<tr><td class=".$style."lkitem><b>Buscar por anexo</b></td>";
print "<td>".textfield(-name=>"nombrecta",-value=>"",-override=>"1",-size=>"10",-maxlength=>"20",-onchange=>"submit();")."<td></td></tr>";
print "</table>";
print hidden(-name=>"opt",-value=>"anexos",-override=>1);
print end_form();



if (param('opty') eq 'add') {
    print br(),table({-align=>"center"},Tr({-align=>"center"},td(button(-class=>$style."Button",-value=>"Aceptar",-onclick=>"document.forms[0].opty.value='save';submit();"))));
} 

print hidden(-name=>"opt" ,-value=>"anexos",-override=>"1");
print hidden(-name=>"opty",-value=>"",-override=>"1");
print hidden(-name=>"memo",-value=>"",-override=>"1");
print hidden(-name=>"cta" ,-value=>$cta,-override=>"1");

print end_form();

}

# -----------------------------------------------------------
sub DespliegaTCuenta {
# -----------------------------------------------------------
my $style = get_sessiondata('cssname');
my @checknum = param('checknum');
my @tcuenta          = param('tcuenta');
my @dsc          = param('dsc');
my @cuenta       = param('cuenta');
my @destino       = param('destino');



#my @names = param;
#foreach (@names) { print $_ , " = ",param($_), "<br>"; }

my ($sql,$start,$seccion,$subcta);

my ($ref,$sth,$dbh);
$dbh = connectdb();

if (param('opty') eq 'pc') {  
    page_header("ridged_paper.png","","");
    my $sql = "SELECT tcuenta as cta,dsc,cuenta,destino FROM cc_tcuenta ORDER BY cta";
    $sth = $dbh->prepare($sql);
    $sth->execute();

    print "<br><table width=450 border=0 cellpadding=2 cellspacing=2 align=center>";
    print Tr(td({-colspan=>"2",-align=>"center",-class=>$style."lkitem"},b("Lista de tipos")));
    print Tr({-class=>$style."lkitem",-bgcolor=>"lightgreen",-align=>"center"},td({-width=>"50"},b("Codigo")),td(b("Nombre del anexo")),td(b("Cuenta")),td(b("Destino"))  );
                                                                                                                            
    while ($ref = $sth->fetchrow_hashref()) {
          print Tr({-class=>$style."lkitem"},td({-align=>"center"},b($ref->{'cta'})),td($ref->{'dsc'}), td($ref->{'cuenta'}), td($ref->{'destino'}));
    }

    print "</table>";
    print "<br><center><a href='javascript:window.print();' title='Imprimir lista de tipo'>".img({-src=>"/images/printer.png",-border=>"0",-alt=>"printer.png"})."</a></center>";
    print end_html();

    return;
}




if (param('opty') eq 'save') {
       my $count = 0;
       my $err;
       foreach my $k (@tcuenta) {
               # Actulizar la cuenta
               $dbh->do("REPLACE cc_tcuenta(tcuenta,dsc,cuenta,destino) VALUES (?,?,?,?)",undef,$k,$dsc[$count],$cuenta[$count],$destino[$count]) or ($err=$DBI::errstr);
               print $err,"<br>" if ($err);
             $count++;
       }
    }



      $sql = "SELECT tcuenta,dsc,cuenta,destino FROM cc_tcuenta";


print start_form(-action=>url(),-target=>"inferior");

# Selector de secciones y subcuentas
#print "<table align=center border=0 cellspacing=0 cellpadding=2>";
#print "<tr>";
#print "<td><b>Anexos:&nbsp;</b></td><td>".AnexosScroll($seccion)."</td><td><img src='/images/spacer.gif' alt='spacer.gif' width=10 height=1></td><td class=".$style."lkitem><a href='?opt=editcuenta&optx=anexo' target='inferior' title='Anexos'>".img({-src=>"/images/increment.png",-alt=>"increment.png"})."</a></td><td><td><img src='/images/spacer.gif' alt='spacer.gif' width=10 height=1></td>";
#print "</tr>";
#print "</table>";

# Despliega la lista de subcuentas de la clase 'XXX'
print "<div align=center>".a({-href=>"?opt=tcuenta&opty=pc",-onclick=>"window.open('?opt=tcuenta&opty=pc','pcw','scrollbars=yes,resizable=yes,width=800,height=600');return false;"},"Lista de tipos")."</div>";
print "<table border=0 align=center cellspacing=2 cellpadding=2>";
print Tr({-class=>$style."lkitem"},td({-colspan=>"3",-align=>"center"},table(Tr(td(b("Lista de tipificacion de cuentas &nbsp;")),td("<a href='?opt=editcuenta&optx=addtcuenta&opty=add' target='inferior' title='Agregar tipos'>".img({-src=>"/images/increment.png",-alt=>"increment.png"})."</a>")))));

print Tr({-class=>$style."lkitem",-bgcolor=>"#FFAF55",-align=>"center"},td({-width=>"70"},b("")),td({-width=>"300"},b("Nombre del tipo")),td({-width=>"40"},b("Cuenta")),td({-width=>"40"},b("Destino")) );
                                                                                                                            
my $pages = 1;
my ($lpp,$firstpage,$lastpage,$offset,$pageno);


   # **************
   # Paginador
   # **************
   $lpp = 12;   # lineas por pagina
   $sth = $dbh->prepare($sql);
   $sth->execute();
   my $records = $sth->rows;
   $pages = int($records/$lpp) + (($records % $lpp > 0) ? 1 : 0);
   $firstpage = (param('param1') eq '') ? 1 : param('param1');
   $lastpage  = ($firstpage + $lpp < $pages) ?  $firstpage + $lpp : $pages;
   $offset    = (param('offset') eq '') ? 0 : param('offset');
   $pageno    = ($offset + $lpp)  / $lpp;   # Pagina actual
   # **************
   $sql .= " ORDER BY tcuenta LIMIT $offset,$lpp";



$sth = $dbh->prepare($sql);
$sth->execute();
#print $sql,"<br>";

while ($ref = $sth->fetchrow_hashref()) {
          if (grep (/^$ref->{'tcuenta'}$/,@checknum)) {
             print Tr({-class=>$style."lkitem"},td({-align=>"center"},textfield(-name=>"tcuenta",-value=>$ref->{'tcuenta'},-class=>$style."NoInput",-size=>"2",-maxlength=>"2",-OnFocus=>"blur();")),td(textfield(-name=>"dsc",-value=>$ref->{'dsc'},-size=>"60",-maxlength=>"60") ),td(textfield(-name=>"cuenta",-value=>$ref->{'cuenta'},-size=>"7",-maxlength=>"7") ) ,td(textfield(-name=>"destino",-value=>$ref->{'destino'},-size=>"7",-maxlength=>"7") ) );
          } else {
             print Tr({-class=>$style."lkitem"},td(checkbox(-name=>"checknum",-value=>$ref->{'tcuenta'},-label =>"",-checked=>0)),td({-width=>"300"},$ref->{'dsc'}),td({-align=>"center"},$ref->{'cuenta'}),td({-align=>"center"},$ref->{'destino'}) );
          }
    }


#while ($ref = $sth->fetchrow_hashref()) {
    
    #print "<tr class=".$style."lkitem>";
    #print "<td width=100 align=center><a href='?opt=editcuenta&optx=addtcuenta&opty=show&cuenta=$ref->{'tcuenta'}&offset=".param('offset')."&param1=".param('param1')."' title='Modificar tipo' target='inferior'>$ref->{'tcuenta'}</a></td>\n";
    #print "<td width=200>$ref->{'dsc'}</td>";
    #print "<td>$ref->{'cuenta'}</td>";
    #print "</tr>\n";

#print Tr({-class=>$style."lkitem"},td(checkbox(-name=>"checknum",-value=>$ref->{'tcuenta'},-label =>"",-checked=>0)),td({-width=>"300"},$ref->{'dsc'}),td({-align=>"center"},$ref->{'cuenta'}) );

#}
print Tr({-class=>$style."lkitem",-bgcolor=>"#FFAF55"},td("&nbsp;"),td("&nbsp;"),td("&nbsp;"),td("&nbsp;"));
                                                                                                                            
print "</table>\n";

# **************
# Paginador
# **************
#if ($pages > 1) {
 #  talonpaginador($firstpage,$lastpage,$lpp,$pageno,$pages,"?opt=listcuentas&subcta=$subcta&seccion=$seccion");
#}


 if (param('opty') eq 'mod' or param('opty') eq 'add') {
       print br(),table({-align=>"center"},Tr({-align=>"center"},td(button(-class=>$style."Button",-value=>"Aceptar",-onclick=>"document.forms[0].opty.value='save';submit();"))));
    } else {
       print br(),table({-align=>"center"},Tr({-align=>"center"},td({-colspan=>"2"},"Con los seleccionados")),Tr({-align=>"center"},td(button(-class=>$style."Button",-value=>"Modificar",-onclick=>"document.forms[0].opty.value='mod';submit();"))));
    } 



print hidden(-name=>"opt" ,-value=>"tcuenta",-override=>"1");
print hidden(-name=>"opty",-value=>"",-override=>"1");
print hidden(-name=>"memo",-value=>"",-override=>"1");
#print hidden(-name=>"cta" ,-value=>$cta,-override=>"1");

print end_form();

}


# ----------------------------------------------------------------------
sub DocumentScroll {
# ----------------------------------------------------------------------
my ($default) = @_;
                                                                                                                            
my (%labels,@names);
my ($ref,$sth,$dbh);
$dbh = connectdb();
$sth = $dbh->prepare("SELECT tipodoc,substring(descripcion,1,32) AS dsc FROM cc_tipodoc ORDER BY descripcion");
$sth->execute();
while ($ref = $sth->fetchrow_hashref()) {
       $labels{$ref->{'tipodoc'}} = $ref->{'dsc'};
       push(@names,$ref->{'tipodoc'});
}
                                                                                                                            
my $style  = get_sessiondata('cssname');
                                                                                                                            
my $depstr;
$depstr = "<table border=0 cellspacing=0 cellpadding=0 class=".$style."FormTABLE>";
$depstr .= Tr({-class=>$style."FieldCaptionTD"},td({-align=>"center"},scrolling_list(-class=>$style."Select",-name=>"tipodoc",-values=>\@names,-labels=>\%labels,override=>"1",-default=>"$default",-size=>"1")));
$depstr .= "</table>";
return($depstr)

}
# ----------------------------------------------------------------------
sub DiarioScroll {
# ----------------------------------------------------------------------
my ($default) = @_;
                                                                                                                            
my ($ref,$sth,$dbh);
$dbh = connectdb();
# Obtiene la lista segun lo disponible en cc_diariocab
my $sql = "SELECT a.diario,a.nombre FROM cc_diarios a LEFT JOIN cc_diariocab b ON (a.diario=b.diario) GROUP BY a.diario ORDER by nombre";
$sth = $dbh->prepare($sql);
$sth->execute();

my (%labels,@names);
while ($ref = $sth->fetchrow_hashref()) {
       $labels{$ref->{'diario'}} = $ref->{'nombre'};
       push(@names,$ref->{'diario'});
}
                                                                                                                            
my $style  = get_sessiondata('cssname');
                                                                                                                            
my $depstr;
$depstr = "<table border=0 cellspacing=0 cellpadding=0 class=".$style."FormTABLE>";
$depstr .= Tr({-class=>$style."FieldCaptionTD"},td({-align=>"center"},scrolling_list(-class=>$style."Select",-name=>"ldiario",-values=>\@names,-labels=>\%labels,-default=>"$default",-size=>"1",-override=>"1",-onchange=>"document.forms[0].scrolldiario.value='yes';submit();")));
$depstr .= "</table>";
return($depstr)

}

# ----------------------------------------------------------------------
sub PeriodoScroll {
# ----------------------------------------------------------------------
my ($ldiario,$periodo) = @_;

my ($ref,$sth,$dbh);
$dbh = connectdb();

my $sql = "SELECT date_format(fecha_conta,'%Y-%m') AS fecha FROM cc_diariocab WHERE diario='$ldiario' GROUP BY fecha ORDER BY fecha DESC";
$sth = $dbh->prepare($sql);
$sth->execute();
my (%labels,@names);
while ($ref = $sth->fetchrow_hashref()) {
       $labels{$ref->{'fecha'}} = $ref->{'fecha'};
       push(@names,$ref->{'fecha'});
}
                                                                                                                            
my $style  = get_sessiondata('cssname');
                                                                                                                            
my $depstr;
$depstr = "<table border=0 cellspacing=0 cellpadding=0 class=".$style."FormTABLE>";
$depstr .= Tr({-class=>$style."FieldCaptionTD"},td({-align=>"center"},scrolling_list(-class=>$style."Select",-name=>"periodo",-values=>\@names,-labels=>\%labels,-default=>[$periodo],-override=>"1",-size=>"1",-onchange=>"document.forms[0].scrollperiodo.value='yes';submit();")));
$depstr .= "</table>";
return($depstr)

}

# ----------------------------------------------------------------------
sub FechaScroll {
# ----------------------------------------------------------------------
my ($diario,$periodo) = @_;

my ($ref,$sth,$dbh);
$dbh = connectdb();

# Construye la lista de dias del libro '$ldiario' correspondiente al periodo='$periodo'
# El dia default (es el ultimo dia)

my $sql = "SELECT date_format(fecha_conta,'%d') AS dia FROM cc_diariocab WHERE diario='$diario' AND date_format(fecha_conta,'%Y-%m') = '$periodo' GROUP BY dia ORDER BY dia DESC";
$sth=$dbh->prepare($sql);
$sth->execute();

my (%labels,@names);
while ($ref = $sth->fetchrow_hashref()) {
       $labels{$ref->{'dia'}} = $ref->{'dia'};
       push(@names,$ref->{'dia'});
}
                                                                                                                            
my $default;
if ( (param('scrolldiario') eq 'yes') or (param('scrollperiodo') eq 'yes') ) {
   $default = $ref->{'dia'};
} elsif (param('scrolldia') eq 'yes') {
   $default = param('dia');
} elsif (!defined(param('scrolldiario')) and !defined(param('scrollperiodo')) and !defined(param('scrolldia'))) {
   $default = param('dia');
}

my $style  = get_sessiondata('cssname');
my $depstr;
$depstr = "<table border=0 cellspacing=0 cellpadding=0 class=".$style."FormTABLE>";
$depstr .= Tr({-class=>$style."FieldCaptionTD"},td({-align=>"center"},scrolling_list(-class=>$style."Select",-name=>"dia",-values=>\@names,-labels=>\%labels,-default=>["$default"],-size=>"1",-override=>"1",-onchange=>"document.forms[0].scrolldia.value='yes';submit();")));
$depstr .= "</table>";
return($depstr)

}

# ----------------------------------------------------------------------
sub CuentaNameScroll {
# ----------------------------------------------------------------------
my ($name,$desde,$hasta,$blanco,$default) = @_;

my (%labels,@names);
my ($ref,$sth,$dbh);
$dbh = connectdb();

my $sql;
if (!$desde and !$hasta) {
   $sql="SELECT cuenta,dsc FROM cc_cuentas WHERE substring(cuenta,4,3) != '000' ORDER BY cuenta";
} else {
   $sql="SELECT cuenta,dsc FROM cc_cuentas WHERE substring(cuenta,4,3) != '000' AND substring(cuenta,1,2) >= '$desde' AND substring(cuenta,1,2) <= '$hasta' ORDER BY cuenta";
}
 
$sth=$dbh->prepare($sql);
$sth->execute();

if ($blanco eq '1') {
   $labels{""} = "";
   push(@names,"");
}
while ($ref = $sth->fetchrow_hashref()) {
       $labels{$ref->{'cuenta'}} = $ref->{'cuenta'}."-".$ref->{'dsc'};
       push(@names,$ref->{'cuenta'});
}
                                                                                                                            
my $style  = get_sessiondata('cssname');
                                                                                                                            
my $depstr;
$depstr = "<table border=0 cellspacing=0 cellpadding=0 class=".$style."FormTABLE>";
$depstr .= Tr({-class=>$style."FieldCaptionTD"},td({-align=>"center"},scrolling_list(-class=>$style."Select",-name=>"$name",-values=>\@names,-labels=>\%labels,-default=>"$default",-size=>"1")));
$depstr .= "</table>";
return($depstr)

}
# ----------------------------------------------------------------------
sub SubCuentaNameScroll {
# ----------------------------------------------------------------------
my ($name,$desde,$hasta,$blanco,$default) = @_;

my (%labels,@names);
my ($ref,$sth,$dbh);
$dbh = connectdb();

my $sql;
if (!$desde and !$hasta) {
   $sql="SELECT cuenta,dsc FROM cc_cuentas WHERE substring(cuenta,4,3) != '000'  ORDER BY cuenta";
} else {
   $sql="SELECT cuenta,dsc FROM cc_cuentas WHERE substring(cuenta,4,3) != '000' AND substring(cuenta,1,3) >= '$desde' AND substring(cuenta,1,3) <= '$hasta' ORDER BY cuenta";
}
 
$sth=$dbh->prepare($sql);
$sth->execute();

if ($blanco eq '1') {
   $labels{""} = "";
   push(@names,"");
}
while ($ref = $sth->fetchrow_hashref()) {
       $labels{$ref->{'cuenta'}} = $ref->{'cuenta'}."-".$ref->{'dsc'};
       push(@names,$ref->{'cuenta'});
}
                                                                                                                            
my $style  = get_sessiondata('cssname');
                                                                                                                            
my $depstr;
$depstr = "<table border=0 cellspacing=0 cellpadding=0 class=".$style."FormTABLE>";
$depstr .= Tr({-class=>$style."FieldCaptionTD"},td({-align=>"center"},scrolling_list(-class=>$style."Select",-name=>"$name",-values=>\@names,-labels=>\%labels,-default=>"$default",-size=>"1")));
$depstr .= "</table>";
return($depstr)

}


# ----------------------------------------------------------------------
sub libros_de_diario {
# ----------------------------------------------------------------------
#my @names = param;
#foreach (@names) { print $_ , " = ",param($_), "<br>"; }

my $style  = get_sessiondata('cssname');

my @diario   = param('diario');
my @nombre   = param('nombre');
my @checknum = param('checknum');

my ($ref,$sth,$dbh);
$dbh = connectdb();

my $err;
if (param('opty') eq 'insert') {
   $dbh->do("INSERT INTO cc_diarios(nombre) VALUES (?)",undef,$nombre[0]) or ($err=$DBI::errstr);
}

if (param('opty') eq 'save') {
    my $count = 0;
    foreach my $k (@diario) {
            # Actulizar/Ingresar registro
            $dbh->do("REPLACE cc_diarios(diario,nombre) VALUES (?,?)",undef,$k,$nombre[$count]) or ($err=$DBI::errstr);
            $count++;
            print $err,"<br>" if ($err);
    }
}

my $sql = "SELECT diario,nombre FROM cc_diarios ORDER BY nombre";
$sth = $dbh->prepare($sql);
$sth->execute();

print start_form();
print "<br><table border=0 cellpadding=2 cellspacing=2 align=center class=".$style."FormTABLE>";
print Tr(td({-colspan=>"4",-class=>$style."FormHeaderFont"},b("Libros de diario").img({-src=>"/images/spacer.gif",-alt=>"spacer.gif",-width=>"20",-height=>"1"}).a({-href=>"?opt=diario&optx=libros&opty=add",-target=>"inferior",-title=>"Agregar Diario"}).img({-src=>"/images/increment.png",-alt=>"increment.png"}) ));
print Tr({-class=>$style."FieldCaptionTD",-align=>"center"},td("&nbsp;"),td(b("Libro")) );

    while ($ref = $sth->fetchrow_hashref()) {
          if (grep (/^$ref->{'diario'}$/,@checknum)) {
             print Tr({-class=>$style."FieldCaptionTD"},td("&nbsp;"),td({-align=>"left"},textfield(-name=>"nombre",-value=>$ref->{'nombre'},-size=>"32",-maxlength=>"32")) );
             print hidden(-name=>"diario",-value=>"$ref->{'diario'}",-override=>1);
          } else {
             print Tr({-class=>$style."FieldCaptionTD"},td(checkbox(-name=>"checknum",-value=>$ref->{'diario'},-label =>"",-checked=>0)),td({-align=>"left"},$ref->{'nombre'}) );
          }
    }

    if (param('opty') eq 'add') {
       print Tr({-class=>$style."FieldCaptionTD"},td("&nbsp;"),td(textfield(-name=>"nombre",-value=>"",-size=>"32",-maxlength=>"32",-onchange=>"document.forms[0].optx.value='libros';document.forms[0].opty.value='insert';submit();")) );
    }


print "</table>";

if (param('opty') eq 'mod' or param('opty') eq 'add') {
    print br(),table({-align=>"center"},Tr({-align=>"center"},td(button(-class=>$style."Button",-value=>"Aceptar",-onclick=>"document.forms[0].optx.value='libros';document.forms[0].opty.value='save';submit();"))));
} else {
    print br(),table({-align=>"center"},Tr({-align=>"center"},td({-colspan=>"2"},"Con los seleccionados")),Tr({-align=>"center"},td(button(-class=>$style."Button",-value=>"Modificar",-onclick=>"document.forms[0].optx.value='libros';document.forms[0].opty.value='mod';submit();"))));
} 
    
print hidden(-name=>"opt",-value=>"diario",-override=>1);
print hidden(-name=>"optx",-value=>"",-override=>1);
print hidden(-name=>"opty",-value=>"",-override=>1);
print end_form();

print "<center><a href='?opt=diario' target='inferior' title='Regresar'>".img({-src=>"/images/return.png",-border=>"0",-alt=>"return.png"})."</a></center>";

}

# ----------------------------------------------------------------------
sub DespliegaDiario {
# ----------------------------------------------------------------------
#my @names = param;
#foreach (@names) { print $_ , " = ",param($_), "<br>"; }

my $style  = get_sessiondata('cssname');
my $mcontab = (get_sessiondata('mcontab') eq 'S') ? "soles" : "dolar";

if (param('optx') eq 'libros') {
   libros_de_diario();
   return;
}

my ($ref,$sth,$dbh);
$dbh = connectdb();

print start_form(-target=>"inferior");

my ($ldiario,$periodo,$dia);

$ldiario = param('ldiario');
$periodo = param('periodo');
$dia     = param('dia');

# Scrolling list defaults 
my $sql;

if (param('optx') eq 'cd') {   # Descuadrados

    # **************
    # Paginador
    # **************

    # Mientras no se solucione el query, el paginador no funciona

    my $lpp = 15;   # lineas por pagina
    my $sql = "SELECT secuencial,SUM(IF(dh=0,$mcontab,0)) AS debe,SUM(IF(dh=1,$mcontab,0)) AS haber FROM cc_diariodet GROUP BY secuencial";
    #print $sql,"<br>";
    $sth = $dbh->prepare($sql);
    $sth->execute();
    my $records;
    while ($ref = $sth->fetchrow_hashref()) {
          if ($ref->{'debe'} != $ref->{'haber'}) {
              $records++;
          }
    }
    my $pages     = int($records/$lpp) + (($records % $lpp > 0) ? 1 : 0);
    my $firstpage = (param('param1') eq '') ? 1 : param('param1');
    my $lastpage  = ($firstpage + $lpp < $pages) ?  $firstpage + $lpp : $pages;
    my $offset    = (param('offset') eq '') ? 0 : param('offset');
    my $pageno    = ($offset + $lpp)  / $lpp;   # Pagina actual
    # **************

    $sth = $dbh->prepare($sql);
    $sth->execute();

    page_header("ridged_paper.png","","");
    
    print "<br><table border=0 cellpadding=2 cellspacing=2 align=center>";
    print Tr(td({-colspan=>"4",-class=>$style."lkitem",-align=>"center"},b("Comprobantes fuera de balance: $records")));
    print Tr({-class=>$style."lkitem",-align=>"center",-bgcolor=>"lightgreen"},td({-width=>"100"},b("Comprobante")),td({-width=>"100"},b("Debe")),td({-width=>"100"},b("Haber")),td({-width=>"100"},b("Diferencia")) );

    my ($t1,$t2);
    while ($ref = $sth->fetchrow_hashref()) {
          if ($ref->{'debe'} ne $ref->{'haber'}) {
              my $lnk = "?opt=vercomp&call=cd&secuencial=$ref->{'secuencial'}&offset=".param('offset')."&param1=".param('param1');
              my $str = "window.open('$lnk','comprobante','scrollbars=yes,resizable=yes,width=800,height=400'); return false;";
              print Tr({-class=>$style."lkitem"},td({-align=>"center"},a({-href=>"/",-onclick=>"$str",-override=>"1"},$ref->{'secuencial'})),td({-align=>"right"},sprintf("%15.2f",$ref->{'debe'})),td({-align=>"right"},sprintf("%15.2f",$ref->{'haber'})), td({-align=>"right"},sprintf("%15.2f",$ref->{'debe'}-$ref->{'haber'} )));
              $t1 += $ref->{'debe'};
              $t2 += $ref->{'haber'};
         }
    }

    print "</table>";

    print $t1,"<br>";
    print $t2,"<br>";

    #if ($pages > 1) {
    #   talonpaginador($firstpage,$lastpage,$lpp,$pageno,$pages,"?opt=analisis&optx=cd"); 
    #}

    print "<center><a href='?opt=diario' target='inferior' title='Regresar'>".img({-src=>"/images/return.png",-border=>"0",-alt=>"return.png"})."</a></center>";

    print end_html();
    return;
}

if (param('optx') eq 'nu') {   # Anulados

    page_header("ridged_paper.png","","");

    print start_form();
    # Scroll periodo
    my $sql = "SELECT date_format(fecha_conta,'%Y-%m') AS fecha FROM cc_diariocab WHERE estado='1' GROUP BY fecha ORDER BY fecha DESC";
    $sth = $dbh->prepare($sql);
    $sth->execute();

    my $default;
    if ($ref = $sth->fetchrow_hashref()) {
       $default = $ref->{'fecha'};
    }
    my $periodo = (defined(param('periodo'))) ? param('periodo') : $default;
    
    $sth->execute();
    my (%labels,@names);
    while ($ref = $sth->fetchrow_hashref()) {
          $labels{$ref->{'fecha'}} = $ref->{'fecha'};
          push(@names,$ref->{'fecha'});
    }
    print br(),table({-align=>"center"},Tr({-class=>$style."lkitem"},td({-align=>"center"},"Per&iacute;odo&nbsp;:&nbsp;".scrolling_list(-class=>$style."Select",-name=>"periodo",-values=>\@names,-labels=>\%labels,-default=>["$periodo"],-override=>"1",-size=>"1",-onchange=>"submit();"))));

    # Lista de anulados
    # **************
    # Paginador
    # **************
    my $lpp       = 15;   # lineas por pagina
    my $records   = $dbh->selectrow_array("SELECT count(*) FROM cc_diariocab WHERE estado='1' AND date_format(fecha_conta,'%Y-%m') = '$periodo'");
    my $pages     = int($records/$lpp) + (($records % $lpp > 0) ? 1 : 0);
    my $firstpage = (param('param1') eq '') ? 1 : param('param1');
    my $lastpage  = ($firstpage + $lpp < $pages) ?  $firstpage + $lpp : $pages;
    my $offset    = (param('offset') eq '') ? 0 : param('offset');
    my $pageno    = ($offset + $lpp)  / $lpp;   # Pagina actual
    # **************

    my $sql = "SELECT secuencial,date_format(fecha_conta,'%Y-%m-%d') as fecha,glosa FROM cc_diariocab WHERE estado='1' AND date_format(fecha_conta,'%Y-%m') = '$periodo' ORDER BY secuencial LIMIT $offset,$lpp";
    $sth = $dbh->prepare($sql);
    $sth->execute();

    print "<br><table border=0 cellpadding=2 cellspacing=2 align=center>";
    print Tr(td({-colspan=>"4",-class=>$style."lkitem",-align=>"center"},b("Comprobantes anulados: $records")));
    print Tr({-class=>$style."lkitem",-align=>"center",-bgcolor=>"lightgreen"},td({-width=>"100"},b("Comprobante")),td({-width=>"100"},b("Fecha")),td({-width=>"250"},b("Detalle")) );
    while ($ref = $sth->fetchrow_hashref()) {
          my $lnk = "?opt=vercomp&call=nu&secuencial=$ref->{'secuencial'}&offset=".param('offset')."&param1=".param('param1');
          my $str = "window.open('$lnk','comprobante','scrollbars=yes,resizable=yes,width=800,height=400'); return false;";
          print Tr({-class=>$style."Error"},td({-align=>"center"},a({-href=>"#",-onclick=>"$str",-override=>"1"},$ref->{'secuencial'})),td($ref->{'fecha'}),td($ref->{'glosa'}) );
    }
    print Tr({-bgcolor=>"lightgreen"},td("&nbsp"),td("&nbsp"),td("&nbsp"));

    print "</table>";

    if ($pages > 1) {
       talonpaginador($firstpage,$lastpage,$lpp,$pageno,$pages,"?opt=diario&optx=nu&periodo=$periodo");
    }

    print hidden(-name=>"opt",-value=>"diario",-override=>1);
    print hidden(-name=>"optx",-value=>"nu",-override=>1);

    print end_form();

    print "<center><a href='?opt=diario' target='inferior' title='Regresar'>".img({-src=>"/images/return.png",-border=>"0",-alt=>"return.png"})."</a></center>";

    print end_html();

    return;
}

if (!defined(param('ldiario'))) {  # Click en menu principal (opcion Diario)
    # Busca el primer registro de la tabla cc_diario
    $ldiario = $dbh->selectrow_array("SELECT a.diario FROM cc_diarios a LEFT JOIN cc_diariocab b ON (a.diario=b.diario) GROUP BY a.diario ORDER by nombre LIMIT 1");
    # Busca el primer dia del primer periodo
    $periodo = $dbh->selectrow_array("SELECT date_format(fecha_conta,'%Y-%m') FROM cc_diariocab WHERE diario='$ldiario' ORDER BY fecha_conta DESC LIMIT 1");
    $dia = $dbh->selectrow_array("SELECT date_format(fecha_conta,'%d') FROM cc_diariocab WHERE diario='$ldiario' AND fecha_conta like '".$periodo."%' ORDER BY fecha_conta DESC LIMIT 1");
} 

if (param('scrolldiario') eq 'yes') {    # Al seleccionar el diario
    #$ldiario = param('ldiario');
    # Busca el primer periodo del diario 'ldiario'
    $periodo = $dbh->selectrow_array("SELECT date_format(fecha_conta,'%Y-%m') FROM cc_diariocab WHERE diario='$ldiario' ORDER BY fecha_conta DESC LIMIT 1");
    # Busca el ultimo dia del primer periodo del diario 'ldiario'
    $dia = $dbh->selectrow_array("SELECT date_format(fecha_conta,'%d') FROM cc_diariocab WHERE diario='$ldiario' AND date_format(fecha_conta,'%Y-%m')='$periodo' ORDER BY fecha_conta DESC LIMIT 1");
}

if (param('scrollperiodo') eq 'yes') {   # Al seleccionar el periodo
    #$ldiario = param('ldiario');
    #$periodo = param('periodo');
    # Busca el ultimo dia del periodo seleccionado del diario 'ldiario'
    $dia = $dbh->selectrow_array("SELECT date_format(fecha_conta,'%d') FROM cc_diariocab WHERE diario='$ldiario' AND date_format(fecha_conta,'%Y-%m')='$periodo' ORDER by fecha_conta DESC LIMIT 1");
}

# Llamada del paginador
if (defined(param('pg'))) {
   #$ldiario = param('ldiario');
   #$periodo = param('periodo');
   #$dia     = param('dia');
   #print "seleccion pg=",$ldiario,"-",$periodo,"-","$dia","<br>";
}

#print $ldiario,"<br>",$periodo,"<br>","$dia","<br>";

# Selector de diario y fechas
my $detalle  = param('detalle');
my %options  = ("1" => "Comprobante", "2" => "Detalle","3" => "Documento","4" => "Cheq./Ref.");

print "<table align=center border=0 cellspacing=0 cellpadding=2>";
print "<tr>";
print "<td><b>Diario:&nbsp;</b></td><td>".DiarioScroll($ldiario)."</td><td><img src='/images/spacer.gif' alt='spacer.gif' width=20 height=1></td><td class=".$style."lkitem><a href='?opt=diario&optx=libros' target='inferior' title='Libros de Diario'>".img({-src=>"/images/increment.png",-alt=>"increment.png"})."</a></td><td><td><img src='/images/spacer.gif' alt='spacer.gif' width=20 height=1></td><td><b>Per&iacute;odo:&nbsp;</b></td><td>".PeriodoScroll($ldiario,$periodo)."</td><td><img src='/images/spacer.gif' alt='spacer.gif' width=20 height=1></td><img src='/images/spacer.gif' alt='spacer.gif' width=20 height=1></td><td><b>D&iacute;a:&nbsp;</b></td><td>".FechaScroll($ldiario,$periodo)."</td><td><img src='/images/spacer.gif' alt='spacer.gif' width=20 height=1></td><td><b>Buscar:&nbsp;<b></td><td>".scrolling_list(-name =>"searchx",-values=>["1","2","3","4"],-labels=>\%options,-size =>1,-multiple=>0,-default=>[""])."</td><td>".textfield(-name=>"detalle",-value=>"$detalle",-override=>"1",-size=>"10",-maxlength=>"20")."<td></td>";
print "</tr>";
print "</table>";

# menu
print "<table align=center border=0 cellspacing=0 cellpadding=0>";
#print Tr(td({-align=>"center",-class=>$style."lkitem"},a({-href=>"?opt=diario&optx=cd",-onclick=>"window.open('?opt=diario&optx=cd','descuadrados','scrollbars=yes,resizable=yes,width=800,height=600');return false;"},"Comprobantes fuera de balance")."&nbsp;|&nbsp;".a({-href=>"?opt=diario&optx=nu",-target=>"inferior"},"Comprobantes anulados")));
print Tr(td({-align=>"center",-class=>$style."lkitem"},a({-href=>"?opt=diario&optx=cd",-target=>"inferior"},"Comprobantes fuera de balance")."&nbsp;|&nbsp;".a({-href=>"?opt=diario&optx=nu",-target=>"inferior"},"Comprobantes anulados")));
print "</table>";

# **************
# Paginador
# **************
my $lpp = 12;   # lineas por pagina

# Calcula el numero de paginas
if (param('detalle') eq '') {
   $sql = "SELECT secuencial FROM cc_diariocab WHERE diario='$ldiario' AND date_format(fecha_conta,'%Y-%m-%d')='".$periodo."-".$dia."'";
} else {  # Busca por comprobante o por detalle
       if (param('searchx') eq '2') {         # Busca por detalle
           $sql = "SELECT secuencial FROM cc_diariocab WHERE glosa like trim('".param('detalle')."')";
       } elsif (param('searchx') eq '1') {    # Busca por secuencial 
           $sql = "SELECT secuencial FROM cc_diariocab WHERE secuencial='".param('detalle')."'";
       } elsif (param('searchx') eq '3') {    # Busca por docid      
           $sql = "SELECT secuencial FROM cc_diariocab WHERE docid like '".param('detalle')."%'";
       } elsif (param('searchx') eq '4') {    # Busca por cheque/referencia
           $sql = "SELECT secuencial FROM cc_diariocab WHERE referencia like '".param('detalle')."%'";
       }
}

$sth = $dbh->prepare($sql);
$sth->execute();
my $records = $sth->rows;

#print $sql,"<br>";
#print $records,"<br>";

my $pages     = int($records/$lpp) + (($records % $lpp > 0) ? 1 : 0);
my $firstpage = (param('param1') eq '') ? 1 : param('param1');
my $lastpage  = ($firstpage + $lpp < $pages) ?  $firstpage + $lpp : $pages;
my $offset    = (param('offset') eq '') ? 0 : param('offset');
my $pageno    = ($offset + $lpp)  / $lpp;   # Pagina actual
# **************
#print $records,"-",$pages,"-",$firstpage,"-",$lastpage,"<br>";

if (param('detalle') eq '') {
    $sql = "SELECT secuencial,fecha_conta,glosa,estado,docid,referencia FROM cc_diariocab WHERE diario='$ldiario' AND date_format(fecha_conta,'%Y-%m-%d')='".$periodo."-".$dia."' ORDER BY secuencial LIMIT $offset,$lpp";
} else {
       if (param('searchx') eq '2') {             # Busca por detalle
          $sql = "SELECT secuencial,fecha_conta,glosa,estado,docid,referencia FROM cc_diariocab WHERE glosa LIKE '".param('detalle')."%' ORDER BY secuencial LIMIT $offset,$lpp";
       } elsif (param('searchx') eq '1') {        # Busca comprobante
          $sql = "SELECT secuencial,fecha_conta,glosa,estado,docid,referencia FROM cc_diariocab WHERE secuencial = '".param('detalle')."'";
       } elsif (param('searchx') eq '3') {        # Busca por docid
          $sql = "SELECT secuencial,fecha_conta,glosa,estado,docid,referencia FROM cc_diariocab WHERE docid LIKE '".param('detalle')."%' LIMIT $offset,$lpp";
       } elsif (param('searchx') eq '4') {        # Busca por cheque/referencia
          $sql = "SELECT secuencial,fecha_conta,glosa,estado,docid,referencia FROM cc_diariocab WHERE referencia LIKE '".param('detalle')."%' LIMIT $offset,$lpp";
       }
}

#print $sql,"<br>";
$sth = $dbh->prepare($sql);
$sth->execute();

# Despliega los comprobantes
print "<table border=0 align=center cellspacing=2 cellpadding=2>";

print Tr({-class=>$style."lkitem"},td({-colspan=>"5",-align=>"center"},table(Tr(td(b("Registro de Comprobantes")),td("<a href='#' target='inferior' title='Agregar Comprobante' onclick=\"window.open('?opt=addcomp&ldiario=$ldiario&periodo=$periodo&dia=$dia&offset=$offset&param1=$firstpage','addcomp','scrollbars=yes,resizable=yes,width=800,height=400');\">".img({-src=>"/images/increment.png",-alt=>"increment.png"})."</a>")))));

print Tr({-class=>$style."lkitem",-bgcolor=>'#00AAAA',-align=>"center"},td({-width=>"100"},b("#")),td(b("Fecha Contable")),td({-width=>"350"},b("Detalle")),td({-width=>"100"},b("Documento")),td({-width=>"100"},b("Cheq./Ref.")));
                                                                                                                            
my ($lnk,$str);
while ($ref = $sth->fetchrow_hashref()) {
    my $tacha = ($ref->{'estado'} eq '1') ? "style='color: rgb(204, 0, 0);text-decoration: line-through;'" : '';
    $lnk = "?opt=vercomp&secuencial=$ref->{'secuencial'}&offset=$offset&param1=".param('param1')."&ldiario=$ldiario&periodo=$periodo&dia=$dia&searchx=".param('searchx')."&detalle=".param('detalle');
    $str = "window.open('$lnk','comprobante','scrollbars=yes,resizable=yes,width=800,height=400'); return false;";
    print "<tr align=center class=".$style."lkitem>\n";
    print "<td><a href=\"\" title='Modificar Comprobante' target='inferior' onclick=\"$str\">$ref->{'secuencial'}</a></td>\n";
    print "<td $tacha>".substr($ref->{'fecha_conta'},0,10)."</td>";
    print "<td align=left $tacha>$ref->{'glosa'}</td>";
    print "<td align=left $tacha>$ref->{'docid'}</td>";
    print "<td align=left $tacha>$ref->{'referencia'}</td>";
    print "</tr>\n";
}
print Tr({-class=>$style."lkitem",-bgcolor=>'#00AAAA'},td("&nbsp;"),td("&nbsp;"),td("&nbsp;"),td("&nbsp;"),td("&nbsp;"));
print "</table>";

# **************
# Paginador
# **************
if ($pages > 1) {
   talonpaginador($firstpage,$lastpage,$lpp,$pageno,$pages,"?opt=diario&pg=1&ldiario=$ldiario&periodo=$periodo&dia=$dia&searchx=". param('searchx') ."&detalle=".escape(param('detalle')));
}

print hidden(-name=>"opt"          ,-value=>"diario",-override=>"1");
print hidden(-name=>"optx"         ,-value=>"",-override=>"1");
print hidden(-name=>"scrolldiario" ,-value=>"",-override=>"1");
print hidden(-name=>"scrollperiodo",-value=>"",-override=>"1");
print hidden(-name=>"scrolldia"    ,-value=>"",-override=>"1");

print end_form();

}


# -----------------------------------------------------------
sub rventa_ndoc_data {
# -----------------------------------------------------------
my ($fecha,$estado,$referencia) = @_;
my $dbh = connectdb();
return($dbh->selectrow_array("SELECT max(docid),min(docid) FROM cc_diariocab WHERE fecha_conta='$fecha' and estado='$estado' and referencia=$referencia"));
}

# -------------------------------------------------------

sub cuentamayor {
	
my $style = get_sessiondata('cssname');
my $periodo = param('periodo');
my $ruc = param('ruc');
my $razonsocial = param('razonsocial');
my $folio = param('tipodoc');
my $fechaconta=param('fechaconta');
my $nasiento = param('asiento');
my ($tdebe,$thaber);

my $cuenta = param('cuenta');    
    
#print "cuenta: ".param('cuenta').", asiento razon social $razonsocial";
my $dbh = connectdb();
print "<br><table border=0 cellpadding=2 cellspacing=2 align=center>";
print Tr(td({-colspan=>"9",-class=>$style."lkitem",-align=>"center"},b("Libro Mayor")));
   print Tr(td({-colspan=>9},table({-align=>"center"},Tr({-class=>$style."lkitem"},td(a({-href=>'javascript:window.print()'},"Imprimir")),td("|"),td(a({-href=>"?opt=download_lmayor&periodo=$periodo&cuenta=$cuenta&ruc=$ruc&razonsocial=$razonsocial&tipodoc=$folio&fechaconta=$fechaconta&asiento=$nasiento"},"Download")))))); 
  # print Tr({-class=>$style."lkitem",-bgcolor=>'#00AAAA'},td({-colspan=>2,-align=>"right"},b("FOLIO: ")),td({-colspan=>10},b($folio)));
     print Tr({-class=>$style."lkitem",-bgcolor=>'#00AAAA'},td({-colspan=>2,-align=>"right"},b("PERIODO: ")),td({-colspan=>10},b($periodo)));
   print Tr({-class=>$style."lkitem",-bgcolor=>'#00AAAA'},td({-colspan=>2,-align=>"right"},b("RUC: ")),td({-colspan=>10},b($ruc)));
   print Tr({-class=>$style."lkitem",-bgcolor=>'#00AAAA'},td({-colspan=>2,-align=>"right"},b("DENOMINACION: ")),td({-colspan=>10},b($razonsocial)));
    print Tr({-class=>$style."lkitem",-bgcolor=>'#00AAAA'},td({-colspan=>2,-align=>"right"},b("CUENTA CONTABLE: ")),td({-colspan=>10},b(param('cuenta')." : ".dsccuentaanexo(param('cuenta')))));
 print Tr({-class=>$style."lkitem",-bgcolor=>'#00AAAA'},td({-rowspan=>2},b("Fecha de la Operacion ")),td({-rowspan=>2},b("# de Asiento")),td({-rowspan=>2},b("Glosa de la Operacion")),td({-colspan=>2},b("Saldos y Movimientos")));
 print Tr({-class=>$style."lkitem",-bgcolor=>'#00AAAA'},td({-align=>"right"},b("Deudor")),td(b("Acreedor")));
print "<tr>";
print "<td>$fechaconta</td>";
print "<td>$nasiento</td>";
print "<td>".descglosa($nasiento)."</td>";
($tdebe,$thaber) = $dbh->selectrow_array ("SELECT IF(a.dh=0,soles,0) AS debe,IF(a.dh=1,soles,0) AS haber FROM cc_diariodet a, cc_diariocab b WHERE b.estado='0' AND (a.secuencial=b.secuencial) AND date_format(b.fecha_conta,'%Y-%m')='$periodo' and a.cuenta=".param('cuenta')." and b.secuencial=$nasiento ORDER BY b.secuencial");
		print "<td>$tdebe</td>";
		print "<td>$thaber</td>";
print "</tr>";
print "<tr>";

print "<td colspan=3 align=right>TOTALES</td>";
print "<td>$tdebe</td>";
print "<td>$thaber</td>";
print "</tr>";
	print "</table>";
	}
# -------------------------------------------------------
sub saldomayor {
my $style  = get_sessiondata('cssname');

my $periodo = param('periodo');
my $ruc= param('ruc');
my $razonsocial = param('razonsocial');
my ($tdebe,$thaber);
my ($sth,$ref,$dbh);
$dbh = connectdb();

   my $sql = "SELECT substring(a.cuenta,1,3) AS cta,SUM(IF(a.dh=0,soles,0)) AS debe,SUM(IF(a.dh=1,soles,0)) AS haber FROM cc_diariodet a, cc_diariocab b WHERE b.estado='0' AND (a.secuencial=b.secuencial) AND substring(a.cuenta,3,4) != '0000' AND date_format(b.fecha_conta,'%Y-%m')<='$periodo' GROUP BY cta ORDER BY cta";
  #    my $sql = "SELECT substring(a.cuenta,1,3) AS cta,SUM(IF(a.dh=0,soles,0)) AS debe,SUM(IF(a.dh=1,soles,0)) AS haber FROM cc_diariodet a, cc_diariocab b, cc_cuentas c WHERE b.estado='0' AND (a.secuencial=b.secuencial) AND (substring(a.cuenta,1,6)=c.cuenta) AND (c.tipo='0' or c.tipo='1' or c.tipo='2' or  c.tipo='3') AND substring(a.cuenta,3,4) != '0000' GROUP BY cta ORDER BY cta";
    
    $sth = $dbh->prepare($sql);
    $sth->execute();


 print "<br><table width=750 border=0 cellpadding=2 cellspacing=2 align=center>";
    print Tr(td({-colspan=>"4",-align=>"center",-class=>$style."lkitem"},b("LIBRO MAYOR <br> SALDOS CONTABLES: ")));
    print Tr({-class=>$style."lkitem",-bgcolor=>"lightgreen",-align=>"center"},td({-width=>"50"},b("Cuenta")),td(b("Nombre de la Cuenta")),td({-width=>"100"},b("Debe")),td({-width=>"100"},b("Haber")) );

while ($ref = $sth->fetchrow_hashref()) {
         # print Tr({-class=>$style."lkitem"},td({-align=>"center"},b($ref->{'cta'})),td(b(NombreCuenta($ref->{'cta'}."0000"))),td("&nbsp;"),td("&nbsp;"));
         # print Tr({-class=>$style."lkitem"},td("&nbsp;"),td(clase3($ref->{'cta'})),td({-valign=>"bottom",-align=>"right"},commify(sprintf("%15.2f",$ref->{'debe'}))),td({-valign=>"bottom",-align=>"right"},commify(sprintf("%15.2f",$ref->{'haber'}))));
           my $link   = "?opt=cuentasaldomayor&periodo=$periodo&ruc=$ruc&razonsocial=$razonsocial&subcuenta=".$ref->{'cta'};
       my $action = "<a href='#' target='inferior' title='Sub cuentas clase $ref->{'cta'}' onclick=\"window.open('$link','sub-cuentas','scrollbars=yes,resizable=yes,width=600,height=500');return false;\">$ref->{'cta'}</a>";
      
           
           print Tr({-class=>$style."lkitem"},td({-align=>"center"},b($action)),td(b(NombreCuenta($ref->{'cta'}."000"))),td({-valign=>"bottom",-align=>"right"},commify(sprintf("%15.2f",$ref->{'debe'}))),td({-valign=>"bottom",-align=>"right"},commify(sprintf("%15.2f",$ref->{'haber'}))));
         
          $tdebe  += $ref->{'debe'};
          $thaber += $ref->{'haber'};
    }
    
 print Tr({-class=>$style."lkitem",-bgcolor=>"lightgreen"},td("&nbsp"),td({-align=>"right"},b("T O T A L E S&nbsp;:&nbsp;")),td({-align=>"right"},b(commify(sprintf("%15.2f",$tdebe)))),td({-align=>"right"},b(commify(sprintf("%15.2f",$thaber)))));
   
print "</table>";
	
	}

# ----------------------------------------------------------------------

sub descglosa {
		my ($nasiento) = @_;
		my $dbh = connectdb();
		my $glosa = $dbh->selectrow_array ("select glosa from cc_diariocab where secuencial=$nasiento");
		return($glosa);
	}
	
	
	# ----------------------------------------------------------------------
sub cuentasaldomayor {
my $style  = get_sessiondata('cssname');

my $periodo = param('periodo');
my $ruc= param('ruc');
my $razonsocial = param('razonsocial');
my $subcuenta = param('subcuenta');
my ($tdebeant,$thaberant);
my $inicial = 0;
	my $sql0 = "SELECT a.cuenta, IF(a.dh=0,soles,0) AS debe,IF(a.dh=1,soles,0) AS haber FROM cc_diariodet a, cc_diariocab b WHERE b.estado='0' AND (a.secuencial=b.secuencial) AND date_format(b.fecha_conta,'%Y-%m')<'$periodo' AND a.cuenta like '$subcuenta%' ORDER BY b.secuencial";
 my ($ref0,$sth0,$dbh0);
$dbh0 = connectdb();

$sth0 = $dbh0->prepare($sql0);
$sth0->execute();

while ($ref0 = $sth0->fetchrow_hashref()) {
$tdebeant  += $ref0->{'debe'};
$thaberant += $ref0->{'haber'};
	$inicial +=1;
}


my ($tdebe,$thaber);

#	my $sql = "SELECT a.cuenta,SUM(IF(a.dh=0,soles,0)) AS debe,SUM(IF(a.dh=1,soles,0)) AS haber FROM cc_diariodet a,cc_diariocab b WHERE b.estado='0' AND (a.secuencial=b.secuencial) AND a.cuenta like '$subcuenta%' GROUP BY cuenta ORDER BY cuenta";
 	my $sql = "SELECT a.cuenta,b.diario,b.glosa,b.fecha_conta,(IF(a.dh=0,soles,0)) AS debe,(IF(a.dh=1,soles,0)) AS haber FROM cc_diariodet a,cc_diariocab b WHERE b.estado='0' AND (a.secuencial=b.secuencial) AND date_format(b.fecha_conta,'%Y-%m')='$periodo' AND a.cuenta like '$subcuenta%' ORDER BY cuenta";

 my ($ref,$sth,$dbh);
$dbh = connectdb();  

$sth = $dbh->prepare($sql);
$sth->execute();
 print "<br><table border=0 cellpadding=2 cellspacing=2 align=center>";
 
print Tr(td({-colspan=>"9",-class=>$style."lkitem",-align=>"center"},b("Libro Mayor")));
   print Tr(td({-colspan=>9},table({-align=>"center"},Tr({-class=>$style."lkitem"},td(a({-href=>'javascript:window.print()'},"Imprimir")),td("|"),td(a({-href=>"?opt=download_lsaldocuentamayor&periodo=$periodo&subcuenta=$subcuenta"},"Download")))))); 
   print Tr({-class=>$style."lkitem",-bgcolor=>'#00AAAA'},td({-colspan=>2,-align=>"right"},b("PERIODO: ")),td({-colspan=>10},b($periodo)));
   print Tr({-class=>$style."lkitem",-bgcolor=>'#00AAAA'},td({-colspan=>2,-align=>"right"},b("RUC: ")),td({-colspan=>10},b($ruc)));
   print Tr({-class=>$style."lkitem",-bgcolor=>'#00AAAA'},td({-colspan=>2,-align=>"right"},b("DENOMINACION: ")),td({-colspan=>10},b($razonsocial)));
 print Tr({-class=>$style."lkitem",-bgcolor=>'#00AAAA'},td({-colspan=>2,-align=>"right"},b("CUENTA CONTABLE: ")),td({-colspan=>10},b($subcuenta." : ".dsccuentaanexo($subcuenta.'000'))));

   #print Tr({-class=>$style."lkitem",-bgcolor=>'#00AAAA'},td({-rowspan=>2},b("Fecha de la Operacion ")),td({-rowspan=>2},b("# de diario")),td({-rowspan=>2},b("Glosa de la Operacion")),td({-colspan=>2},b("Saldos y Movimientos")));
   #print Tr({-class=>$style."lkitem",-bgcolor=>'#00AAAA'},td({-align=>"right"},b("Deudor")),td(b("Acreedor")));
 print Tr({-class=>$style."lkitem",-bgcolor=>'#00AAAA'},td(b("Fecha de la Operacion ")),td(b("# de diario")),td(b("Glosa de la Operacion")),td(b("Deudor")),td(b("Acreedor")));
  
if ($inicial > 0){

print Tr({-class=>$style."lkitem"},
		   td($periodo."-01"),
       td(""),
		   td({-align=>"center"},"Saldo inicial"),
		    td({-align=>"center"},$tdebeant),
		    td({-align=>"center"},$thaberant)
		    
                    );
                      $tdebe +=$tdebeant;
		    $thaber +=$thaberant;

	}
while ($ref = $sth->fetchrow_hashref()) {
	  print Tr({-class=>$style."lkitem"},
		   td($ref->{'fecha_conta'}),
       td($ref->{'diario'}),
		   td({-align=>"center"},$ref->{'glosa'}),
		    td({-align=>"center"},$ref->{'debe'}),
		    td({-align=>"center"},$ref->{'haber'})
                    );
                    
                      $tdebe +=$ref->{'debe'};
		    $thaber +=$ref->{'haber'};
                    
}
   print "<tr style='background-color: #00AAAA'>";

print "<td colspan=3 align=right >TOTALES</td>";
print "<td align=center>".sprintf("%10.2f",$tdebe)."</td>";
print "<td align=center>".sprintf("%10.2f",$thaber)."</td>";
print "</tr>";


   print "</table>";  
	
	
	}


# ----------------------------------------------------------------------
sub DespliegaDiario0 {
# ----------------------------------------------------------------------
#my @names = param;
#foreach (@names) { print $_ , " = ",param($_), "<br>"; }

my $style  = get_sessiondata('cssname');
my $mcontab = (get_sessiondata('mcontab') eq 'S') ? "soles" : "dolar";
print "solo prueba , mcontab: $mcontab<br>";
if (param('optx') eq 'libros') {
   libros_de_diario();
   return;
}

my ($ref,$sth,$dbh);
$dbh = connectdb();

print start_form(-target=>"inferior");

my ($periodo);

$periodo = param('periodo');


# Scrolling list defaults 
my $sql;
page_header("ridged_paper.png","","");
 

#print $ldiario,"<br>",$periodo,"<br>","$dia","<br>";

# Selector de diario y fechas

# menu
my $sql="SELECT min(a.fecha_conta),max(a.fecha_conta) FROM cc_diariocab a,cc_diariodet b,cc_cuentas c WHERE (a.secuencial=b.secuencial) AND (b.cuenta=c.cuenta) AND (tipodoc='01' OR tipodoc='03' OR tipodoc='06') AND estado='0' AND date_format(a.fecha_conta,'%Y-%m')='$periodo' ORDER BY a.tipodoc,fecha_conta";
my ($inicio,$fin) = $dbh->selectrow_array($sql);
my ($razonsocial,$tienda,$direccion,$lineaopt,$ruc)=$dbh->selectrow_array("SELECT razonsocial,tienda,direccion,lineaopt,ruc FROM config_new");
print "<br><table border=0 cellpadding=2 cellspacing=2 align=center>";
 
print Tr(td({-colspan=>"9",-class=>$style."lkitem",-align=>"center"},b("Libro diario <br>Del&nbsp;$inicio&nbsp;Al&nbsp;$fin")));
   print Tr(td({-colspan=>9},table({-align=>"center"},Tr({-class=>$style."lkitem"},td(a({-href=>'javascript:window.print()'},"Imprimir")),td("|"),td(a({-href=>"?opt=download_ldiario&periodo=$periodo"},"Download")))))); 
   print Tr({-class=>$style."lkitem",-bgcolor=>'#00AAAA'},td({-colspan=>2,-align=>"right"},b("PERIODO: ")),td({-colspan=>10},b($periodo)));
   print Tr({-class=>$style."lkitem",-bgcolor=>'#00AAAA'},td({-colspan=>2,-align=>"right"},b("RUC: ")),td({-colspan=>10},b($ruc)));
   print Tr({-class=>$style."lkitem",-bgcolor=>'#00AAAA'},td({-colspan=>2,-align=>"right"},b("DENOMINACION: ")),td({-colspan=>10},b($razonsocial)));
    my ($tdebe,$thaber);
    my ($ttdebe,$tthaber);
  print "<br>";
print Tr({-class=>$style."lkitem",-bgcolor=>'#00AAAA',-align=>"center"},td(b("#")),td(b("Descripcion")),td(b("TD")),td(b("Numero")),td(b("Fecha")),td(b("Numero")),td(b("Denominacion")),td(b("Anexo")),td(b("Debe")),td(b("Haber")) );


# $sql = "SELECT b.secuencial, b.tipodoc,c.dsc, b.docid, b.fecha_conta,c.dsc,b.ruc,b.glosa, substring(a.cuenta,1,6) AS cta,SUM(IF(a.dh=0,$mcontab,0)) AS debe,SUM(IF(a.dh=1,$mcontab,0)) AS haber FROM cc_diariodet a, cc_diariocab b, cc_cuentas c WHERE b.estado='0' AND (a.secuencial=b.secuencial) AND (a.cuenta=c.cuenta) AND date_format(b.fecha_conta,'%Y-%m')='$periodo' AND (b.diario=8) AND substring(a.cuenta,3,4) != '0000' GROUP BY b.fecha_conta,cta,b.ruc ORDER BY b.secuencial";

#$sql = "SELECT b.secuencial, b.tipodoc,b.diario, b.docid, b.fecha_conta,c.dsc,b.ruc,b.glosa, substring(a.cuenta,1,6) AS cta,IF(a.dh=0,$mcontab,0) AS debe,IF(a.dh=1,$mcontab,0) AS haber FROM cc_diariodet a, cc_diariocab b, cc_cuentas c WHERE b.estado='0' AND (a.secuencial=b.secuencial) AND (a.cuenta=c.cuenta) AND date_format(b.fecha_conta,'%Y-%m')='$periodo' AND (b.diario=8) AND substring(a.cuenta,3,4) != '0000' ORDER BY b.secuencial";
#$sql = "SELECT a.cuenta,b.secuencial, b.tipodoc,b.diario, b.docid, b.fecha_conta,b.ruc,b.glosa, substring(a.cuenta,1,6) AS cta,IF(a.dh=0,$mcontab,0) AS debe,IF(a.dh=1,$mcontab,0) AS haber FROM cc_diariodet a, cc_diariocab b WHERE b.estado='0' AND (a.secuencial=b.secuencial) AND date_format(b.fecha_conta,'%Y-%m')='$periodo' AND (b.diario=8) AND substring(a.cuenta,3,4) != '0000' ORDER BY b.secuencial";
$sql = "SELECT a.cuenta,b.secuencial, b.tipodoc,b.diario, b.docid, b.fecha_conta,b.ruc,b.glosa, substring(a.cuenta,1,6) AS cta,IF(a.dh=0,$mcontab,0) AS debe,IF(a.dh=1,$mcontab,0) AS haber FROM cc_diariodet a, cc_diariocab b WHERE b.estado='0' AND (a.secuencial=b.secuencial) AND date_format(b.fecha_conta,'%Y-%m')='$periodo' AND (b.diario=8 or b.diario=5 or b.diario=6 or b.diario=7 or diario=1) AND substring(a.cuenta,3,4) != '0000' ORDER BY b.secuencial,a.dh";


    $sth = $dbh->prepare($sql);
    $sth->execute();

  print Tr(td({-colspan=>"9",-align=>"left",-class=>$style."lkitem"},b("Sub Diario: Caja Efectivo")));
  
my $i=1;
 while ($ref = $sth->fetchrow_hashref()) {

#	if($ref->{'cta'} ne '101001' and $ref->{'cta'} ne '104001')
		if($ref->{'cta'} ne '101000' and $ref->{'cta'} ne '104000')
	{
       	   
	  print Tr({-class=>$style."lkitem"},
		   td($ref->{'secuencial'}),
                    td($ref->{'glosa'}),
		    td({-align=>"center"},$ref->{'tipodoc'}),
		    td({-align=>"center"},$ref->{'docid'}),
		    td({-align=>"center"},$ref->{'fecha_conta'}),
		    td({-align=>"center"},$ref->{'cuenta'}),
		    td({-align=>"left"},dsccuentaanexo($ref->{'cuenta'})),
		    td({-align=>"center"},$ref->{'ruc'}),
	            td({-align=>"center"},$ref->{'debe'}),
                    td({-align=>"center"},$ref->{'haber'})
                    );
           $tdebe  += $ref->{'debe'};
           $thaber += $ref->{'haber'};
         }
    }

   $ttdebe+=$tdebe;
   $tthaber+=$thaber;

  if ($sth->rows) {
     print Tr({-class=>$style."lkitem",-bgcolor=>"#FFFFFF"},td("&nbsp"),td("&nbsp"),td("&nbsp"),td("&nbsp"),td("&nbsp"),td("&nbsp"),td("&nbsp"),td({-align=>"right"},b("TOTAL SUBDIARIO&nbsp;:&nbsp;")),td({-align=>"right"},b(commify(sprintf("%15.2f",$tdebe)))),td({-align=>"right"},b(commify(sprintf("%15.2f",$thaber)))));
 }
   $tdebe=0;
   $thaber=0;



 #$sql = "SELECT b.secuencial,b.tipodoc,c.dsc,b.estado, b.docid, b.fecha_conta,c.dsc,b.ruc,b.glosa, substring(a.cuenta,1,6) AS cta,SUM(IF(a.dh=0,$mcontab,0)) AS debe,SUM(IF(a.dh=1,$mcontab,0)) AS haber FROM cc_diariodet a, cc_diariocab b, cc_cuentas c WHERE b.estado='0' AND (a.secuencial=b.secuencial) AND (a.cuenta=c.cuenta) AND date_format(b.fecha_conta,'%Y-%m')='$periodo' AND (b.diario=6 OR b.diario=5 OR b.diario=17) AND substring(a.cuenta,3,4) != '0000' GROUP BY b.fecha_conta,cta,b.glosa ORDER BY b.secuencial";
#$sql = "SELECT a.cuenta,b.secuencial,b.tipodoc,b.estado, b.docid, b.fecha_conta,b.ruc,b.glosa, substring(a.cuenta,1,6) AS cta,SUM(IF(a.dh=0,$mcontab,0)) AS debe,SUM(IF(a.dh=1,$mcontab,0)) AS haber FROM cc_diariodet a, cc_diariocab b WHERE b.estado='0' AND (a.secuencial=b.secuencial) AND date_format(b.fecha_conta,'%Y-%m')='$periodo' AND (b.diario=6 OR b.diario=5 OR b.diario=17) AND substring(a.cuenta,3,4) != '0000' GROUP BY b.fecha_conta,cta,b.glosa ORDER BY b.secuencial,a.interno";
$sql = "SELECT a.cuenta,b.referencia,b.secuencial,b.tipodoc,b.estado, b.docid, b.fecha_conta,b.ruc,b.glosa, substring(a.cuenta,1,6) AS cta,SUM(IF(a.dh=0,$mcontab,0)) AS debe,SUM(IF(a.dh=1,$mcontab,0)) AS haber FROM cc_diariodet a, cc_diariocab b WHERE b.estado='0' AND (a.secuencial=b.secuencial) AND date_format(b.fecha_conta,'%Y-%m')='$periodo' AND (b.diario=17) AND substring(a.cuenta,3,4) != '0000' GROUP BY b.fecha_conta,cta,b.glosa ORDER BY b.secuencial,a.interno";


    $sth = $dbh->prepare($sql);
    $sth->execute();
    print Tr(td({-colspan=>"9",-align=>"left",-class=>$style."lkitem"},b("Sub Diario: Registro de Ventas")));
 
 while ($ref = $sth->fetchrow_hashref()) {
        my ($ndocini,$ndocfin,$serie,@ndoc,$docid);

	 if ($ref->{'tipodoc'} eq '01') {
            
            $docid=$ref->{'docid'};
	   
           
           }
	   else
	   {

	    ($ndocfin,$ndocini) = rventa_ndoc_data($ref->{'fecha_conta'},$ref->{'estado'},$ref->{'referencia'});
	    @ndoc=split /\-/,$ndocini;
	    $ndocini=$ndoc[1];
	    @ndoc=();
	    @ndoc=split /\-/,$ndocfin;
	    $ndocfin=$ndoc[1];
	    $serie=$ndoc[0];
	    @ndoc=();
	    $ndocfin=$ndocini."/".$ndocfin;
	    $docid=$serie."-".$ndocfin;
	   }


	  print Tr({-class=>$style."lkitem"},
  		   td($ref->{'secuencial'}),
                    td($ref->{'glosa'}),
		    td({-align=>"center"},$ref->{'tipodoc'}),
		    td({-align=>"center"},$docid),
		    td({-align=>"center"},$ref->{'fecha_conta'}),
		    td({-align=>"center"},$ref->{'cuenta'}),
		    td({-align=>"left"},dsccuentaanexo($ref->{'cuenta'})),
		    td({-align=>"center"},$ref->{'ruc'}),
	            td({-align=>"center"},$ref->{'debe'}),
                    td({-align=>"center"},$ref->{'haber'})
                    );
           $tdebe  += $ref->{'debe'};
           $thaber += $ref->{'haber'};
         
   


 }
   
   $ttdebe+=$tdebe;
   $tthaber+=$thaber;

  if ($sth->rows) {
     print Tr({-class=>$style."lkitem",-bgcolor=>"#FFFFFF"},td("&nbsp"),td("&nbsp"),td("&nbsp"),td("&nbsp"),td("&nbsp"),td("&nbsp"),td("&nbsp"),td({-align=>"right"},b("TOTAL SUBDIARIO&nbsp;:&nbsp;")),td({-align=>"right"},b(commify(sprintf("%15.2f",$tdebe)))),td({-align=>"right"},b(commify(sprintf("%15.2f",$thaber)))));
 }
   $tdebe=0;
   $thaber=0;



# $sql = "SELECT b.secuencial, b.tipodoc,c.dsc, b.docid, b.fecha_conta,c.dsc,b.ruc,b.glosa, substring(a.cuenta,1,6) AS cta,SUM(IF(a.dh=0,$mcontab,0)) AS debe,SUM(IF(a.dh=1,$mcontab,0)) AS haber FROM cc_diariodet a, cc_diariocab b, cc_cuentas c WHERE b.estado='0' AND (a.secuencial=b.secuencial) AND (a.cuenta=c.cuenta) AND date_format(b.fecha_conta,'%Y-%m')='$periodo' AND (b.diario=4 ) AND substring(a.cuenta,3,4) != '0000' GROUP BY cta,b.secuencial ORDER BY b.secuencial";
 $sql = "SELECT a.cuenta,b.secuencial, b.tipodoc, b.docid, b.fecha_conta,b.ruc,b.glosa, substring(a.cuenta,1,6) AS cta,SUM(IF(a.dh=0,$mcontab,0)) AS debe,SUM(IF(a.dh=1,$mcontab,0)) AS haber FROM cc_diariodet a, cc_diariocab b WHERE b.estado='0' AND (a.secuencial=b.secuencial) AND date_format(b.fecha_conta,'%Y-%m')='$periodo' AND (b.diario=4 ) AND substring(a.cuenta,3,4) != '0000' GROUP BY cta,b.secuencial ORDER BY b.secuencial,a.interno";
 
    $sth = $dbh->prepare($sql);
    $sth->execute();
if ($sth->rows) {

  print Tr(td({-colspan=>"9",-align=>"left",-class=>$style."lkitem"},b("Sub Diario: Registro de Compras")));
}  

 while ($ref = $sth->fetchrow_hashref()) {
       
	  print Tr({-class=>$style."lkitem"},
		  td($ref->{'secuencial'}),
                    td($ref->{'glosa'}),
		    td({-align=>"center"},$ref->{'tipodoc'}),
		    td({-align=>"center"},$ref->{'docid'}),
		    td({-align=>"center"},$ref->{'fecha_conta'}),
		    td({-align=>"center"},$ref->{'cuenta'}),
		    td({-align=>"left"},dsccuentaanexo($ref->{'cuenta'})),
		    td({-align=>"center"},$ref->{'ruc'}),
	            td({-align=>"center"},$ref->{'debe'}),
                    td({-align=>"center"},$ref->{'haber'})
                    );
           $tdebe  += $ref->{'debe'};
           $thaber += $ref->{'haber'};
         
    }
    $ttdebe+=$tdebe;
   $tthaber+=$thaber;

  if ($sth->rows) {
     print Tr({-class=>$style."lkitem",-bgcolor=>"#FFFFFF"},td("&nbsp"),td("&nbsp"),td("&nbsp"),td("&nbsp"),td("&nbsp"),td("&nbsp"),td("&nbsp"),td({-align=>"right"},b("TOTAL SUBDIARIO&nbsp;:&nbsp;")),td({-align=>"right"},b(commify(sprintf("%15.2f",$tdebe)))),td({-align=>"right"},b(commify(sprintf("%15.2f",$thaber)))));
 }

   $tdebe=0;
   $thaber=0;



 $sql = "SELECT b.secuencial, b.tipodoc,c.dsc, b.docid, b.fecha_conta,c.dsc,b.ruc,b.glosa, substring(a.cuenta,1,6) AS cta,SUM(IF(a.dh=0,$mcontab,0)) AS debe,SUM(IF(a.dh=1,$mcontab,0)) AS haber FROM cc_diariodet a, cc_diariocab b, cc_cuentas c WHERE b.estado='0' AND (a.secuencial=b.secuencial) AND (a.cuenta=c.cuenta) AND date_format(b.fecha_conta,'%Y-%m')='$periodo' AND (b.diario=16 or b.diario=3) AND substring(a.cuenta,3,4) != '0000' GROUP BY  cta,b.secuencial ORDER BY b.secuencial,a.dh";
    $sth = $dbh->prepare($sql);
    $sth->execute();
if ($sth->rows) {

  print Tr(td({-colspan=>"9",-align=>"left",-class=>$style."lkitem"},b("Sub Diario: Variacion de existencia")));
}  

 while ($ref = $sth->fetchrow_hashref()) {
       
	  print Tr({-class=>$style."lkitem"},
		  td($ref->{'secuencial'}),
                    td($ref->{'glosa'}),
		    td({-align=>"center"},$ref->{'tipodoc'}),
		    td({-align=>"center"},$ref->{'docid'}),
		    td({-align=>"center"},$ref->{'fecha_conta'}),
		    td({-align=>"center"},$ref->{'cta'}),
		    td({-align=>"left"},$ref->{'dsc'}),
		    td({-align=>"center"},$ref->{'ruc'}),
	            td({-align=>"center"},$ref->{'debe'}),
                    td({-align=>"center"},$ref->{'haber'})
                    );
           $tdebe  += $ref->{'debe'};
           $thaber += $ref->{'haber'};
         
    }
    $ttdebe+=$tdebe;
   $tthaber+=$thaber;

  if ($sth->rows) {
     print Tr({-class=>$style."lkitem",-bgcolor=>"#FFFFFF"},td("&nbsp"),td("&nbsp"),td("&nbsp"),td("&nbsp"),td("&nbsp"),td("&nbsp"),td("&nbsp"),td({-align=>"right"},b("TOTAL SUBDIARIO&nbsp;:&nbsp;")),td({-align=>"right"},b(commify(sprintf("%15.2f",$tdebe)))),td({-align=>"right"},b(commify(sprintf("%15.2f",$thaber)))));
 }


   $tdebe=0;
   $thaber=0;



#RICHIE
 $sql = "SELECT b.secuencial,b.tipodoc,c.dsc, b.docid, b.fecha_conta,c.dsc,b.ruc,b.glosa, substring(a.cuenta,1,6) AS cta,SUM(IF(a.dh=0,$mcontab,0)) AS debe,SUM(IF(a.dh=1,$mcontab,0)) AS haber FROM cc_diariodet a, cc_diariocab b, cc_cuentas c WHERE b.estado='0' AND (a.secuencial=b.secuencial) AND (a.cuenta=c.cuenta) AND date_format(b.fecha_conta,'%Y-%m')='$periodo' AND (b.diario=11 or b.diario=12 or b.diario=13 or b.diario=14 or b.diario=15) AND substring(a.cuenta,3,4) != '0000' GROUP BY b.fecha_conta,cta,b.ruc ORDER BY b.secuencial";
    $sth = $dbh->prepare($sql);
    $sth->execute();
if ($sth->rows) {
  print Tr(td({-colspan=>"9",-align=>"left",-class=>$style."lkitem"},b("Sub Diario: Proviciones varias")));
}  

 while ($ref = $sth->fetchrow_hashref()) {

#if ($ref->{'cta'} eq '103000' or $ref->{'cta'} eq '104100') {
	  print Tr({-class=>$style."lkitem"},
		   td($ref->{'secuencial'}),
           td($ref->{'glosa'}),
		    td({-align=>"center"},$ref->{'tipodoc'}),
		    td({-align=>"center"},$ref->{'docid'}),
		    td({-align=>"center"},$ref->{'fecha_conta'}),
		    td({-align=>"center"},$ref->{'cta'}),
		    td({-align=>"left"},$ref->{'dsc'}),
		    td({-align=>"center"},$ref->{'ruc'}),
	            td({-align=>"center"},$ref->{'debe'}),
                    td({-align=>"center"},$ref->{'haber'})
                    );
           $tdebe  += $ref->{'debe'};
           $thaber += $ref->{'haber'};
#}
    }

 if ($sth->rows) {
     print Tr({-class=>$style."lkitem",-bgcolor=>"#FFFFFF"},td("&nbsp"),td("&nbsp"),td("&nbsp"),td("&nbsp"),td("&nbsp"),td("&nbsp"),td("&nbsp"),td({-align=>"right"},b("TOTAL SUBDIARIO&nbsp;:&nbsp;")),td({-align=>"right"},b(commify(sprintf("%15.2f",$tdebe)))),td({-align=>"right"},b(commify(sprintf("%15.2f",$thaber)))));
 }
 $sql = "SELECT b.secuencial,b.tipodoc,c.dsc, b.docid, b.fecha_conta,c.dsc,b.ruc,b.glosa, substring(a.cuenta,1,6) AS cta,SUM(IF(a.dh=0,$mcontab,0)) AS debe,SUM(IF(a.dh=1,$mcontab,0)) AS haber FROM cc_diariodet a, cc_diariocab b, cc_cuentas c WHERE b.estado='0' AND (a.secuencial=b.secuencial) AND (a.cuenta=c.cuenta) AND date_format(b.fecha_conta,'%Y-%m')='$periodo' AND (b.diario=2) AND substring(a.cuenta,3,4) != '0000' GROUP BY cta,b.secuencial ORDER BY b.secuencial,a.interno";
    $sth = $dbh->prepare($sql);
    $sth->execute();

if ($sth->rows) {
  print Tr(td({-colspan=>"9",-align=>"left",-class=>$style."lkitem"},b("Sub Diario: Gastos Varios")));
}
  
  

 while ($ref = $sth->fetchrow_hashref()) {
       
	  print Tr({-class=>$style."lkitem"},
		   td($ref->{'secuencial'}),
                    td($ref->{'glosa'}),
		    td({-align=>"center"},$ref->{'tipodoc'}),
		    td({-align=>"center"},$ref->{'docid'}),
		    td({-align=>"center"},$ref->{'fecha_conta'}),
		    td({-align=>"center"},$ref->{'cta'}),
		    td({-align=>"left"},$ref->{'dsc'}),
		    td({-align=>"center"},$ref->{'ruc'}),
	            td({-align=>"center"},$ref->{'debe'}),
                    td({-align=>"center"},$ref->{'haber'})
                    );
           $tdebe  += $ref->{'debe'};
           $thaber += $ref->{'haber'};
         
    }


 $ttdebe+=$tdebe;
   $tthaber+=$thaber;

  if ($sth->rows) {
     print Tr({-class=>$style."lkitem",-bgcolor=>"#FFFFFF"},td("&nbsp"),td("&nbsp"),td("&nbsp"),td("&nbsp"),td("&nbsp"),td("&nbsp"),td("&nbsp"),td({-align=>"right"},b("TOTAL SUBDIARIO&nbsp;:&nbsp;")),td({-align=>"right"},b(commify(sprintf("%15.2f",$tdebe)))),td({-align=>"right"},b(commify(sprintf("%15.2f",$thaber)))));
 }
  
  
    print Tr({-class=>$style."lkitem",-bgcolor=>"#00AAAA"},td("&nbsp"),td("&nbsp"),td("&nbsp"),td("&nbsp"),td("&nbsp"),td("&nbsp"),td("&nbsp"),td({-align=>"right"},b("T O T A L &nbsp; G E N E R A L:&nbsp;")),td({-align=>"right"},b(commify(sprintf("%15.2f",$ttdebe)))),td({-align=>"right"},b(commify(sprintf("%15.2f",$tthaber)))));
    print "</table>";



print end_form();

}

# ----------------------------------------------------------------------
#jimmy -> devuelve la descripcion de una cuenta que pertenece al plan de cuenta o al de un cliente o proovedor
sub dsccuentaanexo {
	my ($cuenta) = @_;
my ($ref,$sth,$dbh);
$dbh = connectdb();
my $dsc;
 if(length($cuenta) <= 6){

 $dsc = $dbh->selectrow_array("select dsc from cc_cuentas where cuenta='$cuenta'");

 }else{
	
 $dsc = $dbh->selectrow_array("select dsc from cc_anexo where cuenta='$cuenta'");
 
	}
	
return($dsc);
	
	}

# ----------------------------------------------------------------------
sub DespliegaDiario2 {
# ----------------------------------------------------------------------
#my @names = param;
#foreach (@names) { print $_ , " = ",param($_), "<br>"; }

my $style  = get_sessiondata('cssname');
my $mcontab = (get_sessiondata('mcontab') eq 'S') ? "soles" : "dolar";

if (param('optx') eq 'libros') {
   libros_de_diario();
   return;
}

my ($ref,$sth,$dbh);
$dbh = connectdb();

print start_form(-target=>"inferior");

my ($periodo);

$periodo = param('periodo');


# Scrolling list defaults 
my $sql;
page_header("ridged_paper.png","","");
 



#print $ldiario,"<br>",$periodo,"<br>","$dia","<br>";

# Selector de diario y fechas


# menu
my $sql="SELECT min(a.fecha_conta),max(a.fecha_conta) FROM cc_diariocab a,cc_diariodet b,cc_cuentas c WHERE (a.secuencial=b.secuencial) AND (b.cuenta=c.cuenta) AND (tipodoc='01' OR tipodoc='03') AND estado='0' AND date_format(a.fecha_conta,'%Y-%m')='$periodo' ORDER BY a.tipodoc,fecha_conta";

my ($inicio,$fin) = $dbh->selectrow_array($sql);
my ($razonsocial,$tienda,$direccion,$lineaopt,$ruc)=$dbh->selectrow_array("SELECT razonsocial,tienda,direccion,lineaopt,ruc FROM config_new");



if( param('rpt') eq 'bc')
{

  my $sql = "SELECT (SUM(IF(a.dh=0,a.soles,0)) - SUM(IF(a.dh=1,a.soles,0))) FROM cc_diariodet a,cc_diariocab b WHERE b.estado='0' AND (a.secuencial=b.secuencial) AND date_format(b.fecha_conta,'%Y-%m-%d') < '$periodo' AND a.cuenta = '101000' and b.diario='8'";

 my $saldo = $dbh->selectrow_array($sql);


print "<br><table border=0 cellpadding=2 cellspacing=2 align=center>";
print Tr(td({-colspan=>"9",-class=>$style."lkitem",-align=>"center"},b("Libro Caja y Bancos - Detalle de los movimientos del efectivo <br>Del&nbsp;$inicio&nbsp;Al&nbsp;$fin")));
print Tr(td({-colspan=>9},table({-align=>"center"},Tr({-class=>$style."lkitem"},td(a({-href=>'javascript:window.print()'},"Imprimir")),td("|"),td(a({-href=>"?opt=download_lcaja&periodo=$periodo"},"Download")))))); 
print Tr({-class=>$style."lkitem",-bgcolor=>'#00AAAA'},td({-colspan=>2,-align=>"right"},b("PERIODO: ")),td({-colspan=>10},b($periodo)));
print Tr({-class=>$style."lkitem",-bgcolor=>'#00AAAA'},td({-colspan=>2,-align=>"right"},b("RUC: ")),td({-colspan=>10},b($ruc)));
print Tr({-class=>$style."lkitem",-bgcolor=>'#00AAAA'},td({-colspan=>2,-align=>"right"},b("DENOMINACION: ")),td({-colspan=>10},b($razonsocial)));

my ($tdebe,$thaber);
print "<br>";
print Tr({-class=>$style."lkitem",-bgcolor=>'#00AAAA',-align=>"center"},td(b("#")),td(b("Descripcion")),td(b("TD")),td(b("Numero")),td(b("Fecha")),td(b("Numero")),td(b("Denominacion")),td(b("Deudor")),td(b("Acreedor")),td(b("Saldo")) );

$sql = "SELECT b.secuencial, b.tipodoc,b.diario, b.docid, b.fecha_conta,c.dsc,b.ruc,b.glosa, substring(a.cuenta,1,6) AS cta,IF(a.dh=0,$mcontab,0) AS debe,IF(a.dh=1,$mcontab,0) AS haber FROM cc_diariodet a, cc_diariocab b, cc_cuentas c WHERE b.estado='0' AND (a.secuencial=b.secuencial) AND (a.cuenta=c.cuenta) AND date_format(b.fecha_conta,'%Y-%m')='$periodo' AND (b.diario=8) AND substring(a.cuenta,3,4) != '0000' ORDER BY b.secuencial";
$sth = $dbh->prepare($sql);
$sth->execute();


print Tr(td({-colspan=>"10",-align=>"left",-class=>$style."lkitem"},b("101000: Caja Efectivo")) );
print Tr(td({-colspan=>"9",-align=>"right",-class=>$style."lkitem"},b("Saldo Anterior :")),td(b($saldo)) );

my $i=1;
my $ttdh=0;

 while ($ref = $sth->fetchrow_hashref()) {
       if($ref->{'cta'} ne '101000' and $ref->{'cta'} ne '104100')
	{
       	   $tdebe  += $ref->{'debe'};
	   $thaber += $ref->{'haber'};
     
	   if($ref->{'debe'} eq '0.00')
	    {
	      $saldo  += $ref->{'haber'};
	    }
	   else
	    {
	      $saldo  -= $ref->{'debe'};
	    }
       

	  print Tr({-class=>$style."lkitem"},
		   td($ref->{'secuencial'}),
                    td($ref->{'glosa'}),
		    td({-align=>"center"},$ref->{'tipodoc'}),
		    td({-align=>"center"},$ref->{'docid'}),
		    td({-align=>"center"},$ref->{'fecha_conta'}),
		    td({-align=>"center"},$ref->{'cta'}),
		    td({-align=>"left"},$ref->{'dsc'}),
	            td({-align=>"center"},$ref->{'haber'}),
                    td({-align=>"center"},$ref->{'debe'}),
	            td({-align=>"center"},$saldo)
                    );
       }
         
    }


    print Tr({-class=>$style."lkitem",-bgcolor=>"#00AAAA"},td("&nbsp"),td("&nbsp"),td("&nbsp"),td("&nbsp"),td("&nbsp"),td("&nbsp"),td("&nbsp"),td("&nbsp"),td({-align=>"right"},b("S A L D O &nbsp;:&nbsp;")),td({-align=>"right"},b(commify(sprintf("%15.2f",$saldo))) ));
    print "</table>";


}
else
{

my $sql = "SELECT (SUM(IF(a.dh=0,a.soles,0)) - SUM(IF(a.dh=1,a.soles,0))) FROM cc_diariodet a,cc_diariocab b WHERE b.estado='0' AND (a.secuencial=b.secuencial) AND date_format(b.fecha_conta,'%Y-%m-%d') < '$periodo' AND a.cuenta = '104100' and b.diario='8'";

 my $saldo = $dbh->selectrow_array($sql);

print "<br><table border=0 cellpadding=2 cellspacing=2 align=center>";
print Tr(td({-colspan=>"10",-class=>$style."lkitem",-align=>"center"},b("Libro Caja y Bancos - Detalle de los movimientos de la cuenta corriente <br>Del&nbsp;$inicio&nbsp;Al&nbsp;$fin")));
print Tr(td({-colspan=>10},table({-align=>"center"},Tr({-class=>$style."lkitem"},td(a({-href=>'javascript:window.print()'},"Imprimir")),td("|"),td(a({-href=>"?opt=download_lbanco&periodo=$periodo"},"Download")))))); 
print Tr({-class=>$style."lkitem",-bgcolor=>'#00AAAA'},td({-colspan=>2,-align=>"right"},b("PERIODO: ")),td({-colspan=>10},b($periodo)));
print Tr({-class=>$style."lkitem",-bgcolor=>'#00AAAA'},td({-colspan=>2,-align=>"right"},b("RUC: ")),td({-colspan=>10},b($ruc)));
print Tr({-class=>$style."lkitem",-bgcolor=>'#00AAAA'},td({-colspan=>2,-align=>"right"},b("DENOMINACION: ")),td({-colspan=>10},b($razonsocial)));

my ($tdebe,$thaber);
print "<br>";
print Tr({-class=>$style."lkitem",-bgcolor=>'#00AAAA',-align=>"center"},td(b("#")),td(b("Descripcion")),td(b("TD")),td(b("Numero")),td(b("Fecha")),td(b("Numero")),td(b("Denominacion")),td(b("Deudor")),td(b("Acreedor")),td(b("Saldo")) );

$sql = "SELECT b.secuencial, b.tipodoc, b.docid, b.fecha_conta,c.dsc,b.ruc,b.glosa, substring(a.cuenta,1,6) AS cta,IF(a.dh=0,$mcontab,0) AS debe,IF(a.dh=1,$mcontab,0) AS haber FROM cc_diariodet a, cc_diariocab b, cc_cuentas c WHERE b.estado='0' AND (a.secuencial=b.secuencial) AND (a.cuenta=c.cuenta) AND date_format(b.fecha_conta,'%Y-%m')='$periodo' AND (b.diario=8) AND substring(a.cuenta,3,4) != '0000' ORDER BY b.secuencial";
    $sth = $dbh->prepare($sql);
    $sth->execute();

  print Tr(td({-colspan=>"10",-align=>"left",-class=>$style."lkitem"},b("104000: Bancos cuentas corriente")) );
  print Tr(td({-colspan=>"9",-align=>"right",-class=>$style."lkitem"},b("Saldo Anterior :")),td(b($saldo)) );
my $i=1;
 while ($ref = $sth->fetchrow_hashref()) {
       if($ref->{'cta'} ne '101000' and $ref->{'cta'} ne '121000')
	{

	   $tdebe  += $ref->{'debe'};
	   $thaber += $ref->{'haber'};
	   if($ref->{'debe'} eq '0.00')
	    {
	      $saldo  += $ref->{'haber'};
	    }
	   else
	    {
	      $saldo  -= $ref->{'debe'};
	    }

	  print Tr({-class=>$style."lkitem"},
		    td($ref->{'secuencial'}),
                    td($ref->{'glosa'}),
		    td({-align=>"center"},$ref->{'tipodoc'}),
		    td({-align=>"center"},$ref->{'docid'}),
		    td({-align=>"center"},$ref->{'fecha_conta'}),
		    td({-align=>"center"},$ref->{'cta'}),
		    td({-align=>"left"},$ref->{'dsc'}),
	            td({-align=>"center"},$ref->{'haber'}),
                    td({-align=>"center"},$ref->{'debe'}),
	            td({-align=>"center"},$saldo)
                    );
         
	   
       }
         
    }


    print Tr({-class=>$style."lkitem",-bgcolor=>"#00AAAA"},td("&nbsp"),td("&nbsp"),td("&nbsp"),td("&nbsp"),td("&nbsp"),td("&nbsp"),td("&nbsp"),td("&nbsp"),td({-align=>"right"},b("S A L D O &nbsp;:&nbsp;")),td({-align=>"right"},b(commify(sprintf("%15.2f",$saldo))) ));
    print "</table>";


}

print end_form();

}



# ----------------------------------------------------------------------
sub DespliegaDiario3 {
# ----------------------------------------------------------------------
#my @names = param;
#foreach (@names) { print $_ , " = ",param($_), "<br>"; }

my $style  = get_sessiondata('cssname');
my $mcontab = (get_sessiondata('mcontab') eq 'S') ? "soles" : "dolar";

if (param('optx') eq 'libros') {
   libros_de_diario();
   return;
}

my ($ref,$sth,$dbh);
$dbh = connectdb();

print start_form(-target=>"inferior");

my ($periodo);

$periodo = param('periodo');


# Scrolling list defaults 
my $sql;
page_header("ridged_paper.png","","");
 

#print $ldiario,"<br>",$periodo,"<br>","$dia","<br>";

# Selector de diario y fechas

# menu
my $sql="SELECT min(a.fecha_conta),max(a.fecha_conta) FROM cc_diariocab a,cc_diariodet b,cc_cuentas c WHERE (a.secuencial=b.secuencial) AND (b.cuenta=c.cuenta) AND (tipodoc='01' OR tipodoc='03') AND estado='0' AND date_format(a.fecha_conta,'%Y-%m')='$periodo' ORDER BY a.tipodoc,fecha_conta";
my ($inicio,$fin) = $dbh->selectrow_array($sql);
my ($razonsocial,$tienda,$direccion,$lineaopt,$ruc)=$dbh->selectrow_array("SELECT razonsocial,tienda,direccion,lineaopt,ruc FROM config_new");

print "<br><table border=0 cellpadding=2 cellspacing=2 align=center>";
   
print Tr(td({-colspan=>"77",-class=>$style."lkitem",-align=>"center"},b("Libro diario simplificado <br>Del&nbsp;$inicio&nbsp;Al&nbsp;$fin")));
   print Tr(td({-colspan=>77},table({-align=>"center"},Tr({-class=>$style."lkitem"},td(a({-href=>'javascript:window.print()'},"Imprimir")),td("|"),td(a({-href=>"?opt=download_rventa&periodo=$periodo"},"Download")))))); 
   print Tr({-class=>$style."lkitem",-bgcolor=>'#00AAAA'},td({-colspan=>2,-align=>"right"},b("PERIODO: ")),td({-colspan=>75},b($periodo)));
   print Tr({-class=>$style."lkitem",-bgcolor=>'#00AAAA'},td({-colspan=>2,-align=>"right"},b("RUC: ")),td({-colspan=>75},b($ruc)));
   print Tr({-class=>$style."lkitem",-bgcolor=>'#00AAAA'},td({-colspan=>2,-align=>"right"},b("DENOMINACION: ")),td({-colspan=>75},b($razonsocial)));



    my ($tdebe,$thaber);
 print "<br>";
print Tr({-class=>$style."lkitem",-bgcolor=>'#00AAAA',-align=>"center"},td(b("#")),td(b("Fecha")),td(b("Descripcion o Glosa")),td(b("10*")),td(b("12*")),td(b("14*")),td(b("16*")),td(b("19*")),td(b("20*")),td(b("21*")),td(b("22*")),td(b("23*")),td(b("24*")),td(b("25*")),td(b("26*")),td(b("28*")),td(b("29*")),td(b("31*")),td(b("32*")),td(b("33*")),td(b("34*")),td(b("35*")),td(b("36*")),td(b("37*")),td(b("38*")),td(b("39*")),td(b("4011D*")),td(b("4011C*")),td(b("4017D*")),td(b("4017C*")),td(b("402*")),td(b("41*")),td(b("42*")),td(b("45*")),td(b("46*")),td(b("47*")),td(b("48*")),td(b("49*")),td(b("50*")),td(b("53*")),td(b("55*")),td(b("56*")),td(b("57*")),td(b("58*")),td(b("59*")),td(b("60*")),td(b("61*")),td(b("62*")),td(b("63*")),td(b("64*")),td(b("65*")),td(b("66*")),td(b("67*")),td(b("68*")),td(b("69*")),td(b("70*")),td(b("71*")),td(b("72*")),td(b("73*")),td(b("75*")),td(b("76*")),td(b("77*")),td(b("78*")),td(b("79*")),td(b("80*")),td(b("81*")),td(b("82*")),td(b("83*")),td(b("84*")),td(b("85*")),td(b("86*")),td(b("88*")),td(b("89*")),td(b("90*")),td(b("94*")),td(b("95*")),td(b("97*")) );


# $sql = "SELECT b.tipodoc, b.docid, b.fecha_conta,c.dsc,b.ruc,b.glosa, substring(a.cuenta,1,6) AS cta,SUM(IF(a.dh=0,$mcontab,0)) AS debe,SUM(IF(a.dh=1,$mcontab,0)) AS haber FROM cc_diariodet a, cc_diariocab b, cc_cuentas c WHERE b.estado='0' AND (a.secuencial=b.secuencial) AND (a.cuenta=c.cuenta) AND date_format(b.fecha_conta,'%Y-%m')='$periodo' AND (b.diario=8) AND substring(a.cuenta,3,4) != '0000' GROUP BY b.fecha_conta,cta,b.ruc ORDER BY b.fecha_conta";

#$sql="SELECT  substring(a.cuenta,1,6) AS cta,b.tipodoc, b.docid, b.fecha_conta,c.dsc,b.ruc,b.glosa, SUM(IF(a.dh=0,$mcontab,0)) AS debe,SUM(IF(a.dh=1,$mcontab,0)) AS haber FROM cc_diariodet a, cc_diariocab b, cc_cuentas c WHERE b.estado='0' AND (a.secuencial=b.secuencial) AND (a.cuenta=c.cuenta) AND date_format(b.fecha_conta,'%Y-%m')='$periodo' AND substring(a.cuenta,3,4) != '0000' GROUP BY cta ORDER BY cta";

# $sql = "SELECT b.tipodoc,c.dsc, b.docid, b.fecha_conta,c.dsc,b.ruc,b.glosa, substring(a.cuenta,1,6) AS cta,SUM(IF(a.dh=0,$mcontab,0)) AS debe,SUM(IF(a.dh=1,$mcontab,0)) AS haber FROM cc_diariodet a, cc_diariocab b, cc_cuentas c WHERE b.estado='0' AND (a.secuencial=b.secuencial) AND (a.cuenta=c.cuenta) AND date_format(b.fecha_conta,'%Y-%m')='$periodo'  AND substring(a.cuenta,3,4) != '0000' GROUP BY cta ORDER BY b.fecha_conta";
$sql = "SELECT b.tipodoc, b.docid, b.fecha_conta,c.dsc,b.ruc,b.glosa, substring(a.cuenta,1,6) AS cta,IF(a.dh=0,$mcontab,0) AS debe,IF(a.dh=1,$mcontab,0) AS haber FROM cc_diariodet a, cc_diariocab b, cc_cuentas c WHERE b.estado='0' AND (a.secuencial=b.secuencial) AND (a.cuenta=c.cuenta) AND date_format(b.fecha_conta,'%Y-%m')='$periodo' AND (b.diario=8 or b.diario=15 or b.diario=12 or b.diario=11) AND substring(a.cuenta,3,4) != '0000' ORDER BY b.secuencial";


#print $sql;

    $sth = $dbh->prepare($sql);
    $sth->execute();
  
my $i=1;
my $fecha_conta;
my ($stds,$tphdebe,$tgvarios);
 while ($ref = $sth->fetchrow_hashref()) {
      
        if((substr($ref->{'cta'},0,2)) eq "12" or $ref->{'haber'} ne '0.00' )
	  {
	   $stds="<td>$ref->{'haber'}</td><td>".$ref->{'haber'}*(-1)."</td><td colspan=25></td>";
          print Tr({-class=>$style."lkitem"},
		    td(commify(sprintf("%03d",$i++))),
                    td($ref->{'fecha_conta'}),
		    td($ref->{'glosa'}),
                    $stds
                    );
          
           $thaber += $ref->{'haber'};
	  }
       
        if((substr($ref->{'cta'},0,2)) eq "42" and $ref->{'debe'} ne '0.00' )
	  {
           $stds="<td>".$ref->{'debe'}*(-1)."</td><td colspan=28></td><td colspan=25>".$ref->{'debe'}."</td>";
           print Tr({-class=>$style."lkitem"},
		     td(commify(sprintf("%03d",$i++))),
                    td($ref->{'fecha_conta'}),
		     td($ref->{'glosa'}),
                    $stds
                    );
           $tdebe  += $ref->{'debe'};
       
	  }
       
	if((substr($ref->{'cta'},0,2)) eq "63")
	  {
           
           $tphdebe  += $ref->{'debe'};
       

	  }
       if((substr($ref->{'cta'},0,2)) eq "65")
	  {
           
           $tgvarios  += $ref->{'debe'};
       

	  }
  
    $fecha_conta=       $ref->{'fecha_conta'};
 
    }

 	my $igv  = rventa_igv_data_new($fecha_conta,0);
	

         $stds="<td></td><td>".$thaber ."</td><td colspan=22></td><td >".(commify(sprintf("%10.2f",($thaber-$thaber/(1.19)))))."</td>";
           print Tr({-class=>$style."lkitem"},
		    td(commify(sprintf("%03d",$i++))),
                    td($fecha_conta),
		    td("Centralizacion de registro de ventas"),
                    $stds
                    );

           $igv  = rventa_igv_data_new2($fecha_conta,0);

           $stds="<td colspan=5></td><td>".$tdebe."</td><td colspan=17></td><td>".(commify(sprintf("%10.2f",($tdebe-$tdebe/(1.19)))))."</td><td colspan=22></td><td>$tphdebe</td><td colspan=1></td><td>$tgvarios</td>";
           print Tr({-class=>$style."lkitem"},
		    td(commify(sprintf("%03d",$i++))),
                    td($fecha_conta),
		    td("Centralizacion de registro de compras"),
                    $stds
                    );


  
    print Tr({-class=>$style."lkitem",-bgcolor=>"#00AAAA"},td("&nbsp"),td("&nbsp"),td("&nbsp"),td("&nbsp"),td("&nbsp"),td("&nbsp"),td("&nbsp"),td("&nbsp"),td("&nbsp"),td("&nbsp"),td("&nbsp"),td("&nbsp"),td("&nbsp"),td("&nbsp"),td("&nbsp"),td("&nbsp"),td("&nbsp"),td("&nbsp"),td("&nbsp"),td("&nbsp"),td("&nbsp"),td("&nbsp"),td("&nbsp"),td("&nbsp"),td("&nbsp"),td("&nbsp"),td("&nbsp"),td("&nbsp"),td("&nbsp"),td("&nbsp"),td("&nbsp"),td("&nbsp"),td("&nbsp"),td("&nbsp"),td("&nbsp"),td("&nbsp"),td("&nbsp"),td("&nbsp"),td("&nbsp"),td("&nbsp"),td("&nbsp"),td("&nbsp"),td("&nbsp"),td("&nbsp"),td("&nbsp"),td("&nbsp"),td("&nbsp"),td("&nbsp"),td("&nbsp"),td("&nbsp"),td("&nbsp"),td("&nbsp"),td("&nbsp"),td("&nbsp"),td("&nbsp"),td("&nbsp"),td("&nbsp"),td("&nbsp"),td("&nbsp"),td("&nbsp"),td("&nbsp"),td("&nbsp"),td("&nbsp"),td("&nbsp"),td("&nbsp"),td("&nbsp"),td("&nbsp"),td("&nbsp"),td("&nbsp"),td("&nbsp"),td("&nbsp"),td("&nbsp"),td("&nbsp"),td("&nbsp"),td("&nbsp"),td("&nbsp"),td("&nbsp"));
    print "</table>";



print end_form();

}

# -----------------------------------------------------------
sub rventa_igv_data_new {
# -----------------------------------------------------------
my ($fecha,$estado) = @_;
my $dbh = Contab33::connectdb();
return($dbh->selectrow_array("SELECT sum(a.soles) FROM cc_diariodet a,cc_diariocab b  WHERE (a.secuencial=b.secuencial)and b.fecha_conta='$fecha' and a.cuenta='401100' and b.estado='$estado'"));
}

# -----------------------------------------------------------
sub rventa_igv_data_new2 {
# -----------------------------------------------------------
my ($fecha,$estado) = @_;
my $dbh = Contab33::connectdb();
return($dbh->selectrow_array("SELECT sum(a.soles) FROM cc_diariodet a,cc_diariocab b  WHERE (a.secuencial=b.secuencial)and b.fecha_conta='$fecha' and a.cuenta='401200' and b.estado='$estado'"));
}

# ------------------------------
sub talonpaginador {
# ------------------------------
my ($firstpage,$lastpage,$lpp,$pageno,$pages,$retorno) = @_;
                                                                                                  
#print $firstpage, "-" , $lastpage , "-", $pageno ,"-", $pages;
                                                                                                  
my $style = get_sessiondata('cssname');
                                                                                                  
print "<br><table align=center><tr>";
                                                                                                  
if ($firstpage == $lastpage) {
   return;
}
                                                                                                  
my $i;
my $offset;
# param1 = inicio del siguiente rango de paginas
if ($firstpage > 1) {
    my $param1 = ($firstpage - 1) - $lpp;
    my $offset = (($firstpage - 1) - 1) * $lpp;
    print "<td class=".$style."lkitem><a href='$retorno&offset=0&param1=1'>Primero</a></td>";
    print "<td class=".$style."lkitem><a href='$retorno&offset=$offset&param1=$param1'>Anterior</a></td>";
}
                                                                                                  
$firstpage = ($firstpage < 0) ? 1 : $firstpage;
for ($i = $firstpage; $i <= $lastpage; $i++) {
     $offset = ($i-1) * $lpp;
     if ($i != $pageno) {  # paginas por ver
          print "<td class=".$style."lkitem><a href='$retorno&offset=$offset&param1=$firstpage'>".$i."</a></td>";
     } else {              # pagina actual
          print "<td class=".$style."lkitem>$i</td>";
     }
}

if ($lastpage < $pages) {   # 
    my $param1 = $lastpage + 1;
    my $offset = ($param1-1) * $lpp;
    print "<td class=".$style."lkitem><a href='$retorno&offset=$offset&param1=$param1'>Siguiente</a></td>";
    my $param1 = $pages - $lpp;
    my $offset = ($pages-1) * $lpp;
    print "<td class=".$style."lkitem><a href='$retorno&offset=$offset&param1=$param1'>Ultimo</a></td>";
}
                                                                                                  
print "</tr></table>";
                                                                                                  
}

# ----------------------------------------------------------------------
sub NombreCuenta {
# ----------------------------------------------------------------------
my ($cuenta) = @_;

my $dbh = connectdb();
#my $cuentareal = substr($cuenta, 3);
my $cuentareal = $cuenta;
my $sql = "SELECT dsc FROM cc_cuentas WHERE cuenta='$cuenta'";
#my $sql = "SELECT dsc FROM cc_anexo WHERE cuenta='$cuentareal'";
return($dbh->selectrow_array($sql));

}
sub NombreCuentaAnexo {
# ----------------------------------------------------------------------
my ($cuenta) = @_;

my $dbh = connectdb();
#my $cuentareal = substr($cuenta, 3);
my $cuentareal = $cuenta;
#my $sql = "SELECT dsc FROM cc_cuentas WHERE cuenta='$cuenta'";
my $sql = "SELECT dsc FROM cc_anexo WHERE cuenta='$cuentareal'";
return($dbh->selectrow_array($sql));

}


# ----------------------------------------------------------------------
sub NombreSubCuenta {
# ----------------------------------------------------------------------
my ($cuenta) = @_;

my $dbh = connectdb();
my $sql = "SELECT dsc FROM cc_cuentas WHERE cuenta='".substr($cuenta,0,3)."000'";
return($dbh->selectrow_array($sql));

}

# ----------------------------------------------------------------------
sub NombreCuentaPrincipal {
# ----------------------------------------------------------------------
my ($cuenta) = @_;

my $dbh = connectdb();
my $sql = "SELECT dsc FROM cc_cuentas WHERE cuenta='".substr($cuenta,0,2)."0000'";
return($dbh->selectrow_array($sql));

}

# ----------------------------------------------------------------------
sub ListaSubCuentas {
# ----------------------------------------------------------------------
my ($cuenta) = @_;

# Falta
my $dbh = connectdb();
my $sql = "SELECT substr(cuenta,1,3),dsc FROM cc_cuentas WHERE cuenta='".substr($cuenta,0,3)."000'";
return($dbh->selectrow_array($sql));

}

# ----------------------------------------------------------------------
sub NombreDocumento {
# ----------------------------------------------------------------------
my ($tipodoc) = @_;

my $dbh = connectdb();
my $sql = "SELECT substring(descripcion,1,32) FROM cc_tipodoc WHERE tipodoc='$tipodoc'";
return($dbh->selectrow_array($sql));

}

# ----------------------------------------------------------------------
sub NombreDiario {
# ----------------------------------------------------------------------
my ($diario) = @_;

my $dbh = connectdb();
my $sql = "SELECT nombre FROM cc_diarios WHERE diario='$diario'";
return($dbh->selectrow_array($sql));

}


# ----------------------------------------------------------------------
sub comp_nombrediario {
my ($ldiario) = @_;
my $dbh = connectdb();
my $nombrediario = $dbh->selectrow_array("SELECT nombre FROM cc_diarios WHERE diario='$ldiario'");

return $nombrediario;
	}
# ----------------------------------------------------------------------
	
sub comp_tipomoneda {
	my ($moneda) = @_;
	my $nombremoneda;
	my %options        = ("0" => "Nuevos Soles", "1" => "Dolares Americanos");
	if ($moneda eq '0'){
		$nombremoneda="Nuevos Soles";
	}else{
			$nombremoneda="Dolares Americanos";
		}
	 return $nombremoneda
	}
# ----------------------------------------------------------------------
	
sub comp_tipodoc {
	my ($tipodoc) = @_;
	my $dbh = connectdb();
	my $nombretipodoc = $dbh->selectrow_array("SELECT descripcion FROM cc_tipodoc WHERE tipodoc='$tipodoc'");
return $nombretipodoc
	}	
# ----------------------------------------------------------------------
sub comp_manifiesto {
	my ($manifiesto) = @_;
		my $dbh = connectdb();
	my $numeromanifiesto = $dbh->selectrow_array("select cuenta from cc_tipoanexo where scuenta='$manifiesto'");
return $numeromanifiesto
		
	}
# ----------------------------------------------------------------------
	
	
sub AgregarComprobante {
# ----------------------------------------------------------------------
#my @names = param;
#foreach (@names) { print $_ , " = ",param($_), "<br>"; }

my @checknum = param('checknum');

my $style = get_sessiondata('cssname');

print start_form(-name=>"agregar_comp",-target=>"");

if (param('optx') eq 'additem') {   
    my $cuenta = param('cuenta');
    my $memo   = param('memo');
    my $dh     = (param('debe') ne '') ? '0' : '1';
    my $moneda = (defined(param('moneda')))    ? param('moneda')    : '0';   # default = soles
    my $valor  = ($moneda eq '0') ? param('debe') : param('haber');
    my $tc_compra = (defined(param('tc_compra'))) ? param('tc_compra') : get_sessiondata('tc_compra');
    additem($moneda,$tc_compra,$cuenta,$memo,$dh,$valor,'dart');
}

if (param('optx') eq 'delitems') {   
    delitems('dart');
}

if (param('optx') eq 'saveitems') {   
    saveitems('dart');
}

if (param('optx') eq 'insertcomp') {   

    my $uid  = $$."-".$ENV{'REMOTE_ADDR'}."-".time();

    my $ldiario     = param('ldiario');
    my $fecha_conta = param('fecha_conta');
    my $glosa       = param('glosa');
    my $tc_compra   = param('tc_compra');
    my $tipodoc     = param('tipodoc');
    my $docid       = param('docid');
    my $moneda      = param('moneda');
    my $estado      = param('estado');
    my $ruc         = param('ruc');
    my $referencia  = param('referencia');
    my $percepcion  = '0';
    my $detraccion  = '0';
    my $usuario     = get_sessiondata('user');

    my $dbh = connectdb();
    $dbh->do("INSERT INTO cc_diariocab
         (uid,diario,tc_compra,tipodoc,docid,ruc,glosa,estado,fecha_conta,moneda,referencia,usuario,percepcion,detraccion)
             VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?)",undef,
             $uid,
             $ldiario,
             $tc_compra,
             $tipodoc,
             $docid,
             $ruc,
             $glosa,
             $estado,
             $fecha_conta,
             0,
             $referencia,
             $usuario,
             $percepcion,
             $detraccion
             ) or (my $err=$DBI::errstr);
     
    print $err,"<br>" if ($err); 

    # insert en diariodet
    my ($secuencial) = $dbh->selectrow_array("SELECT secuencial FROM cc_diariocab WHERE uid='$uid'");
    
    
    
print "<table border=0 align=center><tr><td>"; # Tabla externa
print "<br><table border=0 width=100% cellpadding=2 cellspacing=2 class=".$style."FormTABLE>";

print Tr(td({-colspan=>"2",-class=>$style."ttitem",-align=>"center"},b("<font color=green>Nuevo comprobante de diario</font>")));

print Tr({-class=>$style."FieldCaptionTD"},td(table(Tr(td(b("Diario")),td(comp_nombrediario($ldiario)),td({-width=>"100"},b("Fecha")),td($fecha_conta),td(b("Tipo de Cambio")),td($tc_compra),td(b("Moneda")),td(comp_tipomoneda(param('moneda')))    ))));

print Tr({-class=>$style."FieldCaptionTD"},td(table(Tr(td(b("Documento")),td(comp_tipodoc(param('tipodoc'))),td(b("N&uacute;mero")),td($docid),td(b("Estado")),td("Activo"),td(b("Usuario:&nbsp;")),td(get_sessiondata('user'))) )));

print Tr({-class=>$style."FieldCaptionTD"},td(table(Tr(td(b("Detalle")),td($glosa),td(b("Cheque/Ref.")),td($referencia) ))));


print "</table>";

# Detalle del Comprobante
print "<table width=100% border=0 cellpadding=2 cellspacing=2 align=center class=".$style."FormTABLE>";

# Cabecera y simbolo para agregar registro
print Tr({-class=>$style."FormHeaderFont",-align=>"center"},td({-width=>"50"}),td({width=>"50"},b("Cuenta")),td(b("Nombre")),td({-width=>"120"},b("Memo")),td({-width=>"100"},b("Debe")),td({-width=>"100"},b("Haber")) );




    if (defined (cookie('contab'))) {      
        if (my $sess_ref = opensession() and $secuencial ne '') {
            my %orders;
            my $item_id;
            my $cart_ref = $sess_ref->attr("dart");
            foreach $item_id (keys(%{$cart_ref})) {
                    my $item_ref = $cart_ref->{$item_id};
                    $orders{$item_ref->{"item"}} = $item_id;
            }
            foreach my $key (sort keys(%orders)) {
                    my $item_ref = $cart_ref->{$orders{$key}};
                    my $tc_compra = param('tc_compra');
                    if (param('moneda') eq '0') {
                          $dbh->do ("INSERT INTO cc_diariodet(secuencial,cuenta,memo,dh,soles,dolar) VALUES (?,?,?,?,?,?)",undef,$secuencial,$orders{$key},$item_ref->{'memo'},$item_ref->{'dh'},$item_ref->{'soles'},$item_ref->{'dolar'});
                    } else {
                       if ($tc_compra > 0) {
                          $dbh->do ("INSERT INTO cc_diariodet(secuencial,cuenta,memo,dh,soles,dolar) VALUES (?,?,?,?,?,?)",undef,$secuencial,$orders{$key},$item_ref->{'memo'},$item_ref->{'dh'},$item_ref->{'soles'},$item_ref->{'dolar'});
                       }
                    }
                    

 print Tr({-class=>$style."FieldCaptionTD",-align=>"center"},
                            td({-align=>"center"}),
                            td($orders{$key}),
                            td({-align=>"left"},dsccuentaanexo($orders{$key})),
                            td({-align=>"left"},$item_ref->{'memo'}),
                            td({-align=>"right"},($item_ref->{'dh'} eq '0') ? commify(sprintf("%10.2f",$item_ref->{'soles'}))  : ''),
                            td({-align=>"right"},($item_ref->{'dh'} eq '1') ? commify(sprintf("%10.2f",$item_ref->{'soles'})) : '')

);                    
                    
            }
            
            
            
print "</table>";
print "</td></tr></table>";
#print br(),table({-align=>"center"},Tr(td(a({-href=>"?opt=addcomp&optx=insertcomp&cuenta=".param('cuenta'),-title=>"Imprimir",-onclick=>"window.print();"},img({-src=>"/images/printer.png",-border=>"0",-alt=>"printer.png",-width=>"36",-height=>"36"}))) ));
print br(),table({-align=>"center"},Tr(td(a({-href=>"",-title=>"Imprimir",-onclick=>"window.print();window.close();"},img({-src=>"/images/printer.png",-border=>"0",-alt=>"printer.png",-width=>"36",-height=>"36"}))) ));

            # Eliminar variables de sesion
            foreach $item_id (keys(%{$cart_ref})) {
                     delete($cart_ref->{$item_id});
            }
            $sess_ref->attr("dart", $cart_ref);
            $sess_ref->close();
        }
    }

    #if (param('opty') eq 'dopay') {       # Regresa a Documentos por cobrar/pagar
     #   my $pflag = defined(param('pflag')) ? '1' : '0';
      #  print redirect("?opt=opevarias&pflag=$pflag&secuencial=$secuencial&optx=".param('optw')."&opty=cuenta&cuenta=".param('cuenta'));
   # } elsif (param('opty') eq 'nc') {     # Regresa a Documentos por pagar (genera nota de credito)
    #    print redirect("?opt=opevarias&optx=cpagar&opty=cuenta&cuenta=".param('cuenta'));
    #} else {                              # Refresca el diario
     #   print redirect("?opt=diario&scrolldiario=yes&scrollperiodo=yes&scrolldia=yes&offset=".param('offset')."&param1=".param('param1')."&ldiario=".param('ldiario')."&periodo=".param('periodo')."&dia=".param('dia'));
    #}



   return;
} # end insertcomp

if (param('optx') eq 'vistaprevia') {   

    my $ldiario     = param('ldiario');
    my $fecha_conta = param('fecha_conta');
    my $glosa       = param('glosa');
    my $tc_compra   = param('tc_compra');
    my $tipodoc     = param('tipodoc');
    my $docid       = param('docid');
    my $moneda      = param('moneda');
    my $estado      = param('estado');
    my $ruc         = param('ruc');
    my $referencia  = param('referencia');
    my $percepcion  = '0';
    my $detraccion  = '0';
    my $usuario     = get_sessiondata('user');

    my $dbh = connectdb();
    print "<br><table border=1 width=600 align=center cellpadding=2 cellspacing=2 class=".$style."FormTABLE>";

print Tr(td({-colspan=>"2",-class=>$style."ttitem",-align=>"center"},b("<font color=green>Nuevo comprobante de diario</font>")));

print Tr({-class=>$style."FieldCaptionTD"},td(table(Tr(td(b("Diario")),td({-width=>"100"},comp_nombrediario($ldiario)),td(b("Fecha")),td({-width=>"80"},$fecha_conta),td(b("Tipo de Cambio")),td($tc_compra),td(b("Moneda")),td(comp_tipomoneda(param('moneda')))    ))));

print Tr({-class=>$style."FieldCaptionTD"},td(table(Tr(td(b("Documento")),td({-width=>"250"},comp_tipodoc(param('tipodoc'))),td(b("N&uacute;mero")),td({-width=>"100"},$docid),td(b("Estado")),td({-width=>"100"},"Activo"),td(b("Usuario:&nbsp;")),td(get_sessiondata('user'))) )));

print Tr({-class=>$style."FieldCaptionTD"},td(table(Tr(td(b("Detalle")),td({-width=>"300"},$glosa),td(b("Cheque/Ref.")),td($referencia) ))));


print "</table>";

print "<table width=600 border=0 cellpadding=2 cellspacing=2 align=center class=".$style."FormTABLE>";
# Cabecera y simbolo para agregar registro
print Tr({-class=>$style."FormHeaderFont",-align=>"center"},td({width=>"50"},b("Cuenta")),td(b("Nombre")),td({-width=>"120"},b("Memo")),td({-width=>"100"},b("Debe")),td({-width=>"100"},b("Haber")) );

 if (defined (cookie('contab'))) {      
        if (my $sess_ref = opensession()) {
            my %orders;
            my $item_id;
            my $cart_ref = $sess_ref->attr("dart");
            foreach $item_id (keys(%{$cart_ref})) {
                    my $item_ref = $cart_ref->{$item_id};
                    $orders{$item_ref->{"item"}} = $item_id;
            }
            foreach my $key (sort keys(%orders)) {
                    my $item_ref = $cart_ref->{$orders{$key}};
                    my $tc_compra = param('tc_compra');
print Tr({-class=>$style."FieldCaptionTD",-align=>"center"},
                            
                            td($orders{$key}),
                            td({-align=>"left"},dsccuentaanexo($orders{$key})),
                            td({-align=>"left"},$item_ref->{'memo'}),
                            td({-align=>"right"},($item_ref->{'dh'} eq '0') ? commify(sprintf("%10.2f",$item_ref->{'soles'}))  : ''),
                            td({-align=>"right"},($item_ref->{'dh'} eq '1') ? commify(sprintf("%10.2f",$item_ref->{'soles'})) : '')

);                    
                    
            }
            
            
            
print "</table>";
print "</td></tr></table>";
#print br(),table({-align=>"center"},Tr(td(a({-href=>"?opt=addcomp&optx=insertcomp&cuenta=".param('cuenta'),-title=>"Imprimir",-onclick=>"window.print();"},img({-src=>"/images/printer.png",-border=>"0",-alt=>"printer.png",-width=>"36",-height=>"36"}))) ));
print br(),table({-align=>"center"},Tr(td(a({-href=>"",-title=>"Imprimir",-onclick=>"window.print();window.close();"},img({-src=>"/images/printer.png",-border=>"0",-alt=>"printer.png",-width=>"36",-height=>"36"}))) ));

            # Eliminar variables de sesion
            foreach $item_id (keys(%{$cart_ref})) {
                     delete($cart_ref->{$item_id});
            }
            $sess_ref->attr("dart", $cart_ref);
            $sess_ref->close();
        }
    }
    
print "</table>";

   return;
}

if (param('optx') eq 'cancelar') {   
    limpiar_dart();
}

#
# Crea un comprobante en variables de session
#

# -- parametros para refrescar el despliegue del diario
my $ldiario = param('ldiario');
my $periodo = param('periodo');
my $dia     = param('dia');
                                                                                                                            
my $offset  = param('offset');
my $param1  = param('param1');
# -- parametros para refrescar el despliegue del diario

print <<EOF;
<script language="JavaScript" type="text/javascript">
function chkdebe(field) {   
         rx = /[^0-9.]/;
         if (rx.test(field.value)) {
            alert("Este campo acepta solamente numeros.");
            field.select();
            field.focus();
         } else {
            document.forms[0].haber.value='';document.forms[0].submit();
         }
}

function chkhaber(field) {   
         rx = /[^0-9.]/;
         if (rx.test(field.value)) {
            alert("Este campo acepta solamente numeros.");
            field.select();
            field.focus();
         } else {
            document.forms[0].debe.value='';document.forms[0].submit();
         }
}
</script>
EOF

# Visualiza la Cabecera de Comprobante
my %options        = ("0" => "Nuevos Soles", "1" => "Dolares Americanos");
my %estadooptions  = ("0" => "Activo", "1" => "Anulado", "2" => "Proceso");
my $style          = get_sessiondata('cssname');

my ($diario,$tc_compra,$tipodoc,$docid,$ruc,$glosa,$estado,$fecha_conta,$moneda,$referencia,$usuario,$percepcion,$detraccion,$igv);

if (param('optx') eq 'clonar') {   

    my $dbh = connectdb();
   ($ldiario,$tc_compra,$tipodoc,$docid,$ruc,$glosa,$estado,$fecha_conta,$moneda,$referencia,$usuario,$percepcion,$detraccion) = $dbh->selectrow_array("SELECT diario,tc_compra,tipodoc,docid,ruc,glosa,estado,fecha_conta,moneda,referencia,usuario,percepcion,detraccion FROM cc_diariocab WHERE secuencial='".param('secuencial')."'");
    
   $glosa  = (defined(param('glosa')))   ? "NOTA DE CREDITO"  : $glosa;
   $estado = (defined(param('estado')))  ? param('estado')    : $estado;

} else {

   $tc_compra   = get_sessiondata('tc_compra');
   $fecha_conta = substr(HKZ33::getDate(),0,10);

   $moneda  = (!defined(param('moneda'))) ? '0' : param('moneda');
   $glosa   = (!defined(param('glosa')))  ? ''  : param('glosa');
   $estado  = (!defined(param('estado'))) ? '0' : param('estado');
   $tipodoc = (!defined(param('tipodoc'))) ? '' : param('tipodoc');
   $docid   = (!defined(param('docid')))  ? ''  : param('docid');
   $referencia = (!defined(param('referencia')))  ? ''  : param('referencia');
   $ruc = (!defined(param('ruc')))  ? ''  : param('ruc');
   $igv = (!defined(param('igv')))  ? ''  : param('igv');
	
}


print "<table border=0 align=center><tr><td>"; # Tabla externa
print "<br><table border=0 width=100% cellpadding=2 cellspacing=2 class=".$style."FormTABLE>";
print Tr(td({-colspan=>"2",-class=>$style."ttitem",-align=>"center"},b("<font color=green>Nuevo comprobante de diario</font>")));

print Tr({-class=>$style."FieldCaptionTD"},td(table(Tr(td(b("Diario")),td(DiarioScroll($ldiario)),td(b("Fecha")),td(textfield(-name=>"fecha_conta",-value=>"$fecha_conta",-size=>"10",-maxlength=>"10",-override=>"1")),td(b("Tipo de Cambio")),td(textfield(-name=>"tc_compra",-value=>"$tc_compra",-size=>"6",-maxlength=>"6",-override=>"1")),td(b("Moneda")),td(scrolling_list(-name =>"moneda",-values=>["0","1"],-labels=>\%options,-size =>1,-multiple=>0,-default=>["$moneda"],-onchange=>"submit();"))    ))));

print Tr({-class=>$style."FieldCaptionTD"},td(table(Tr(td(b("Documento")),td(DocumentScroll($tipodoc)),td(b("N&uacute;mero")),td(textfield(-name=>"docid",-value=>"$docid",-size=>"12",-maxlength=>"12")),td(b("Estado")),td(scrolling_list(-name =>"estado",-values=>["0","1","2"],-labels=>\%estadooptions,-size =>1,-multiple=>0,-default=>["$estado"],-onchange=>"submit();")),td(b("Usuario:&nbsp;")),td(textfield(-name=>"usuario",-class=>$style."NoInput",-value=>get_sessiondata('user'),-size=>"11",-maxlength=>"11",-OnFocus=>"blur();",,-override=>"1"))) )));


#print Tr({-class=>$style."FieldCaptionTD"},td(table(Tr(td(b("Detalle")),td(textfield(-name=>"glosa",-value=>"$glosa",-size=>"45",-maxlength=>"128",-override=>"1")),td(b("Cheque/Ref.")),td(textfield(-name=>"referencia",-value=>$referencia,-size=>"11",-maxlength=>"11",-override=>"1")),td(b("RUC:")),td(textfield(-name=>"ruc",-value=>"$ruc",-size=>"11",-maxlength=>"11",-override=>"1")) ))));

#print Tr({-class=>$style."FieldCaptionTD"},td(table(Tr(td(b("RUC:")),td(textfield(-name=>"ruc",-value=>"$ruc",-size=>"11",-maxlength=>"11",-override=>"1")),td(b("IGV:")),td(textfield(-name=>"igv",-value=>$igv,-size=>"6",-maxlength=>"6",-override=>"1")) ))));

print Tr({-class=>$style."FieldCaptionTD"},td(table(Tr(td(b("Detalle")),td(textfield(-name=>"glosa",-value=>"$glosa",-size=>"45",-maxlength=>"128",-override=>"1")),td(b("Cheque/Ref.")),td(textfield(-name=>"referencia",-value=>$referencia,-size=>"11",-maxlength=>"11",-override=>"1")) ))));


print "</table>";

# Detalle del Comprobante
print "<table width=100% border=0 cellpadding=2 cellspacing=2 align=center class=".$style."FormTABLE>";

# Cabecera y simbolo para agregar registro
print Tr({-class=>$style."FormHeaderFont",-align=>"center"},td({-width=>"50"},a({-href=>"#",-onclick=>"document.forms[0].optx.value='addrow';document.forms[0].submit();"},img({-src=>"/images/increment.png",-alt=>"increment.png",-border=>"0"}))),td({width=>"50"},b("Cuenta")),td(b("Nombre")),td({-width=>"120"},b("Memo")),td({-width=>"100"},b("Debe")),td({-width=>"100"},b("Haber")) );

my ($tdebe_mn,$thaber_mn,$tdebe_me,$thaber_me);

#my $moneda = (!defined(param('moneda'))) ? 0 : param('moneda');

# -- Despliega el contenido de session --
my %orders;
my $item_id;
if (defined (cookie('contab'))) {      # check new session and & retrieve $sess_ref
   my $dbh = connectdb();
   if (my $sess_ref = opensession()) {
      my $cart_ref = $sess_ref->attr("dart");
      foreach $item_id (keys(%{$cart_ref})) {
              my $item_ref = $cart_ref->{$item_id};
              $orders{$item_ref->{"item"}} = $item_id;
      }
      foreach my $key (sort keys(%orders)) {

               my $item_ref = $cart_ref->{$orders{$key}};
               my $delete_button = "<button class=".$style."button type='button' name='delete_submit' value='delete' title='Eliminar' onclick=\"document.forms[0].checknum.value='$item_ref->{'item'}';document.forms[0].optx.value='delitems';document.forms[0].submit();\">".img({-src=>"/images/b_drop.png",-alt=>"b_drop.png",-border=>"0"}). "</button>";
               my $update_button = "<button class=".$style."button type='button' name='update_submit' value='update' title='Actualizar' onclick=\"document.forms[0].checknum.value='$item_ref->{'item'}';document.forms[0].optx.value='saveitems';document.forms[0].submit();\">".img({-src=>"/images/b_edit.png",-alt=>"b_edit.png",-border=>"0"}). "</button>";

               my ($debe,$haber);
               my $soles =  $item_ref->{'soles'};
               my $dolar =  $item_ref->{'dolar'};
               if ($moneda eq '0') {
                  $debe  = ($item_ref->{'dh'} eq '0') ? $soles : '';
                  $haber = ($item_ref->{'dh'} eq '1') ? $soles : '';
               } else {
                  $debe  = ($item_ref->{'dh'} eq '0') ? $dolar : '';
                  $haber = ($item_ref->{'dh'} eq '1') ? $dolar : '';
               }

               if ( (param('optx') eq 'modrow' and grep(/^$item_ref->{'item'}$/,@checknum)) or (param('optx') eq 'additem' and $orders{$key} eq param('cuenta')) ) {
                   print Tr({-class=>$style."FieldCaptionTD",-align=>"center"},
                        td({-width=>"50",-align=>"center"},table(Tr(td($delete_button),td($update_button) ))),
                        td($orders{$key}),
                        td({-align=>"left"},dsccuentaanexo($orders{$key})),
                        td(textfield(-name=>"memo",-value=>"$item_ref->{'memo'}",-size=>"16",-override=>"1",-maxlength=>"24")),
                        td(textfield(-name=>"debe",-value=>$debe,-size=>"10",-maxlength=>"10",-override=>"1",-onchange=>"document.forms[0].optx.value='saveitems';chkdebe(this);")),
                        td(textfield(-name=>"haber",-value=>$haber,-size=>"10",-maxlength=>"10",-override=>"1",-onchange=>"document.forms[0].optx.value='saveitems';chkhaber(this);"))
                      );
                   print hidden(-name=>"checknum",-value=>"$item_ref->{'item'}",-override=>1);
               } else {   # Linea sin marcar
                      my $ck = (param('optx') ne 'addrow') ? 
                               checkbox(-name=>"checknum",-value=>$item_ref->{'item'},-label =>"",-checked=>0,-override=>'1',-onclick=>"document.forms[0].optx.value='modrow';submit();") : "&nbsp;";
                      print Tr({-class=>$style."FieldCaptionTD",-align=>"center"},
                            td({-align=>"center"},$ck),
                            td($orders{$key}),
                            td({-align=>"left"},dsccuentaanexo($orders{$key})),
                            td({-align=>"left"},$item_ref->{'memo'}),
                            td({-align=>"right"},($item_ref->{'dh'} eq '0') ? commify(sprintf("%10.2f",$debe))  : ''),
                            td({-align=>"right"},($item_ref->{'dh'} eq '1') ? commify(sprintf("%10.2f",$haber)) : '')

                      );
               }
               $tdebe_mn   += ($item_ref->{'dh'} eq '0') ? $item_ref->{'soles'} : 0;
               $thaber_mn  += ($item_ref->{'dh'} eq '1') ? $item_ref->{'soles'} : 0;
               $tdebe_me   += ($item_ref->{'dh'} eq '0') ? $item_ref->{'dolar'} / $tc_compra : 0;
               $thaber_me  += ($item_ref->{'dh'} eq '1') ? $item_ref->{'dolar'} / $tc_compra : 0;
      }
   }
}

# entrada para una fila nueva
if (param('optx') eq 'addrow') {
    print Tr({-class=>$style."FieldCaptionTD",-align=>"right"},
      td({-width=>"50"},"&nbsp;"),
      td(textfield(-name=>"cuenta",-value=>"",-size=>"6",-override=>"1",-maxlength=>"6",-onchange=>"document.forms[0].optx.value='additem';document.forms[0].submit();")),
      td({-align=>"left"},NombreCuenta(param('cuenta'))),
      td(textfield(-name=>"memo",-value=>"",-size=>"16",-override=>"1",-maxlength=>"24")),
      td(textfield(-name=>"debe",-value=>"",-size=>"10",-maxlength=>"10",-override=>"1",-onchange=>"document.forms[0].optx.value='additem';chkdebe(this);")),
      td(textfield(-name=>"haber",-value=>"",-size=>"10",-maxlength=>"10",-override=>"1",-onchange=>"document.forms[0].optx.value='additem';chkhaber(this);"))
    );
}

# Totales
print Tr({-class=>$style."FieldCaptionTD",-align=>"right"},
         td({-colspan=>"7"},table({-align=>"center",-border=>"0"},
            Tr({-align=>"right"},
            td(b("&nbsp;|&nbsp;")),
            td(b(sprintf("D: %s %15.2f",get_sessiondata('simbolo_nac'),$tdebe_mn))),
            td(b("&nbsp;|&nbsp;")),
            td(b(sprintf("H: %s %15.2f",get_sessiondata('simbolo_nac'),$thaber_mn))),
            td(b("&nbsp;|&nbsp;")),
            td(b(sprintf("D: %s %15.2f",get_sessiondata('simbolo_ext'),$tdebe_me))),
            td(b("&nbsp;|&nbsp;")),
            td(b(sprintf("H: %s %15.2f",get_sessiondata('simbolo_ext'),$thaber_me))),
            td(b("&nbsp;|&nbsp;"))))));

# Linea de Comandos
my $cuenta = param('cuenta');
my $opty   = param('opty');
my $optw   = param('optw');

if (param('opty') eq 'nc') {              # Linea de comandos -> agregar nota de credito

    print Tr({-class=>$style."FieldCaptionTD",-align=>"center"},td({-colspan=>"7"},table(Tr(td(button(-class=>$style."Button",-value=>"Aceptar",-onclick=>"document.forms[0].optx.value='insertcomp';document.forms[0].opty.value='$opty';document.forms[0].cuenta.value='$cuenta';document.forms[0].target='cpagar';submit();window.close();")),td(button(-class=>$style."Button",-value=>"Cancelar",-onclick=>"document.forms[0].optx.value='cancelar';submit();window.close();")) ))));

} elsif (param('opty') eq 'dopay') {      # Linea de comandos -> generar pago o generar cobranza

    # $optw es la variable que contiene la ventana de regreso (cpagar|cobrar)
   # print Tr({-class=>$style."FieldCaptionTD",-align=>"center"},td({-colspan=>"7"},table(Tr(td(button(-class=>$style."Button",-value=>"Aceptar",-onclick=>"document.forms[0].optx.value='insertcomp';document.forms[0].target='$optw';document.forms[0].opty.value='$opty';document.forms[0].cuenta.value='$cuenta';submit();window.close();")),td(checkbox(-name=>"pflag",-value=>"",-label=>"Con impresion de comprobante",-checked=>0)),td(button(-class=>$style."Button",-value=>"Cancelar",-onclick=>"document.forms[0].optx.value='cancelar';submit();window.close();")) ))));
    
my $editlink = "?opt=addcomp&optx=vistaprevia&target=$optw&opty=$opty&cuenta=$cuenta";
    #print Tr({-class=>$style."FieldCaptionTD",-align=>"center"},td({-colspan=>"7"},table(Tr(td(button(-class=>$style."Button",-value=>"Aceptar",-onclick=>"document.forms[0].optx.value='insertcomp';document.forms[0].target='$optw';document.forms[0].opty.value='$opty';document.forms[0].cuenta.value='$cuenta';submit();")),td(checkbox(-name=>"pflag",-value=>"",-label=>"Con impresion de comprobante",-checked=>0)),td(button(-class=>$style."Button",-value=>"Cancelar",-onclick=>"document.forms[0].optx.value='cancelar';submit();window.close();")) ))));
     print Tr({-class=>$style."FieldCaptionTD",-align=>"center"},td({-colspan=>"7"},table(Tr(td(button(-class=>$style."Button",-value=>"Aceptar",-onclick=>"document.forms[0].optx.value='insertcomp';document.forms[0].target='$optw';document.forms[0].opty.value='$opty';document.forms[0].cuenta.value='$cuenta';submit();")),td(button(-class=>$style."Button",-value=>"Vista Previa",-onclick=>"document.forms[0].optx.value='vistaprevia';document.forms[0].target='$optw';document.forms[0].opty.value='$opty';document.forms[0].cuenta.value='$cuenta';submit();")),td(button(-class=>$style."Button",-value=>"Cancelar",-onclick=>"document.forms[0].optx.value='cancelar';submit();window.close();")) ))));
   #  print Tr({-class=>$style."FieldCaptionTD",-align=>"center"},td({-colspan=>"7"},table(Tr(td(button(-class=>$style."Button",-value=>"Aceptar",-onclick=>"document.forms[0].optx.value='insertcomp';document.forms[0].target='$optw';document.forms[0].opty.value='$opty';document.forms[0].cuenta.value='$cuenta';submit();")),td(button(-class=>$style."Button",-value=>"Vista Previa",-onclick=>"window.open('document.forms[0].optx.value='vistaprevia';','vista','scrollbars=yes,resizable=yes,width=250,height=100');document.forms[0].target='$optw';document.forms[0].opty.value='$opty';document.forms[0].cuenta.value='$cuenta';submit();return false;")),td(button(-class=>$style."Button",-value=>"Cancelar",-onclick=>"document.forms[0].optx.value='cancelar';submit();window.close();")) ))));

} else {                                  # Linea de comandos -> Agregar comprobantes

    print Tr({-class=>$style."FieldCaptionTD",-align=>"center"},td({-colspan=>"7"},table(Tr(td(button(-class=>$style."Button",-value=>"Aceptar",-onclick=>"document.forms[0].target='inferior',document.forms[0].optx.value='insertcomp';submit();window.close();")),td(button(-class=>$style."Button",-value=>"Cancelar",-onclick=>"document.forms[0].optx.value='cancelar';submit();window.close();")) ))));

}

print "</table>";

print "</td></tr></table>";

print hidden(-name=>"opt",-value=>"addcomp",-override=>1);

print hidden(-name=>"optx",-value=>"",-override=>1);
print hidden(-name=>"opty",-value=>"$opty",-override=>1); # (dopay | nc)
print hidden(-name=>"optw",-value=>"$optw",-override=>1); # (cpagar|cobrar)
print hidden(-name=>"cuenta",-value=>"$cuenta",-override=>1);

# -- parametros para refrescar el despliegue del diario
print hidden(-name=>"periodo",-value=>"$periodo",-override=>1);
print hidden(-name=>"dia",-value=>"$dia",-override=>1);
print hidden(-name=>"offset",-value=>"$offset",-override=>1);
print hidden(-name=>"param1",-value=>"$param1",-override=>1);
# -- parametros para refrescar el despliegue del diario

print end_form();

}

#ElleLawlietElleLawlietElleLawlietElleLawlietElleLawlietElleLawlietElleLawlietElleLawlietElleLawliet
#RICHIE
sub AgregarNotaCredito {
my @checknum = param('checknum');
my $style = get_sessiondata('cssname');
print start_form(-name=>"agregar_nc",-target=>"");
my $centinela=0;
if (param('optx') eq 'insertnotacredito') {
    my $uid  = $$."-".$ENV{'REMOTE_ADDR'}."-".time();
    my $ldiario     = param('ldiario');
    my $fecha_conta = param('fecha_conta');
    my $glosa       = param('glosa');
    my $tc_compra   = param('tc_compra');
    my $tipodoc     = param('tipodoc');
    my $tipodocid       = param('dociddd');
    my $docid       = param('documento');
    my $moneda      = param('moneda');
    my $estado      = 0;
    my $ruc         = param('ruc');
    my $referencia  = param('referencia');
    my $percepcion  = '0';
    my $detraccion  = '0';
    my $usuario     = get_sessiondata('user');

    my $sql="INSERT INTO cc_diariocab (uid,diario,tc_compra,tipodoc,tipodocid,docid,ruc,glosa,estado,fecha_conta,moneda,referencia,usuario,percepcion,detraccion) VALUES('".$uid."','".$ldiario."','".$tc_compra."','".$tipodoc."','".$tipodocid."','".$docid."','".$ruc."','".$glosa."','".$estado."','".$fecha_conta."','0','".$referencia."','".$usuario."','".$percepcion."','".$detraccion."')";
    my $dbh_mio = connectdb();
    $dbh_mio->do($sql);
    my ($secuencial) = $dbh_mio->selectrow_array("SELECT secuencial FROM cc_diariocab WHERE uid='$uid'");
    if ($secuencial>0) {
#ElleLawlietElleLawlietElleLawlietElleLawlietElleLawlietElleLawlietElleLawlietElleLawlietElleLawlietElleLawlietElleLawliet
if (param('moneda') eq '0') {
$sql="INSERT INTO cc_diariodet(secuencial,cuenta,memo,dh,soles) VALUES ('".$secuencial."','121000','".param('memo1')."','1','".param('debe1')."')";
$dbh_mio->do($sql);
$sql="INSERT INTO cc_diariodet(secuencial,cuenta,memo,dh,soles) VALUES ('".$secuencial."','401100','".param('memo2')."','0','".param('haber2')."')";
$dbh_mio->do($sql);
$sql="INSERT INTO cc_diariodet(secuencial,cuenta,memo,dh,soles) VALUES ('".$secuencial."','741000','".param('memo3')."','0','".param('haber3')."')";
$dbh_mio->do($sql);
} else {
$sql="INSERT INTO cc_diariodet(secuencial,cuenta,memo,dh,dolar) VALUES ('".$secuencial."','121000','".param('memo1')."','1','".param('debe1')."')";
$dbh_mio->do($sql);
$sql="INSERT INTO cc_diariodet(secuencial,cuenta,memo,dh,dolar) VALUES ('".$secuencial."','401100','".param('memo2')."','0','".param('haber2')."')";
$dbh_mio->do($sql);
$sql="INSERT INTO cc_diariodet(secuencial,cuenta,memo,dh,dolar) VALUES ('".$secuencial."','741000','".param('memo3')."','0','".param('haber3')."')";
$dbh_mio->do($sql);
}
print "<h1>Nota de Credito Guardada con exito.</h1>\n";
$centinela=1;
#ElleLawlietElleLawlietElleLawlietElleLawlietElleLawlietElleLawlietElleLawlietElleLawlietElleLawlietElleLawlietElleLawliet
       }
    }

if (param('optx') eq 'cancelar') {   
    limpiar_dart();
}
#
# Crea un comprobante en variables de session
#

# -- parametros para refrescar el despliegue del diario
my $ldiario = param('ldiario');
my $periodo = param('periodo');
my $dia     = param('dia');
                                                                                                                            
my $offset  = param('offset');
my $param1  = param('param1');
# -- parametros para refrescar el despliegue del diario

print <<EOF;
<script language="JavaScript" type="text/javascript">
function chkdebe(field) {   
         rx = /[^0-9.]/;
         if (rx.test(field.value)) {
            alert("Este campo acepta solamente numeros.");
            field.select();
            field.focus();
         } else {
            document.forms[0].haber.value='';document.forms[0].submit();
         }
}

function chkhaber(field) {   
         rx = /[^0-9.]/;
         if (rx.test(field.value)) {
            alert("Este campo acepta solamente numeros.");
            field.select();
            field.focus();
         } else {
            document.forms[0].debe.value='';document.forms[0].submit();
         }
}
</script>
EOF

# Visualiza la Cabecera de Comprobante
my %options       = ("0" => "Nuevos Soles", "1" => "Dolares Americanos");
my %estadooptions  = ("0" => "Activo", "1" => "Anulado", "2" => "Proceso");
my $style= get_sessiondata('cssname');

my ($diario,$tc_compra,$tipodoc,$docidd,$ruc,$glosa,$estado,$fecha_conta,$moneda,$referencia,$usuario,$percepcion,$detraccion,$igv);
my $miestado='';
#my $dbh_richie = connectdb();  
#my $debe=$dbh_richie->selectrow_array("SELECT sum(soles) FROM cc_diariodet WHERE cuenta='121001' AND dh=0 AND secuencial='".param('secuencial')."'");
#print "SELECT sum(soles) FROM cc_diariodet WHERE cuenta='121001' AND dh=0 AND secuencial='".get_sessiondata('secuencial')."'";
if (param('optx') eq 'clonar') {   

    my $dbh = connectdb();
   ($ldiario,$tc_compra,$tipodoc,$docidd,$ruc,$glosa,$estado,$fecha_conta,$moneda,$referencia,$usuario,$percepcion,$detraccion) = $dbh->selectrow_array("SELECT diario,tc_compra,tipodoc,docid,ruc,glosa,estado,fecha_conta,moneda,referencia,usuario,percepcion,detraccion FROM cc_diariocab WHERE secuencial='".param('secuencial')."'");
    
   $glosa  = (defined(param('glosa')))   ? "NOTA DE CREDITO"  : $glosa;
   $estado = (defined(param('estado')))  ? param('estado')    : $estado;

} else {

   $tc_compra   = get_sessiondata('tc_compra');
   $fecha_conta = substr(HKZ33::getDate(),0,10);

   $moneda  = (!defined(param('moneda'))) ? '0' : param('moneda');
   $glosa   = "NOTA DE CREDITO";
   $estado  = (!defined(param('estado'))) ? '0' : param('estado');
   $tipodoc = (!defined(param('tipodoc'))) ? '' : param('tipodoc');
   $docidd   = (!defined(param('docid')))  ? ''  : param('docid');
   $referencia = (!defined(param('referencia')))  ? ''  : param('referencia');
   $ruc = (!defined(param('ruc')))  ? ''  : param('ruc');
   $igv = (!defined(param('igv')))  ? ''  : param('igv');
    if ($estado==0) {$miestado='Activo';}
    if ($estado==1) {$miestado='Anulado';}
    if ($estado==2) {$miestado='Proceso';}
	
}

if ($centinela==0) 
{
#ElleLawlietElleLawlietElleLawlietElleLawlietElleLawliet
print  "<script language='javascript' type='text/javascript'>\n";
print  "function validar(tope) {\n";
print  "    tope=parseFloat(tope);\n";
print  "    var valido=parseFloat(document.agregar_nc.debe1.value);\n";
print  "    if (tope<valido) {\n";
print  "    document.agregar_nc.debe1.value=0;\n";
print  "    document.agregar_nc.haber2.value=0;\n";
print  "    document.agregar_nc.haber3.value=0;\n";
print  '    alert("Este monto no es valido");';
print  "    } else {\n";
print  "    var igv=(valido*19/119);\n";
print  "    igv=Math.round(igv*10000)/10000;\n";
print  "    var descu=valido-igv;\n";
print  "    document.agregar_nc.haber2.value=igv;\n";
print  "    document.agregar_nc.haber2.disabled=false;\n";
print  "    document.agregar_nc.haber3.value=descu;\n";
print  "    document.agregar_nc.haber3.disabled=false;\n";
print  "    }";
print  "} </script>";
#ElleLawlietElleLawlietElleLawlietElleLawlietElleLawliet
print "<table border=0 align=center><tr><td>"; # Tabla externa
print "<br><table border=0 width=100% cellpadding=2 cellspacing=2 class=".$style."FormTABLE>";
print Tr(td({-colspan=>"2",-class=>$style."ttitem",-align=>"center"},b("<font color=green>Nueva nota de credito</font>")));
print Tr({-class=>$style."FieldCaptionTD"},td(table(Tr(td(b("Diario")),td("<select name='ldiario' size='1' class='CarlingSelect'><option value='6' selected>VENTAS CON FACTURA</option></select>"),td(b("Fecha")),td(textfield(-name=>"fecha_conta",-value=>"$fecha_conta",-size=>"10",-maxlength=>"10",-override=>"1")),td(b("Tipo de Cambio")),td(textfield(-name=>"tc_compra",-value=>"$tc_compra",-size=>"6",-maxlength=>"6",-override=>"1")),td(b("Moneda")),td(scrolling_list(-name =>"moneda",-values=>["0","1"],-labels=>\%options,-size =>1,-multiple=>0,-default=>["$moneda"],-onchange=>"submit();"))    ))));
print Tr({-class=>$style."FieldCaptionTD"},td(table(Tr(td(b("Documento fuente")),td("Factura"),td(b("N&uacute;mero")),td("$docidd"),td(b("Estado")),td("$miestado"),td(b("Usuario:&nbsp;")),td(get_sessiondata('user')))) ));
print Tr({-class=>$style."FieldCaptionTD"},td(table(Tr(td(b("Documento")),td("<select name='tipodoc' size='1' class='CarlingSelect'><option value='07' selected>Nota de Credito</option></select>"),td(b("N&uacute;mero de nota de credito")),td("<input type='text' name='documento' size='12' maxlength='12'/>") )) ));
print Tr({-class=>$style."FieldCaptionTD"},td(table(Tr(td(b("Detalle")),td(textfield(-name=>"glosa",-value=>"$glosa",-size=>"45",-maxlength=>"128",-override=>"1")),td(b("Cheque/Ref.")),td(textfield(-name=>"referencia",-value=>$referencia,-size=>"11",-maxlength=>"11",-override=>"1")) ))));
print "</table>";

# Detalle del Comprobante
print "<table width=100% border=0 cellpadding=2 cellspacing=2 align=center class=".$style."FormTABLE>";

# Cabecera y simbolo para agregar registro
print Tr({-class=>$style."FormHeaderFont",-align=>"center"},td({width=>"50"},b("Cuenta")),td(b("Nombre")),td({-width=>"120"},b("Memo")),td({-width=>"100"},b("Debe")),td({-width=>"100"},b("Haber")) );

my ($tdebe_mn,$thaber_mn,$tdebe_me,$thaber_me);

#my $moneda = (!defined(param('moneda'))) ? 0 : param('moneda');

# -- Despliega el contenido de session --
my %orders;
my $item_id;
my ($debe,$haber);
if (defined (cookie('contab'))) {      # check new session and & retrieve $sess_ref
   my $dbh = connectdb();
   if (my $sess_ref = opensession()) {
      my $cart_ref = $sess_ref->attr("dart");
      foreach $item_id (keys(%{$cart_ref})) {
              my $item_ref = $cart_ref->{$item_id};
              $orders{$item_ref->{"item"}} = $item_id;
      }
      foreach my $key (sort keys(%orders)) {
               my $item_ref = $cart_ref->{$orders{$key}};
               my $soles =  $item_ref->{'soles'};
               my $dolar =  $item_ref->{'dolar'};
               if ($moneda eq '0') {
                  $debe  = ($item_ref->{'dh'} eq '0') ? $soles : '';
                  $haber = ($item_ref->{'dh'} eq '1') ? $soles : '';
               } else {
                  $debe  = ($item_ref->{'dh'} eq '0') ? $dolar : '';
                  $haber = ($item_ref->{'dh'} eq '1') ? $dolar : '';
               }
               #print "DEBE HABER ".$debe." -> ".$haber." <br>";
        }
#ElleLawlietElleLawlietElleLawlietElleLawlietElleLawlietElleLawlietElleLawlietElleLawlietElleLawliet
      print Tr({-class=>$style."FieldCaptionTD",-align=>"center"},
     # td("121001"),
     # td({-align=>"left"},NombreCuenta("121001")),
      td("121000"),
      td({-align=>"left"},NombreCuenta("121000")),
      td(textfield(-name=>"memo1",-size=>"16",-override=>"1",-maxlength=>"24")),
      td("$debe"),
      td(textfield(-name=>"debe1",-size=>"10",-maxlength=>"10",-override=>"1",-onchange=>"validar($debe);"))
      );
      print Tr({-class=>$style."FieldCaptionTD",-align=>"center"},
      #td("401001"),
      #td({-align=>"left"},NombreCuenta("401001")),
      td("401100"),
      td({-align=>"left"},NombreCuenta("401100")),
      td(textfield(-name=>"memo2",-size=>"16",-override=>"1",-maxlength=>"24")),
      td(textfield(-name=>"haber2",-size=>"10",-maxlength=>"10",-override=>"1",-readonly => 'readonly')),
      td("")
      );
      print Tr({-class=>$style."FieldCaptionTD",-align=>"center"},
    #  td("741001"),
     # td({-align=>"left"},NombreCuenta("741001")),
      td("741000"),
      td({-align=>"left"},NombreCuenta("741000")),
      td(textfield(-name=>"memo3",-size=>"16",-override=>"1",-maxlength=>"24")),
      td(textfield(-name=>"haber3",-size=>"10",-maxlength=>"10",-override=>"1",-readonly => 'readonly')),
      td("")
      );
#ElleLawlietElleLawlietElleLawlietElleLawlietElleLawlietElleLawlietElleLawlietElleLawlietElleLawliet
   }
}

# Totales
print Tr({-class=>$style."FieldCaptionTD",-align=>"right"},
         td({-colspan=>"7"},table({-align=>"center",-border=>"0"},
            Tr({-align=>"right"},
            td(b("&nbsp;|&nbsp;")),
            td(b(sprintf("D: %s %15.2f",get_sessiondata('simbolo_nac'),$tdebe_mn))),
            td(b("&nbsp;|&nbsp;")),
            td(b(sprintf("H: %s %15.2f",get_sessiondata('simbolo_nac'),$thaber_mn))),
            td(b("&nbsp;|&nbsp;")),
            td(b(sprintf("D: %s %15.2f",get_sessiondata('simbolo_ext'),$tdebe_me))),
            td(b("&nbsp;|&nbsp;")),
            td(b(sprintf("H: %s %15.2f",get_sessiondata('simbolo_ext'),$thaber_me))),
            td(b("&nbsp;|&nbsp;"))))));

# Linea de Comandos
my $cuenta = param('cuenta');
my $opty   = param('opty');
my $optw   = param('optw');

print Tr({-class=>$style."FieldCaptionTD",-align=>"center"},td({-colspan=>"7"},table(Tr(td(button(-class=>$style."Button",-value=>"Aceptar",-onclick=>"document.forms[0].optx.value='insertnotacredito';submit();")),td(button(-class=>$style."Button",-value=>"Cancelar",-onclick=>"document.forms[0].optx.value='cancelar';submit();window.close();")) ))));

print "</table>";

print "</td></tr></table>";
print hidden(-name=>"dociddd",-value=>"$docidd",-override=>1);
#print hidden(-name=>"debe1",-value=>"$debe",-override=>1);
print hidden(-name=>"opt",-value=>"addnotacredito",-override=>1);

print hidden(-name=>"optx",-value=>"",-override=>1);
print hidden(-name=>"opty",-value=>"$opty",-override=>1); # (dopay | nc)
print hidden(-name=>"optw",-value=>"$optw",-override=>1); # (cpagar|cobrar)
print hidden(-name=>"cuenta",-value=>"$cuenta",-override=>1);

# -- parametros para refrescar el despliegue del diario
print hidden(-name=>"periodo",-value=>"$periodo",-override=>1);
print hidden(-name=>"dia",-value=>"$dia",-override=>1);
print hidden(-name=>"offset",-value=>"$offset",-override=>1);
print hidden(-name=>"param1",-value=>"$param1",-override=>1);
# -- parametros para refrescar el despliegue del diario

print end_form();
}
}
#ElleLawlietElleLawlietElleLawlietElleLawlietElleLawlietElleLawlietElleLawlietElleLawlietElleLawliet
# ----------------------------------------------------------------------
sub limpiar_dart {
# ----------------------------------------------------------------------
    if (defined (cookie('contab'))) {
        my $dbh = connectdb();
        if (my $sess_ref = opensession()) {
            my $item_id;
            my $cart_ref = $sess_ref->attr("dart");
            # Eliminar variables de sesion
            foreach $item_id (keys(%{$cart_ref})) {
                     delete($cart_ref->{$item_id});
            }
            $sess_ref->attr("dart", $cart_ref);
            $sess_ref->close();
         }
     }
}
                                                                                                                            
# ----------------------------------------------------------------------
sub VerComprobante {
# ----------------------------------------------------------------------
#my @names = param;
#foreach (@names) { print $_ , " = ",param($_), "<br>"; }

my ($ref,$sth,$dbh);
$dbh = connectdb();

my $style = get_sessiondata('cssname');

# Operaciones en document.forms[0]

if (param('optx') eq 'print') {
    # Imprime el asiento (param('secuencial'))
    # chown comprobante_diario.pl (debe ser apache:apache)
    my $output = get_sessiondata('scriptdir')."comprobante_diario.pl ". param('secuencial') . " " .  get_sessiondata('pq_contab');
    #print $output,"<br>";
    `$output`;
}

if (param('optx') eq 'clonar') {
    # Despeja el arreglo
    limpiar_dart();

    # Copia de la cabecera del asiento (param('secuencial'))
    my ($tc_compra,$moneda) = $dbh->selectrow_array("SELECT tc_compra,moneda FROM cc_diariocab WHERE secuencial='".param('secuencial')."'");

    # Copia el detalle del asiento (param('secuencial'))
    $sth = $dbh->prepare("SELECT interno,cuenta,memo,dh,soles,dolar FROM cc_diariodet WHERE secuencial='".param('secuencial')."'");
    $sth->execute();
    while ($ref = $sth->fetchrow_hashref()) {
           my $valor = ($moneda eq '0') ? $ref->{'soles'} : $ref->{'dolar'};
           additem($moneda,$tc_compra,$ref->{'cuenta'},$ref->{'memo'},$ref->{'dh'},$valor,'dart',$ref->{'interno'});
    }
    print redirect("?opt=addcomp&optx=clonar&secuencial=".param('secuencial'));

    return;
}

print start_form();

if (param('optx') eq 'save') {

    my $secuencial  = param('secuencial');
    my $diario      = param('ldiario');
    my $fecha_conta = param('fecha_conta');
    my $glosa       = param('glosa');
    my $tc_compra   = param('tc_compra');
    my $tipodoc     = param('tipodoc');
    my $docid       = param('docid');
    my $moneda      = param('moneda');
    my $estado      = param('estado');
    my $referencia  = param('referencia');
    my $consolida   = param('consolida');
    my $ruc         = param('ruc');
    my $percepcion  = param('percepcion');
    my $detraccion  = param('detraccion');
    my $usuario     = (!defined(param('usuario'))) ? get_sessiondata('user') : param('usuario');

    # Reemplaza cabecera
    $dbh->do("REPLACE cc_diariocab(secuencial,diario,fecha_conta,glosa,tc_compra,tipodoc,docid,ruc,estado,moneda,consolida,referencia,usuario,percepcion,detraccion) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",undef,$secuencial,$diario,$fecha_conta,$glosa,$tc_compra,$tipodoc,$docid,$ruc,$estado,$moneda,$consolida,$referencia,$usuario,$percepcion,$detraccion) or (my $err=$DBI::errstr);
    print $err,"<br>" if ($err);

   # 2. Falta Verificar que el comprobante cuadra

   # 3. Reemplaza detalle marcado
   my (@soles,@dolar,@dh,@valor);

   my @cuenta     = param('cuenta');
   my @memo       = param('memo');
   my @interno    = param('checknum');
   my @debe       = param('debe');
   my @haber      = param('haber');

   my $count      = 0;
   foreach my $k (@interno) {
           $dh[$count]    = ($debe[$count] ne '') ? '0' : '1';
           $valor[$count] = ($debe[$count] ne '') ? $debe[$count] : $haber[$count];
           if ($moneda eq '0') {
              $soles[$count] = $valor[$count];
              $dolar[$count] = ($tc_compra > 0) ? $valor[$count] / $tc_compra : 0;
           } else {
              $soles[$count] = $valor[$count] * $tc_compra;
              $dolar[$count] = $valor[$count];
           }
           $dbh->do("REPLACE cc_diariodet(secuencial,interno,cuenta,memo,dh,soles,dolar) VALUES (?,?,?,?,?,?,?)",undef,$secuencial,$k,$cuenta[$count],$memo[$count],$dh[$count],$soles[$count],$dolar[$count]) or (my $err=$DBI::errstr);
           print $err,"<br>" if ($err);

           #print "secuencial=",$secuencial,"interno=",$k,"cuenta=",$cuenta[$count],"dh=",$dh[$count],"soles=",$soles[$count],"dolar=",$dolar[$count],"<br>";

           $count++;
   }


   #if (param('opty') eq 'cpagar') {
   #     print redirect("?opt=opevarias&optx=cpagar&opty=cuenta&cuenta=".param('cuenta_ret'));
   #} elsif (param('opty') eq 'resumen_pagos') {
   #     print redirect("?opt=opevarias&optx=cpagar&opty=resumen_pagos");
   #}
   
   #if (param('call') eq 'ac') {
   #     print redirect("?opt=analisis&optx=vpcuenta&cuenta=".param('cuenta_ret')."&fecha_desde=".param('fecha_desde')."&fecha_hasta=".param('fecha_hasta')."&rango=".param('rango')."&orden=".param('orden'));
   #}

} # end save

if (param('optx') eq 'delete') {
   my @checknum = param('checknum');
   foreach my $k (@checknum) {
           $dbh->do("DELETE FROM cc_diariodet WHERE secuencial='".param('secuencial')."' AND interno='$k'");
   }
}
                                                                                                                            
if (param('optx') eq 'insert') {
   my $tc_compra = param('tc_compra');
   my $cuenta    = param('cuenta');
   my $memo      = param('memo');
   my ($soles,$dolar);
   my $dhx     = (param('debe') ne '') ? '0' : '1'; 
   my $valor   = (param('debe') ne '') ? param('debe') : param('haber');
   if (param('moneda') eq '0') {
       $soles = $valor;
       $dolar = ($tc_compra > 0) ? $valor / $tc_compra : 0;
   } else {
       $soles = $valor * $tc_compra;
       $dolar = $valor;
   }
   $dbh->do("INSERT INTO cc_diariodet(secuencial,cuenta,memo,dh,soles,dolar) VALUES ('".param('secuencial')."','$cuenta','$memo',$dhx,$soles,$dolar)") or (my $err=$DBI::errstr);
   print $err,"<br>" if ($err);
}

#
# Despliega el comprobante
#
 
print <<EOF;
<script language="JavaScript" type="text/javascript">
function chkdebe(field) {
        rx = /[^0-9.-]/;
        if (rx.test(field.value)) {
           alert("Este campo debe ser numerico.");
           field.select();
           field.focus();
        } else {
           document.forms[0].haber.value='';
           document.forms[0].optx.value='save';
           document.forms[0].submit();
        }
}
function chkhaber(field) {
        rx = /[^0-9.-]/;
        if (rx.test(field.value)) {
           alert("Este campo debe ser numerico.");
           field.select();
           field.focus();
        } else {
           document.forms[0].debe.value='';
           document.forms[0].optx.value='save';
           document.forms[0].submit();
        }
}
</script>
EOF

my $secuencial = param('secuencial');

# Lee la cabecera de cc_diariocab;
my ($diario,$fecha_conta,$glosa,$tc_compra,$tipodoc,$docid,$estado,$ruc,$moneda,$usuario,$referencia,$consolida,$percepcion,$detraccion) = $dbh->selectrow_array("SELECT diario,fecha_conta,glosa,tc_compra,tipodoc,docid,estado,ruc,moneda,usuario,referencia,consolida,percepcion,detraccion FROM cc_diariocab WHERE secuencial='$secuencial'") or (my $err=$DBI::errstr);
print $err,"<br>" if ($err);

my %options        = ("0" => "Nuevos Soles", "1" => "Dolares Americanos");
my %estadooptions  = ("0" => "Activo", "1" => "Anulado","2" => "Proceso");

my $moneda         = defined(param('moneda')) ? param('moneda') : $moneda;

# Despliega la cabecera del comprobante
print "<br><table align=center border=0><tr><td>";
print "<table width=100% border=0 cellpadding=2 cellspacing=2 class=".$style."FormTABLE>";

print Tr(td({-colspan=>"2",-align=>"center",-class=>$style."FormHeaderFont"},b("Comprobante de Diario # $secuencial")));

if (param('opty') eq 'edit') {   # Comprobante edit mode

    print Tr({-class=>$style."FieldCaptionTD"},td(table(Tr(td(b("Diario")),td(DiarioScroll($diario)),td(b("Fecha")),td(textfield(-name=>"fecha_conta",-value=>substr($fecha_conta,0,10),-size=>"10",-maxlength=>"10",override=>"1")),td(b("Tipo de Cambio")),td(textfield(-name=>"tc_compra",-value=>$tc_compra,-size=>"6",-maxlength=>"6",override=>"1")),td(b("Moneda")),td(scrolling_list(-name =>"moneda",-values=>["0","1"],-labels=>\%options,-size =>1,,override=>"1",-multiple=>0,-default=>[$moneda],-onchange=>"document.forms[0].opty.value='edit';document.forms[0].submit();"))   ))));

    print Tr({-class=>$style."FieldCaptionTD"},td(table(Tr(td(b("Documento")),td(DocumentScroll($tipodoc)),td(b("N&uacute;mero")),td(textfield(-name=>"docid",-value=>$docid,-size=>"12",-maxlength=>"12",override=>"1")),td(b("Estado")),td(scrolling_list(-name =>"estado",-values=>["0","1","2"],-labels=>\%estadooptions,-size =>1,,override=>"1",-multiple=>0,-default=>["$estado"],-onchange=>"")),td(b("Usuario&nbsp")),td(textfield(-name=>"usuario",-value=>$usuario,-class=>$style."NoInput",-size=>"11",-maxlength=>"11",override=>"1",-OnFocus=>"")) ))));

    print Tr({-class=>$style."FieldCaptionTD"},td(table(Tr(td(b("Detalle")),td(textfield(-name=>"glosa",-value=>"$glosa",-size=>"45",-maxlength=>"128",override=>"1")),td(b("Cheque/Ref.")),td(textfield(-name=>"referencia",-value=>$referencia,-size=>"11",-maxlength=>"11",override=>"1")), td(b("Consolidado")),td(textfield(-name=>"consolida",-value=>$consolida,-size=>"6",-maxlength=>"6",,override=>"1",-onclick=>"")) ))));

} else {                          # Comprobante view mode

    print Tr({-class=>$style."FieldCaptionTD"},td(table(Tr(td(b("Diario:&nbsp;")),td({-width=>"150"},$dbh->selectrow_array("SELECT nombre FROM cc_diarios WHERE diario='$diario'")),td(b("Fecha:&nbsp;")),td({-width=>"100"},substr($fecha_conta,0,10)),td(b("Tipo de Cambio:&nbsp;")),td({-width=>"50"},$tc_compra),td(b("Moneda:&nbsp;")),td($options{$moneda}) ))));

    print Tr({-class=>$style."FieldCaptionTD"},td(table(Tr(td(b("Documento:&nbsp;")),td({-width=>"200"},$dbh->selectrow_array("SELECT descripcion FROM cc_tipodoc WHERE tipodoc='$tipodoc'")),td(b("N&uacute;mero:&nbsp;")),td({-width=>"100"},$docid),td(b("Estado:&nbsp;")),td({-width=>"50"},$estadooptions{$estado}),td(b("Usuario:&nbsp")),td($usuario) ))));

    print Tr({-class=>$style."FieldCaptionTD"},td(table(Tr(td(b("Detalle:&nbsp;")),td({-width=>"300"},$glosa),td(b("Cheque/Ref.:&nbsp;")),td({-width=>"50"},$referencia), td(b("Consolidado:&nbsp;")),td($consolida) ))));

}

print "</table>";

# Despliega el detalle del comprobante;
my $sql = "SELECT secuencial,interno,a.cuenta,a.memo,b.dsc,dh,soles,dolar FROM cc_diariodet a LEFT JOIN cc_cuentas b ON a.cuenta=b.cuenta WHERE secuencial='$secuencial'";
$sth = $dbh->prepare($sql);
$sth->execute();
#print $sql;

print "<table width=100% border=0 cellpadding=2 cellspacing=2 align=center class=".$style."FormTABLE>";

if (param('opty') eq 'edit') {
    print Tr({-class=>$style."FormHeaderFont",-align=>"center"},td({-width=>"50"},a({-href=>"?opt=vercomp&secuencial=$secuencial&optx=entry&periodo=".param('periodo')."&dia=".param('dia')."&call=".param('call')."&cuenta_ret=".param('cuenta_ret')."&offset=".param('offset')."&param1=".param('param1'),-target=>"_self",-title=>"Agregar"},img({-src=>"/images/increment.png",-alt=>"increment.png",-border=>"0"}))),td({width=>"50"},b("Cuenta")),td(b("Nombre")),td({-width=>"120"},b("Memo")),td({-width=>"100"},b("Debe")),td({-width=>"100"},b("Haber")) );
} else {
    print Tr({-class=>$style."FormHeaderFont",-align=>"center"},td({-width=>"50"},"&nbsp;"),td({width=>"50"},b("Cuenta")),td(b("Nombre")),td({-width=>"120"},b("Memo")),td({-width=>"100"},b("Debe")),td({-width=>"100"},b("Haber")) );
}

my ($tdebe_mn,$thaber_mn,$tdebe_me,$thaber_me);

my $k = 0;
my @checknum = param('checknum');
while ($ref = $sth->fetchrow_hashref()) {

      my ($debe,$haber);
      if ($moneda eq '0') {
          $debe  = ($ref->{'dh'} eq '0') ? $ref->{'soles'} : '';
          $haber = ($ref->{'dh'} eq '1') ? $ref->{'soles'} : '';
      } else {
          $debe  = ($ref->{'dh'} eq '0') ? $ref->{'dolar'} : '';
          $haber = ($ref->{'dh'} eq '1') ? $ref->{'dolar'} : '';
      }

      if (grep (/^$ref->{'interno'}$/,@checknum) and (param('optx') ne 'save')) {  # Linea para editar

          my $delete_button = "<button class=".$style."button type='button' name='delete_submit' value='delete' title='Eliminar' onclick=\"document.forms[0].checknum.value='$ref->{'interno'}';document.forms[0].optx.value='delete';document.forms[0].submit();\">".img({-src=>"/images/b_drop.png",-alt=>"b_drop.png",-border=>"0"}). "</button>";

          my $update_button = "<button class=".$style."button type='button' name='update_submit' value='update' title='Actualizar' onclick=\"document.forms[0].checknum.value='$ref->{'interno'}';document.forms[0].optx.value='save';document.forms[0].submit();\">".img({-src=>"/images/b_edit.png",-alt=>"b_edit.png",-border=>"0"}). "</button>";

          my $scuenta = defined(param('cuenta')) ? param('cuenta') : $ref->{'cuenta'};
         
          print Tr({-class=>$style."FieldCaptionTD",-align=>"right"},
                    td({-align=>"center"},table(Tr(td($delete_button),td($update_button) ))),
                    td(textfield(-name=>"cuenta",-value=>"$scuenta",-size=>"6",-maxlength=>"6",-override=>"1",-onchange=>"document.forms[0].checknum.value='$ref->{'interno'}';document.forms[0].optx.value='edit';document.forms[0].opty.value='edit';submit();")),
                    td({-align=>"left"},dsccuentaanexo($scuenta)),
                    td(textfield(-name=>"memo",-value=>"$ref->{'memo'}",-override=>"1",-size=>"16",-maxlength=>"24",-onchange=>"document.forms[0].optx.value='save';document.forms[0].submit();")),
                    td(textfield(-name=>"debe",-value=>"$debe",-size=>"10",-override=>"1",-maxlength=>"10",-onchange=>"chkdebe(this);")),
                    td(textfield(-name=>"haber",-value=>"$haber",-size=>"10",-override=>"1",-maxlength=>"10",-onchange=>"chkhaber(this);"))
                    );
          print hidden(-name=>"checknum",-value=>"$ref->{'interno'}",-override=>1);
      } else {                                    # Linea para marcar
             my $ck = (param('opty') eq 'edit')  ? 
                      checkbox(-name=>"checknum",-value=>$ref->{'interno'},-label =>"",-checked=>0,-override=>'1',-onclick=>"document.forms[0].opty.value='edit';submit();") : "&nbsp";
             print Tr({-class=>$style."FieldCaptionTD",-align=>"right"},
                      td({-align=>"center"},$ck),
                      td({-align=>"center"},$ref->{'cuenta'}),
                      td({-align=>"left"},dsccuentaanexo($ref->{'cuenta'})),
                      td({-align=>"left"},$ref->{'memo'}),
                      td(($ref->{'dh'} eq '0') ? commify($debe) : ''),
                      td(($ref->{'dh'} eq '1') ? commify($haber) : '')
                      );
      }

      $tdebe_mn   += ($ref->{'dh'} eq '0') ? $ref->{'soles'} : 0;
      $thaber_mn  += ($ref->{'dh'} eq '1') ? $ref->{'soles'} : 0;
      $tdebe_me   += ($ref->{'dh'} eq '0') ? $ref->{'dolar'} : 0;
      $thaber_me  += ($ref->{'dh'} eq '1') ? $ref->{'dolar'} : 0;
}

# Nueva linea de entrada
if (param('optx') eq 'entry') {
    print Tr({-class=>$style."FieldCaptionTD",-align=>"right"},
          td("&nbsp;"),
          td(textfield(-name=>"cuenta",-value=>"",-size=>"6",-maxlength=>"6",-override=>"0",-onchange=>"document.forms[0].optx.value='entry';submit()")),
          td({-align=>"left"},NombreCuenta(param('cuenta'))),
          td(textfield(-name=>"memo",-value=>"",-size=>"16",-maxlength=>"24",-override=>"1")),
          td(textfield(-name=>"debe",-value=>"",-size=>"10",-maxlength=>"10",-override=>"1",-onchange=>"document.forms[0].haber.value='';document.forms[0].optx.value='insert';submit();")),
          td(textfield(-name=>"haber",-value=>"",-size=>"10",-maxlength=>"10",-override=>"1",-onchange=>"document.forms[0].debe.value='';document.forms[0].optx.value='insert';submit();"))
          );
}

# Linea de totales
print Tr({-class=>$style."FieldCaptionTD",-align=>"right"},
         td({-colspan=>"7"},table({-align=>"center",-border=>"0"},
            Tr({-align=>"right"},
            td(b("&nbsp;|&nbsp;")),
            td(b(sprintf("D: %s %15.2f",get_sessiondata('simbolo_nac'),$tdebe_mn))),
            td(b("&nbsp;|&nbsp;")),
            td(b(sprintf("H: %s %15.2f",get_sessiondata('simbolo_nac'),$thaber_mn))),
            td(b("&nbsp;|&nbsp;")),
            td(b(sprintf("D: %s %15.2f",get_sessiondata('simbolo_ext'),$tdebe_me))),
            td(b("&nbsp;|&nbsp;")),
            td(b(sprintf("H: %s %15.2f",get_sessiondata('simbolo_ext'),$thaber_me))),
            td(b("&nbsp;|&nbsp;"))
         ))));

my $optz = param('optz');
print hidden(-name=>"opt",-value=>"vercomp",-override=>1);
print hidden(-name=>"optx",-value=>"",-override=>1);
print hidden(-name=>"opty",-value=>"",-override=>1);
print hidden(-name=>"optz",-value=>"$optz",-override=>1);
print hidden(-name=>"moneda",-value=>"$moneda",-override=>1);
print hidden(-name=>"tc_compra",-value=>"$tc_compra",-override=>1);
print hidden(-name=>"percepcion",-value=>"$percepcion",-override=>1);
print hidden(-name=>"detraccion",-value=>"$detraccion",-override=>1);
print hidden(-name=>"ruc",-value=>"$ruc",-override=>1);
                                                                                                                            
print hidden(-name=>"secuencial",-value=>$secuencial,-override=>1);
#print hidden(-name=>"moneda",-value=>"",-override=>1);

#print hidden(-name=>"consolida",-value=>"$consolida",-override=>1);

my $offset  = param('offset');
my $param1  = param('param1');

my $ldiario = param('ldiario');
my $periodo = param('periodo');
my $dia     = param('dia');

# Para refrescar el despliegue del diario
print hidden(-name=>"ldiario",-value=>"$ldiario",-override=>1);
print hidden(-name=>"periodo",-value=>"$periodo",-override=>1);
print hidden(-name=>"dia",-value=>"$dia",-override=>1);

print hidden(-name=>"offset",-value=>"$offset",-override=>1);
print hidden(-name=>"param1",-value=>"$param1",-override=>1);
# Para refrescar el despliegue del diario

my $searchx = param('searchx');
my $detalle = param('detalle');
print hidden(-name=>"searchx",-value=>"$searchx",-override=>1);
print hidden(-name=>"detalle",-value=>"$detalle",-override=>1);

my $call       = param('call');
my $cuenta_ret = param('cuenta_ret');
print hidden(-name=>"call",-value=>"$call",-override=>1);
print hidden(-name=>"cuenta_ret",-value=>"$cuenta_ret",-override=>1);

my $evento;

if ($call eq '') {                                  # Retorno de vercomp
    $evento = "window.close();window.open('?opt=diario&ldiario=$ldiario&periodo=$periodo&dia=$dia&searchx=$searchx&detalle=$detalle&offset=$offset&param1=$param1','inferior');return false;";

} elsif ($call eq 'op') {                           # Retorno de Cuenta por pagar

    $evento = "window.close();window.open('?opt=opevarias&optx=cpagar&opty=cuenta&cuenta=$cuenta_ret','cpagar');return false;";

} elsif ($call eq 'oc') {                           # Retorno de Cuenta por cobrar

    $evento = "window.close();window.open('?opt=opevarias&optx=ccobrar&opty=cuenta&cuenta=$cuenta_ret','ccobrar');return false;";
} elsif ($call eq 'resumen_pagos') {                # Retorno de Resumen de pagos

    $evento = "window.close();window.open('?opt=opevarias&optx=cpagar&opty=resumen_pagos','wresumen_pagos');return false;";

} elsif ($call eq 'ac') {                           # Retorno de Analisis de Cuenta

    my $wlink = "?opt=vistapre&optx=vpcuenta&cuenta=$cuenta_ret&fecha_desde=".param('fecha_desde')."&fecha_hasta=".param('fecha_hasta')."&rango=".param('rango')."&orden=".param('orden');

   $evento = "window.close();window.open('$wlink','vp');return false;";

} elsif (($call eq 'cd') or ($call eq 'nu')) {      # Retorno de Comprobantes fuera de balance/anulados

    $evento = "window.close();window.open('?opt=diario&optx=$call&offset=$offset&param1=$param1','inferior');return false;";

}

if (param('opty') eq 'edit') {
    print Tr({-class=>$style."FieldCaptionTD",-align=>"center"},td({-colspan=>"8"},
    table(Tr(
    td(button(-class=>$style."Button",-value=>"Imprimir",-onclick=>"document.forms[0].optx.value='print';submit();")),
    td(button(-class=>$style."Button",-value=>"Aceptar",-onclick=>"document.forms[0].optx.value='save';submit()")),
    td(button(-class=>$style."Button",-value=>"Clonar",-onclick=>"document.forms[0].optx.value='clonar';submit();")),
    td(button(-class=>$style."Button",-value=>"Cerrar",-override=>"1",-onclick=>"$evento")),
    ))));
} else {
    print Tr({-class=>$style."FieldCaptionTD",-align=>"center"},td({-colspan=>"8"},
    table(Tr(
    td(button(-class=>$style."Button",-value=>"Imprimir",-onclick=>"document.forms[0].optx.value='print';submit();")),
    td(button(-class=>$style."Button",-value=>"Modificar",-onclick=>"document.forms[0].opty.value='edit';submit();")),
    td(button(-class=>$style."Button",-value=>"Clonar",-onclick=>"document.forms[0].optx.value='clonar';submit();")),
    td(button(-class=>$style."Button",-value=>"Cerrar",-override=>"1",-onclick=>"$evento")),
    ))));
}

print "</table>";

print "</td></tr></table>";

print end_form();

# Si es el libro de Compras, link a la orden de compra
if ($diario == '4') {
    my @list   = split /#/ , $glosa;
    my $lnk = "?opt=ver_oc&tipodoc=4&orden_referencia=$list[1]";
    my $str = "window.open(\"$lnk\",'referencia','scrollbars=yes,resizable=yes,width=800,height=400'); return false;";
    print "<div align=center>".a({-href=>"$lnk",-onclick=>"$str"},"Ver registro de compra")."</div>";
}

if ($diario == '3') {
    my @list   = split /#/ , $glosa;
    my $lnk;
    if ($glosa =~ m/AJUSTE/) {
        $lnk = "?opt=ver_oc&tipodoc=2&orden_referencia=$list[1]";
    } elsif ($glosa =~ m/SALIDA/) {
        $lnk = "?opt=ver_oc&tipodoc=1&orden_referencia=$list[1]";
    }
    my $str = "window.open(\"$lnk\",'referencia','scrollbars=yes,resizable=yes,width=800,height=400'); return false;";
    print "<div align=center>".a({-href=>"$lnk",-onclick=>"$str"},"Ver registro de almacen")."</div>";
}


}

# -----------------------------------------------------------
sub VerOrden {
# -----------------------------------------------------------
my ($banner,$order_title,$optlabel,$exelabel,$sess_array) = @_;

#my @names = param;
#foreach (@names) { print $_ , " = ",param($_), "<br>"; }

if (param('optx') eq 'savemod') {
   savemod($sess_array);
}

if (param('auto') eq 'si') {
   GeneraOA();
}

my $check = (!defined(param('check'))) ? 0 : ((param('check') == 0) ? 1 : 0);

my $memo      = param('memo');
my $seccion   = param('seccion');
my $style     = get_sessiondata('cssname');
my $proveedor = get_sessiondata('proveedor');
my $provee    = get_sessiondata('provee');
my $perfil    = get_sessiondata('perfil');  
my $igv       = get_sessiondata('igv');  
my $tc_compra = get_sessiondata('tc_compra');  
my $tmoneda   = (get_sessiondata('moneda') eq '0') ? get_sessiondata('moneda_nac') : get_sessiondata('moneda_ext');  
my $simbolo_nac = get_sessiondata('simbolo_nac');  

my $total;
my $total_igv;

    #topbanner($banner);

    if (defined(cookie('contab'))) {      # check new session and & retrieve $sess_ref
        my $i = 0;
        my $dbh = connectdb();
        if (my $sess_ref = opensession($dbh)) {
            my %orders;
            my $cart_ref = $sess_ref->attr($sess_array);
            my $i=0;
            foreach my $item_id (keys(%{$cart_ref})) {
                    my $item_ref = $cart_ref->{$item_id};
                    $orders{$item_ref->{"item"}} = $item_id;
                    $i++;
            }

            if (!$i) {
                my $mensaje=escapeHTML("No ha seleccionado... ");
                if ($optlabel eq 'compra') {
                   print redirect("?opt=compra&mensaje=".$mensaje);
                } elsif ($optlabel eq 'devolucion') {
                   print redirect("?opt=devolucion&mensaje=".$mensaje);
                } elsif ($optlabel eq 'pedido') {
                   print redirect("?opt=pedido&mensaje=".$mensaje);
                } elsif ($optlabel eq 'ajuste') {
                   print redirect("?opt=ajuste&mensaje=".$mensaje);
                }
                return;
            }

            if ($optlabel eq 'compra' or $optlabel eq 'devolucion') {
                if ($proveedor eq '') {
                    my $mensaje = "No ha seleccionado proveedor para esta orden";
                    print redirect("?opt=compra&mensaje=".$mensaje);
                    return;
                }
            }

            print start_form();
            print "<br><table border=0 align=center cellspacing=2 cellpadding=2 class=".$style."FormTABLE>";

            if ($optlabel eq 'compra' or $optlabel eq 'devolucion') {  # Header title
                print Tr({-class=>$style."FormHeaderFont"},td({-colspan=>"11"},b($order_title." en $tmoneda")));



                print Tr(td({-colspan=>"9"},table({-border=>"0",-cellspacing=>"0",-cellpadding=>"0"},Tr(td("Proveedor&nbsp;:&nbsp;"),td("<font color=blue>".$proveedor."</font>"),td("&nbsp;&nbsp;"),td("Raz&oacute;n Social&nbsp;:&nbsp;"),td("<font color=blue>".nombreproveedor($proveedor)."</font>"),td("&nbsp;&nbsp;"),td("T/C=<font color=blue>".$tc_compra."</font>") ))));

                print Tr({-class=>$style."FormHeaderFont"},td({-width=>"30"},"&nbsp;"),td({-width=>"100"},"C&oacute;digo"),td({-width=>"200"},"Descripci&oacute;n"),td({-width=>"50"},"Cuenta"),td({-width=>"50"},"Cant."),td({-width=>"50"},"Precio"),td({-width=>"50"},"%Desc"),td({-width=>"50"},"%Isc"),td({-width=>"50"},"Flete"),td({-width=>"50"},"%Igv"),td({-width=>"50"},"Neto"));

            } elsif ($optlabel eq 'ajuste') {
                print Tr({-class=>$style."FormHeaderFont"},td({-colspan=>"7"},b($order_title)));
                print Tr({-class=>$style."FormHeaderFont"},td("&nbsp;"),td("C&oacute;digo"),td("Descripci&oacute;n"),td("Cuenta"),td("Disponible"),td("Fisico"),td("Diferencia"));
            } else {
                print Tr({-class=>$style."FormHeaderFont"},td({-colspan=>"5"},b($order_title)));
                print Tr({-class=>$style."FormHeaderFont"},td({-width=>"50"},"&nbsp;"),td({-width=>"100"},"C&oacute;digo"),td({-width=>"300"},"Descripci&oacute;n"),td({-width=>"50"},"Unidad"),td({-width=>"100"},"Cantidad"));
            }

            #print Tr({-class=>$style."FormHeaderFont"},td({-colspan=>"6"},"Memo : ".textfield(-name=>"memo",-value=>"$memo",-size=>64,-maxlength=>64)));

            foreach my $key (sort keys(%orders)) {
               my $item_ref = $cart_ref->{$orders{$key}};
               if ($optlabel eq 'compra' or $optlabel eq 'devolucion') {
                  my $neto = $item_ref->{"flete"} * $item_ref->{"cantidad"} + ($item_ref->{"costo"} * $item_ref->{"cantidad"} * (1 - 0.01 * $item_ref->{"descuento"}) * (1 + 0.01 * $item_ref->{"isc"})) / (1 + 0.01 * $item_ref->{"igv"});  
                  print Tr({-class=>$style."FieldCaptionTD",-align=>"right"},
                  td ({-align=>"center"},checkbox(-name=>"checknum",-value=>$item_ref->{'item'},-label =>"",-checked=>$check,-override=>"1")),
                  td ({-align=>"center"},$orders{$key}),
                  td ({-align=>"left"},nombretipo($orders{$key})),
                  td ({-align=>"center"},cuentatipo($orders{$key})),
                  td (sprintf("%10.3f",$item_ref->{"cantidad"})),
                  td (sprintf("%10.4f",$item_ref->{"costo"})),
                  td (sprintf("%10.2f",$item_ref->{"descuento"})),
                  td (sprintf("%10.2f",$item_ref->{"isc"})),
                  td (sprintf("%10.2f",$item_ref->{"flete"})),
                  td (sprintf("%10.2f",$item_ref->{"igv"})),
                  td (sprintf("%10.2f",$neto)));
                  $total += $neto;
                  $total_igv += $neto * $item_ref->{"igv"} * 0.01;
               } elsif ($optlabel eq 'ajuste') {
                   my $disponible;
                   my $unidad;
                   if ($perfil == 5) {  
                      $disponible = disponible_pv($orders{$key});
                      $unidad = unidadusoarticulo($orders{$key});
                   } elsif ($perfil == 4 or $perfil <= 1) {
                      $disponible = disponible($orders{$key});
                      $unidad = unidadarticulo($orders{$key});
                   }
                   print Tr({-class=>$style."FieldCaptionTD",-align=>"center"},
                       td ({-width=>"50"},checkbox(-name=>"checknum",-value=>$item_ref->{'item'},-label =>"",-checked=>$check,-override=>"1")),
                       td ({-width=>"100"},$orders{$key}),
                       td ({-width=>"200",-align=>"left"},nombrearticulo($orders{$key})),
                       td ({-width=>"50"},$unidad),
                       td ({-width=>"100",-align=>"right"},sprintf("%10.3f",$disponible)),
                       td ({-width=>"100",-align=>"right"},sprintf("%10.3f",$item_ref->{"cantidad"})),
                       td ({-width=>"100",-align=>"right"},sprintf("%10.2f",$item_ref->{"cantidad"}-$disponible)));
               } else {  # Pedido
                   print Tr({-class=>$style."FieldCaptionTD",-align=>"center"},
                   td (checkbox(-name=>"checknum",-value=>$item_ref->{'item'},-label =>"",-checked=>$check,-override=>"1")),
                   td ($orders{$key}),
                   td ({-align=>"left"},nombrearticulo($orders{$key})),
                   td (unidadarticulo($orders{$key})),
                   td ({-align=>"right"},sprintf("%10.2f",$item_ref->{"cantidad"})));
               }
            }

            if ($optlabel eq 'compra' or $optlabel eq 'devolucion') {



                print Tr({-class=>$style."FieldCaptionTD",-align=>"right"},td({-colspan=>"10"},b("Valor Venta&nbsp;$simbolo_nac&nbsp;")),td ({-width=>"50",-align=>"right"},sprintf("%10.2f",$total)));
                print Tr({-class=>$style."FieldCaptionTD",-align=>"right"},td({-colspan=>"10"},b("Impuesto General a las Ventas ". $igv * 100 . "%&nbsp;$simbolo_nac&nbsp;")),td({-width=>"50",-align=>"right"},sprintf("%10.2f",$total_igv)));
                print Tr({-class=>$style."FieldCaptionTD",-align=>"right"},td({-colspan=>"10"},b("Total Orden&nbsp;$simbolo_nac&nbsp;")),td ({-width=>"50",-align=>"right"},sprintf("%10.2f",$total+$total_igv)));
            }

            print "</table><br>";
              
            my $exetag;
            if ($optlabel eq 'pedido') {
               $exetag = "Enviar pedido";
            } elsif ($optlabel eq 'compra') {
               $exetag = "Cerrar Gasto";
            } elsif ($optlabel eq 'devolucion') {
               $exetag = "Cerrar O.D.";
            } elsif ($optlabel eq 'ajuste') {
               $exetag = "Ajustar Inventario";
            }

            #my $check_button = "<button class=".$style."button type='button' name='marcar' title='Cambiar todo' onclick=\"document.forms[0].opt.value='view$optlabel';document.forms[0].optx.value='checkall';document.forms[0].submit();\">".img({-src=>"/images/b_edit.png",-alt=>"b_edit.png",-border=>"0"}). "</button>";

            #my $str = "&nbsp;&nbsp;".img({-src=>"/images/arrow_ltr.png",-alt=>"arrow_ltr.png",-width=>"38",-height=>"22"}). "&nbsp;" .a({-href=>"?opt=cpendiente&secuencial=$secuencial&optx=$optx&checkmark=yes"},"Marcar") . "&nbsp;" . a({-href=>"?opt=cpendiente&secuencial=$secuencial&optx=$optx&checkmark=no"},"Quitar");
              

            my $check_button = "<button class=".$style."button type='button' name='marcar' title='Cambiar todo' onclick=\"document.forms[0].opt.value='view$optlabel';document.forms[0].submit();\">".img({-src=>"/images/b_edit.png",-alt=>"b_edit.png",-border=>"0"}). "</button>";

            print "<table border=0 align=center cellspacing=2 cellpadding=2>";
            print Tr({-align=>"center"},td({-class=>$style."button"},$check_button),td("Con los seleccionados:"),td(button(-class=>$style."Button",-value=>"Eliminar",-onclick=>"document.forms[0].opt.value='delitems';submit();")),td(button(-class=>$style."Button",-value=>"Modificar",-onclick=>"document.forms[0].opt.value='mod$optlabel';submit();")),td($order_title.":"),td(button(-class=>$style."Button",-value=>"Continuar",-onclick=>"document.forms[0].opt.value='$optlabel';submit();"),td(button(-class=>$style."Button",-value=>$exetag,-OnClick=>"document.forms[0].opt.value='$exelabel';submit();"))));
            print "</table><br>";

            print hidden(-name=>"opt",-value=>"",-override=>"1");
            print hidden(-name=>"optx",-value=>"",-override=>"1");
            print hidden(-name=>"opty",-value=>$sess_array,-override=>"1");
            print hidden(-name=>"optlabel",-value=>$optlabel,-override=>"1");
            print hidden(-name=>"check",-value=>$check,-override=>"1");
            print hidden(-name=>"memo",-value=>$memo,-override=>"1");
            print hidden(-name=>"seccion",-value=>$seccion,-override=>"1");
            print hidden(-name=>"provee",-value=>$provee,-override=>"1");
            print end_form();
            return(0);
        }
    }
}

sub contenidohistorico {
	
# -------------------------------------------------------
my $style = get_sessiondata('cssname');

#my @names = param;
#foreach (@names) { print $_ , " = ",param($_), "<br>"; }

my ($ref,$sth,$dbh);
$dbh = connectdb();

my ($ref1,$sth1,$dbh1);
$dbh1 = connectdb();

my ($tipodoc,$banner,$listtitle); 
if (param('optx') eq 'p') {
   $tipodoc = '0';
   $banner = "Hist&oacute;rico";
   $listtitle = "Orden de Pedido";
} elsif (param('optx') eq 'c') {
   $tipodoc = '4';
   $banner = "Hist&oacute;rico";
   $listtitle = "Gastos de Orden ";
} elsif (param('optx') eq 'd') {
   $tipodoc = '5';
   $banner = "Hist&oacute;rico";
   $listtitle = "Orden de Devolucion";
} elsif (param('optx') eq 'a') {
   $tipodoc = '2';
   $banner = "Ajuste de Inventario";
   $listtitle = "Ajuste de Inventario";
}
elsif (param('optx') eq 'b') {
   $tipodoc = '2';
   $banner = "Ajuste de Inventario Barra";
   $listtitle = "Ajuste de Inventario Barra";
}


my ($user,$fecha,$fecha_ingreso,$proveedor,$referencia,$guia,$factura,$tc_compra);
my $sql;

if(param('optx') eq 'b'){

# Cabecera
 ($user,$fecha,$fecha_ingreso,$proveedor,$referencia,$guia,$factura,$tc_compra) = $dbh->selectrow_array("SELECT usuario,fecha,fecha_ingreso,proveedor,referencia,guia,factura,tc_compra FROM almacencab WHERE secuencial='".param('secuencial')."'");

# Detalle
# $sql="SELECT a.secuencial,a.interno,a.insumo,a.cantidad,a.descuento,a.costo,a.isc,a.flete,a.igv,b.descripcion,b.unidad,b.equivalencia,b.unidad_uso FROM almacendet a LEFT JOIN almacen b ON (a.insumo=b.insumo) WHERE a.secuencial='".param('secuencial')."'";
$sql="SELECT a.secuencial,a.interno,a.insumo,a.cantidad,a.descuento,a.isc,a.flete,a.igv,a.costo,b.nombre,b.unidad,b.equivalencia,b.unidad_uso FROM almacendet a LEFT JOIN producto b ON (a.insumo=b.codigo) WHERE a.secuencial='".param('secuencial')."'";

}else{

# Cabecera
 ($user,$fecha,$fecha_ingreso,$proveedor,$referencia,$guia,$factura,$tc_compra) = $dbh->selectrow_array("SELECT usuario,fecha,fecha_ingreso,proveedor,referencia,guia,factura,tc_compra FROM almacencab WHERE secuencial='".param('secuencial')."'");

# Detalle
# $sql="SELECT a.secuencial,a.interno,a.insumo,a.cantidad,a.descuento,a.costo,a.isc,a.flete,a.igv,b.descripcion,b.unidad,b.equivalencia,b.unidad_uso FROM almacendet a LEFT JOIN almacen b ON (a.insumo=b.insumo) WHERE a.secuencial='".param('secuencial')."'";
#  $sql="SELECT a.secuencial,a.interno,a.insumo,a.cantidad,a.descuento,a.isc,a.flete,a.igv,a.costo,b.nombre,b.unidad,b.equivalencia,b.unidad_uso FROM almacendet a LEFT JOIN producto b ON (a.insumo=b.codigo) WHERE a.secuencial='".param('secuencial')."'";
#$sql="SELECT a.secuencial,a.interno,a.insumo,a.cantidad,a.descuento,a.isc,a.flete,a.igv,a.costo,b.nombre,b.unidad,b.equivalencia,b.unidad_uso,c.codalmacen  FROM almacendet a , producto b , almacencab c WHERE a.insumo=b.codigo and a.secuencial=c.secuencial and a.secuencial='".param('secuencial')."'";
$sql= "SELECT a.secuencial,a.interno,a.insumo,a.cantidad,a.descuento,a.isc,a.flete,a.igv,a.costo,b.dsc as nombre,b.cuenta as unidad FROM almacendet a LEFT JOIN cc_tcuenta b ON (a.insumo=b.tcuenta) WHERE a.secuencial='".param('secuencial')."'"
}


$sth = $dbh->prepare($sql);
$sth->execute();

#topbanner($banner);

print start_form();

print "<table border=0 align=center cellspacing=0 cellpadding=0><tr><td>";

print "<table width=100% border=0 align=center cellspacing=2 cellpadding=2 class=".$style."FormTABLE>";
print Tr({-class=>$style."FormHeaderFont"},td({-colspan=>"11"},b($listtitle."&nbsp;#&nbsp;$referencia<br>Registro&nbsp;#&nbsp;".param('secuencial')."&nbsp;Fecha ingreso&nbsp;:&nbsp;".$fecha_ingreso."&nbsp;T/C=&nbsp;".$tc_compra."&nbsp;Usuario&nbsp;:&nbsp;".$user)));

if (param('optx') eq 'c' or param('optx') eq 'd') {
	
my ($diario1,$docid1,$tipodoc1,$ruc1,$tc_compra1,$usuario1,$glosa1,$consolida1,$referencia1) = $dbh1->selectrow_array("select c.diario,c.docid,c.tipodoc,c.ruc,c.tc_compra,c.usuario,c.glosa,c.consolida,c.referencia from almacencab a, cc_diariocab c WHERE a.secuencial_contab=c.secuencial and a.secuencial=".param('secuencial'));
	print Tr({-class=>$style."FieldCaptionTD"},td({-colspan=>"11"},table({-border=>"0",-cellspacing=>"0",-cellpadding=>"0"},Tr(td("RUC&nbsp;:&nbsp;"),td("<font color=blue>".$proveedor."</font>"),td("&nbsp;&nbsp;Raz&oacute;n Social&nbsp;:&nbsp;"),td("<font color=blue>".nombreproveedor($proveedor)."</font>") ))));
 print Tr({-class=>$style."FieldCaptionTD"},td({-colspan=>"11"},table(Tr(td(b("Diario")),td(comp_nombrediario($diario1)),td(b("Fecha")),td($fecha),td(b("&nbsp;&nbsp;Emisi&oacute;n,&nbsp;:&nbsp;")."$fecha"), 
                        td("&nbsp;&nbsp;".b("Vencimiento:")."&nbsp;$fecha_ingreso")
    ))));
print Tr({-class=>$style."FieldCaptionTD"},td({-colspan=>"11"},table(Tr(td(b("Documento")),td(comp_tipodoc(sprintf("%02d",sprintf("%02d",$tipodoc1)))),td(b("N&uacute;mero")),td($docid1),td(b("Tipo de Cambio")),td({-width=>"100"},$tc_compra1),td(b("Usuario:&nbsp;")),td($usuario1)) )));
print Tr({-class=>$style."FieldCaptionTD"},td({-colspan=>"11"},table(Tr(td(b("Detalle")),td({-width=>"200"},$glosa1 ),td(b("Cheque/Ref.")),td($referencia1) ))));



  if (param('optx') eq 'c') {
  	# print table({-width=>"100%"},Tr({-class=>$style."FieldCaptionTD"},td("Proveedor&nbsp;:&nbsp;<font color=blue>".$proveedor."</font>&nbsp;Nombre&nbsp;:&nbsp;<font color=blue>".nombreproveedor($proveedor)."</font>"),td({-width=>"50"},"&nbsp;Factura&nbsp;:&nbsp;"),td({-width=>"50",-align=>"right"},"<font color=blue>".sprintf("%12s",$factura)."</font>")));
   print "<table width=100% border=0 align=center cellspacing=2 cellpadding=2 class=".$style."FormTABLE>";
   print Tr({-class=>$style."FormHeaderFont"},td("#"),td("Insumo"),td("Descripci&oacute;n"),td("Und"),td("Cant."),td("Precio"),td("%Desc"),td("%Isc"),td("Flete"),td("%Igv"),td({-width=>"70"},"Importe"));

  }else{
   print "<table width=100% border=0 align=center cellspacing=2 cellpadding=2 class=".$style."FormTABLE>";
   print Tr({-class=>$style."FormHeaderFont"},td("#"),td("Insumo"),td("Descripci&oacute;n"),td("Und"),td("Cant."),td("Precio"),td("%Desc"),td("%Isc"),td("Flete"),td("%Igv"),td({-width=>"70"},"Importe"));

  	}
  

} else {
   	
   	
   	if (param('optx') eq 'a' or param('optx') eq 'b') {
		print "<table width=100% border=0 align=center cellspacing=2 cellpadding=2 class=".$style."FormTABLE>";
   print Tr({-class=>$style."FormHeaderFont"},td("#"),td("Insumo"),td("Descripci&oacute;n"),td("Unidad"),td("Costo"),td("Cantidad"),td("Importe"));
		} else {
			print "<table width=100% border=0 align=center cellspacing=2 cellpadding=2 class=".$style."FormTABLE>";
      print Tr({-class=>$style."FormHeaderFont"},td("#"),td("Insumo"),td("Descripci&oacute;n"),td("Unidad"),td("Costo"),td("Cantidad"),td("Importe"));

			}
		 
   
}

#if (param('optx') eq 'c') {
#   print Tr(td({-colspan=>"11"},table({-border=>"0",-cellspacing=>"0",-cellpadding=>"0"},Tr(td("Proveedor&nbsp;:&nbsp;"),td("<font color=blue>".$proveedor."</font>"),td("&nbsp;&nbsp;"),td("Raz&oacute;n Social&nbsp;:&nbsp;"),td("<font color=blue>".nombreproveedor($proveedor)."</font>")))));
#   print Tr({-class=>$style."FormHeaderFont"},td("#"),td("Insumo"),td("Descripci&oacute;n"),td("Und"),td("Cant."),td("Precio"),td("%Desc"),td("%Isc"),td("Flete"),td("%Igv"),td({-width=>"70"},"Importe"));
#} else {
#   print Tr({-class=>$style."FormHeaderFont"},td("#"),td("Insumo"),td("Descripci&oacute;n"),td("Unidad"),td("Costo"),td("Cantidad"),td("Importe"));
#}

my $totalorden;
my $total_igv;
my $neto;
while ($ref = $sth->fetchrow_hashref()) {
       if (param('optx') eq 'c' or param('optx') eq 'd') {
           $neto = + $ref->{"flete"} * $ref->{"cantidad"} + ($ref->{'cantidad'} * $ref->{'costo'}) * (1 - $ref->{'descuento'} * 0.01) * (1 + $ref->{'isc'} * 0.01) * (1 / (1 + $ref->{'igv'} * 0.01));
           print Tr({-class=>$style."FieldCaptionTD",-align=>"right"},
             td ({-width=>"50",-align=>"center"},$ref->{'interno'}),
             td ($ref->{'insumo'}),
           #  td ({-width=>"250",-align=>"left"},$ref->{'nombre'}),
             td ({-width=>"250",-align=>"left"},$ref->{'nombre'}),
             td ({-align=>"center"},$ref->{'unidad'}),
             td ($ref->{'cantidad'}),
             td ($ref->{'costo'}),
             td ($ref->{'descuento'}),
             td ($ref->{'isc'}),
             td ($ref->{'flete'}),
             td ($ref->{'igv'}),
             td (sprintf("%10.2f",$neto)));
             $totalorden  += $neto;
             $total_igv   += $neto * $ref->{'igv'} * 0.01;
       } else {   # pedidos
             #my $costo_insumo = ultimo_costo_insumo($ref->{'insumo'});
             my $costo_insumo = costo_promedio($ref->{'insumo'});
             print Tr({-class=>$style."FieldCaptionTD",-align=>"center"},
             td ({-width=>"50"},$ref->{'interno'}),
             td ($ref->{'insumo'}),
             td ({-width=>"300",-align=>"left"},$ref->{'nombre'}." - Tienda:".$ref->{'codalmacen'}),
             td ($ref->{'unidad'}),
             td ({-align=>"right"},sprintf("%10.2f",$costo_insumo)),
             td ({-align=>"right"},$ref->{'cantidad'}),
             td ({-align=>"right"},sprintf("%10.2f",$ref->{'cantidad'} * $costo_insumo)));
             $totalorden += $ref->{'cantidad'} * $costo_insumo;
       }
}

if (param('optx') eq 'c' or param('optx') eq 'd') {
    print Tr({-class=>$style."FieldCaptionTD",-align=>"right"},td({-colspan=>"10"},b("Valor Venta&nbsp;".get_sessiondata('simbolo_nac')."&nbsp;")),td(b(sprintf("%10.2f",$totalorden))));
    print Tr({-class=>$style."FieldCaptionTD",-align=>"right"},td({-colspan=>"10"},b("Impuesto General a las Ventas&nbsp;". get_sessiondata('igv') * 100 . "%&nbsp;".get_sessiondata('simbolo_nac')."&nbsp;")),td(b(sprintf("%10.2f",$total_igv))));
    print Tr({-class=>$style."FieldCaptionTD",-align=>"right"},td({-colspan=>"10"},b("Total Orden&nbsp;".get_sessiondata('simbolo_nac')."&nbsp;")),td(b(sprintf("%10.2f",$totalorden+$total_igv))));
}

if (param('optx') eq 'p') {
    print Tr({-class=>$style."FieldCaptionTD",-align=>"right"},td({-colspan=>"6"},b("Total Pedido&nbsp;".get_sessiondata('simbolo_nac')."&nbsp;")),td(b(sprintf("%10.2f",$totalorden))));
}

if (param('optx') eq 'a') {
    print Tr({-class=>$style."FieldCaptionTD",-align=>"right"},td({-colspan=>"6"},b("Total Ajuste&nbsp;".get_sessiondata('simbolo_nac')."&nbsp;")),td(b(sprintf("%10.2f",$totalorden))));
}
if (param('optx') eq 'b') {
    print Tr({-class=>$style."FieldCaptionTD",-align=>"right"},td({-colspan=>"6"},b("Total Ajuste&nbsp;".get_sessiondata('simbolo_nac')."&nbsp;")),td(b(sprintf("%10.2f",$totalorden))));
}

# Quien puede extornar historicos ?
# print Tr({-class=>$style."FieldCaptionTD"},td({-colspan=>"7"},table({-align=>"center"},td(button(-class=>$style."Button",-name=>"Imprimir",-OnClick=>"document.forms[0].imprime.value='1';submit();")),td(button(-class=>$style."Button",-name=>"Extornar",-OnClick=>"document.forms[0].extorno.value='1';submit();")),td(submit(-class=>$style."Button",-name=>"Regresar")))));

if (param('optx') eq 'c') {                # Compras 
   # print Tr({-class=>$style."FieldCaptionTD"},td({-colspan=>"11"},table({-align=>"center"},Tr(td(button(-class=>$style."Button",-name=>"Imprimir",-OnClick=>"document.forms[0].imprime.value='1';submit();window.close();")),td((button(-class=>$style."Button",-name=>"Extornar",-OnClick=>"if ( confirm('Confirma extornar esta orden ?')) { document.forms[0].extorno.value='1';submit();window.close();}"))),td(button(-class=>$style."Button",-name=>"Generar OC",-OnClick=>"document.forms[0].genera_oc.value='1';submit();")),td(button(-class=>$style."Button",-name=>"Cerrar",-onclick=>"window.close();")) ))));
 print Tr({-class=>$style."FieldCaptionTD"},
           td({-colspan=>"11"},table({-align=>"center"},
                Tr(
                  td(button(-class=>$style."Button",-name=>"Cerrar",-onclick=>"window.close();")) 
                  ))));

} elsif (param('optx') eq 'd') {           # Devoluciones
    print Tr({-class=>$style."FieldCaptionTD"},td({-colspan=>"11"},table({-align=>"center"},Tr(td(button(-class=>$style."Button",-name=>"Imprimir",-OnClick=>"document.forms[0].imprime.value='1';submit();window.close();")),td((button(-class=>$style."Button",-name=>"Extornar",-OnClick=>"if ( confirm('Confirma extornar esta orden ?')) { document.forms[0].extorno.value='1';submit();window.close();}"))),td(button(-class=>$style."Button",-name=>"Cerrar",-onclick=>"window.close();")) ))));
} elsif (param('optx') eq 'p') {           # Pedidos
    if (get_sessiondata('perfil') == 5) {
        print Tr({-class=>$style."FieldCaptionTD"},td({-colspan=>"11"},table({-align=>"center"},Tr(td(submit(-class=>$style."Button",-name=>"Regresar")),td(button(-class=>$style."Button",-name=>"Generar OP",-OnClick=>"document.forms[0].genera_op.value='1';submit();")) ))));
    } else {
        print Tr({-class=>$style."FieldCaptionTD"},td({-colspan=>"11"},table({-align=>"center"},Tr(td(button(-class=>$style."Button",-name=>"Imprimir",-OnClick=>"document.forms[0].imprime.value='1';submit();window.close();")),td(button(-class=>$style."Button",-name=>"Cerrar",-onclick=>"window.close();")) ))));
    }
} else {                                   # Ajustes
    print Tr({-class=>$style."FieldCaptionTD"},td({-colspan=>"11"},table({-align=>"center"},Tr(td(button(-class=>$style."Button",-name=>"Imprimir",-OnClick=>"document.forms[0].imprime.value='1';submit();window.close();")),td(button(-class=>$style."Button",-name=>"Cerrar",-onclick=>"window.close();")) ))));
}

print "</table>";
print "</td></tr></table>";

print hidden(-name=>"opt",-value=>"historico",-override=>1);
print hidden(-name=>"optx",-value=>param('optx'),-override=>1);
print hidden(-name=>"secuencial",-value=>param('secuencial'),-override=>1);
print hidden(-name=>"datesel",-value=>param('datesel'),-override=>1);
print hidden(-name=>"days",-value=>param('days'),-override=>1);
print hidden(-name=>"extorno",-value=>"0",-override=>1);
print hidden(-name=>"genera_oc",-value=>"0",-override=>1);
print hidden(-name=>"genera_op",-value=>"0",-override=>1);
print hidden(-name=>"imprime",-value=>"0",-override=>1);
my $offset = param('offset');
my $param1 = param('param1');
my $provee = param('provee');
print hidden(-name=>"offset",-value=>"$offset",-override=>1);
print hidden(-name=>"param1",-value=>"$param1",-override=>1);
print hidden(-name=>"provee",-value=>"$provee",-override=>1);
print end_form();

#print "<br><center><a href='?opt=historico&optx=".param('optx')."&secuencial=".param('secuencial')."' target='p2' title='Regresar'>".img({-src=>"/images/return.png",-border=>"0",-alt=>"return.png"})."</a></center>";


	}


# ----------------------------------------------------------------------
sub additem1 {
# ----------------------------------------------------------------------
my ($insumo,$cantidad,$costo,$sess_array) = @_;

my $igv = get_sessiondata('igv');

        # Almacenamiento de items en variable de session
	if (defined(cookie('contab'))) {   # check session and & retrieve $sess_ref
            my $dbh = connectdb();
            if (my $sess_ref = opensession($dbh)) {
                my $cart_ref;
                if (!defined ($cart_ref = $sess_ref->attr ($sess_array))) {
                    $cart_ref = {};
                }
                if (!exists ($cart_ref->{$insumo})) {  # -- create new entry
                    $cart_ref->{$insumo}               = {};     
                    $cart_ref->{$insumo}->{item}       = time();    # uniq number 
                    $cart_ref->{$insumo}->{descuento}  = 0;
                    $cart_ref->{$insumo}->{isc}        = 0;
                    $cart_ref->{$insumo}->{flete}      = 0;
                    $cart_ref->{$insumo}->{igv}        = $igv * 100;
                    $cart_ref->{$insumo}->{cantidad}   = 0;
                }
                $cart_ref->{$insumo}->{cantidad} += $cantidad;
                $cart_ref->{$insumo}->{costo}     = $costo;

                # -- Save cart data
                $sess_ref->attr ($sess_array , $cart_ref);
               	$sess_ref->close();
            } 
        } 
}


# ----------------------------------------------------------------------
sub additem {
# ----------------------------------------------------------------------
my ($moneda,$tc,$cuenta,$memo,$dh,$valor,$sess_array,$num) = @_;

# Almacenamiento de items en variable de session
if (defined(cookie('contab'))) {   # check session and & retrieve $sess_ref
    my $dbh = connectdb();
    if (my $sess_ref = opensession()) {
        my $cart_ref;
        if (!defined ($cart_ref = $sess_ref->attr($sess_array))) {
            $cart_ref = {};
        }
        if (!exists ($cart_ref->{$cuenta})) {           # -- create new entry
           $cart_ref->{$cuenta}            = {};     
           $cart_ref->{$cuenta}->{item}    = defined($num) ? $num : time();    # uniq number 
        }
        $cart_ref->{$cuenta}->{memo}       = $memo;
        $cart_ref->{$cuenta}->{dh}         = $dh;
        if ($moneda eq '0') {
           $cart_ref->{$cuenta}->{soles}   = $valor;
           $cart_ref->{$cuenta}->{dolar}   = ($tc > 0) ? $valor / $tc : 0;
        } else {
           $cart_ref->{$cuenta}->{soles}   = $valor * $tc;
           $cart_ref->{$cuenta}->{dolar}   = $valor;
        }
        # -- Save cart data
        $sess_ref->attr($sess_array,$cart_ref);
        $sess_ref->close();
    } 
} 

}

# -------------------------------------------------------
sub ModOrden {
# -------------------------------------------------------
my ($banner,$order_title,$optlabel,$exelabel,$sess_array) = @_;

#my @names = param;
#foreach (@names) { print $_ , " = ",param($_), "<br>"; }

#topbanner($banner);

my $memo      = param('memo');
my $seccion   = param('seccion');
my @checknum  = param('checknum');
my $style     = get_sessiondata('cssname');
my $proveedor = get_sessiondata('proveedor');
my $igv       = get_sessiondata('igv');

        if (defined(cookie('contab'))) {      
	   my $dbh = connectdb();
	   if (my $sess_ref = opensession($dbh)) {
	       my $cart_ref = $sess_ref->attr($sess_array);
               my %orders;
               print start_form();
               print "<br><table border=0 align=center cellspacing=2 cellpadding=2 class=".$style."FormTABLE>";
               print Tr({-class=>$style."FormHeaderFont"},td({-colspan=>"10"},b($order_title)));
               if ($optlabel eq 'compra' or $optlabel eq 'devolucion') { # Compra|Devolucion
                  

 print Tr(td({-colspan=>"10"},table({-width=>"100%",-border=>"0",-cellspacing=>"0",-cellpadding=>"0"},Tr(td({-width=>"25%"},"Proveedor&nbsp;:&nbsp;<font color=blue>$proveedor</font>"),td("Raz&oacute;n Social&nbsp;:&nbsp;<font color=blue>". nombreproveedor($proveedor)) . "</font>"))));
                   print Tr({-class=>$style."FormHeaderFont"},td({-width=>"100"},"C&oacute;digo"),td({-width=>"250"},"Descripci&oacute;n"),td({-width=>"50"},"Cuenta"),td({-width=>"50"},"Cant."),td({-width=>"50"},"Precio"),td({-width=>"50"},"%Desc."),td({-width=>"50"},"%Isc"),td({-width=>"50"},"Flete"),td({-width=>"50"},"%Igv"));
               } else {                              # Pedido y Ajuste
                  print Tr({-class=>$style."FormHeaderFont"},td({-width=>"100"},"C&oacute;digo"),td({-width=>"300"},"Descripci&oacute;n"),td({-width=>"100"},"Cuenta"),td({-width=>"100"},"Cantidad"));
               }

               foreach my $item_id (keys(%{$cart_ref})) {
                       my $item_ref = $cart_ref->{$item_id};
                       $orders{$item_ref->{"item"}} = $item_id;
               }

               foreach my $key (sort keys(%orders)) {
                       my $item_ref = $cart_ref->{$orders{$key}};
                       if (grep (/^$key$/,@checknum)) { # marcados
                          if ($optlabel eq 'compra' or $optlabel eq 'devolucion') {
                              print Tr({-class=>$style."FieldCaptionTD",-align=>"center"},
                                td ($orders{$key}),
                                td ({-align=>"left"},nombretipo($orders{$key})),
                                td (cuentatipo($orders{$key})),
		     		td ("<input width=50 type=text name=cantidad value='$item_ref->{cantidad}' size=4 maxlength=10>"),
		     		td ("<input width=50 type=text name=costo value='$item_ref->{costo}' size=4 maxlength=10>"),
		     		td ("<input width=50 type=text name=descuento value='$item_ref->{descuento}' size=4 maxlength=10>"),
		     		td ("<input width=50 type=text name=isc value='$item_ref->{isc}' size=4 maxlength=10>"),
		     		td ("<input width=50 type=text name=flete value='$item_ref->{flete}' size=4 maxlength=10>"),
		     		td ("<input width=50 type=text name=igv value='$item_ref->{igv}' size=4 maxlength=10>"));
                          } elsif (param('optlabel') eq 'ajuste') {
                              print Tr({-class=>$style."FieldCaptionTD",-align=>"center"},
                                td ($orders{$key}),
                                td ({-align=>"left"},nombretipo($orders{$key})),
                                td (unidadarticulo($orders{$key})),
		     		td ("<input type=text name=cantidad value='$item_ref->{cantidad}' size=10 maxlength=10>"));
                          } else {
                              print Tr({-class=>$style."FieldCaptionTD",-align=>"center"},
                                td ($orders{$key}),
                                td ({-align=>"left"},nombretipo($orders{$key})),
                                td (cuentatipo($orders{$key})),
		     		td ("<input type=text name=cantidad value='$item_ref->{cantidad}' size=10 maxlength=10>"));
                          }
                          print hidden(-name=>"checknum",-value=>"$item_ref->{'item'}",-override=>"1");
                       } else {
                          if ($optlabel eq 'compra' or $optlabel eq 'devolucion') {
                              print Tr({-class=>$style."FieldCaptionTD",-align=>"center"},
                                td ($orders{$key}),
                                td ({-align=>"left"},nombretipo($orders{$key})),
                                td (cuentatipo($orders{$key})),
		     		td ({-align=>"right"},sprintf("%10.2f",$item_ref->{cantidad})),
		     		td ({-align=>"right"},sprintf("%10.2f",$item_ref->{costo})),
		     		td ({-align=>"right"},sprintf("%10.2f",$item_ref->{descuento})),
		     		td ({-align=>"right"},sprintf("%10.2f",$item_ref->{isc})),
		     		td ({-align=>"right"},sprintf("%10.2f",$item_ref->{flete})),
		     		td ({-align=>"right"},sprintf("%10.2f",$item_ref->{igv})));
                          } elsif ($optlabel eq 'ajuste') {
                              print Tr({-class=>$style."FieldCaptionTD",-align=>"center"},
                                td ($orders{$key}),
                                td ({-align=>"left"},nombretipo($orders{$key})),
                                td (cuentatipo($orders{$key})),
		     		td ("<input type=text name=cantidad value='$item_ref->{cantidad}' size=10 maxlength=10>"));
                          } else {
                              print Tr({-class=>$style."FieldCaptionTD",-align=>"center"},
                                td ($orders{$key}),
                                td ({-align=>"left"},nombretipo($orders{$key})),
                                td (cuentatipo($orders{$key})),
		     		td ({-align=>"right"},sprintf("%10.2f",$item_ref->{cantidad})));
                          }
                       }
               }
               print "</table><br>";
           }
           print "<table border=0 width=768 align=center cellspacing=2 cellpadding=2>";
           print Tr({-align=>"center"},td({-align=>"right",-width=>"50%"},button(-class=>$style."Button",-value=>"Aceptar Cambios",-onclick=>"document.forms[0].optx.value='savemod';submit();")),td({-align=>"left"},button(-class=>$style."Button",-value=>"Cancelar",-onclick=>"submit();")) );
           print "</table><br>";
           print hidden(-name=>"opt",-value=>"view$optlabel",-override=>"1");
           print hidden(-name=>"optx",-value=>"",-override=>"1");
           print hidden(-name=>"opty",-value=>$sess_array,-override=>"1");
           print hidden(-name=>"memo",-value=>$memo,-override=>"1");   
           print hidden(-name=>"seccion",-value=>$seccion,-override=>"1");
           print end_form();
        }

}

# -------------------------------------------------------
sub savemod {   # save modification
# -------------------------------------------------------
my ($sess_array) = @_;
my @checknum  = param('checknum');
my @cantidad  = param('cantidad');
my @costo     = param('costo');
my @isc       = param('isc');
my @flete     = param('flete');
my @igv       = param('igv');
my @descuento = param('descuento');

#my @names = param;
#foreach (@names) { print $_ , " = ",param($_), "<br>"; }

	if (defined(cookie('contab'))) {      
	    my $dbh = connectdb();
	    if (my $sess_ref = opensession($dbh)) {
	       my $cart_ref = $sess_ref->attr($sess_array);

               my %orders;
               foreach my $item_id (keys(%{$cart_ref})) {
                       my $item_ref = $cart_ref->{$item_id};
                       $orders{$item_ref->{"item"}} = $item_id;
               }

               my $j = 0;  # para cantidad
               foreach my $key (sort keys(%orders)) {
                        my $item_ref = $cart_ref->{$orders{$key}};
                        if (grep (/^$key$/,@checknum)) {
		                $item_ref->{cantidad}  = $cantidad[$j];
		                $item_ref->{descuento} = $descuento[$j];
		                $item_ref->{isc}       = $isc[$j];
		                $item_ref->{flete}     = $flete[$j];
		                $item_ref->{igv}       = $igv[$j];
		                $item_ref->{costo}     = $costo[$j++];
                        }
               }
               $sess_ref->attr ($sess_array, $cart_ref);
               $sess_ref->close();
    	    }
	}
}

# -------------------------------------------------------
sub fincompra { # Copia del arreglo en memoria a la bd 
# -------------------------------------------------------
# La O.C. aparece en la lista de pendientes
my $user      = get_sessiondata('user');
my $proveedor = get_sessiondata('proveedor');
my $tc_compra = get_sessiondata('tc_compra');
my $moneda    = get_sessiondata('moneda');
#my $tipoanexo    = get_sessiondata('seccion');
my $seccion = param('seccion');
if (defined(cookie('contab'))) {      # check new session and & retrieve $sess_ref
my $dbh = connectdb();
if (my $sess_ref = opensession($dbh)) {
my %orders;
my $cart_ref = $sess_ref->attr("ccart");
foreach my $item_id (keys(%{$cart_ref})) {
	my $item_ref = $cart_ref->{$item_id};
	$orders{$item_ref->{"item"}} = $item_id;
}
# Grabar en almacencab
# Almacen Central : almacen = 0
# Almacen PV      : almacen = 1
my $aprobado = 1;  # default en esta version

# Obtiene el numero de orden de compra

my $uid  = $$."-".$ENV{'REMOTE_ADDR'}."-".time();
$dbh->do("INSERT INTO in_compra (uid) VALUES ('$uid')");
my $referencia = $dbh->selectrow_array("SELECT oc FROM in_compra WHERE uid = '$uid'");

#my $manifiesto = cuentatipo($referencia);
my $manifiesto = cuentamanifiesto($seccion);

my $tipodoc = '4';
my $err;
$dbh->do("INSERT INTO almacencab(usuario,almacen,fecha,fecha_ingreso,proveedor,tc_compra,moneda,referencia,tipodoc,aprobado,memo,uid,nro_manifiesto) VALUES('$user','0',now(),now(),'$proveedor','$tc_compra','$moneda','$referencia','$tipodoc','$aprobado','1','$uid','$manifiesto')") or ($err=$DBI::errstr);
print $err,"<br>" if ($err);

# Buscar uid
my $secuencial = $dbh->selectrow_array("SELECT secuencial FROM almacencab WHERE uid = '$uid'");
print "<br> manifiesto: $manifiesto , referncia: $referencia , secion: $seccion";
# Grabar en almacendet
# Aqui se registra todo en soles
my $factor = ($moneda eq '0') ? 1 : $tc_compra;
foreach my $key (sort keys(%orders)) {
	my $item_ref = $cart_ref->{$orders{$key}};
	$dbh->do("INSERT INTO almacendet(secuencial,insumo,cantidad,descuento,isc,flete,igv,costo) VALUES ('$secuencial','$orders{$key}','$item_ref->{cantidad}','$item_ref->{descuento}','$item_ref->{isc}','$item_ref->{flete}','$item_ref->{igv}','".$item_ref->{costo} * $factor ."')");
}

# Clear proveedor
$sess_ref->{proveedor} = "";
$sess_ref->{provee} = "";
$sess_ref->{moneda} = "0";
$sess_ref->{devolucion} = "";
$sess_ref->close();
}
}

cleararray("ccart");

}


# -------------------------------------------------------
sub contenidopendiente {
# -------------------------------------------------------
#my @names = param;
#foreach (@names) { print $_ , " = ",param($_), "<br>"; }

my $style      = get_sessiondata('cssname');
my $perfil     = get_sessiondata('perfil');
my $moneda_str = (get_sessiondata('moneda') eq '0') ? "Soles" : "Dolar";

my $secuencial = param('secuencial');
my $optx       = param('optx');


my $defaulttipodoc = (defined(param('defaulttipodoc'))) ? sprintf("%02d",param('defaulttipodoc')) : '01';
my ($tipodoc,$banner,$listtitle,$execproc); 

if (param('optx') eq 'p') {
   $tipodoc = '0';
   $banner = "Pendiente";
   $listtitle = "Orden de Pedido";
   $execproc  = "ingresapedido";
} elsif (param('optx') eq 'd') {
   $tipodoc = '5';
   $banner = "Pendiente";
   $listtitle = "Orden de Devolucion";
   $execproc  = "ingresadevolucion";
} elsif (param('optx') eq 'c') {
   $tipodoc = '4';
   $banner = "Pendiente";
   $listtitle = "Gastos Varios ";
   $execproc  = "ingresacompra";
} 

my ($ref,$sth,$dbh);
$dbh = connectdb();

if (param('imprime') eq '1') {   # Imprime pendiente

   if (param('optx') eq 'c' or param('optx') eq 'd') {
      $dbh->do("UPDATE almacencab SET guia='".param('guiacompra')."',factura='".param('factcompra')."',fecha='".param('fecha')."',fecha_ingreso='".param('fecha_ingreso')."' WHERE secuencial='".param('secuencial')."'") or (my $err=$DBI::errstr);
      print $err,"<br>" if($err);
   }

   my $secuencial = param('secuencial');
   my $pq_almacen = get_sessiondata('pq_almacen');
                                                                                                                            
   my $output;
   if (param('optx') eq 'c' or param('optx') eq 'd') {
       $output = get_sessiondata('scriptdir')."ordenf.pl ".$secuencial." 0";
   } elsif (param('optx') eq 'p') {
       $output = get_sessiondata('scriptdir')."pedido.pl ".$secuencial." 0";
   }
                                                                                                                            
   my @list   = split /\n/ , `$output`;
   hardcopy (\@list,$pq_almacen);
}

my $checkmark = (param('checkmark') eq 'yes') ? 'checked' : '';

if (param('opty') eq 'delete') {
   my @interno  = param('checknum');
   foreach my $k (@interno) {
           my $sql="DELETE FROM almacendet WHERE secuencial='".param('secuencial')."' AND interno='$k'";
           $dbh->do($sql) or (my $err=$DBI::errstr);
           print $err if ($err);
   }
}

if (param('opty') eq '1') {   # Actualizar
   my @cantidad  = param('cantidad');
   my @costo     = param('costo');
   my @descuento = param('descuento');
   my @isc       = param('isc');
   my @flete     = param('flete');
   my @igv       = param('igv');
   my @interno   = param('interno');
   my @insumo    = param('insumo');
   my $count=0;

   #foreach my $k (@interno) {
   #        my $sql="UPDATE almacendet SET flete='".$flete[$count]."',cantidad='".$cantidad[$count]."',descuento='".$descuento[$count]."',isc='".$isc[$count]."',igv='".$igv[$count]."',costo='".$costo[$count++]."' WHERE secuencial='".param('secuencial')."' AND interno='$k'";
   #        print $sql,"<br>";
   #        #$dbh->do($sql);
   #}

   my $count=0;
   foreach my $k (@insumo) {
           my $sql="UPDATE almacendet SET flete='".$flete[$count]."',cantidad='".$cantidad[$count]."',descuento='".$descuento[$count]."',isc='".$isc[$count]."',igv='".$igv[$count]."',costo='".$costo[$count++]."' WHERE secuencial='".param('secuencial')."' AND insumo='$k'";
           #print $sql,"<br>";
           $dbh->do($sql);
   }
}

#if (param('opty') eq 'saveheader') {  
#   $dbh->do("UPDATE almacencab SET guia='".param('guiacompra')."',factura='".param('factcompra')."',fecha_ingreso='".param('fecha_ingreso')."' WHERE secuencial='".param('secuencial')."'") or (my $err=$DBI::errstr);
#   print $err,"<br>" if($err);
#}

if (param('opty') eq 'inafecto') {  
   $dbh->do("UPDATE almacendet SET igv=0 WHERE secuencial='".param('secuencial')."'") or (my $err=$DBI::errstr);
   print $err,"<br>" if($err);
}

#topbanner($banner);

# Cabecera
#my ($user,$fecha,$fecha_ingreso,$tipodoc,$proveedor,$guia,$factura,$tc_compra,$estado,$aprobado,$memo,$referencia) = $dbh->selectrow_array("SELECT usuario,fecha,date_format(fecha_ingreso,'%Y-%m-%d'),tipodoc,proveedor,guia,factura,tc_compra,estado,aprobado,memo,referencia FROM almacencab WHERE secuencial='".param('secuencial')."'");

my ($user,$fecha,$fecha_ingreso,$tipodoc,$proveedor,$guia,$factura,$tc_compra,$estado,$aprobado,$memo,$referencia,$nro_manifiesto1) = $dbh->selectrow_array("SELECT usuario,fecha,fecha_ingreso,tipodoc,proveedor,guia,factura,tc_compra,estado,aprobado,memo,referencia,nro_manifiesto FROM almacencab WHERE secuencial='".param('secuencial')."'");

# Detalle
my $sql = "SELECT a.secuencial,a.interno,a.insumo,a.cantidad,a.descuento,a.isc,a.flete,a.igv,a.costo,b.dsc as descripcion,b.cuenta as unidad FROM almacendet a LEFT JOIN cc_tcuenta b ON (a.insumo=b.tcuenta) WHERE a.secuencial='".param('secuencial')."'";
#print $sql;

$sth = $dbh->prepare($sql);
$sth->execute();

my $rows = $sth->rows;

my $nummanifiesto = comp_manifiesto($nro_manifiesto1);
my $seccion	= get_sessiondata('seccion');
#print "seccion : $seccion , $nummanifiesto";
print start_form();   # forms[0]

# Titulo de cabecera
print "<br><table border=0 align=center cellspacing=2 cellpadding=2 class=".$style."FormTABLE>";
#print Tr({-class=>$style."FormHeaderFont"},td({-colspan=>"11"},b($listtitle." #&nbsp;&nbsp;".$referencia."<br>Registro #&nbsp;".param('secuencial')."&nbsp;Fecha :&nbsp;".$fecha."&nbsp;T/C=".$tc_compra."&nbsp;Usuario:".$user)));

print Tr({-class=>$style."FormHeaderFont"},td({-colspan=>"11"},b($listtitle." #&nbsp;&nbsp;".$referencia."&nbsp;&nbsp; Registro #&nbsp;".param('secuencial')."")));


if (param('optx') eq 'c' or param('optx') eq 'd') {   # Cabecera y titulos de tablas
   


print Tr({-class=>$style."FieldCaptionTD"},td({-colspan=>"11"},table({-border=>"0",-cellspacing=>"0",-cellpadding=>"0"},Tr(td("RUC&nbsp;:&nbsp;"),td("<font color=blue>".$proveedor."</font>"),td("&nbsp;&nbsp;Raz&oacute;n Social&nbsp;:&nbsp;"),td("<font color=blue>".nombreproveedor($proveedor)."</font>") ))));

#print Tr({-class=>$style."FieldCaptionTD"},td({-colspan=>"11"},table(Tr(td(b("Diario")),td(DiarioScroll("08")),td(b("Fecha")),td(textfield(-name=>"fecha_conta",-value=>"$fecha",-size=>"10",-maxlength=>"10",-override=>"1")),td(b("Tipo de Cambio")),td(textfield(-name=>"tc_compra",-value=>"$tc_compra",-size=>"6",-maxlength=>"6",-override=>"1")),td(b("Moneda")),td("")    ))));


print Tr({-class=>$style."FieldCaptionTD"},td({-colspan=>"11"},table(Tr(td(b("Diario")),td(DiarioScroll("12")),td(b("Fecha")),td(textfield(-name=>"fecha_conta",-value=>"$fecha",-size=>"10",-maxlength=>"10",-override=>"1")),td("&nbsp;&nbsp;Emisi&oacute;n&nbsp;:&nbsp;" . textfield(-name=>"fecha",-id=>"sel1",-value=>$fecha,-size=>"10",-maxlength=>"10") . reset(-value=>" ....",-onclick=>"return showCalendar('sel1','%Y-%m-%d');")), 
                        td("&nbsp;&nbsp;Vencimiento;n&nbsp;:&nbsp;" . textfield(-name=>"fecha_ingreso",-id=>"sel2",-value=>$fecha_ingreso,-size=>"10",-maxlength=>"10") . reset(-value=>" ....",-onclick=>"return showCalendar('sel2','%Y-%m-%d');"))
   ))));


print Tr({-class=>$style."FieldCaptionTD"},td({-colspan=>"11"},table(Tr(td(b("Documento")),td(DocumentScroll($defaulttipodoc)),td(b("N&uacute;mero")),td(textfield(-name=>"factcompra",-value=>"",-size=>"12",-maxlength=>"12")),td(b("Tipo de Cambio")),td(textfield(-name=>"tc_compra",-value=>"$tc_compra",-size=>"6",-maxlength=>"6",-override=>"1")),td(b("Usuario:&nbsp;")),td(textfield(-name=>"usuario",-class=>$style."NoInput",-value=>get_sessiondata('user'),-size=>"11",-maxlength=>"11",-OnFocus=>"blur();",,-override=>"1"))) )));

#     print Tr(td({-colspan=>"11"},
#             table({-width=>"100%",-align=>"center",-border=>"0",-cellspacing=>"0",-cellpadding=>"0"},
#                     Tr({-class=>$style."FieldCaptionTD"},
#                        td("Gu&iacute;a&nbsp;:&nbsp;" . textfield(-name=>"guiacompra",-value=>$guia,-size=>"12",-maxlength=>"12")),
#                       td("&nbsp;&nbsp;Factura&nbsp;:&nbsp;" . textfield(-name=>"factcompra",-value=>$factura,-size=>"12",-maxlength=>"12")),
#                     td("&nbsp;&nbsp;Emisi&oacute;n&nbsp;:&nbsp;" . textfield(-name=>"fecha",-id=>"sel1",-value=>$fecha,-size=>"10",-maxlength=>"10") . reset(-value=>" ....",-onclick=>"return showCalendar('sel1','%Y-%m-%d');")), 
#                       td("&nbsp;&nbsp;Recepci&oacute;n&nbsp;:&nbsp;" . textfield(-name=>"fecha_ingreso",-id=>"sel2",-value=>$fecha_ingreso,-size=>"10",-maxlength=>"10") . reset(-value=>" ....",-onclick=>"return showCalendar('sel2','%Y-%m-%d');")) )
#                    )));

print Tr({-class=>$style."FieldCaptionTD"},td({-colspan=>"11"},table(Tr(td(b("Detalle")),td(textfield(-name=>"glosa",-value=>"",-size=>"45",-maxlength=>"128",-override=>"1")),td(b("Cheque/Ref.")),td(textfield(-name=>"referencia",-value=>"",-size=>"11",-maxlength=>"11",-override=>"1")) ))));



    print Tr({-class=>$style."FormHeaderFont"},td({-width=>"30"},"#"),td("Codigo"),td("Descripci&oacute;n"),td("Cuenta"),td("Cant."),td("Precio"),td("%Desc"),td("%Isc"),td("Flete"),td("%Igv"),td({-width=>"70"},"Importe"));

} 

if (param('optx') eq 'p') {   # Cabecera y titulos de tablas
    print Tr({-class=>$style."FormHeaderFont"},td({-width=>"30"},"#"),td("Codigo"),td("Descripci&oacute;n"),td("Cuenta"),td("Cantidad"),td("Costo"),td("Importe"));
}

if (param('optx') eq 'a') {   # Cabecera y titulos de tablas
    print Tr({-class=>$style."FormHeaderFont"},td({-width=>"30"},"#"),td("Codigo"),td("Descripci&oacute;n"),td("Cuenta"),td("Cantidad"));
}

my $pigvmark = (param('pigv') eq 'on') ? 'checked' : '';

my $totalorden;
my $total_igv;
my $neto;
my $igv = get_sessiondata('igv');
my @checknum = param('checknum');
my $j = 0;

#print $sql,"<br>";

while ($ref = $sth->fetchrow_hashref()) {
       
       if (param('optx') eq 'a') {          # Ajustes
           print Tr({-class=>$style."FieldCaptionTD",-align=>"center"},
             td ({-width=>"50"},$ref->{'interno'}),
             td ($ref->{'insumo'}),
             td ({-width=>"300",-align=>"left"},$ref->{'descripcion'}),
             td ($ref->{'unidad'}),
             td ({-align=>"right"},$ref->{'cantidad'}));
       } elsif (param('optx') eq 'p') {     # Pedidos 
           #my $costo = ultimo_costo_insumo($ref->{'insumo'});
           my $costo = costo_promedio($ref->{'insumo'});
           if ($perfil == 4) {   # Solo perfil 4 puede modificar pedidos
               if (param('opty') eq 'x' and $checknum[$j] == $ref->{'interno'}) {   
                   print Tr({-class=>$style."FieldCaptionTD",-align=>"center"},
                         td ({-width=>"50"},$ref->{'interno'}),
                         td ($ref->{'insumo'}),
                         td ({-width=>"300",-align=>"left"},$ref->{'descripcion'}),
                         td ($ref->{'unidad'}),

                         td ({-align=>"right"},textfield(-name=>"cantidad",-value=>$ref->{'cantidad'},-size=>"6",-maxlength=>"10",-override=>"1",-onchange=>"document.forms[0].opt.value='cpendiente';document.forms[0].secuencial.value='".param('secuencial')."';document.forms[0].optx.value='p';document.forms[0].opty.value='1';submit();")),

                         td ({-align=>"right"},sprintf("%10.2f",$costo)),
                         td ({-align=>"right"},sprintf("%10.2f",$ref->{'cantidad'} * $costo)));

                         print hidden(-name=>"insumo",-value=>$ref->{'insumo'},-override=>1);
                         print hidden(-name=>"costo",-value=>$costo,-override=>1);
                         #print hidden(-name=>"interno",-value=>$ref->{'interno'},-override=>1);
                         $j++;
               } else {
                         print Tr({-class=>$style."FieldCaptionTD",-align=>"center"},
                         td ({-align=>"center"},"<input type=checkbox name=checknum $checkmark value=\"$ref->{'interno'}\">"),
                         td ($ref->{'insumo'}),
                         td ({-width=>"300",-align=>"left"},$ref->{'descripcion'}),
                         td ($ref->{'unidad'}),
                         td ({-align=>"right"},$ref->{'cantidad'}),
                         td ({-align=>"right"},sprintf("%10.2f",$costo)),
                         td ({-align=>"right"},sprintf("%10.2f",$ref->{'cantidad'} * $costo)));
               }
           } else {             # Para todos los perfiles diferentes a 4 
                   print Tr({-class=>$style."FieldCaptionTD",-align=>"center"},
                         td ({-align=>"center"},$ref->{'interno'}),
                         td ($ref->{'insumo'}),
                         td ({-width=>"300",-align=>"left"},$ref->{'descripcion'}),
                         td ($ref->{'unidad'}),
                         td ({-align=>"right"},$ref->{'cantidad'}),
                         td ({-align=>"right"},sprintf("%10.2f",$costo)),
                         td ({-align=>"right"},sprintf("%10.2f",$ref->{'cantidad'} * $costo)));
           }
           $totalorden += $ref->{'cantidad'} * $costo;

       } elsif (param('optx') eq 'c' or param('optx') eq 'd') {     # Compras | Devoluciones

           $neto = + $ref->{"flete"} * $ref->{"cantidad"} + ($ref->{'cantidad'} * $ref->{'costo'} * (1 - $ref->{'descuento'} * 0.01) * (1 + $ref->{'isc'} * 0.01)) / (1 + 0.01 * $ref->{'igv'});

           if (param('opty') eq 'x' and $checknum[$j] == $ref->{'interno'}) {   
               print Tr({-class=>$style."FieldCaptionTD",-align=>"center"},
                td ({-width=>"50"},$ref->{'interno'}),
                td ($ref->{'insumo'}),
                td ({-width=>"300",-align=>"left"},$ref->{'descripcion'}),
                td ($ref->{'unidad'}),
                td ({-align=>"right"},textfield(-name=>"cantidad",-align=>"right",-value=>$ref->{'cantidad'},-size=>"6",-maxlength=>"10",-override=>"1")),
                td ({-align=>"right"},textfield(-name=>"costo",-align=>"right",-value=>$ref->{'costo'},-size=>"6",-maxlength=>"10",-override=>"1")),
                td ({-align=>"right"},textfield(-name=>"descuento",-align=>"right",-value=>$ref->{'descuento'},-size=>"6",-maxlength=>"6",-override=>"1")),
                td ({-align=>"right"},textfield(-name=>"isc",-align=>"right",-value=>$ref->{'isc'},-size=>"6",-maxlength=>"6",-override=>"1")),
                td ({-align=>"right"},textfield(-name=>"flete",-align=>"right",-value=>$ref->{'flete'},-size=>"6",-maxlength=>"6",-override=>"1")),
                td ({-align=>"right"},textfield(-name=>"igv",-align=>"right",-value=>$ref->{'igv'},-size=>"6",-maxlength=>"6",-override=>"1")),
                td ({-align=>"right"},sprintf("%10.2f",$ref->{'costo'} * $ref->{'cantidad'})));
                #print hidden(-name=>"costo",-value=>$ref->{'costo'},-override=>1);
                print hidden(-name=>"insumo",-value=>$ref->{'insumo'},-override=>1);
                print hidden(-name=>"interno",-value=>$ref->{'interno'},-override=>1);
                $j++;
           } else {    # No marcados para editar
               print Tr({-class=>$style."FieldCaptionTD",-align=>"right"},
                td ({-align=>"center"},"<input type=checkbox name=checknum $checkmark value=\"$ref->{'interno'}\">"),
                td ({-align=>"center"},$ref->{'insumo'}),
                td ({-width=>"250",-align=>"left"},$ref->{'descripcion'}),
                td ({-align=>"center"},$ref->{'unidad'}),
                td ($ref->{'cantidad'}),
                td ($ref->{'costo'}),
                td ($ref->{'descuento'}),
                td ($ref->{'isc'}),
                td ($ref->{'flete'}),
                td ($ref->{'igv'}),
                td (sprintf("%10.2f",$neto)));
           }
       } # end elsif compras

       $totalorden += $neto;
       $total_igv  += $neto * $ref->{'igv'} * 0.01;
}

if (param('optx') eq 'c' or param('optx') eq 'd') {   # Linea de Total para Ordenes de Compra | Devoluciones

    #my $delete_button = "<button class=".$style."button type='button' name='delete_button' value='delete' title='Eliminar' onclick=\"document.forms[0].opt.value='cpendiente';document.forms[0].secuencial.value='$secuencial';document.forms[0].submit();\">".img({-src=>"/images/b_drop.png",-alt=>"b_drop.png",-border=>"0"}). "</button>";

    my $edit_button = "<button class=".$style."button type='button' name='edit_button' value='update' title='Editar' onclick=\"document.forms[0].opt.value='cpendiente';document.forms[0].secuencial.value='$secuencial';document.forms[0].opty.value='x';document.forms[0].submit();\">".img({-src=>"/images/b_edit.png",-alt=>"b_edit.png",-border=>"0"}). "</button>";


    my $str;
    if (param('optx') eq 'c') {   
       $str = "&nbsp;&nbsp;".img({-src=>"/images/arrow_ltr.png",-alt=>"arrow_ltr.png",-width=>"38",-height=>"22"}). "&nbsp;" .a({-href=>"?opt=cpendiente&secuencial=$secuencial&optx=$optx&checkmark=yes"},"Marcar") . "&nbsp;" . a({-href=>"?opt=cpendiente&secuencial=$secuencial&optx=$optx&checkmark=no"},"Quitar"). "&nbsp;&nbsp;Con Marcas&nbsp;&nbsp;&nbsp;$edit_button&nbsp;&nbsp;&nbsp;Sujeto al sistema de percepciones del IGV&nbsp;&nbsp;<input type='checkbox' name='pigv' $pigvmark\">";
    } else {
       $str = "&nbsp;&nbsp;".img({-src=>"/images/arrow_ltr.png",-alt=>"arrow_ltr.png",-width=>"38",-height=>"22"}). "&nbsp;" .a({-href=>"?opt=cpendiente&secuencial=$secuencial&optx=$optx&checkmark=yes"},"Marcar") . "&nbsp;" . a({-href=>"?opt=cpendiente&secuencial=$secuencial&optx=$optx&checkmark=no"},"Quitar") . "&nbsp;&nbsp;Con Marcas&nbsp;&nbsp;&nbsp;$edit_button";
    }


    if (param('opty') ne 'x') {
       print Tr({-class=>$style."FieldCaptionTD",-align=>"left"},td({-colspan=>"11",-class=>$style."lkitem"},$str));
    } else {
          print Tr({-class=>$style."FieldCaptionTD"},td({-align=>"center",-colspan=>"11"},button(-class=>$style."Button",-name=>"Actualizar",-OnClick=>"document.forms[0].opt.value='cpendiente';document.forms[0].opty.value='1';submit();")));
    }

    print Tr({-class=>$style."FieldCaptionTD",-align=>"right"},td({-colspan=>"10"},b("Valor Venta&nbsp;".get_sessiondata('simbolo_nac')."&nbsp;")),td(b(sprintf("%10.2f",$totalorden))));
    print Tr({-class=>$style."FieldCaptionTD",-align=>"right"},td({-colspan=>"10"},a({-href=>"?opt=cpendiente&secuencial=".param('secuencial')."&optx=c&opty=inafecto"},"Inafecto")."&nbsp;&nbsp;".b("Impuesto General a las Ventas&nbsp;". get_sessiondata('igv') * 100 . "%&nbsp;".get_sessiondata('simbolo_nac')."&nbsp;")),td(b(sprintf("%10.2f",$total_igv))));
    print Tr({-class=>$style."FieldCaptionTD",-align=>"right"},td({-colspan=>"10"},b("Total Orden&nbsp;".get_sessiondata('simbolo_nac')."&nbsp;")),td(b(sprintf("%10.2f",$totalorden + $total_igv))));
}


if ($tipodoc eq '5') {             # Linea de Comandos para Devoluciones
      if (param('opty') ne 'x') {
          print Tr({-class=>$style."FieldCaptionTD"},td({-colspan=>"11"},table({-align=>"center"},td(button(-class=>$style."Button",-name=>"Devolver",-OnClick=>"submit();")),td(button(-class=>$style."Button",-name=>"Imprimir",-OnClick=>"document.forms[0].opt.value='cpendiente';document.forms[0].imprime.value='1';submit();")),td(button(-class=>$style."Button",-name=>"Extornar",-OnClick=>"document.forms[0].opt.value='pendiente';document.forms[0].extorno.value='1';submit();")),td(button(-class=>$style."Button",-name=>"Regresar",-OnClick=>"document.forms[0].opt.value='pendiente';document.forms[0].opty.value='savehdr';submit();")))));
      }       
}

if ($tipodoc eq '4') {             # Linea de Comandos para OC

      if (param('opty') ne 'x') {
     #     print Tr({-class=>$style."FieldCaptionTD"},td({-colspan=>"11"},table({-align=>"center"},td(button(-class=>$style."Button",-name=>"Cerrar Operacion",-OnClick=>"submit();")),td(button(-class=>$style."Button",-name=>"Imprimir",-OnClick=>"document.forms[0].opt.value='cpendiente';document.forms[0].imprime.value='1';submit();")),td(button(-class=>$style."Button",-name=>"Extornar",-OnClick=>"document.forms[0].opt.value='pendiente';document.forms[0].extorno.value='1';submit();")),td(button(-class=>$style."Button",-name=>"Regresar",-OnClick=>"document.forms[0].opt.value='pendiente';document.forms[0].opty.value='savehdr';submit();")))));
      print Tr({-class=>$style."FieldCaptionTD"},td({-colspan=>"11"},table({-align=>"center"},td(button(-class=>$style."Button",-name=>"Cerrar Operacion",-OnClick=>"submit();")),td(button(-class=>$style."Button",-name=>"Imprimir",-OnClick=>"document.forms[0].opt.value='previapendiente';document.forms[0].optx.value='$optx';document.forms[0].secuencial.value='$secuencial';document.forms[0].proveedor.value='$proveedor';submit();")),td(button(-class=>$style."Button",-name=>"Extornar",-OnClick=>"document.forms[0].opt.value='pendiente';document.forms[0].extorno.value='1';submit();")),td(button(-class=>$style."Button",-name=>"Regresar",-OnClick=>"document.forms[0].opt.value='pendiente';document.forms[0].opty.value='savehdr';submit();")))));
     
      }       

} elsif ($tipodoc eq '1') {        # Linea de Comandos para pedidos

       if ($perfil == 4) {         # Jefe de almacen puede modificar

           my $delete_button = "<button class=".$style."button type='button' name='delete_button' value='delete' title='Eliminar' onclick=\"document.forms[0].opt.value='cpendiente';document.forms[0].opty.value='delete';document.forms[0].submit();\">".img({-src=>"/images/b_drop.png",-alt=>"b_drop.png",-border=>"0"}). "</button>";

           my $edit_button = "<button class=".$style."button type='button' name='edit_button' value='update' title='Modificar' onclick=\"document.forms[0].opt.value='cpendiente';document.forms[0].opty.value='x';document.forms[0].submit();\">".img({-src=>"/images/b_edit.png",-alt=>"b_edit.png",-border=>"0"}). "</button>";

           my $str = "&nbsp;&nbsp;".img({-src=>"/images/arrow_ltr.png",-alt=>"arrow_ltr.png",-width=>"38",-height=>"22"}). "&nbsp;" .a({-href=>"?opt=cpendiente&secuencial=$secuencial&optx=$optx&checkmark=yes"},"Marcar") . "&nbsp;" . a({-href=>"?opt=cpendiente&secuencial=$secuencial&optx=$optx&checkmark=no"},"Quitar"). "&nbsp;&nbsp;Con Marcas&nbsp;&nbsp;&nbsp;".$edit_button."&nbsp;&nbsp;&nbsp;".$delete_button;

          if (param('opty') ne 'x' and $rows) {  
              print Tr({-class=>$style."FieldCaptionTD",-align=>"left"},td({-colspan=>"11",-class=>$style."lkitem"},$str));
          }

          # Total pedido
          print Tr({-class=>$style."FieldCaptionTD",-align=>"right"},td({-colspan=>"6"},b("Total Pedido&nbsp;".get_sessiondata('simbolo_nac')."&nbsp;")),td(b(sprintf("%10.2f",$totalorden))));

          # Botonera
          if (param('opty') ne 'x') {  
              print Tr({-class=>$style."FieldCaptionTD"},td({-colspan=>"7"},table({-align=>"center"},td(button(-class=>$style."Button",-name=>"Entregar",-OnClick=>"submit();")),td(button(-class=>$style."Button",-name=>"Imprimir",-OnClick=>"document.forms[0].opt.value='cpendiente';document.forms[0].imprime.value='1';submit();")),td(button(-class=>$style."Button",-name=>"Extornar",-OnClick=>"document.forms[0].opt.value='pendiente';document.forms[0].extorno.value='1';submit();")),td(button(-class=>$style."Button",-name=>"Regresar",-OnClick=>"document.forms[0].opt.value='pendiente';submit();")))));
          } else {
             print Tr({-class=>$style."FieldCaptionTD"},td({-colspan=>"7"},table({-align=>"center"},td(button(-class=>$style."Button",-name=>"Actualizar",-OnClick=>"document.forms[0].opt.value='cpendiente';document.forms[0].opty.value='1';submit();")),td(button(-class=>$style."Button",-name=>"Regresar",-OnClick=>"document.forms[0].opt.value='cpendiente';document.forms[0].secuencial.value='".param('secuencial')."';document.forms[0].optx.value='p';submit();")))));
          }

       } else {              # El usuario solo puede ver la op que genero
           print Tr({-class=>$style."FieldCaptionTD"},td({-colspan=>"7"},table({-align=>"center"},td(button(-class=>$style."Button",-name=>"Regresar",-OnClick=>"document.forms[0].opt.value='pendiente';document.forms[0].optx.value='p';submit();")))));
       }
}

print "</table>\n";

print hidden(-name=>"opt",-value=>$execproc,-override=>1);
print hidden(-name=>"secuencial",-value=>"$secuencial",-override=>1);
print hidden(-name=>"proveedor",-value=>"$proveedor",-override=>1);
print hidden(-name=>"optx",-value=>"$optx",-override=>1);
print hidden(-name=>"opty",-value=>"",-override=>1);
print hidden(-name=>"extorno",-value=>"0",-override=>1);
print hidden(-name=>"imprime",-value=>"0",-override=>1);
print hidden(-name=>"manifiesto",-value=>$nummanifiesto,-override=>1);

print end_form();

# Enviar un mensaje al jefe de almacen y al receptor

# Regresar
#print "<br><center><a href='?opt=pendiente&optx=".param('optx')."' target='p2' title='Regresar'>".img({-src=>"/images/return.png",-border=>"0",-alt=>"return.png"})."</a></center>";

}



# -------------------------------------------------------
sub cleararray {
# -------------------------------------------------------
my ($sess_array) = @_;

if (defined(cookie('contab'))) {   # check session and & retrieve $sess_ref
    my $dbh = connectdb();
    if (my $sess_ref = opensession($dbh)) {
        my $cart_ref = $sess_ref->attr($sess_array);
        foreach my $tnum_id (keys(%{$cart_ref})) {
                delete($cart_ref->{$tnum_id});
        }
        $sess_ref->attr($sess_array,$cart_ref);
        $sess_ref->close();
    }
}

}


# -------------------------------------------------------
sub MontoOC {
# -------------------------------------------------------
my ($secuencial) = @_;

my ($ref,$sth,$dbh);
$dbh = connectdb();

my $sql="SELECT a.secuencial,a.interno,a.insumo,a.cantidad,a.descuento,a.costo,a.isc,a.flete,a.igv,b.descripcion,b.unidad,b.equivalencia,b.unidad_uso FROM almacendet a LEFT JOIN almacen b ON (a.insumo=b.insumo) WHERE a.secuencial='$secuencial'";
$sth = $dbh->prepare($sql);
$sth->execute();

my $neto;
while ($ref = $sth->fetchrow_hashref()) {
       $neto +=  $ref->{"flete"} * $ref->{"cantidad"} + ($ref->{'cantidad'} * $ref->{'costo'} * (1 - $ref->{'descuento'} * 0.01) * (1 + $ref->{'isc'} * 0.01));
}
return($neto);

}

#------------------------------------------------------
sub browsehistorico {
# -------------------------------------------------------
my $style  = get_sessiondata('cssname');
my $user   = get_sessiondata('user');
my $perfil = get_sessiondata('perfil');

#my @names = param;
#foreach (@names) { print $_ , " = ",param($_), "<br>"; }

my ($tipodoc,$almacen,$banner,$listtitle); 
if (param('optx') eq 'p') {
   $tipodoc = 1;
   $almacen = 1;
   $banner = "Hist&oacute;rico de Pedidos";
   $listtitle = "Pedidos";
} elsif (param('optx') eq 'c') {
   $tipodoc = 4;
   $almacen = 0;
   $banner = "Hist&oacute;rico de Gastos Varios";
   $listtitle = "Ordenes de Gastos";
} elsif (param('optx') eq 'd') {
   $tipodoc = 5;
   $almacen = 0;
   $banner = "Hist&oacute;rico de Devoluciones";
   $listtitle = "Ordenes de Devolucion";
} elsif (param('optx') eq 'a') {
   $tipodoc = 2;
   $banner = "Ajuste de Inventario";
   $listtitle = "Ajuste de Inventario";
}

my ($ref,$sth,$dbh);
$dbh = connectdb();

if (param('extorno') eq '1') {
    $dbh->do("UPDATE almacencab SET estado='2' WHERE secuencial='".param('secuencial')."'");
    # Anular el documento contable, 
    #$dbh->do("UPDATE cc_diariocab SET estado='1' WHERE secuencial=$secuencial_contab");
}

if (param('imprime') eq '1') {
    # Salida de reporte a array
    my $secuencial = param('secuencial');
    my $pq_almacen = get_sessiondata('pq_almacen');
    my $output;
    if (param('optx') eq 'c' or param('optx') eq 'd' or param('optx') eq 'a') {
        $output = get_sessiondata('scriptdir')."ordenf.pl ".$secuencial." 1";
    } elsif (param('optx') eq 'p') {
        $output = get_sessiondata('scriptdir')."pedido.pl ".$secuencial." 1";
    }
    my @list   = split /\n/ , `$output`;
    hardcopy (\@list,$pq_almacen);
}

if (param('genera_oc') eq '1') {
    GeneraOC(param('secuencial'));
}

if (param('genera_op') eq '1') {
    GeneraOP(param('secuencial'));
}

#topbanner($banner);

# -- scrolling_list periodo
my (%labels,@names,$last);
my $sql="SELECT date_format(fecha_ingreso,'%Y-%m') AS datetag FROM almacencab WHERE estado='1' and tipodoc='$tipodoc' and memo='1' AND almacen='$almacen' GROUP BY datetag ORDER BY datetag";
$sth = $dbh->prepare($sql);
$sth->execute();
while ($ref = $sth->fetchrow_hashref()) {
      $labels{$ref->{'datetag'}} = $ref->{'datetag'};
      push(@names,$ref->{'datetag'});
      $last = $ref->{'datetag'};
}

my $default = (param('datesel') eq '') ? $last : param('datesel');
#print "defecto: $default";
# -- scrolling_list dias
my (%labels1,@names1,$lastd);
my $sql = "SELECT date_format(fecha_ingreso,'%d') AS days FROM almacencab WHERE date_format(fecha_ingreso,'%Y-%m') = '$default' AND estado='1' and tipodoc='$tipodoc' and memo='1' AND almacen='$almacen' GROUP BY days ORDER BY fecha_ingreso DESC";

$lastd = $dbh->selectrow_array($sql . " LIMIT 1");

$sth = $dbh->prepare($sql);
$sth->execute();
while ($ref = $sth->fetchrow_hashref()) {
       $labels1{$ref->{'days'}} = $ref->{'days'};
       push(@names1,$ref->{'days'});
}

my $day_default;
if (param('optz') eq '') {
    $day_default = (param('days') eq '') ? $lastd : param('days');
} else {
    $day_default = $lastd;
}



print start_form();

print "<br><table border=0 align=center cellspacing=0 cellpadding=0>";

if (param('optx') eq 'c' or param('optx') eq 'd' ) {   # Compras y devoluciones
    print Tr(td(b("Per&iacute;odo&nbsp;:&nbsp;")),td({-align=>"center"},scrolling_list(-class=>$style."Select",-name=>"datesel",-values=>\@names,-labels=>\%labels,-default=>"$default",-size=>"1",-onchange=>"document.forms[0].optz.value='y';submit();")),td(img({-src=>"/images/spacer.gif",-alt=>"spacer.gif",-width=>"20",-height=>"1"})),td({-align=>"center"},scrolling_list(-class=>$style."Select",-name=>"days",-values=>\@names1,-labels=>\%labels1,-default=>"$day_default",-size=>"1",-onchange=>"submit();")),td(img({-src=>"/images/spacer.gif",-alt=>"spacer.gif",-width=>"20",-height=>"1"})),td(b("Busca Proveedor:&nbsp;")),td(textfield(-name=>"provee",-value=>"",-size=>"12",-maxlength=>"12",-onchange=>"submit();")),td(b("&nbsp;Orden#:&nbsp;")),td(textfield(-name=>"orden_num",-value=>"",-size=>"6",-maxlength=>"6",-onchange=>"submit();")));

} elsif (param('optx') eq 'p') {     # Pedidos 
    print Tr(td(b("Per&iacute;odo&nbsp;:&nbsp;")),td({-align=>"center"},scrolling_list(-class=>$style."Select",-name=>"datesel",-values=>\@names,-labels=>\%labels,-default=>"$default",-size=>"1",-onchange=>"document.forms[0].optz.value='y';submit();"),td(img({-src=>"/images/spacer.gif",-alt=>"spacer.gif",-width=>"20",-height=>"1"})),td({-align=>"center"},scrolling_list(-class=>$style."Select",-name=>"days",-values=>\@names1,-labels=>\%labels1,-default=>"$day_default",-size=>"1",-onchange=>"submit();"))));
} else {                             # Ajustes
    print Tr(td(b("Per&iacute;odo&nbsp;:&nbsp;")),td({-align=>"center"},scrolling_list(-class=>$style."Select",-name=>"datesel",-values=>\@names,-labels=>\%labels,-default=>"$default",-size=>"1",-onchange=>"document.forms[0].optz.value='y';submit();"),td(img({-src=>"/images/spacer.gif",-alt=>"spacer.gif",-width=>"20",-height=>"1"})),td({-align=>"center"},scrolling_list(-class=>$style."Select",-name=>"days",-values=>\@names1,-labels=>\%labels1,-default=>"$day_default",-size=>"1",-onchange=>"submit();"))));
} 

print hidden(-name=>"opt",-value=>"historico",-override=>1);
print hidden(-name=>"optx",-value=>param('optx'),-override=>1);
print hidden(-name=>"optz",-value=>"",-override=>1);
print "</table>";

print end_form();

my $search_criteria = (param('provee') ne '') ? " AND b.dsc LIKE '%".param('provee')."%'" : '';
my $dating_criteria = " AND date_format(fecha_ingreso,'%Y-%m-%d')='". $default . "-". $day_default. "'";

my $sql;

# **************
# Paginador
# **************
my $lpp = 15;   # lineas por pagina


if (grep(/Contab/,$ENV{'REQUEST_URI'})) {       # Compras, Pedidos y Ajustes (llama almacenx)
    if (param('optx') eq 'c' or param('optx') eq 'd') {
        if ($search_criteria ne '') {
            $dating_criteria = " AND date_format(fecha_ingreso,'%Y-%m')='$default'";
        }
        $sql="SELECT count(*) AS records FROM almacencab a,cc_anexo b WHERE (a.proveedor=b.cuenta) AND estado='1' AND memo=1 AND almacen='$almacen' AND tipodoc='$tipodoc' $dating_criteria $search_criteria";
    } elsif (param('optx') eq 'p' or param('optx') eq 'a') {
        $sql="SELECT count(*) AS records FROM almacencab WHERE estado='1' AND memo=1 AND almacen='$almacen' AND tipodoc='$tipodoc' $dating_criteria";
   }
}else{
	if (param('optx') eq 'c' or param('optx') eq 'd') {
        if ($search_criteria ne '') {
            $dating_criteria = " AND date_format(fecha_ingreso,'%Y-%m')='$default'";
        }
        $sql="SELECT count(*) AS records FROM almacencab a,cc_anexo b WHERE (a.proveedor=b.cuenta) AND estado='1' AND memo=1 AND almacen='$almacen' AND tipodoc='$tipodoc' $dating_criteria $search_criteria";
    } 
	}

#print $sql,"<br>";

my $records   = (param('orden_num') eq '') ? $dbh->selectrow_array ($sql) : 0;
my $pages     = int($records/$lpp) + (($records % $lpp > 0) ? 1 : 0);
my $firstpage = (param('param1') eq '') ? 1 : param('param1');
my $lastpage  = ($firstpage + 15 < $pages) ?  $firstpage + 15 : $pages;
my $offset    = (param('offset') eq '') ? 0 : param('offset');
my $pageno    = ($offset + $lpp)  / $lpp;   # Pagina actual
# **************

#print $records,"-",$pages,"<br>";

if (grep(/Contab/,$ENV{'REQUEST_URI'})) {  # Llaman de almacenx
#print "<br>Dentro de moodulo contable<br>";
    if (param('optx') eq 'c') {  
        if ($search_criteria ne '') {
            $dating_criteria = " AND date_format(fecha_ingreso,'%Y-%m')='$default'";
        }
        $sql="SELECT secuencial,usuario,fecha,fecha_ingreso,proveedor,estado,a.referencia,guia,factura FROM almacencab a, cc_anexo b WHERE (a.proveedor=b.cuenta) AND estado='1' AND memo=1 AND almacen='0' AND tipodoc='4' $dating_criteria $search_criteria ORDER BY secuencial LIMIT $offset,$lpp";
        if (param('orden_num') ne '') {
            $sql="SELECT secuencial,usuario,fecha,fecha_ingreso,proveedor,estado,a.referencia,guia,factura FROM almacencab a, cc_anexo b WHERE (a.proveedor=b.cuenta) AND estado='1' AND memo=1 AND almacen='0' AND tipodoc='4' AND a.referencia = " .param('orden_num');
        }
    }

    if (param('optx') eq 'd') {  
        if ($search_criteria ne '') {
            $dating_criteria = " AND date_format(fecha_ingreso,'%Y-%m')='$default'";
        }

        $sql="SELECT secuencial,usuario,fecha,fecha_ingreso,proveedor,estado,a.referencia,guia,factura FROM almacencab a, cc_anexo b WHERE (a.proveedor=b.cuenta) AND estado='1' AND memo=1 AND almacen='0' AND tipodoc='5'";

        if (param('orden_num') ne '') {
            $sql .= " AND referencia = " .param('orden_num');
        } else {
            $sql .= " $dating_criteria $search_criteria ORDER BY secuencial LIMIT $offset,$lpp";
        }
    }

    if (param('optx') eq 'a' or param('optx') eq 'p') {   
       $sql="SELECT secuencial,usuario,fecha,fecha_ingreso,estado,referencia FROM almacencab WHERE estado='1' AND memo=1 AND tipodoc='$tipodoc' $dating_criteria LIMIT $offset,$lpp";
    }
}else{
	print "<br>Dentro de modulo contable de gastos<br>";
	  if (param('optx') eq 'c') {  
        if ($search_criteria ne '') {
            $dating_criteria = " AND date_format(fecha_ingreso,'%Y-%m')='$default'";
        }
        $sql="SELECT secuencial,usuario,fecha,fecha_ingreso,proveedor,estado,a.referencia,guia,factura FROM almacencab a, cc_anexo b WHERE (a.proveedor=b.cuenta) AND estado='1' AND memo=1 AND almacen='0' AND tipodoc='4' $dating_criteria $search_criteria ORDER BY secuencial LIMIT $offset,$lpp";
        if (param('orden_num') ne '') {
            $sql="SELECT secuencial,usuario,fecha,fecha_ingreso,proveedor,estado,a.referencia,guia,factura FROM almacencab a, cc_anexo b WHERE (a.proveedor=b.cuenta) AND estado='1' AND memo=1 AND almacen='0' AND tipodoc='4' AND a.referencia = " .param('orden_num');
        }
    }
    
    
	}



#print $sql,"<br>";

$sth = $dbh->prepare($sql);
$sth->execute();

if (!$sth->rows) {
    Aviso("No existen &oacute;rdenes hist&oacute;ricas",$style);
    regresar_historico();
    return;
}

# Despliega las ordenes
print "<table border=0 align=center cellspacing=2 cellpadding=2 class=".$style."FormTABLE>";

print Tr({-class=>$style."FormHeaderFont"},td({-colspan=>"8"},b("Hist&oacute;rico de $listtitle")));

if (param('optx') eq 'c' or param('optx') eq 'd' ) {   # Compras y devoluciones
    print Tr({-class=>$style."FormHeaderFont"},td({-width=>"50"},"#"),td("Fecha Orden"),td("Fecha Ingreso"),td("Razon Social"),td("Usuario"),td("Guia"),td("Nro Doc"),td("Importe"));
} else {                                               # Pedidos y Ajustes 
    print Tr({-class=>$style."FormHeaderFont"},td({-width=>"50"},"#"),td("Fecha Orden"),td("Fecha Ingreso"),td("Usuario"),td("Importe"));
}




while ($ref = $sth->fetchrow_hashref()) {
       print "<tr class=".$style."FieldCaptionTD>";
     #  my $link = "?opt=chistorico&optx=".param('optx')."&secuencial=$ref->{'secuencial'}&offset=$offset&param1=".param('param1')."&datesel=".param('datesel')."&days=".param('days')."&provee=".param('provee');
       #print "<td align=center><a href='$link' title='Ver Orden' target='p2'>$ref->{'referencia'}</a></td>";

       my $link = "?opt=chistorico&optx=".param('optx')."&secuencial=$ref->{'secuencial'}";
       #my $link = "#";
       print "<td align=center><a href='$link' title='Ver Orden' onclick=\"window.open('$link','p3','scrollbars=yes,resizable=yes,width=700,height=400');return false;\">$ref->{'referencia'}</a></td>";
       print "<td align=left>".substr($ref->{'fecha'},0,10)         ."</td>";
       print "<td align=left>".substr($ref->{'fecha_ingreso'},0,10) ."</td>";
       if (param('optx') eq 'c' or param('optx') eq 'd') {
          print "<td align=left>".nombreproveedor($ref->{'proveedor'})."</td>";
       }
       print "<td align=center>$ref->{'usuario'}</td>";
       if (param('optx') eq 'c' or param('optx') eq 'd') {
           print "<td>$ref->{'guia'}</td><td>$ref->{'factura'}</td><td align=right>".sprintf("%10.2f",MontoOC($ref->{'secuencial'}))."</td>";
       } else {
           print "<td align=center>$ref->{'estado'}</td>";
           #print "<td align=right>".commify(sprintf("%10.2f",MontoOS($ref->{'secuencial'})))."</td>";
       }
       print "</tr>";
}

print "</table>";

# **************
# Paginador
# **************
talonpaginador($firstpage,$lastpage,$lpp,$pageno,$pages,"?opt=historico&optx=".param('optx')."&datesel=".param('datesel')."&days=$day_default&provee=".param('provee'));

regresar_historico();   # Regresar

}

# -------------------------------------------------------
sub ingresacompra { 
# -------------------------------------------------------
# 1 . Ingresan las mercaderias por compras. Aceptas parciales ?
# almacen = 0 ->  Almacen Central
# almacen = 1 ->  Almacen de Punto de Venta

my $dbh = connectdb();

# 1. Actualiza estado = 1 (recibido) , guia , factura y fecha_ingreso en almacencab

my $ldiario     = param('ldiario');
my $fecha_conta = param('fecha');
my $glosa       = param('glosa');
my $tc_compra   = param('tc_compra');
my $tipodoc     = param('tipodoc');
my $docid       = param('factcompra');
my $ruc         = param('ruc');
my $referencia1  = param('referencia');
#print "tipodoc ingresado: ".$tipodoc;

$dbh->do("UPDATE almacencab SET estado='1',guia='".param('guiacompra')."',factura='".param('factcompra')."',fecha_ingreso='".param('fecha_ingreso')."' WHERE secuencial='".param('secuencial')."'") or (my $err=$DBI::errstr);
print $err,"<br>" if($err);



# 2. Actualiza cantidades y precios de compra en almacendet
my @insumo   = param('insumo');
my @cantidad = param('cantidad');
my @costo    = param('costo');
my $i = 0;

foreach my $key (@insumo) {   # Actualiza posibles cambios ?
        $dbh->do("UPDATE almacendet SET cantidad='".$cantidad[$i]."',costo='".$costo[$i++]."' WHERE insumo='".$key."' AND secuencial='".param('secuencial')."'");
}
#print "$referencia1 : secuencial enviada: ".param('secuencial').", manifiesto:".param('manifiesto');
# Escribe el asiento de contabilidad
my ($referencia,$moneda,$tc_compra,$ruc) = $dbh->selectrow_array("SELECT referencia,moneda,tc_compra,proveedor FROM almacencab WHERE secuencial='".param('secuencial')."'");
escribe_comprobante_compra($referencia,$moneda,$tc_compra,param('secuencial'),$ldiario,$fecha_conta,$glosa,$tc_compra,$tipodoc,$docid,$ruc,$referencia1 );



}

# Determina la cuenta debe donde debe cargar el insumo comprado
# -----------------------------------
sub cuenta_inventario {
# -----------------------------------
my ($insumo) = @_;
														    
my $dbh = connectdb();
my $sql = "SELECT cuenta FROM cc_tcuenta WHERE tcuenta ='".$insumo. "'";
my $cta = $dbh->selectrow_array($sql);

}

# -----------------------------------
sub cuenta_destino {
# -----------------------------------
my ($insumo) = @_;
														    
my $dbh = connectdb();
my $sql = "SELECT destino FROM cc_tcuenta WHERE tcuenta ='".$insumo. "'";
my $cta = $dbh->selectrow_array($sql);

}

# Determina la cuenta debe del proveedor (su # de ruc)
# -----------------------------------
sub cuenta_proveedor {
# -----------------------------------
my ($ruc) = @_;
my $dbh = connectdb();
#my $sql = "SELECT cuenta FROM cc_cuentas WHERE ruc='$ruc' AND cuenta LIKE '421%'";
my $sql = "SELECT scuenta FROM cc_tipoanexo WHERE cuenta='$ruc'";
my $cta = $dbh->selectrow_array($sql);
return $cta;


}



# -------------------------------------------------------
sub escribe_comprobante_compra_original {
# -------------------------------------------------------
my ($referencia,$moneda,$tc_compra,$almacencab_secuencial,$ldiario,$fecha_conta,$glosa,$tc_compra,$tipodoc,$docid,$ruc,$referencia1) = @_;

#escribe_comprobante_compra($referencia,$moneda,$tc_compra,param('secuencial'),$ldiario,$fecha_conta,$glosa,$tc_compra,$tipodoc,$docid,$ruc,$referencia1 );

#my @names = param;
#foreach (@names) { print $_ , " = ",param($_), "<br>"; }

my $dbh = connectdb();
														    
my $err;

my $uid         = $$."-".$ENV{'REMOTE_ADDR'}."-".$referencia;
#my $fecha_conta = $dbh->selectrow_array("SELECT fecha_ingreso FROM almacencab WHERE secuencial='$almacencab_secuencial'");
my $user        = get_sessiondata('user');
#my $ruc         = param('proveedor');
my $seccion	= get_sessiondata('seccion');

print "  ,seccion: $seccion, con cuenta:".substr(cuenta_proveedor($seccion),0,2);
# La cabecera
$dbh->do("INSERT INTO cc_diariocab
     (uid,diario,tc_compra,tipodoc,docid,ruc,glosa,estado,fecha_conta,moneda,referencia,usuario)
     VALUES(?,?,?,?,?,?,?,?,?,?,?,?)",undef,
     $uid,
     $ldiario,
     $tc_compra,
     $tipodoc,
     $docid,
     $ruc,
     $glosa,
     0,
     $fecha_conta,
     $moneda,
     $referencia1,
     $user
     ) or ($err=$DBI::errstr);
														    
print $err,"<br>" if ($err);

# Donde insertaste mi registro?
my ($diariocab_secuencial) = $dbh->selectrow_array("SELECT secuencial FROM cc_diariocab WHERE uid='$uid'");

# Almacena diariocab_secuencial en el campo secuencial_contab de la tabla almacencab
$dbh->do("UPDATE almacencab SET secuencial_contab=$diariocab_secuencial WHERE secuencial=$almacencab_secuencial");


# Obtiene los insumos de almacendet, busca las cuentas contables asocisdas y escribe en cc_diariodet
my $sql = "SELECT secuencial,interno,insumo,cantidad,costo,descuento,isc,flete,igv FROM almacendet WHERE secuencial='$almacencab_secuencial'";
#print $sql;

my $sth = $dbh->prepare($sql);
$sth->execute();
														    
my ($neto,$total_orden,$total_igv);
my $old_cuenta_inventario;
my ($cuenta_inventario,$cuenta_destino);
my $total_cuenta_inventario;
my $k = 0;
														    
my $ref;
my ($soles,$dolar);
while ($ref = $sth->fetchrow_hashref()) {
														    
$cuenta_inventario = cuenta_inventario($ref->{'insumo'});
$cuenta_destino = cuenta_destino($ref->{'insumo'});
														    
$neto = $ref->{"flete"} * $ref->{"cantidad"} + ($ref->{'cantidad'} * $ref->{'costo'} * (1 - $ref->{'descuento'} * 0.01) * (1 + $ref->{'isc'} * 0.01)) / (1 + 0.01 * $ref->{'igv'});
														    
if ($old_cuenta_inventario ne $cuenta_inventario and $k > 0) {
  $soles = $total_cuenta_inventario;
  $dolar = ($tc_compra > 0) ? $total_cuenta_inventario / $tc_compra : 0;
  insert_diariodet2($diariocab_secuencial,$old_cuenta_inventario,"0",$soles,$dolar);
  $total_cuenta_inventario = 0;
}
$k++;
														    
$old_cuenta_inventario = $cuenta_inventario;

$total_cuenta_inventario += $neto;
$total_orden += $neto;
$total_igv   += $neto * $ref->{'igv'} * 0.01;
}
														    
# Inserta el detalle
# Los valores estan en su moneda de origen

$soles = $total_cuenta_inventario;
$dolar = ($tc_compra > 0) ? $total_cuenta_inventario / $tc_compra : 0;
insert_diariodet2($diariocab_secuencial,$cuenta_inventario,"0",$soles,$dolar);

#if ((substr(cuenta_proveedor($seccion),0,2) ne '63') or (substr(cuenta_proveedor($seccion),0,2) ne '68') or (substr(cuenta_proveedor($seccion),0,2) ne '46') )
if ((substr(cuenta_proveedor($seccion),0,2) ne '63') or (substr(cuenta_proveedor($seccion),0,2) ne '68') )

{
	my $ctproveedor = substr(cuenta_proveedor($seccion),0,2);
	
	#if ($ctproveedor != 46){
		#print "<br> cuenta proovedor: ".substr(cuenta_proveedor($seccion),0,2);
	insert_diariodet2($diariocab_secuencial,$cuenta_destino,"0",$soles,$dolar);
 insert_diariodet2($diariocab_secuencial,'791000',"1",$soles,$dolar);

		#}
 
}



$soles = $total_igv;
$dolar = ($tc_compra > 0) ? $total_igv / $tc_compra : 0;
insert_diariodet2($diariocab_secuencial,'401200',"0",$soles,$dolar);

$soles = $total_orden + $total_igv;
$dolar = ($tc_compra > 0) ? ($total_orden + $total_igv) / $tc_compra : 0;
insert_diariodet2($diariocab_secuencial,cuenta_proveedor($seccion),"1",$soles,$dolar);










# Asiento de percepcion
if (param('pigv') eq 'on') {
   my $uid         = $$."-".$ENV{'REMOTE_ADDR'}."-".time();
   my $ldiario     = '12';
   # La cabecera
   $dbh->do("INSERT INTO cc_diariocab
           (uid,diario,tc_compra,tipodoc,docid,ruc,glosa,estado,fecha_conta,moneda,referencia,usuario)
            VALUES(?,?,?,?,?,?,?,?,?,?,?,?)",undef,
           $uid,
           $ldiario,
           $tc_compra,
           $tipodoc,
           $docid,
           $ruc,
           "*** PERCEPCION IGV ***",
           0,
           $fecha_conta,
           $moneda,
           "",
          $user
        ) or ($err=$DBI::errstr);

        print $err,"<br>" if ($err);

   # Donde insertaste mi registro?
   my ($diariocab_secuencial) = $dbh->selectrow_array("SELECT secuencial FROM cc_diariocab WHERE uid='$uid'");

   my $percepcion_igv = 0.02;
   $soles  = ($total_orden + $total_igv);
   $soles *= $percepcion_igv;
   $dolar  = ($tc_compra > 0) ? ($total_orden + $total_igv) / $tc_compra : 0;
   $dolar *= $percepcion_igv;

   insert_diariodet2($diariocab_secuencial,      '4012000'        ,"0",$soles,$dolar);
   insert_diariodet2($diariocab_secuencial,cuenta_proveedor($seccion),"1",$soles,$dolar);

}





}

# -------------------------------------------------------
sub escribe_comprobante_compra {
# -------------------------------------------------------
my ($referencia,$moneda,$tc_compra,$almacencab_secuencial,$ldiario,$fecha_conta,$glosa,$tc_compra,$tipodoc,$docid,$ruc,$referencia1) = @_;

#escribe_comprobante_compra($referencia,$moneda,$tc_compra,param('secuencial'),$ldiario,$fecha_conta,$glosa,$tc_compra,$tipodoc,$docid,$ruc,$referencia1 );

#my @names = param;
#foreach (@names) { print $_ , " = ",param($_), "<br>"; }

my $dbh = connectdb();
														    
my $err;

my $uid         = $$."-".$ENV{'REMOTE_ADDR'}."-".$referencia;
#my $fecha_conta = $dbh->selectrow_array("SELECT fecha_ingreso FROM almacencab WHERE secuencial='$almacencab_secuencial'");
my $user        = get_sessiondata('user');
#my $ruc         = param('proveedor');
#my $seccion	= get_sessiondata('seccion');
my $seccion	= sprintf("%02d",param('manifiesto'));

# La cabecera
$dbh->do("INSERT INTO cc_diariocab
     (uid,diario,tc_compra,tipodoc,docid,ruc,glosa,estado,fecha_conta,moneda,referencia,usuario)
     VALUES(?,?,?,?,?,?,?,?,?,?,?,?)",undef,
     $uid,
     $ldiario,
     $tc_compra,
     $tipodoc,
     $docid,
     $ruc,
     $glosa,
     0,
     $fecha_conta,
     $moneda,
     $referencia1,
     $user
     ) or ($err=$DBI::errstr);
														    
print $err,"<br>" if ($err);
print "<br>cuenta almacen: $almacencab_secuencial , cuenta: ".substr(cuenta_proveedor($seccion),0,1);
print "<br>tipo de cuenta:".substr(cuenta_proveedor($seccion),0,2);
# Donde insertaste mi registro?
my ($diariocab_secuencial) = $dbh->selectrow_array("SELECT secuencial FROM cc_diariocab WHERE uid='$uid'");

# Almacena diariocab_secuencial en el campo secuencial_contab de la tabla almacencab
$dbh->do("UPDATE almacencab SET secuencial_contab=$diariocab_secuencial WHERE secuencial=$almacencab_secuencial");


# Obtiene los insumos de almacendet, busca las cuentas contables asocisdas y escribe en cc_diariodet
my $sql = "SELECT secuencial,interno,insumo,cantidad,costo,descuento,isc,flete,igv FROM almacendet WHERE secuencial='$almacencab_secuencial'";
#print $sql;

my $sth = $dbh->prepare($sql);
$sth->execute();
														    
my ($neto,$total_orden,$total_igv);
my $old_cuenta_inventario;
my ($cuenta_inventario,$cuenta_destino);
my $total_cuenta_inventario;
my $k = 0;
														    
my $ref;
my ($soles,$dolar);
while ($ref = $sth->fetchrow_hashref()) {
														    
$cuenta_inventario = cuenta_inventario($ref->{'insumo'});
$cuenta_destino = cuenta_destino($ref->{'insumo'});
	$neto = $ref->{"flete"} * $ref->{"cantidad"} + ($ref->{'cantidad'} * $ref->{'costo'} * (1 - $ref->{'descuento'} * 0.01) * (1 + $ref->{'isc'} * 0.01)) / (1 + 0.01 * $ref->{'igv'});
														    
#if ($old_cuenta_inventario ne $cuenta_inventario and $k > 0) {
#  $soles = $total_cuenta_inventario;
#  $dolar = ($tc_compra > 0) ? $total_cuenta_inventario / $tc_compra : 0;
  
#  print "<br>seccion :$seccion ,cuenta inventario: $cuenta_inventario, cuenta destino: $cuenta_destino";													    
#  print "<br>dh:0 ingresando cuenta : $old_cuenta_inventario"; 
#  insert_diariodet2($diariocab_secuencial,$old_cuenta_inventario,"0",$soles,$dolar);
#  $total_cuenta_inventario = 0;
#}
#$k++;
														    
$old_cuenta_inventario = $cuenta_inventario;

$total_cuenta_inventario += $neto;
$total_orden += $neto;
$total_igv   += $neto * $ref->{'igv'} * 0.01;
}
														    
# Inserta el detalle
# Los valores estan en su moneda de origen


if($cuenta_inventario eq '501000'){
	$soles = $total_cuenta_inventario;
$dolar = ($tc_compra > 0) ? $total_cuenta_inventario / $tc_compra : 0;
insert_diariodet2($diariocab_secuencial,$cuenta_inventario,"1",$soles,$dolar);


}else{
	$soles = $total_cuenta_inventario;
$dolar = ($tc_compra > 0) ? $total_cuenta_inventario / $tc_compra : 0;
    if (substr(cuenta_proveedor($seccion),0,1) eq '6'){
     print "<br> dh=1 cuenta:".$cuenta_inventario;
     insert_diariodet2($diariocab_secuencial,$cuenta_inventario,"1",$soles,$dolar);
    }else{
  	print "<br> dh=0 cuenta:".$cuenta_inventario;
  	insert_diariodet2($diariocab_secuencial,$cuenta_inventario,"0",$soles,$dolar);
  	}




	
	}


if($cuenta_inventario ne '501000'){
	  #if(substr(cuenta_proveedor($seccion),0,2) ne '63' or substr(cuenta_proveedor($seccion),0,2) ne '68')
    #{
	print "<br>se imprime con cuenta proovedor que no es 63 y 68 , con cuenta: ".$cuenta_destino;
	#if (substr(cuenta_proveedor($seccion),0,2) ne '63'){
		#print "<br>se imprime con cuenta proovedor que no es 63";
		# insert_diariodet2($diariocab_secuencial,$cuenta_destino,"0",$soles,$dolar);
 #insert_diariodet2($diariocab_secuencial,'791000',"1",$soles,$dolar);
	#	}
	#if (substr(cuenta_proveedor($seccion),0,2) ne '68'){
		#print "<br>se imprime con cuenta proovedor que no es 68";
		# insert_diariodet2($diariocab_secuencial,$cuenta_destino,"0",$soles,$dolar);
 #insert_diariodet2($diariocab_secuencial,'791000',"1",$soles,$dolar);
	#	}
	
	
	if (substr(cuenta_proveedor($seccion),0,1) eq '6'){
	    		 if (substr(cuenta_proveedor($seccion),0,2) eq '62'){
	 	           insert_diariodet2($diariocab_secuencial,'942000',"0",$soles,$dolar);
	         }else{
	          	 insert_diariodet2($diariocab_secuencial,'791000',"0",$soles,$dolar);
		       }
	             insert_diariodet2($diariocab_secuencial,$cuenta_destino,"1",$soles,$dolar);
	
	}else{
		insert_diariodet2($diariocab_secuencial,'791000',"1",$soles,$dolar);		
    insert_diariodet2($diariocab_secuencial,$cuenta_destino,"0",$soles,$dolar);
		}

 
  #}
}





$soles = $total_igv;
$dolar = ($tc_compra > 0) ? $total_igv / $tc_compra : 0;
if($cuenta_inventario eq '501000'){
	insert_diariodet2($diariocab_secuencial,'401200',"1",$soles,$dolar);
}else{
	insert_diariodet2($diariocab_secuencial,'401200',"0",$soles,$dolar);
	}



	$soles = $total_orden + $total_igv;
$dolar = ($tc_compra > 0) ? ($total_orden + $total_igv) / $tc_compra : 0;


if($cuenta_inventario eq '501000'){
		 insert_diariodet2($diariocab_secuencial,$cuenta_destino,"0",$soles,$dolar);
}else{
	   if (substr(cuenta_proveedor($seccion),0,1) eq '6'){
	   	print "<br>-dh:0  cuenta:".cuenta_proveedor($seccion);
	  	insert_diariodet2($diariocab_secuencial,cuenta_proveedor($seccion),"0",$soles,$dolar);
	  }else{
	  	print "<br>dh:1  cuenta:".cuenta_proveedor($seccion);
	  	insert_diariodet2($diariocab_secuencial,cuenta_proveedor($seccion),"1",$soles,$dolar);
	 	}
	
	
	

	}













# Asiento de percepcion
if (param('pigv') eq 'on') {
   my $uid         = $$."-".$ENV{'REMOTE_ADDR'}."-".time();
   my $ldiario     = '12';
   # La cabecera
   $dbh->do("INSERT INTO cc_diariocab
           (uid,diario,tc_compra,tipodoc,docid,ruc,glosa,estado,fecha_conta,moneda,referencia,usuario)
            VALUES(?,?,?,?,?,?,?,?,?,?,?,?)",undef,
           $uid,
           $ldiario,
           $tc_compra,
           $tipodoc,
           $docid,
           $ruc,
           "*** PERCEPCION IGV ***",
           0,
           $fecha_conta,
           $moneda,
           "",
          $user
        ) or ($err=$DBI::errstr);

        print $err,"<br>" if ($err);

   # Donde insertaste mi registro?
   my ($diariocab_secuencial) = $dbh->selectrow_array("SELECT secuencial FROM cc_diariocab WHERE uid='$uid'");

   my $percepcion_igv = 0.02;
   $soles  = ($total_orden + $total_igv);
   $soles *= $percepcion_igv;
   $dolar  = ($tc_compra > 0) ? ($total_orden + $total_igv) / $tc_compra : 0;
   $dolar *= $percepcion_igv;

   insert_diariodet2($diariocab_secuencial,      '401200'        ,"0",$soles,$dolar);
   insert_diariodet2($diariocab_secuencial,cuenta_proveedor($seccion),"1",$soles,$dolar);

}





}
# -----------------------------------
sub insert_diariodet2 {
# -----------------------------------
my ($secuencial,$cuenta,$dh,$soles,$dolar) = @_;

if ($cuenta eq '103000') { $dh=1; } #RICHIE
												    
my $err;
my $dbh = connectdb();
$dbh->do("INSERT INTO cc_diariodet(secuencial,cuenta,dh,soles,dolar) VALUES ('$secuencial','$cuenta','$dh','$soles','$dolar')") or ($err=$DBI::errstr);
														    
print $err,"\n" if ($err);
														    
}


# -------------------------------------------------------
sub regresar_historico {
# -------------------------------------------------------
my $ret;

if (param('optx') eq 'p') {
   $ret="?opt=pedido";
} elsif (param('optx') eq 'c') {
   $ret="?opt=compra";
} elsif (param('optx') eq 'd') {
   $ret="?opt=devolucion";
} elsif (param('optx') eq 'a') {
   $ret="?opt=ajuste";
}

# Regresar

print "<br><center><a href='$ret'  title='Regresar'>".img({-src=>"/images/return.png",-border=>"0",-alt=>"return.png"})."</a></center>";

}
# -------------------------------------------------------
sub Aviso {  
# -------------------------------------------------------
my ($message,$style) = @_;
print "<br><br><br><br><br><table align=center><tr align=center><td class=".$style."smitem>".$message."</td></tr></table>";
}



# -------------------------------------------------------
sub browsependiente {
# -------------------------------------------------------
my ($mensaje) = @_;

my $style  = get_sessiondata('cssname');
my $user   = get_sessiondata('user');
my $perfil = get_sessiondata('perfil');

#my @names = param;
#foreach (@names) { print $_ , " = ",param($_), "<br>"; }

# tipodoc
# 0 = insumo utilizado (pos)
# 1 = pedido
# 2 = ajuste
# 3 = insumo anulacion (pos)
# 4 = compra
# 5 = devolucion

my ($tipodoc,$almacen,$banner,$listtitle); 
if (param('optx') eq 'p') {
   $tipodoc = '1';
   $almacen = 1;
   $banner = "Ordenes  pendientes";
   $listtitle = "Pedidos";
} elsif (param('optx') eq 'd') {
   $tipodoc = '5';
   $almacen = 0;
   $banner = "Ordenes  pendientes";
   $listtitle = "Devoluciones";
} elsif (param('optx') eq 'c') {
   $tipodoc = '4';
   $almacen = 0;
   $banner = "Gastos  pendientes";
   $listtitle = "Compra";
}

my ($ref,$sth,$dbh);
$dbh = connectdb();

if (param('opty') eq '1') {         # Obsoleto
   $dbh->do("UPDATE almacencab SET aprobado='1',memo='".param('memo')."' WHERE secuencial='".param('secuencial')."'");
} elsif (param('opty') eq '0') {
   $dbh->do("UPDATE almacencab SET aprobado='0',memo='".param('memo')."' WHERE secuencial='".param('secuencial')."'");
}

if (param('opty') eq 'savehdr') {   #  guarda cambios de la cabecera : boton regresar de contenidopendiente
   $dbh->do("UPDATE almacencab SET guia='".param('guiacompra')."',factura='".param('factcompra')."',fecha='".param('fecha')."',fecha_ingreso='".param('fecha_ingreso')."' WHERE secuencial='".param('secuencial')."'") or (my $err=$DBI::errstr);
   print $err,"<br>" if($err);
}

if (param('extorno') eq '1') {      # Extorna el documento
   $dbh->do("UPDATE almacencab SET estado='2' WHERE secuencial='".param('secuencial')."'");
}

#if (param('imprime') eq '1') {      # Imprime pendiente y guarda cambios de la cabecera

#   $dbh->do("UPDATE almacencab SET guia='".param('guiacompra')."',factura='".param('factcompra')."',fecha_ingreso='".param('fecha_ingreso')."' WHERE secuencial='".param('secuencial')."'") or (my $err=$DBI::errstr);
#   print $err,"<br>" if($err);

#   my $secuencial = param('secuencial');
#   my $pq_almacen = get_sessiondata('pq_almacen');

#   my $output;
#   if (param('optx') eq 'c') {
#       $output = get_sessiondata('scriptdir')."ordenf.pl ".$secuencial." 0";
#   } elsif (param('optx') eq 'p') {
#       $output = get_sessiondata('scriptdir')."pedido.pl ".$secuencial." 0";
#   }

#   my @list   = split /\n/ , `$output`;
#   hardcopy (\@list,$pq_almacen);
#   hardcopy (\@list,$pq_almacen);
#}

my $sql;
# **************
# Paginador
# **************
my $lpp = 15;   # lineas por pagina

# Calcula el numero de paginas
if ($perfil == 5) {
    $sql="SELECT count(*) AS records FROM almacencab WHERE estado='0' AND almacen='$almacen' AND tipodoc='$tipodoc' AND usuario='$user'";
} elsif ($perfil == 4 or $perfil <= 1) {
    $sql="SELECT count(*) AS records FROM almacencab WHERE estado='0' AND almacen='$almacen' AND tipodoc='$tipodoc'";
}

#print $sql,"<br>";

my $records   = $dbh->selectrow_array ($sql);
my $pages     = int($records/$lpp) + (($records % $lpp > 0) ? 1 : 0);
my $firstpage = (param('param1') eq '') ? 1 : param('param1');
my $lastpage  = ($firstpage + 15 < $pages) ?  $firstpage + 15 : $pages;
my $offset    = (param('offset') eq '') ? 0 : param('offset');
my $pageno    = ($offset + $lpp)  / $lpp;   # Pagina actual
# **************

if ($perfil == 5) {                           # Jefes de Area
   $sql="SELECT a.secuencial,a.usuario,a.proveedor,a.guia,a.factura,a.fecha,a.memo,a.estado,a.aprobado,a.referencia FROM almacencab a WHERE tipodoc='$tipodoc' AND almacen='$almacen' AND estado='0' AND usuario='$user' ORDER BY a.fecha";
} elsif ($perfil == 4 or $perfil <= 1) {      # Jefes de almacen, administradores y supervisores
   $sql="SELECT a.secuencial,a.usuario,a.proveedor,a.guia,a.factura,a.fecha,a.memo,a.estado,a.aprobado,a.referencia FROM almacencab a WHERE tipodoc='$tipodoc' AND almacen='$almacen' AND estado='0' and memo=1 ORDER BY a.fecha";
}

$sql .= " LIMIT $offset,$lpp";

#print $sql,"<br>";

$sth = $dbh->prepare($sql);
$sth->execute();

#topbanner($banner);
print $mensaje if ($mensaje);

if (!$sth->rows) {
   Aviso("No existen &oacute;rdenes pendientes",$style);
   regresar_pendiente();
   return;
}

# Despliega los pedidos
print "<br><table border=0 align=center cellspacing=2 cellpadding=2 class=".$style."FormTABLE>";
print Tr({-class=>$style."FormHeaderFont"},td({-colspan=>"7"},b($banner)));

if (param('optx') eq 'c' or param('optx') eq 'd') {
    print Tr({-class=>$style."FormHeaderFont"},td("Orden"),td("Fecha"),td("Usuario"),td("Razon Social"),td("Guia"),td("Nro Doc"),td("Importe"));
} else {
    print Tr({-class=>$style."FormHeaderFont"},td("Orden"),td("Fecha"),td("Usuario"));
}

while ($ref = $sth->fetchrow_hashref()) {
    my %aprov = ("0" => "", "1" => "Aprobado");
    my $memo  = ($ref->{'memo'} ne '') ? "Si" : "No";
    my $doc   = ($ref->{'factura'} ne '') ? $ref->{'factura'} : $ref->{'guia'};
    if (param('optx') eq 'c' or param('optx') eq 'd') {



       print "<tr align=center class=".$style."FieldCaptionTD>\n";
       print "<td align=center><a href='?opt=cpendiente&optx=".param('optx')."&secuencial=$ref->{'secuencial'}' title='Ver Orden' >$ref->{'referencia'}</a></td>";
       print "<td>$ref->{'fecha'}</td>\n";
       print "<td>$ref->{'usuario'}</td>\n";
       print "<td align=left>".nombreproveedor($ref->{'proveedor'})."</td>\n";
       print "<td>$ref->{'guia'}</td>\n";
       print "<td>$ref->{'factura'}</td>\n";
       print "<td align=right>".sprintf("%10.2f",MontoOC($ref->{'secuencial'}))."</td>\n";
       print "</tr>\n";
    } else {
       print "<tr class=".$style."FieldCaptionTD>\n";
       print "<td align=center><a href='?opt=cpendiente&optx=".param('optx')."&secuencial=$ref->{'secuencial'}' title='Ver Pedido'>$ref->{'referencia'}</a></td>";
       print "<td width=150 align=center>$ref->{'fecha'}</td>\n";
       print "<td width=100align=center>$ref->{'usuario'}</td>\n";
       print "</tr>\n";
    }
}

print "</table>\n";

if ($pages <= 1) {
    regresar_pendiente();
    return;
}

# **************
# Paginador
# **************
talonpaginador($firstpage,$lastpage,$lpp,$pageno,$pages,"?opt=pendiente&optx=".param('optx'));

regresar_pendiente();

}

# -------------------------------------------------------
sub regresar_pendiente {
# -------------------------------------------------------

my $ret;
if (param('optx') eq 'p') {
   $ret="pedido";
} elsif (param('optx') eq 'c') {
   $ret="compra";
} elsif (param('optx') eq 'd') {
   $ret="devolucion";
}

# Regresar
print "<br><center><a href='?opt=$ret'  title='Regresar'>".img({-src=>"/images/return.png",-border=>"0",-alt=>"return.png"})."</a></center>";

}


# -------------------------------------------------------
sub delitems1 {
# -------------------------------------------------------
#my ($sess_array) = @_;

#my @names = param;
#foreach (@names) { print $_ , " = ",param($_), "<br>"; }
#print $sess_array;

my @checknum = param('checknum');
my $sess_array = param('opty');

my ($sess_ref,$cart_ref,%delarray);

	   if (defined(cookie('almacen'))) {  
	        my $dbh = connectdb();
                if ($sess_ref = opensession($dbh)) {
                   if (defined ($cart_ref = $sess_ref->attr($sess_array))) {
                       # Lee item-insumo  (item = orden de entrada a la matriz) 
                       my %orders;
                       foreach my $item_id (keys(%{$cart_ref})) {
                               my $item_ref = $cart_ref->{$item_id};
                               $orders{$item_ref->{"item"}} = $item_id;
                               #print $item_id,"<br>";
                       }
                       my $i=0;
                       foreach my $key (sort keys(%orders)) {
                                my $item_ref = $cart_ref->{$orders{$key}};
                                #print $item_ref->{"item"},"<br>";
                                if (grep (/^$key$/,@checknum)) {
				    $delarray{$i} = $orders{$item_ref->{"item"}};  # insumo
                                } 
                                $i++;
                       }

		       # Usa delarray para eliminar
                       foreach (keys(%delarray)) {
                               #print $delarray{$_},"<br>";
                               delete($cart_ref->{$delarray{$_}});
                       }

        	       $sess_ref->attr($sess_array , $cart_ref);
		   }
                   $sess_ref->close();
                }
	   }
}



# -------------------------------------------------------
sub delitems {
# -------------------------------------------------------
my ($sess_array) = @_;

#my @names = param;
#foreach (@names) { print $_ , " = ",param($_), "<br>"; }

my @checknum = param('checknum');

my ($sess_ref,$cart_ref,%delarray);

	   if (defined(cookie('contab'))) {  
	        my $dbh = connectdb();
                if ($sess_ref = opensession()) {
                   if (defined ($cart_ref = $sess_ref->attr($sess_array))) {
                       # Lee item-insumo  (item = orden de entrada a la matriz) 
                       my %orders;
                       foreach my $item_id (keys(%{$cart_ref})) {
                               my $item_ref = $cart_ref->{$item_id};
                               $orders{$item_ref->{"item"}} = $item_id;
                               #print $item_id,"<br>";
                       }
                       my $i=0;
                       foreach my $key (sort keys(%orders)) {
                                my $item_ref = $cart_ref->{$orders{$key}};
                                #print $item_ref->{"item"},"<br>";
                                if (grep (/^$key$/,@checknum)) {
				    $delarray{$i} = $orders{$item_ref->{"item"}};  # insumo
                                } 
                                $i++;
                       }

		       # Usa delarray para eliminar
                       foreach (keys(%delarray)) {
                               #print $delarray{$_},"<br>";
                               delete($cart_ref->{$delarray{$_}});
                       }

        	       $sess_ref->attr($sess_array , $cart_ref);
		   }
                   $sess_ref->close();
                }
	   }
}

# -------------------------------------------------------
sub saveitems {   # save modification
# -------------------------------------------------------
my ($sess_array) = @_;

my $tc       = param('tc_compra');
my $moneda   = param('moneda');

my @checknum = param('checknum');
my @cuenta   = param('cuenta');
my @memo     = param('memo');
my @debe     = param('debe');
my @haber    = param('haber');

#my @names = param;
#foreach (@names) { print $_ , " = ",param($_), "<br>"; }

	if (defined(cookie('contab'))) {      
	    my $dbh = connectdb();
	    if (my $sess_ref = opensession()) {
	       my $cart_ref = $sess_ref->attr($sess_array);

               my %orders;
               foreach my $item_id (keys(%{$cart_ref})) {
                       my $item_ref = $cart_ref->{$item_id};
                       $orders{$item_ref->{"item"}} = $item_id;
               }

               my $j = 0;  
               foreach my $key (sort keys(%orders)) {
                        my $item_ref = $cart_ref->{$orders{$key}};
                        #print $orders{$key},"<br>";
                        if (grep (/^$key$/,@checknum)) {
                            #print $item_ref->{"item"}," "," ",$item_ref->{"dh"}," ",$item_ref->{"valor"},"<br>";
		            $item_ref->{memo}       = $memo[$j];
		            $item_ref->{dh}         = ($debe[$j] ne '') ? 0 : 1;
		            my $valor               = ($debe[$j] ne '') ? $debe[$j] : $haber[$j++];
                            if ($moneda eq '0') {
                               $item_ref->{soles}   = $valor;
                               $item_ref->{dolar}   = ($tc > 0) ? $valor / $tc : 0;
                            } else {
                               $item_ref->{soles}   = $valor * $tc;
                               $item_ref->{dolar}   = $valor;
                            }
                        }
               }
               $sess_ref->attr ($sess_array, $cart_ref);
               $sess_ref->close();
    	    }
	}
}

# -----------------------------------------------------------
sub RangoScroll_1 {
# -----------------------------------------------------------

my ($ref,$sth,$dbh);
$dbh = connectdb();

my $style = Contab33::get_sessiondata('cssname');

my $sql = "SELECT substring(fecha_conta,1,7) AS fecha FROM cc_diariocab GROUP BY fecha ORDER BY fecha DESC";
$sth = $dbh->prepare($sql);
$sth->execute();
my (%labels,@names);
while ($ref = $sth->fetchrow_hashref()) {
       $labels{$ref->{'fecha'}} = $ref->{'fecha'};
       push(@names,$ref->{'fecha'});
}

my $depstr = scrolling_list(-name=>"rango1",-values=>\@names,-labels=>\%labels,-size=>"1");

}
# -----------------------------------------------------------
sub RangoScroll_2 {
# -----------------------------------------------------------

my ($ref,$sth,$dbh);
$dbh = connectdb();

my $style = Contab33::get_sessiondata('cssname');

my $sql = "SELECT substring(fecha_conta,1,7) AS fecha FROM cc_diariocab GROUP BY fecha ORDER BY fecha DESC";
$sth = $dbh->prepare($sql);
$sth->execute();
my (%labels,@names);
while ($ref = $sth->fetchrow_hashref()) {
       $labels{$ref->{'fecha'}} = $ref->{'fecha'};
       push(@names,$ref->{'fecha'});
}

my $depstr = scrolling_list(-name=>"rango2",-values=>\@names,-labels=>\%labels,-size=>"1");

}

# -------------------------------------------------------
sub SelecionarRango {
# -------------------------------------------------------
my ($optx) = @_;
my $style   = get_sessiondata('cssname');
 print start_form();
	print "<p><div align=center class=".$style."mditem>Periodo Inicial:&nbsp;".RangoScroll_1()."&nbsp;Periodo Final:&nbsp;".RangoScroll_2()."&nbsp;&nbsp;".submit(-class=>$style."Button",-value=>"Ejecutar")."</div>";

print hidden(-name=>"opt",-value=>"analisis",-override=>1);
print hidden(-name=>"optx",-value=>"$optx",-override=>1);
print end_form();
}

# -------------------------------------------------------
sub analisis {
# -------------------------------------------------------
my ($topbanner) = @_;

#my @names = param;
#foreach (@names) { print $_ , " = ",param($_), "<br>"; }

my $style   = get_sessiondata('cssname');
my $mcontab = (get_sessiondata('mcontab') eq 'S') ? "soles" : "dolar";

my $localbanner;
$localbanner  = "<table align=center border=0 cellspacing=0 cellpadding=0>";
$localbanner .= "<tr><td align=center class=".$style."lkitem><a href='?opt=analisis&optx=bg4' target='inferior'>Balance General</a>&nbsp;|&nbsp;<a href='?opt=analisis&optx=gp' target='inferior'>Ganancias y P&eacute;rdidas</a>&nbsp;|&nbsp;<a href='?opt=analisis&optx=bc' target='inferior'>Balance de Comprobaci&oacute;n</a></td></tr>";
my $periodoactual = substr(HKZ33::getDate(),0,7);
my $rango1 = (defined(param('rango1'))) ? param('rango1') : $periodoactual;
my $rango2 = (defined(param('rango2'))) ? param('rango2') : $periodoactual;
$localbanner .= "</table>";

my ($sth,$ref,$dbh);
$dbh = connectdb();


if (param('optx') eq 'bg4') {  # Balance General (lista de cuentas principales XX)
    page_header("ridged_paper.png","","");
   
my ($sth1,$ref1,$dbh1);
$dbh1 = connectdb();
    my ($tdebe,$thaber);
   # my $sql = "SELECT substring(a.cuenta,1,2) AS cta,SUM(IF(a.dh=0,$mcontab,0)) AS debe,SUM(IF(a.dh=1,$mcontab,0)) AS haber FROM cc_diariodet a, cc_diariocab b, cc_cuentas c WHERE b.estado='0' AND (a.secuencial=b.secuencial) AND (a.cuenta=c.cuenta) AND (c.tipo='0' or c.tipo='1' or c.tipo='2' or  c.tipo='3') AND substring(a.cuenta,3,4) != '0000' GROUP BY cta ORDER BY cta";
    my $sql = "SELECT substring(a.cuenta,1,2) AS cta,SUM(IF(a.dh=0,$mcontab,0)) AS debe,SUM(IF(a.dh=1,$mcontab,0)) AS haber FROM cc_diariodet a, cc_diariocab b, cc_cuentas c WHERE b.estado='0' AND (a.secuencial=b.secuencial) AND (substring(a.cuenta,1,6)=c.cuenta)  AND (substring(a.cuenta,4,3) != '000' or substring(a.cuenta,6,100)>0 ) and DATE_FORMAT(b.fecha_conta,'%Y-%m') >= '$rango1' and DATE_FORMAT(b.fecha_conta,'%Y-%m') <= '$rango2'  GROUP BY cta ORDER BY cta";

   # print $sql,"<br>";

    $sth = $dbh->prepare($sql);
    $sth->execute();

    print $topbanner;
    print $localbanner;
     SelecionarRango('bg4');
    print "<br><table width=750 border=0 cellpadding=2 cellspacing=2 align=center>";
   # print Tr(td({-colspan=>"4",-align=>"center",-class=>$style."lkitem"},b("Balance General<br>Al:&nbsp;".substr(HKZ33::getDate(),0,10))));
    print Tr(td({-colspan=>"4",-align=>"center",-class=>$style."lkitem"},b("Balance General<br>Del:&nbsp;".$rango1."&nbsp;Al:&nbsp;".$rango2)));
   
    print Tr({-class=>$style."lkitem",-bgcolor=>"lightgreen",-align=>"center"},td({-width=>"50"},b("Cuenta")),td(b("Nombre de la Cuenta")),td({-width=>"100"},b("Debe")),td({-width=>"100"},b("Haber")) );

    while ($ref = $sth->fetchrow_hashref()) {
          print Tr({-class=>$style."lkitem"},td({-align=>"center"},b($ref->{'cta'})),td(b(NombreCuenta($ref->{'cta'}."0000"))),td("&nbsp;"),td("&nbsp;"));
        print Tr({-class=>$style."lkitem"},td("&nbsp;"),td(clase3($ref->{'cta'},$rango1,$rango2)),td({-valign=>"bottom",-align=>"right"},commify(sprintf("%15.2f",$ref->{'debe'}))),td({-valign=>"bottom",-align=>"right"},commify(sprintf("%15.2f",$ref->{'haber'}))));
          $tdebe  += $ref->{'debe'};
          $thaber += $ref->{'haber'};
    }

    #print Tr({-class=>$style."lkitem",-bgcolor=>"lightgreen"},td("&nbsp"),td({-align=>"right"},b("T O T A L E S&nbsp;:&nbsp;")),td({-align=>"right"},b(commify(sprintf("%15.2f",$tdebe)))),td({-align=>"right"},b(commify(sprintf("%15.2f",$thaber)))));

    # Calcular los resultados

    # Resultado de ejercicios (tipo 8)
    my ($tdebe8,$thaber8);
    my $sql1 = "SELECT substring(a.cuenta,1,2) AS cta,SUM(IF(a.dh=0,$mcontab,0)) AS debe,SUM(IF(a.dh=1,$mcontab,0)) AS haber FROM cc_diariodet a, cc_diariocab b, cc_cuentas c WHERE b.estado='0' AND (a.secuencial=b.secuencial) AND (substring(a.cuenta,1,6)=c.cuenta) AND (c.tipo='8') AND substring(a.cuenta,3,4) != '0000' GROUP BY cta ORDER BY cta";

    $sth1 = $dbh1->prepare($sql1);
$sth1->execute();
    while ($ref1 = $sth1->fetchrow_hashref()) {
          print Tr({-class=>$style."lkitem"},td({-align=>"center"},b($ref1->{'cta'})),td(b(NombreCuenta($ref1->{'cta'}."0000"))),td("&nbsp;"),td("&nbsp;"));
          print Tr({-class=>$style."lkitem"},td("&nbsp;"),td(clase3($ref->{'cta'},$rango1,$rango2)),td({-valign=>"bottom",-align=>"right"},commify(sprintf("%15.2f",$ref1->{'debe'}))),td({-valign=>"bottom",-align=>"right"},commify(sprintf("%15.2f",$ref1->{'haber'}))));
          $tdebe8  += $ref1->{'debe'};
          $thaber8 += $ref1->{'haber'};
    }
    print Tr({-class=>$style."lkitem",-bgcolor=>"lightgreen"},td("&nbsp"),td({-align=>"right"},b("T O T A L E S&nbsp;:&nbsp;")),td({-align=>"right"},b(commify(sprintf("%15.2f",$tdebe+$tdebe8)))),td({-align=>"right"},b(commify(sprintf("%15.2f",$thaber+$thaber8)))));

    print "</table>";

    print end_html();
}

if (param('optx') eq 'gp') {  # Ganancias y Perdidas
    # Determina cuantos años fiscales contiene la bd
    page_header("ridged_paper.png","","");
    print $topbanner;
    print $localbanner;

    my $sql = "SELECT date_format(fecha_conta,'%Y') AS periodo_fiscal FROM cc_diariocab WHERE estado='0' GROUP BY periodo_fiscal";
    $sth = $dbh->prepare($sql);
    $sth->execute();
    my $periodos_link;
    my $periodo_actual = (defined(param('qperiodo'))) ? param('qperiodo') : substr(HKZ33::getDate(),0,4);
    #print $sql,"<br>";
    while ($ref = $sth->fetchrow_hashref()) {
           if ($ref->{'periodo_fiscal'} ne $periodo_actual) {
               $periodos_link .= a({-href=>"?opt=analisis&optx=gp&qperiodo=$ref->{'periodo_fiscal'}"},$ref->{'periodo_fiscal'}) . "&nbsp;";          
           } else {
               $periodos_link .= $ref->{'periodo_fiscal'} . "&nbsp;";          
           }
    }
    print "<br><div align=center class=".$style."lkitem>Periodo fiscal: $periodos_link</div>";

    # Muestra el estado de g/p del año fiscal seleccionado
    my ($tdebe,$thaber);
    print "<table border=0 cellpadding=2 cellspacing=2 align=center>";
    print Tr(td({-colspan=>"4",-class=>$style."lkitem",-align=>"center"},b("Ganancias y P&eacute;rdidas<br>A&ntilde;o fiscal&nbsp;".$periodo_actual)));
    print Tr({-class=>$style."lkitem",-align=>"center",-bgcolor=>"lightgreen"},td(b("Cuenta")),td({-width=>"300"},b("Nombre de la Cuenta")),td({-width=>"100"},b("Debe")),td({-width=>"100"},b("Haber")) );

    # Ventas : tipo 3
    my ($tdebe3,$thaber3);
    #print $sql,"<br>";
   # my $sql = "SELECT substring(a.cuenta,1,2) AS cta,SUM(IF(dh=0,$mcontab,0)) AS debe,SUM(IF(dh=1,$mcontab,0)) AS haber FROM cc_diariodet a,cc_cuentas b,cc_diariocab c WHERE c.estado='0' AND (a.cuenta=b.cuenta) AND (a.secuencial=c.secuencial) AND date_format(c.fecha_conta,'%Y') = $periodo_actual AND (b.tipo='3') GROUP BY cta ORDER BY a.cuenta";
    my $sql = "SELECT substring(a.cuenta,1,2) AS cta,SUM(IF(dh=0,$mcontab,0)) AS debe,SUM(IF(dh=1,$mcontab,0)) AS haber FROM cc_diariodet a,cc_cuentas b,cc_diariocab c WHERE c.estado='0' AND (substring(a.cuenta,1,6)=b.cuenta) AND (a.secuencial=c.secuencial) AND date_format(c.fecha_conta,'%Y') = $periodo_actual AND (b.tipo='3') GROUP BY cta ORDER BY a.cuenta";
    $sth = $dbh->prepare($sql);
    $sth->execute();
    while ($ref = $sth->fetchrow_hashref()) {
          print Tr({-class=>$style."lkitem"},td({-align=>"center"},$ref->{'cta'}),td(NombreCuenta($ref->{'cta'}."0000")),td({-align=>"right"},commify(sprintf("%15.2f",$ref->{'debe'})),td({-align=>"right"},commify(sprintf("%15.2f",$ref->{'haber'})))));
          $tdebe3  += $ref->{'debe'};
          $thaber3 += $ref->{'haber'};
    }
    print Tr({-class=>$style."lkitem",-bgcolor=>"lightgreen"},td("&nbsp"),td({-align=>"right"},b("TOTAL INGRESOS&nbsp;:&nbsp;")),td({-align=>"right"},b(commify(sprintf("%15.2f",$tdebe3)))),td({-align=>"right"},b(commify(sprintf("%15.2f",$thaber3)))));

    # Costo de Venta : tipo 4
    my ($tdebe4,$thaber4);
    #my $sql = "SELECT substring(a.cuenta,1,2) AS cta,SUM(IF(dh=0,$mcontab,0)) AS debe,SUM(IF(dh=1,$mcontab,0)) AS haber FROM cc_diariodet a,cc_cuentas b,cc_diariocab c WHERE c.estado='0' AND (a.cuenta=b.cuenta) AND (a.secuencial=c.secuencial) AND date_format(c.fecha_conta,'%Y') = $periodo_actual AND (b.tipo='4') GROUP BY cta ORDER BY a.cuenta";
    my $sql = "SELECT substring(a.cuenta,1,2) AS cta,SUM(IF(dh=0,$mcontab,0)) AS debe,SUM(IF(dh=1,$mcontab,0)) AS haber FROM cc_diariodet a,cc_cuentas b,cc_diariocab c WHERE c.estado='0' AND (substring(a.cuenta,1,6)=b.cuenta) AND (a.secuencial=c.secuencial) AND date_format(c.fecha_conta,'%Y') = $periodo_actual AND (b.tipo='4') GROUP BY cta ORDER BY a.cuenta";
    
    $sth = $dbh->prepare($sql);
    $sth->execute();
    #print $sql,"<br>";
    while ($ref = $sth->fetchrow_hashref()) {
          print Tr({-class=>$style."lkitem"},td({-align=>"center"},$ref->{'cta'}),td(NombreCuenta($ref->{'cta'}."0000")),td({-align=>"right"},commify(sprintf("%15.2f",$ref->{'debe'})),td({-align=>"right"},commify(sprintf("%15.2f",$ref->{'haber'})))));
          $tdebe4  += $ref->{'debe'};
          $thaber4 += $ref->{'haber'};
    }
    print Tr({-class=>$style."lkitem",-bgcolor=>"lightgreen"},td("&nbsp"),td({-align=>"right"},b("COSTO DE VENTAS&nbsp;:&nbsp;")),td({-align=>"right"},b(commify(sprintf("%15.2f",$tdebe4)))),td({-align=>"right"},b(commify(sprintf("%15.2f",$thaber4)))));


    my $UB = ($thaber3-$thaber4) + ($tdebe3-$tdebe4);
    print Tr({-class=>$style."lkitem",-bgcolor=>"lightblue"},td("&nbsp"),td({-align=>"right"},b("UTILIDAD BRUTA&nbsp;:&nbsp;")),td({-align=>"right"},"&nbsp;"),td({-align=>"right"},b(commify(sprintf("%15.2f",$UB)))));

    # Gastos : tipo 5
    my ($tdebe5,$thaber5);
   my $sql = "SELECT substring(a.cuenta,1,2) AS cta,SUM(IF(dh=0,$mcontab,0)) AS debe,SUM(IF(dh=1,$mcontab,0)) AS haber FROM cc_diariodet a,cc_cuentas b,cc_diariocab c WHERE c.estado='0' AND (a.cuenta=b.cuenta)                AND (a.secuencial=c.secuencial) AND date_format(c.fecha_conta,'%Y') = $periodo_actual AND (b.tipo='5') GROUP BY cta ORDER BY a.cuenta";
     # my $sql = "SELECT substring(a.cuenta,1,2) AS cta,SUM(IF(dh=0,$mcontab,0)) AS debe,SUM(IF(dh=1,$mcontab,0)) AS haber FROM cc_diariodet a,cc_cuentas b,cc_diariocab c WHERE c.estado='0' AND (substring(a.cuenta,1,6)=b.cuenta) AND (a.secuencial=c.secuencial) AND date_format(c.fecha_conta,'%Y') = $periodo_actual AND (b.tipo='5') and (substring(a.cuenta,1,2) != '61') GROUP BY cta ORDER BY a.cuenta";
  
    $sth = $dbh->prepare($sql);
    $sth->execute();
    #print $sql,"<br>";
    while ($ref = $sth->fetchrow_hashref()) {
          print Tr({-class=>$style."lkitem"},td({-align=>"center"},$ref->{'cta'}),td(NombreCuenta($ref->{'cta'}."0000")),td({-align=>"right"},commify(sprintf("%15.2f",$ref->{'debe'})),td({-align=>"right"},commify(sprintf("%15.2f",$ref->{'haber'})))));
          $tdebe5  += $ref->{'debe'};
          $thaber5 += $ref->{'haber'};
    }
    print Tr({-class=>$style."lkitem",-bgcolor=>"lightgreen"},td("&nbsp"),td({-align=>"right"},b("TOTAL GASTOS&nbsp;:&nbsp;")),td({-align=>"right"},b(commify(sprintf("%15.2f",$tdebe5)))),td({-align=>"right"},b(commify(sprintf("%15.2f",$thaber5)))));
    print Tr({-class=>$style."lkitem",-bgcolor=>"lightblue"},td("&nbsp"),td({-align=>"right"},b("UTILIDAD ANTES DE IMPUESTOS&nbsp;:&nbsp;")),td({-align=>"right"},"&nbsp;"),td({-align=>"right"},b(commify(sprintf("%15.2f",$UB - ($tdebe5-$thaber5))))));

    print end_html();
}
#RICHIE
if (param('optx') eq 'bc') {   # Balance de comprobacion
    page_header("ridged_paper.png","","");
      
    print $topbanner;
    print $localbanner;
    SelecionarRango('bc');
    my ($tdebe,$thaber,$tsaldo_debe,$tsaldo_haber,$tinv_debe,$tinv_haber,$ttrans_debe,$ttrans_haber,$tresult_debe,$tresult_haber,$tresult_debe2,$tresult_haber2);
    my $sql = "SELECT substring(a.cuenta,1,6) AS cta, c.tipo  ,SUM(IF(a.dh=0,$mcontab,0)) AS debe,SUM(IF(a.dh=1,$mcontab,0)) AS haber FROM cc_diariodet a, cc_diariocab b, cc_cuentas c WHERE b.estado='0' AND (a.secuencial=b.secuencial) AND (substring(a.cuenta,1,6)=c.cuenta) and DATE_FORMAT(b.fecha_conta,'%Y-%m') >= '$rango1' and DATE_FORMAT(b.fecha_conta,'%Y-%m') <= '$rango2' GROUP BY cta ORDER BY cta";
 #  my $sql = "SELECT substring(a.cuenta,1,6) AS cta, c.tipo  ,SUM(IF(a.dh=0,$mcontab,0)) AS debe,SUM(IF(a.dh=1,$mcontab,0)) AS haber FROM cc_diariodet a, cc_diariocab b, cc_cuentas c WHERE b.estado='0' AND (a.secuencial=b.secuencial) AND (substring(a.cuenta,1,3)=substring(c.cuenta,1,3))  GROUP BY cta ORDER BY cta";

     #print $sql,"<br>";

    $sth = $dbh->prepare($sql);
    $sth->execute();
   
    print "<br><table width=1240 border=0 cellpadding=2 cellspacing=2 align=center>";
     print Tr(td({-colspan=>9},table({-align=>"center"},Tr({-class=>$style."lkitem"},td(a({-href=>'javascript:window.print()'},"Imprimir")),td("|"),td(a({-href=>"?opt=download_bc&periodo=".substr(HKZ33::getDate(),0,10)},"Download")))))); 
 
   # print Tr(td({-colspan=>"12",-align=>"center",-class=>$style."lkitem"},b("Balance de Comprobacion Al : ".substr(HKZ33::getDate(),0,10))));
    print Tr(td({-colspan=>"12",-align=>"center",-class=>$style."lkitem"},b("Balance de Comprobacion Del : ".$rango1." Al:".$rango2)));
    
    print Tr({-class=>$style."lkitem",-bgcolor=>"lightgreen",-align=>"center"},td(b("")),td({-width=>"500"},b("")),td({-width=>"100", colspan=>"2"},b(" SUMAS ")),td({-width=>"100", colspan=>"2"},b(" SALDOS ")),td({-width=>"100", colspan=>"2"},b(" AJUSTES ")),td({-width=>"100", colspan=>"2"},b(" INVENTARIOS ")),td({-width=>"100", colspan=>"2"},b(" RESULTADOS x Naturaleza")),td({-width=>"100", colspan=>"2"},b(" RESULTADOS x Funcion")) );

    print Tr({-class=>$style."lkitem",-bgcolor=>"lightgreen",-align=>"center"},td({-width=>"50"},b("Cuenta")),td({-width=>"500"},b("Nombre de la Cuenta")),td({-width=>"100"},b("Debe")),td({-width=>"100"},b("Haber")),td({-width=>"100"},b("Deudor")),td({-width=>"100"},b("Acreedor")), td({-width=>"100"},b("Debe")),td({-width=>"100"},b("Haber")) , td({-width=>"100"},b("Activo")),td({-width=>"100"},b("Pasivo")), td({-width=>"100"},b("Perdida")),td({-width=>"100"},b("Ganancia")),td({-width=>"100"},b("Perdida")),td({-width=>"100"},b("Ganancia"))   );


    while ($ref = $sth->fetchrow_hashref()) {
          #print Tr({-class=>$style."lkitem"},td({-align=>"center"},b($ref->{'cta'})),td(b(NombreCuenta($ref->{'cta'}."0000"))),td("&nbsp;"),td("&nbsp;"));
	
          #print Tr({-class=>$style."lkitem"},td("&nbsp;"),td({colspan=>"3"},clase3($ref->{'cta'})),td({-valign=>"bottom",-align=>"right"},commify(sprintf("%15.2f",$ref->{'debe'}))),td({-valign=>"bottom",-align=>"right"},commify(sprintf("%15.2f",$ref->{'haber'}))));

# SALDO
	my($saldo_debe,$saldo_haber);

	if(($ref->{'debe'} -$ref->{'haber'})>0)
	  {
          $saldo_debe = ($ref->{'debe'} -$ref->{'haber'});
          }
	 else
	  {
          $saldo_haber =($ref->{'haber'} -$ref->{'debe'});
          }
          
  #    INVENTARIOS      
	my($inv_debe,$inv_haber);
       if($ref->{'tipo'} eq '0' or $ref->{'tipo'} eq '1' or $ref->{'tipo'} eq '2' )
     {
	   	    if (substr($ref->{'cta'},0,1) eq '1' or substr($ref->{'cta'},0,1) eq '2' or substr($ref->{'cta'},0,1) eq '3' and  (substr($ref->{'cta'},0,2) ne '19' or substr($ref->{'cta'},0,2) ne '29' or substr($ref->{'cta'},0,2) ne '39')){
	   	   	$inv_debe=$ref->{'debe'} -$ref->{'haber'};
	   	    }else {
	   	    	$inv_haber=($ref->{'haber'} -$ref->{'debe'});
	   	    	}
           
	 #  $inv_debe=$saldo_debe;
	 #  $inv_haber=$saldo_haber;
	   $tinv_debe+=$inv_debe;
	   $tinv_haber+=$inv_haber;
	   } 

#GASTOS - TRANSFERENCIA POR NATURALEZA - Ajustes
	my($trans_debe,$trans_haber);
         #if(substr($ref->{'cta'},0,2) eq '60' or  substr($ref->{'cta'},0,2) eq '61' or substr($ref->{'cta'},0,2) eq '62' or substr($ref->{'cta'},0,2) eq '63' or substr($ref->{'cta'},0,2) eq '64' or substr($ref->{'cta'},0,2) eq '65' or substr($ref->{'cta'},0,2) eq '67' or substr($ref->{'cta'},0,2) eq '68' or substr($ref->{'cta'},0,2) eq '69')
	  if(substr($ref->{'cta'},0,2) eq '61' or  substr($ref->{'cta'},0,2) eq '69' or substr($ref->{'cta'},0,2) eq '79' or substr($ref->{'cta'},0,2) eq '94' or substr($ref->{'cta'},0,2) eq '95' or substr($ref->{'cta'},0,2) eq '97')
	 
	   {
           $trans_debe=$saldo_debe;
	   $trans_haber=$saldo_haber;
	   $ttrans_debe+=$trans_debe;
	   $ttrans_haber+=$trans_haber;
	   } 


#RESULTADOS x naturaleza para perdida
	my($result_debe,$result_haber);
      if(substr($ref->{'cta'},0,2) eq '60' or substr($ref->{'cta'},0,2) eq '62' or substr($ref->{'cta'},0,2) eq '63' or substr($ref->{'cta'},0,2) eq '64' or substr($ref->{'cta'},0,2) eq '65' or substr($ref->{'cta'},0,2) eq '66' or substr($ref->{'cta'},0,2) eq '67' or substr($ref->{'cta'},0,2) eq '68' or substr($ref->{'cta'},0,2) eq '74' )
	   
	   {
           $result_debe=$saldo_debe;
	   #$result_haber=$saldo_haber;
	   $tresult_debe+=$result_debe;
	  # $tresult_haber+=$result_haber;
	   } 

#RESULTADOS x naturaleza para ganancia
   if(substr($ref->{'cta'},0,2) eq '61' or substr($ref->{'cta'},0,2) eq '70' or substr($ref->{'cta'},0,2) eq '71' or substr($ref->{'cta'},0,2) eq '72' or substr($ref->{'cta'},0,2) eq '73' or substr($ref->{'cta'},0,2) eq '75' or substr($ref->{'cta'},0,2) eq '76' or substr($ref->{'cta'},0,2) eq '77' or substr($ref->{'cta'},0,2) eq '78' or substr($ref->{'cta'},0,2) eq '79')
	   
	   {
     #      $result_debe=$saldo_debe;
	   $result_haber=$saldo_haber;
	  # $tresult_debe+=$result_debe;
	   $tresult_haber+=$result_haber;
	   } 


#RESULTADOS x funcion para perdida
	my($result_debe2,$result_haber2);
     if(substr($ref->{'cta'},0,2) eq '66' or substr($ref->{'cta'},0,2) eq '69' or substr($ref->{'cta'},0,2) eq '74' or substr($ref->{'cta'},0,1) eq '9' )
	   
	   {
           $result_debe2=$saldo_debe;
	  # $result_haber2=$saldo_haber;
	   $tresult_debe2+=$result_debe;
	   #$tresult_haber2+=$result_haber;
	   } 

#RESULTADOS x funcion para ganancia
	my($result_debe2,$result_haber2);
     if(substr($ref->{'cta'},0,2) eq '70' or substr($ref->{'cta'},0,2) eq '71' or substr($ref->{'cta'},0,2) eq '72' or substr($ref->{'cta'},0,2) eq '73' or substr($ref->{'cta'},0,2) eq '74' or substr($ref->{'cta'},0,2) eq '75' or substr($ref->{'cta'},0,2) eq '76' or substr($ref->{'cta'},0,2) eq '77' or substr($ref->{'cta'},0,2) eq '78' )
	   
	   {
      #     $result_debe2=$saldo_debe;
	   $result_haber2=$saldo_haber;
	   #$tresult_debe2+=$result_debe;
	   $tresult_haber2+=$result_haber;
	   } 

	  print Tr({-class=>$style."lkitem"},td({-align=>"center"},b($ref->{'cta'})),td(b(NombreCuenta($ref->{'cta'}))),td({-valign=>"bottom",-align=>"right"},commify(sprintf("%15.2f",$ref->{'debe'}))),td({-valign=>"bottom",-align=>"right"},commify(sprintf("%15.2f",$ref->{'haber'}))),td({-valign=>"bottom",-align=>"right"},commify(sprintf("%15.2f",$saldo_debe))) , td({-valign=>"bottom",-align=>"right"},commify(sprintf("%15.2f",$saldo_haber))),

td({-valign=>"bottom",-align=>"right"},commify(sprintf("%15.2f",$trans_debe))) , td({-valign=>"bottom",-align=>"right"},commify(sprintf("%15.2f",$trans_haber)))
,

td({-valign=>"bottom",-align=>"right"},commify(sprintf("%15.2f",$inv_debe))) , td({-valign=>"bottom",-align=>"right"},commify(sprintf("%15.2f",$inv_haber)))

,

td({-valign=>"bottom",-align=>"right"},commify(sprintf("%15.2f",$result_debe))) , td({-valign=>"bottom",-align=>"right"},commify(sprintf("%15.2f",$result_haber)))

,

td({-valign=>"bottom",-align=>"right"},commify(sprintf("%15.2f",$result_debe2))) , td({-valign=>"bottom",-align=>"right"},commify(sprintf("%15.2f",$result_haber2)))

);

          $tdebe  += $ref->{'debe'};
          $thaber += $ref->{'haber'};
          
	  $tsaldo_debe += $saldo_debe;
          $tsaldo_haber += $saldo_haber;

    }


 print Tr({-class=>$style."lkitem",-bgcolor=>"lightgreen"},td("&nbsp"),td({-align=>"right"},b("T O T A L E S  G E N E R A L&nbsp;:&nbsp;")),td({-align=>"right"},b(commify(sprintf("%15.2f",$tdebe)))),td({-align=>"right"},b(commify(sprintf("%15.2f",$thaber))))
,td({-align=>"right"},b(commify(sprintf("%15.2f",$tsaldo_debe)))), td({-align=>"right"},b(commify(sprintf("%15.2f",$tsaldo_haber))))
,

td({-align=>"right"},b(commify(sprintf("%15.2f",$ttrans_debe)))), td({-align=>"right"},b(commify(sprintf("%15.2f",$ttrans_haber))))
,
td({-align=>"right"},b(commify(sprintf("%15.2f",$tinv_debe)))), td({-align=>"right"},b(commify(sprintf("%15.2f",$tinv_haber))))

,
td({-align=>"right"},b(commify(sprintf("%15.2f",$tresult_debe)))), td({-align=>"right"},b(commify(sprintf("%15.2f",$tresult_haber))))

,
td({-align=>"right"},b(commify(sprintf("%15.2f",$tresult_debe2)))), td({-align=>"right"},b(commify(sprintf("%15.2f",$tresult_haber2))))


 );

my($saldo_tinv_haber,$saldo_tinv_debe);

if(($tinv_debe-$tinv_haber)>0)
{
 $saldo_tinv_haber= $tinv_debe-$tinv_haber;


}
else
{
 $saldo_tinv_debe= $tinv_haber-$tinv_debe;

}


my($saldo_tresult_haber,$saldo_tresult_debe);

if(($tresult_debe-$tresult_haber)>0)
{
 $saldo_tresult_haber= $tresult_debe-$tresult_haber;


}
else
{
 $saldo_tresult_debe= $tresult_haber-$tresult_debe;

}

my($saldo_tresult_haber2,$saldo_tresult_debe2);

if(($tresult_debe2-$tresult_haber2)>0)
{
 $saldo_tresult_haber2 = $tresult_debe2 - $tresult_haber2;


}
else
{
 $saldo_tresult_debe2 = $tresult_haber2 - $tresult_debe2;

}
    print Tr({-class=>$style."lkitem",-bgcolor=>"lightgreen"},td({-colspan=>"8"},"&nbsp"),
td({-align=>"right"},b(commify(sprintf("%15.2f",$saldo_tinv_debe)))), td({-align=>"right"},b(commify(sprintf("%15.2f",$saldo_tinv_haber))))

,
td({-align=>"right"},b(commify(sprintf("%15.2f",$saldo_tresult_debe)))), td({-align=>"right"},b(commify(sprintf("%15.2f",$saldo_tresult_haber))))

,
td({-align=>"right"},b(commify(sprintf("%15.2f",$saldo_tresult_debe2)))), td({-align=>"right"},b(commify(sprintf("%15.2f",$saldo_tresult_haber2))))


 );


 print Tr({-class=>$style."lkitem",-bgcolor=>"lightgreen"},td({-align=>"right",-colspan=>"8"},b("T O T A L&nbsp;:&nbsp;")),
td({-align=>"right"},b(commify(sprintf("%15.2f",($saldo_tinv_debe +$tinv_debe))))), td({-align=>"right"},b(commify(sprintf("%15.2f",($saldo_tinv_haber +$tinv_haber)))))

,
td({-align=>"right"},b(commify(sprintf("%15.2f",($saldo_tresult_debe +$tresult_debe))))), td({-align=>"right"},b(commify(sprintf("%15.2f",($saldo_tresult_haber +$tresult_haber)))))

,
td({-align=>"right"},b(commify(sprintf("%15.2f",($saldo_tresult_debe2 +$tresult_debe2))))), td({-align=>"right"},b(commify(sprintf("%15.2f",($saldo_tresult_haber2 +$tresult_haber2)))))

 );


    print "</table>";
    print end_html();
}

if (param('optx') eq 'subcuenta') {   # Lista las cuentas de la clase XXX
   
    my $sql;
    my $busca_nombre_cta  = param('busca_nombre_cta');
    my $subcuenta         = param('subcuenta');

    # **************
    # Paginador
    # **************
    my $lpp = 12;   # lineas por pagina
    if (param('opty') ne 'busca') {   
     #  $sql = "SELECT cuenta FROM cc_diariodet WHERE cuenta like '$subcuenta%' AND substring(cuenta,4,3) != '000' GROUP BY cuenta";
    $sql = "SELECT cuenta FROM cc_diariodet WHERE cuenta like '$subcuenta%' AND (substring(cuenta,4,3) != '000' or substring(cuenta,6,100)>0 ) GROUP BY cuenta";
   
    } else {
    #   $sql = "SELECT a.cuenta FROM cc_diariodet a,cc_cuentas b WHERE (a.cuenta=b.cuenta) AND a.cuenta like '$subcuenta%' AND b.dsc like '%$busca_nombre_cta%' AND substring(a.cuenta,4,3) != '000' GROUP BY a.cuenta";
     $sql = "SELECT a.cuenta FROM cc_diariodet a,cc_cuentas b WHERE (substring(a.cuenta,1,6)=b.cuenta) AND a.cuenta like '$subcuenta%' AND b.dsc like '%$busca_nombre_cta%' AND (substring(a.cuenta,4,3) != '000' or substring(a.cuenta,6,100)>0 ) GROUP BY a.cuenta";
    
    }
    $sth = $dbh->prepare($sql);
    $sth->execute();
    my $records   = $sth->rows;
    my $pages     = int($records/$lpp) + (($records % $lpp > 0) ? 1 : 0);
    my $firstpage = (param('param1') eq '') ? 1 : param('param1');
    my $lastpage  = ($firstpage + $lpp < $pages) ?  $firstpage + $lpp : $pages;
    my $offset    = (param('offset') eq '') ? 0 : param('offset');
    my $pageno    = ($offset + $lpp)  / $lpp;   # Pagina actual
    # **************

    if (param('opty') ne 'busca') {   
     #  $sql = "SELECT a.cuenta,SUM(IF(a.dh=0,$mcontab,0)) AS debe,SUM(IF(a.dh=1,$mcontab,0)) AS haber FROM cc_diariodet a,cc_diariocab b WHERE b.estado='0' AND (a.secuencial=b.secuencial) AND a.cuenta like '$subcuenta%' AND substring(a.cuenta,4,3) != '000' GROUP BY cuenta ORDER BY cuenta LIMIT $offset,$lpp";
    $sql = "SELECT a.cuenta,SUM(IF(a.dh=0,$mcontab,0)) AS debe,SUM(IF(a.dh=1,$mcontab,0)) AS haber FROM cc_diariodet a,cc_diariocab b WHERE b.estado='0' AND (a.secuencial=b.secuencial) AND a.cuenta like '$subcuenta%' AND (substring(a.cuenta,4,3) != '000' or substring(a.cuenta,6,100)>0 ) GROUP BY cuenta ORDER BY cuenta LIMIT $offset,$lpp";
    
    } else {
   #    $sql = "SELECT a.cuenta,SUM(IF(a.dh=0,$mcontab,0)) AS debe,SUM(IF(a.dh=1,$mcontab,0)) AS haber FROM cc_diariodet a,cc_diariocab b,cc_cuentas c WHERE b.estado='0' AND (a.cuenta=c.cuenta) AND (a.secuencial=b.secuencial) AND c.dsc like '%$busca_nombre_cta%' AND a.cuenta like '$subcuenta%' AND substring(a.cuenta,4,3) != '000' GROUP BY cuenta ORDER BY cuenta LIMIT $offset,$lpp";
     $sql = "SELECT a.cuenta,SUM(IF(a.dh=0,$mcontab,0)) AS debe,SUM(IF(a.dh=1,$mcontab,0)) AS haber FROM cc_diariodet a,cc_diariocab b,cc_cuentas c WHERE b.estado='0' AND (substring(a.cuenta,1,6)=c.cuenta) AND (a.secuencial=b.secuencial) AND c.dsc like '%$busca_nombre_cta%' AND a.cuenta like '$subcuenta%' AND (substring(a.cuenta,4,3) != '000' or substring(a.cuenta,6,100)>0 ) GROUP BY cuenta ORDER BY cuenta LIMIT $offset,$lpp";
    
    }

    $sth = $dbh->prepare($sql);
    $sth->execute();

    page_header("ridged_paper.png","","Clase ".param('subcuenta'));
    print "<br><table border=0 cellpadding=2 cellspacing=2 align=center>";
    print Tr(td({-colspan=>"4",-class=>$style."lkitem",-align=>"center"},b("Cuentas de la clase&nbsp;".param('subcuenta')."<br>Pag.&nbsp;".$pageno."/".$pages."&nbsp;&nbsp;".NombreCuentaPrincipal(substr($subcuenta,0,2).'0000')."-".NombreCuenta($subcuenta."000"))));
    if (param('opty') eq 'busca') {
        print Tr(td({-colspan=>"4",-class=>$style."lkitem",-align=>"center"},b("Nombres de cuenta que contienen el texto '$busca_nombre_cta'")));
    }
    print Tr({-class=>$style."lkitem",-align=>"center",-bgcolor=>"lightgreen"},td({-width=>"50"},b("Cuenta")),td({-width=>"300"},b("Nombre de la Cuenta")),td({-width=>"100"},b("Debe")),td({-width=>"100"},b("Haber")) );

    while ($ref = $sth->fetchrow_hashref()) {

          my $link = "?opt=vistapre&cuenta=$ref->{'cuenta'}&xoffset=".param('offset')."&xparam1=". param('param1');
          my $str  = "<a href='$link' target='detalle' title='Vista Preliminar' onclick=\"window.open('$link','vp','scrollbars=yes,resizable=yes,width=800,height=600');return false\">$ref->{'cuenta'}</a>";
          print Tr({-class=>$style."lkitem"},td({-align=>"center"},$str),td(dsccuentaanexo($ref->{'cuenta'})),td({-align=>"right"},commify(sprintf("%15.2f",$ref->{'debe'}))),td({-align=>"right"},commify(sprintf("%15.2f",$ref->{'haber'}))));

          #my $link = "?opt=analisis&optx=cuenta&cuenta=$ref->{'cuenta'}&xoffset=".param('offset')."&xparam1=".param('param1');
          #my $action = "<a href='#' target='analisis' title='Detalle cuenta $ref->{'cuenta'}' onclick=\"window.open('$link','detalle','scrollbars=yes,resizable=yes,width=700,height=500');return false;\">$ref->{'cuenta'}</a>";

          #print Tr({-class=>$style."lkitem"},td({-align=>"center"},$action),td(NombreCuenta($ref->{'cuenta'})),td({-align=>"right"},commify(sprintf("%15.2f",$ref->{'debe'}))),td({-align=>"right"},commify(sprintf("%15.2f",$ref->{'haber'}))));

          #print Tr({-class=>$style."lkitem"},td({-align=>"center"},$link),td(NombreCuenta($ref->{'cuenta'})),td({-align=>"right"},commify(sprintf("%15.2f",$ref->{'debe'}))),td({-align=>"right"},commify(sprintf("%15.2f",$ref->{'haber'}))));
    }

    if ($pageno == $pages) { # La ultima pagina
        if (param('opty') ne 'busca') {   
            #$sql = "SELECT substring(a.cuenta,1,3) as cta,SUM(IF(a.dh=0,$mcontab,0)) AS debe,SUM(IF(a.dh=1,$mcontab,0)) AS haber FROM cc_diariodet a, cc_diariocab b WHERE b.estado='0' AND (a.secuencial=b.secuencial) AND a.cuenta like '$subcuenta%' AND substring(a.cuenta,4,3) != '000' GROUP BY cta";
        $sql = "SELECT substring(a.cuenta,1,3) as cta,SUM(IF(a.dh=0,$mcontab,0)) AS debe,SUM(IF(a.dh=1,$mcontab,0)) AS haber FROM cc_diariodet a, cc_diariocab b WHERE b.estado='0' AND (a.secuencial=b.secuencial) AND a.cuenta like '$subcuenta%' AND (substring(a.cuenta,4,3) != '000' or substring(a.cuenta,6,100)>0 ) GROUP BY cta";
       
        } else {
          #  $sql = "SELECT substring(a.cuenta,1,3) as cta,SUM(IF(a.dh=0,$mcontab,0)) AS debe,SUM(IF(a.dh=1,$mcontab,0)) AS haber FROM cc_diariodet a, cc_diariocab b, cc_cuentas c WHERE b.estado='0' AND (a.cuenta=c.cuenta) AND (a.secuencial=b.secuencial) AND a.cuenta like '$subcuenta%' AND c.dsc like '%$busca_nombre_cta%' AND substring(a.cuenta,4,3) != '000' GROUP BY cta";
          $sql = "SELECT substring(a.cuenta,1,3) as cta,SUM(IF(a.dh=0,$mcontab,0)) AS debe,SUM(IF(a.dh=1,$mcontab,0)) AS haber FROM cc_diariodet a, cc_diariocab b, cc_cuentas c WHERE b.estado='0' AND ((substring(a.cuenta,1,6)=b.cuenta)=c.cuenta) AND (a.secuencial=b.secuencial) AND a.cuenta like '$subcuenta%' AND c.dsc like '%$busca_nombre_cta%' AND (substring(a.cuenta,4,3) != '000' or substring(a.cuenta,6,100)>0 ) GROUP BY cta";
       
        }
        my ($cta,$tdebe,$thaber) = $dbh->selectrow_array($sql);
        print Tr({-class=>$style."lkitem",-bgcolor=>"lightgreen"},td("&nbsp;"),td({-align=>"right"},b("T O T A L E S&nbsp;:&nbsp;")),td({-align=>"right"},b(commify(sprintf("%15.2f",$tdebe)))),td({-align=>"right"},b(commify(sprintf("%15.2f",$thaber)))));
    } else {
        print Tr({-class=>$style."lkitem",-bgcolor=>"lightgreen"},td("&nbsp;"),td("&nbsp;"),td("&nbsp;"),td("&nbsp;"));
    }

    print "</table>";
    
    # **************
    # Paginador
    # **************
    if ($pages > 1) {
       talonpaginador($firstpage,$lastpage,$lpp,$pageno,$pages,"?opt=analisis&optx=subcuenta&subcuenta=".param('subcuenta')); 
    }

    # Buscar
    if ($records > $lpp) {
        print start_form();
        print "<br><table align=center border=0>";
        print "<tr><td class=".$style."lkitem><b>Buscar por nombre de cuenta</b>&nbsp;</td>";
        print "<td>".textfield(-name=>"busca_nombre_cta",-value=>"",-override=>"1",-size=>"10",-maxlength=>"20",-onchange=>"document.forms[0].opty.value='busca';submit();")."<td></td></tr>";
        print "</table>";
        print hidden(-name=>"opt",-value=>"analisis",-override=>1);
        print hidden(-name=>"optx",-value=>"subcuenta",-override=>1);
        print hidden(-name=>"subcuenta",-value=>"$subcuenta",-override=>1);
        print hidden(-name=>"opty",-value=>"",-override=>1);
        print end_form();
    } 

    print "<center><a href='javascript:window.close();' title='Cerrar ventana'>".img({-src=>"/images/return.png",-border=>"0",-alt=>"return.png"})."</a></center>";

    print end_html();
}

if (param('optx') eq 'cuenta') {       # Analisis de cuenta XXXXXX

    # Notas : 
    # Muestra las cuentas de balance XXXXXX
    # Muestra los movimientos del periodo actual
    # Colocar un listbox para mostrar periodos anteriores

    # Guarda parametros de retorno (there are two paginators nested)
    if (defined(param('xoffset')) and defined(cookie('contab'))) {
       if (my $sess_ref = opensession()) {
           $sess_ref->{xoffset} = param('xoffset');
           $sess_ref->{xparam1} = param('xparam1');
           $sess_ref->close();
       }
    }
  
    my $cuenta = (!defined(param('cuenta'))) ? $dbh->selectrow_array("SELECT cuenta from cc_cuentas WHERE dsc LIKE '%".param('nombrecta')."%' AND cuenta LIKE '". param('subcuenta'). "%'") : param('cuenta');
    
    if (substr($cuenta,3,3) eq '000' or $cuenta eq '') {
       print "<br><br><br><div align=center class=".$style."mditem>No existe un nombre de cuenta con texto parecido a '".param('nombrecta')."'</div>";
       return;
    }
   
    page_header("ridged_paper.png","","Cuenta $cuenta");

    # **************
    # Listbox
    # **************
    #my $default = $dbh->selectrow_array("SELECT substring(a.fecha_conta,1,7) AS periodo FROM cc_diariocab a,cc_diariodet b WHERE (a.secuencial=b.secuencial) AND b.cuenta='$cuenta' GROUP BY periodo ORDER BY periodo DESC LIMIT 1");
    #print $default,"<br>";

    #my $sql = "SELECT substring(a.fecha_conta,1,7) AS periodo FROM cc_diariocab a,cc_diariodet b WHERE (a.secuencial=b.secuencial) AND b.cuenta='$cuenta' GROUP BY periodo ORDER BY periodo DESC";
    #$sth = $dbh->prepare($sql);
    #$sth->execute();
    #$ref = $sth->fetchrow_hashref();
    #my (%labels,@names);
    #while ($ref = $sth->fetchrow_hashref()) {
    #      $labels{$ref->{'periodo'}} = $ref->{'periodo'};
    #      push(@names,$ref->{'periodo'});
    #}
    #print $sql,"<br>";

    #my $periodo = defined(param('periodo')) ? param('periodo') : $default;

    # **************
    # Paginador
    # **************
    my $lpp       = 12;   # lineas por pagina
    #my $sql       = "SELECT count(*) FROM cc_diariodet a,cc_diariocab b WHERE b.estado='0' AND (a.secuencial=b.secuencial) AND date_format(b.fecha_conta,'%Y-%m') = '$periodo' AND cuenta='$cuenta'";
    my $sql       = "SELECT count(*) FROM cc_diariodet a,cc_diariocab b WHERE b.estado='0' AND (a.secuencial=b.secuencial) AND cuenta='$cuenta'";
    my $records   = $dbh->selectrow_array ($sql);
    my $pages     = int($records/$lpp) + (($records % $lpp > 0) ? 1 : 0);
    my $firstpage = (param('param1') eq '') ? 1 : param('param1');
    my $lastpage  = ($firstpage + $lpp < $pages) ?  $firstpage + $lpp : $pages;
    my $offset    = (param('offset') eq '') ? 0 : param('offset');
    my $pageno    = ($offset + $lpp)  / $lpp;   # Pagina actual
    # **************

    #print $sql,"<br>",$records,"-",$pages,"<br>";

    print start_form();
    print "<br><table border=0 cellpadding=2 cellspacing=2 align=center>";
    print Tr(td({-colspan=>"7",-class=>$style."lkitem",-align=>"center"},b("An&aacute;lisis de Cuenta<br>Pag.&nbsp;".$pageno."/".$pages."&nbsp($records&nbsp;registros)<br>Cuenta&nbsp;".$cuenta."-".NombreCuentaPrincipal($cuenta)."-".NombreSubCuenta($cuenta)."-".NombreCuenta($cuenta))));

    # Display listbox
    #print "<tr><td colspan=7>";
    #print "<table align=center border=0 cellspacing=0 cellpadding=0>";
    #print Tr(td(scrolling_list(-class=>$style."Select",-name=>"periodo",-values=>\@names,-labels=>\%labels,-default=>[""],-override=>"1",-size=>"1",-onchange=>"submit();")));
    #print "</table>";
    #print "</td></tr>";

    print Tr({-class=>$style."lkitem",-align=>"center",-bgcolor=>"lightgreen"},td({-width=>"50"},b("#")),td({-width=>"50"},b("Fecha")),td({-width=>"50"},b("Chq./Ref.")),td({-width=>"300"},b("Detalle")),td({-width=>"100"},b("Debe")),td({-width=>"100"},b("Haber")),td({-width=>"100"},b("Saldo")) );
   
    # Calcula el saldo al periodo anterior
    #my $saldoant;
    #my $sql = "SELECT IF(dh=0,$mcontab,0) AS DEBE, IF(dh=1,$mcontab,0) AS HABER FROM cc_diariodet a,cc_diariocab b WHERE b.estado='0' AND (a.secuencial=b.secuencial) AND date_format(b.fecha_conta,'%Y-%m') < '$periodo' AND a.cuenta = '$cuenta' ORDER BY a.secuencial,b.consolida,b.fecha_conta";
    #$sth = $dbh->prepare($sql);
    #$sth->execute();
    #while ($ref = $sth->fetchrow_hashref()) {
    #      $saldoant += ($ref->{'DEBE'} - $ref->{'HABER'});
    #} 
    
    # Despliega el saldos de pagina
    my $saldoant;
    if ($pageno > 1) {
        my $numregs = ($pageno - 1) * $lpp;
        #my $sql = "SELECT IF(dh=0,$mcontab,0) AS DEBE, IF(dh=1,$mcontab,0) AS HABER FROM cc_diariodet a,cc_diariocab b WHERE b.estado='0' AND (a.secuencial=b.secuencial) AND date_format(b.fecha_conta,'%Y-%m') = $periodo AND a.cuenta = '$cuenta' ORDER BY a.secuencial,b.consolida,b.fecha_conta LIMIT 0,$numregs";
        my $sql = "SELECT IF(dh=0,$mcontab,0) AS DEBE, IF(dh=1,$mcontab,0) AS HABER FROM cc_diariodet a,cc_diariocab b WHERE b.estado='0' AND (a.secuencial=b.secuencial) AND a.cuenta = '$cuenta' ORDER BY a.secuencial,b.consolida,b.fecha_conta LIMIT 0,$numregs";
        #print $sql,"<br>";
        $sth = $dbh->prepare($sql);
        $sth->execute();
        while ($ref = $sth->fetchrow_hashref()) {
              $saldoant += ($ref->{'DEBE'} - $ref->{'HABER'});
        }
    }
    #print "saldoantr=",$saldoant,"<br>";

    # Query de pagina
    #my $sql = "SELECT a.secuencial,substring(b.fecha_conta,1,10) as fecha,b.consolida,b.referencia,b.glosa,IF(dh=0,soles,0) AS debe,IF(dh=1,soles,0) AS haber,IF(dh=0,dolar,0) AS debe_d,IF(dh=1,dolar,0) AS haber_d FROM cc_diariodet a,cc_diariocab b WHERE b.estado='0' AND (a.secuencial=b.secuencial) AND date_format(b.fecha_conta,'%Y-%m') = '$periodo' AND a.cuenta = '$cuenta' ORDER BY a.secuencial,b.consolida,b.fecha_conta LIMIT $offset,$lpp";
    my $sql = "SELECT a.secuencial,substring(b.fecha_conta,1,10) as fecha,b.consolida,b.referencia,b.glosa,IF(dh=0,soles,0) AS debe,IF(dh=1,soles,0) AS haber,IF(dh=0,dolar,0) AS debe_d,IF(dh=1,dolar,0) AS haber_d FROM cc_diariodet a,cc_diariocab b WHERE b.estado='0' AND (a.secuencial=b.secuencial) AND a.cuenta = '$cuenta' ORDER BY b.fecha_conta,b.consolida LIMIT $offset,$lpp";

    #print $sql,"<br>";

    $sth = $dbh->prepare($sql);
    $sth->execute();

    #my $color = ($saldoant > 0) ? 'red' : 'blue';
    my $color = 'black';
    print Tr({-class=>$style."lkitem",-align=>"center"},td("&nbsp;"),td("&nbsp;"),td("&nbsp;"),td({-align=>"right"},b("Saldo Anterior:")),td("&nbsp;"),td("&nbsp;"),td({-align=>"right"},"<font color=$color>".commify(sprintf("%15.2f",$saldoant))."</font>") );

    while ($ref = $sth->fetchrow_hashref()) {
          my $lnk = "?opt=vercomp&call=ac&secuencial=$ref->{'secuencial'}&cuenta_ret=$cuenta&offset=".param('offset')."&param1=".param('param1');
          
          my $saldo = (get_sessiondata('mcontab') eq 'S') ? $saldoant + $ref->{'debe'} - $ref->{'haber'} : $saldoant + $ref->{'debe_d'} - $ref->{'haber_d'};

          #my $color = ($saldo > 0) ? 'red' : 'blue';
          my $color = 'black';
          my $str = "window.open('$lnk','comprobante','scrollbars=yes,resizable=yes,width=800,height=400'); return false;";

          if (get_sessiondata('mcontab') eq 'S') {
              print Tr({-class=>$style."lkitem",-align=>"right"},td({-align=>"center"},a({-href=>"#",-onclick=>"$str",-override=>"1"},$ref->{'secuencial'})),td({-align=>"center"},$ref->{'fecha'}),td({-align=>"left"},$ref->{'referencia'}),td({-align=>"left"},$ref->{'glosa'}),td(commify(sprintf("%15.2f",$ref->{'debe'}))),td(commify(sprintf("%15.2f",$ref->{'haber'}))),td("<font color=$color>".commify(sprintf("%15.2f",$saldo))."</font>") );
          } else {
              print Tr({-class=>$style."lkitem",-align=>"right"},td({-align=>"center"},a({-href=>"#",-onclick=>"$str",-override=>"1"},$ref->{'secuencial'})),td({-align=>"center"},$ref->{'fecha'}),td({-align=>"left"},$ref->{'referencia'}),td({-align=>"left"},$ref->{'glosa'}),td(commify(sprintf("%15.2f",$ref->{'debe_d'}))),td(commify(sprintf("%15.2f",$ref->{'haber_d'}))),td("<font color=$color>".commify(sprintf("%15.2f",$saldo))."</font>") );
          }

          $saldoant = $saldo;
    }

    if ($pageno == $pages) {  # Totales en la ultima pagina

        # Totales
        # Despliega el saldo final
        #my $sql = "SELECT SUM(IF(a.dh=0,$mcontab,0)),SUM(IF(a.dh=1,$mcontab,0)) FROM cc_diariodet a, cc_diariocab b WHERE b.estado='0' AND (a.secuencial=b.secuencial) AND date_format(b.fecha_conta,'%Y-%m')='$periodo' AND a.cuenta='$cuenta'";
        my $sql = "SELECT SUM(IF(a.dh=0,$mcontab,0)),SUM(IF(a.dh=1,$mcontab,0)) FROM cc_diariodet a, cc_diariocab b WHERE b.estado='0' AND (a.secuencial=b.secuencial) AND a.cuenta='$cuenta'";
        my ($tdebe,$thaber) = $dbh->selectrow_array($sql);
        print Tr({-class=>$style."lkitem",-bgcolor=>"lightgreen"},td("&nbsp"),td("&nbsp"),td("&nbsp;"),td({-align=>"right"},b("T O T A L E S&nbsp;:&nbsp;")),td({-align=>"right"},b(commify(sprintf("%15.2f",$tdebe)))),td({-align=>"right"},b(commify(sprintf("%15.2f",$thaber)))),td({-align=>"right"},b(commify(sprintf("%15.2f",$tdebe - $thaber)))) );

       # Antiguedad de la deuda

    } else {
        print Tr({-class=>$style."lkitem",-bgcolor=>"lightgreen"},td("&nbsp"),td("&nbsp"),td("&nbsp;"),td("&nbsp;"),td("&nbsp;"),td("&nbsp;"),td("&nbsp"));
    }

    print "</table>";
       
   # **************
   # Paginador
   # **************
   if ($pages > 1) {
      #talonpaginador($firstpage,$lastpage,$lpp,$pageno,$pages,"?opt=analisis&optx=cuenta&cuenta=$cuenta&periodo=$periodo"); 
      talonpaginador($firstpage,$lastpage,$lpp,$pageno,$pages,"?opt=analisis&optx=cuenta&cuenta=$cuenta"); 
   }

   print table({-align=>"center"},Tr(
               td(a({-href=>"javascript:window.close();",-title=>"Cerrar Ventana"},img({-src=>"/images/return.png",-border=>"0",-alt=>"return.png"}))),
               td("&nbsp;&nbsp;"),
               td("<a href='?opt=vistapre&cuenta=$cuenta' target='inferior' title='Vista Preliminar' onclick=\"window.open('?opt=vistapre&cuenta=$cuenta','vp','scrollbars=yes,resizable=yes,width=800,height=600');return false\">".img({-src=>"/images/gnome-day.png",-border=>"0",-alt=>"return.png",-width=>"20",-height=>"20"})."</a>"),
               td("&nbsp;"),
               td("<a href='?opt=download_cuenta&cuenta=$cuenta' target='inferior' title='Importar esta cuenta'>".img({-src=>"/images/drivemount-applet.png",-border=>"0",-alt=>"drivemount-applet.png",-width=>"40",-height=>"40"})."</a>")
          ));

   print hidden(-name=>"opt",-value=>"analisis",-override=>1);
   print hidden(-name=>"optx",-value=>"cuenta",-override=>1);
   print hidden(-name=>"cuenta",-value=>"$cuenta",-override=>1);
   print hidden(-name=>"periodo",-value=>"",-override=>1);

   print end_form();
   print end_html();

}

if (param('optx') eq 'vpcuenta') {       # Vista preliminar cuenta XXXXXX

    my $cuenta = (!defined(param('cuenta'))) ? $dbh->selectrow_array("SELECT cuenta from cc_cuentas WHERE dsc LIKE '%".param('nombrecta')."%'") : param('cuenta');

    my ($mtd) = $dbh->selectrow_array("SELECT substring(CURDATE(),1,7)");

    my ($periodo) = $dbh->selectrow_array("SELECT date_format(fecha_conta,'%Y') FROM cc_diariocab WHERE estado='0' GROUP BY fecha_conta ORDER by fecha_conta DESC LIMIT 1");

    my %options0 = ("0" => "Mes a la fecha", "1" => "Mes pasado","2" => "Periodo actual","3" => "Periodo anterior","4" => "Inicio a la fecha","5" => "Rango de fechas");
    
    my %options1 = ("0" => "Comprobante", "1" => "Documento","2" => "Fecha","3" => "Consolidado");

    my $rango = (!defined(param('rango'))) ? 0 : param('rango');
    my $orden = (!defined(param('orden'))) ? 0 : param('orden');

    my $sql;

    my  $inicio = $dbh->selectrow_array("SELECT date_format(fecha_conta,'%Y-%m-%d') FROM cc_diariocab a, cc_diariodet b WHERE a.secuencial=b.secuencial AND b.cuenta = ". param('cuenta') ." ORDER BY fecha_conta LIMIT 1");

    # Calcula las fechas
    my ($fecha_desde,$fecha_hasta) = $dbh->selectrow_array("SELECT CURDATE(),CURDATE()");
    if ($rango == 0) {      # Mes actual
        $fecha_desde = sprintf("%s-01",$dbh->selectrow_array("SELECT date_format(CURDATE(),'%Y-%m')"));
        $fecha_hasta = $dbh->selectrow_array("SELECT CURDATE()");
    } elsif ($rango == 1) { # Mes pasado
        # Calculo el ultimo dia del mes pasado
        # Primer dia del mes
        $fecha_hasta = sprintf("%s-01",$dbh->selectrow_array("SELECT date_format(CURDATE(),'%Y-%m')"));
        # Quitamos 1 dia     
        $fecha_hasta = $dbh->selectrow_array("SELECT DATE_ADD('$fecha_hasta',INTERVAL - 1 day)");
        # El primer dia del mes pasado     
        $fecha_desde = sprintf("%s-01",substr($fecha_hasta,0,7));
    } elsif ($rango == 2) { # Periodo actual
        $fecha_desde = sprintf("%d-01-01",$dbh->selectrow_array("SELECT date_format(CURDATE(),'%Y')"));
        $fecha_hasta = $dbh->selectrow_array("SELECT CURDATE()");
    } elsif ($rango == 3) { # Periodo anterior
        $fecha_desde = sprintf("%d-01-01",$dbh->selectrow_array("SELECT date_format(CURDATE(),'%Y')") - 1);
        $fecha_hasta = sprintf("%d-01-01",$dbh->selectrow_array("SELECT date_format(CURDATE(),'%Y')"));
        $fecha_hasta = $dbh->selectrow_array("SELECT DATE_ADD('$fecha_hasta', INTERVAL - 1 day)");
    } elsif ($rango == 4) { # Inicio a la fecha 
        $fecha_desde = $inicio;
        $fecha_hasta = $dbh->selectrow_array("SELECT CURDATE()");
    } elsif ($rango == 5) { # Seleccion del usuario 
        $fecha_desde = param('fecha_desde');
        $fecha_hasta = param('fecha_hasta');
    }
 
    # Calcula el Saldo anterior 
    my $sql = "SELECT (SUM(IF(a.dh=0,a.soles,0)) - SUM(IF(a.dh=1,a.soles,0))) FROM cc_diariodet a,cc_diariocab b WHERE b.estado='0' AND (a.secuencial=b.secuencial) AND date_format(b.fecha_conta,'%Y-%m-%d') >= '$inicio' AND date_format(b.fecha_conta,'%Y-%m-%d') < '$fecha_desde' AND a.cuenta = '$cuenta'";
    my $saldo = $dbh->selectrow_array($sql);
    #print $sql,"<br>";

    page_header("ridged_paper.png","","Estado de cuenta",'calendar');
    print start_form();

    print "<br><table border=0 cellpadding=2 cellspacing=2 align=center>";
    print Tr(td({-colspan=>"10",-class=>$style."lkitem",-align=>"center"},b("Estado de Cuenta<br>Cuenta&nbsp;".$cuenta."-".NombreCuentaPrincipal($cuenta)."-".NombreSubCuenta($cuenta)."-".NombreCuenta($cuenta))));

    print Tr(td({-colspan=>"10",align=>"center"},table({-border=>"0",width=>"100%"},Tr({-class=>$style."lkitem"},td({-align=>"center"},"Selecci&oacute;n:&nbsp;". scrolling_list(-name =>"rango",-values=>["0","1","2","3","4","5"],-labels=>\%options0,-size =>1,-multiple=>0,-default=>["$rango"],-onchange=>"document.forms[0].submit();"),td("Desde&nbsp;:&nbsp;" . textfield(-name=>"fecha_desde",-id=>"sel1",-value=>"$fecha_desde",-size=>"10",-maxlength=>"10",-override=>"1") . reset(-value=>" ....",-onclick=>"return showCalendar('sel1','%Y-%m-%d');")),td("Hasta&nbsp;:&nbsp;" . textfield(-name=>"fecha_hasta",-id=>"sel2",-value=>"$fecha_hasta",-size=>"10",-maxlength=>"10",-override=>"1") . reset(-value=>" ....",-onclick=>"return showCalendar('sel2','%Y-%m-%d');")),td({-class=>$style."lkitem",-align=>"center"},"Orden:&nbsp;". scrolling_list(-name=>"orden",-values=>["0","1","2","3"],-labels=>\%options1,-size =>1,-multiple=>0,-default=>["$orden"],-onchange=>"document.forms[0].submit();") ))))));

    print Tr({-class=>$style."lkitem",-align=>"center",-bgcolor=>"lightgreen"},td({-width=>"50"},b("#")),td(b("Fecha")),td(b("Chq./Ref.")),td(b("C")),td(b("T")),td(b("Documento")),td({-width=>"300"},b("Detalle")),td(b("Debe")),td(b("Haber")),td(b("Saldo")) );

    my $sql = "SELECT a.secuencial,substring(b.fecha_conta,1,10) as fecha,b.referencia,b.consolida,b.tipodoc,b.docid,b.glosa,IF(a.dh=0,a.soles,0) AS debe,IF(a.dh=1,a.soles,0) AS haber FROM cc_diariodet a,cc_diariocab b WHERE b.estado='0' AND (a.secuencial=b.secuencial) AND date_format(b.fecha_conta,'%Y-%m-%d') >= '$fecha_desde' AND date_format(b.fecha_conta,'%Y-%m-%d') <= '$fecha_hasta' AND a.cuenta = '$cuenta' "; 

    if ($orden == 0) { 
        $sql .= "ORDER BY a.secuencial,b.docid,b.fecha_conta";
    } elsif ($orden == 1) {
        $sql .= "ORDER BY b.docid,b.fecha_conta,a.secuencial";
    } elsif ($orden == 2) {
        $sql .= "ORDER BY fecha_conta,b.tipodoc,b.docid";
    } elsif ($orden == 3) {
        $sql .= "ORDER BY b.consolida,b.tipodoc,b.docid";
    }

    #print $sql,"<br>";

    $sth = $dbh->prepare($sql);
    $sth->execute();

    my ($tdebe,$thaber);
    print Tr({-class=>$style."lkitem",-align=>"right"},td("&nbsp;"),td("&nbsp;"),td("&nbsp;"),td("&nbsp;"),td("&nbsp;"),td("&nbsp;"),td(b("Saldo Anterior:")),td("&nbsp;"),td("&nbsp;"),td(commify(sprintf("%15.2f",$saldo))) );
    while ($ref = $sth->fetchrow_hashref()) {
          $saldo += ($ref->{'debe'} - $ref->{'haber'});
          my $lnk = "?opt=vercomp&call=ac&secuencial=$ref->{'secuencial'}&cuenta_ret=$cuenta&fecha_desde=$fecha_desde&fecha_hasta=$fecha_hasta&rango=$rango&orden=$orden";
          my $str = "window.open('$lnk','comprobante','scrollbars=yes,resizable=yes,width=800,height=400'); return false;";
          print Tr({-class=>$style."lkitem",-align=>"right"},td(a({-href=>"$lnk",-onclick=>"$str"},$ref->{'secuencial'})),td({-align=>"center"},$ref->{'fecha'}),td($ref->{'referencia'}),td($ref->{'consolida'}),td($ref->{'tipodoc'}),td($ref->{'docid'}),td({-align=>"left"},$ref->{'glosa'}),td(commify(sprintf("%15.2f",$ref->{'debe'}))),td(commify(sprintf("%15.2f",$ref->{'haber'}))),td(commify(sprintf("%15.2f",$saldo))) );
          $tdebe  += $ref->{'debe'};
          $thaber += $ref->{'haber'};
    }

    print Tr({-class=>$style."lkitem",-align=>"right",-bgcolor=>"lightgreen"},td("&nbsp;"),td("&nbsp;"),td("&nbsp"),td("&nbsp;"),td("&nbsp"),td("&nbsp;"),td(b("T O T A L E S&nbsp;:&nbsp;")),td(b(commify(sprintf("%15.2f",$tdebe)))),td(b(commify(sprintf("%15.2f",$thaber)))),td(b(commify(sprintf("%15.2f",$saldo)))));

    print "</table>";

    #
    # Antiguedad de la deuda    
    #

    print hidden(-name=>"opt",-value=>"analisis",-override=>1);
    print hidden(-name=>"optx",-value=>"vpcuenta",-override=>1);
    print hidden(-name=>"cuenta",-value=>"$cuenta",-override=>1);
    print end_form();
    print end_html();
    return;

}

} # end sub

# -------------------------------------------------------
sub download_cuenta {
# -------------------------------------------------------
    my $sql = "SELECT a.secuencial as asiento,substring(b.fecha_conta,1,10) as fecha,b.glosa,IF(dh=0,soles,0) AS debe,IF(dh=1,soles,0) AS haber FROM cc_diariodet a,cc_diariocab b WHERE b.estado='0' AND (a.secuencial=b.secuencial) AND a.cuenta = '".param('cuenta')."' ORDER BY b.fecha_conta,a.secuencial";

    my @headrow = ("asiento","fecha","glosa","debe","haber");
    my $dnlfilnam = "cuenta.txt";

    my ($sth,$dbh,$ref);
    $dbh = connectdb();
    $sth = $dbh->prepare($sql);
    $sth->execute();
                                                                                                                            
    print header(-type =>"text/plain",-Content_Disposition=>"attachment; filename =\"Hello\"",attachment=>$dnlfilnam);
                                                                                                                            
    # Print Header
    foreach (@headrow) { print $_,"\t"}; print "\n";
                                                                                                                            
    # Print Detail
    while ($ref = $sth->fetchrow_hashref()) {
           my @values = keys(%$ref);
           foreach my $g (@headrow) {
                    print $$ref{$g},"\t";
           }
           print "\n";
    }

}

# -------------------------------------------------------
sub clase3 {
# -------------------------------------------------------
my ($cta,$rango1,$rango2) = @_;

my $style   = get_sessiondata('cssname');
my $mcontab = (get_sessiondata('mcontab') eq 'S') ? "soles" : "dolar";

my ($sth,$ref,$dbh);
$dbh = connectdb();

#my $sql = "SELECT substring(a.cuenta,1,3) as cta,SUM(IF(a.dh=0,$mcontab,0)) AS debe,SUM(IF(a.dh=1,$mcontab,0)) AS haber FROM cc_diariodet a, cc_diariocab b WHERE b.estado='0' AND (a.secuencial=b.secuencial) AND a.cuenta like '$cta%' AND substring(a.cuenta,4,3) != '000' GROUP BY cta ORDER BY cta";
 my $sql = "SELECT substring(a.cuenta,1,3) as cta,SUM(IF(a.dh=0,$mcontab,0)) AS debe,SUM(IF(a.dh=1,$mcontab,0)) AS haber FROM cc_diariodet a, cc_diariocab b WHERE b.estado='0' AND (a.secuencial=b.secuencial) AND a.cuenta like '$cta%' AND (substring(a.cuenta,4,3) != '000' or substring(a.cuenta,6,100)>0 ) and DATE_FORMAT(b.fecha_conta,'%Y-%m') >= '$rango1' and DATE_FORMAT(b.fecha_conta,'%Y-%m') <= '$rango2' GROUP BY cta ORDER BY cta";

$sth = $dbh->prepare($sql);
$sth->execute();
#print $sql,"<br>";

my $ret = "<table width=100% border=0 cellpadding=0 cellspacing=0>";
while ($ref = $sth->fetchrow_hashref()) {
       my $link   = "?opt=analisis&optx=subcuenta&subcuenta=".$ref->{'cta'};
       my $action = "<a href='#' target='inferior' title='Sub cuentas clase $ref->{'cta'}' onclick=\"window.open('$link','sub-cuentas','scrollbars=yes,resizable=yes,width=600,height=500');return false;\">$ref->{'cta'}</a>";
       $ret .= Tr({-class=>$style."lkitem"},td({-width=>"50"},$action),td(NombreCuenta($ref->{'cta'}."000")),td({-width=>"100",-align=>"right"},commify(sprintf("%15.2f",$ref->{'debe'}))),td({-width=>"100",align=>"right"},commify(sprintf("%15.2f",$ref->{'haber'}))));
}
$ret .= "</table>";

}

# -------------------------------------------------------
sub fld0 {
# -------------------------------------------------------
my ($cta,$periodo) = @_;

my $style   = get_sessiondata('cssname');
my $mcontab = (get_sessiondata('mcontab') eq 'S') ? "soles" : "dolar";

my ($sth,$ref,$dbh);
$dbh = connectdb();

my $sql = "SELECT substring(a.cuenta,1,3) as cta,SUM(IF(a.dh=0,$mcontab,0)) AS debe,SUM(IF(a.dh=1,$mcontab,0)) AS haber FROM cc_diariodet a, cc_diariocab b WHERE b.estado='0' AND (a.secuencial=b.secuencial) AND a.cuenta like '$cta%' AND substring(a.cuenta,4,3) != '000' AND date_format( b.fecha_conta, '%Y-%m' ) = '$periodo' GROUP BY cta ORDER BY cta";

$sth = $dbh->prepare($sql);
$sth->execute();
#print $sql,"<br>";

my $ret = "<table width=100% border=0 cellpadding=0 cellspacing=0>";
while ($ref = $sth->fetchrow_hashref()) {
       my $link   = "?opt=ldiario&optx=subcuenta&subcuenta=".$ref->{'cta'}."&periodo=$periodo";
       my $action = "<a href='#' target='inferior' title='Sub cuentas clase $ref->{'cta'}' onclick=\"window.open('$link','sub-cuentas','scrollbars=yes,resizable=yes,width=600,height=500');return false;\">$ref->{'cta'}</a>";
       $ret .= Tr({-class=>$style."lkitem"},td({-width=>"50"},$action),td(NombreCuenta($ref->{'cta'}."000")),td({-width=>"100",-align=>"right"},commify(sprintf("%15.2f",$ref->{'debe'}))),td({-width=>"100",align=>"right"},commify(sprintf("%15.2f",$ref->{'haber'}))));
}
$ret .= "</table>";

}

# -------------------------------------------------------
sub fld1 {
# -------------------------------------------------------
my ($periodo,$subcuenta) = @_;

my $style   = get_sessiondata('cssname');
my $mcontab = (get_sessiondata('mcontab') eq 'S') ? "soles" : "dolar";

my ($sth,$ref,$dbh);
$dbh = connectdb();
my $sql = "SELECT a.cuenta,SUM(IF(a.dh=0,$mcontab,0)) AS debe,SUM(IF(a.dh=1,$mcontab,0)) AS haber FROM cc_diariodet a,cc_diariocab b,cc_cuentas c WHERE b.estado='0' AND (a.cuenta=c.cuenta) AND (a.secuencial=b.secuencial)  AND a.cuenta like '$subcuenta%' AND substring(a.cuenta,4,3) != '000'AND date_format(b.fecha_conta,'%Y-%m') = '$periodo'  GROUP BY cuenta ORDER BY cuenta ";
$sth = $dbh->prepare($sql);
$sth->execute();

my $ret = "<br><table border=0 cellpadding=2 cellspacing=2 align=center>";
   #$ret .= Tr(td({-colspan=>"4",-class=>$style."lkitem",-align=>"center"},b("Cuentas de la clase&nbsp;".param('subcuenta')."<br>&nbsp;&nbsp;".NombreCuentaPrincipal(substr($subcuenta,0,2).'0000')."-".NombreCuenta($subcuenta."000"))));
    
    #$ret .= Tr({-class=>$style."lkitem",-align=>"center",-bgcolor=>"lightgreen"},td({-width=>"50"},b("Cuenta")),td({-width=>"300"},b("Nombre de la Cuenta")),td({-width=>"100"},b("Debe")),td({-width=>"100"},b("Haber")) );

    while ($ref = $sth->fetchrow_hashref()) {

          my $link = "?opt=vistapre&cuenta=$ref->{'cuenta'}&xoffset=".param('offset')."&xparam1=". param('param1');
          my $str  = "<a href='$link' target='detalle' title='Vista Preliminar' onclick=\"window.open('$link','vp','scrollbars=yes,resizable=yes,width=800,height=600');return false\">$ref->{'cuenta'}</a>";
          $ret .= Tr({-class=>$style."lkitem"},td({-align=>"center"},$str),td(NombreCuenta($ref->{'cuenta'})),td({-align=>"right"},commify(sprintf("%15.2f",$ref->{'debe'}))),td({-align=>"right"},commify(sprintf("%15.2f",$ref->{'haber'}))));
    
}

$sql = "SELECT substring(a.cuenta,1,3) as cta,SUM(IF(a.dh=0,$mcontab,0)) AS debe,SUM(IF(a.dh=1,$mcontab,0)) AS haber FROM cc_diariodet a, cc_diariocab b, cc_cuentas c WHERE b.estado='0' AND (a.cuenta=c.cuenta) AND (a.secuencial=b.secuencial) AND a.cuenta like '$subcuenta%' AND date_format(b.fecha_conta,'%Y-%m') = '$periodo'  AND  substring(a.cuenta,4,3) != '000' GROUP BY cta";

 my ($cta,$tdebe,$thaber) = $dbh->selectrow_array($sql);
        $ret .= Tr({-class=>$style."lkitem",-bgcolor=>"lightgreen"},td("&nbsp;"),td({-align=>"right"},b("T O T A L E S&nbsp;:&nbsp;")),td({-align=>"right"},b(commify(sprintf("%15.2f",$tdebe)))),td({-align=>"right"},b(commify(sprintf("%15.2f",$thaber)))));

$ret .= "</table>";

}



# -----------------------------------------------------------
sub page_header {
# -----------------------------------------------------------
my ($fondo,$event,$head,$calendar) = @_;

my $background = (defined($fondo)) ? $fondo : "papelfondo.jpg";
my $onload     = (defined($event)) ? $event : "history.forward();";
my $title      = (defined($head))  ? $head  : "Contabilidad General";

print header;
my $cssname    = get_sessiondata('cssname');
my $stylesheet = "/themes/".$cssname.".css";

if ($calendar ne 'calendar') {

   print start_html(-title  => "$title",
                 -meta   => {keywords=>'$title',copyright=>'Reynaldo Lam'},
                 -author => 'reynaldolam@yahoo.com',
                 -expire => 'now',
                 -style  => {-src=> "$stylesheet"},   # or -code=>"$style"
                 -script => {-language=>'javascript',-src=> "/includes/chkent.js"},
                 -marginwidth  => "0",
                 -marginheight => "0",
                 -leftmargin   => "0",
                 -topmargin    => "0",
                 -onload       => "$onload",
                 -class        => $cssname."PageBODY",
                 -link         => "#000000",
                 -alink        => "#000000",
                 -vlink        => "#000000",
                 -background   => "/images/" . $background
                );
} else {

    print start_html(-title=>"$title",
                      -meta   => {keywords=>'Contabilidad',copyright=>'Reynaldo Lam'},
                      -author => 'reynaldolam@yahoo.com',
                      -expire => 'now',
                      -style  => {-src=> ["/calendar/skins/aqua/theme.css","/themes/".$cssname.".css"],-media=>'all'},
                      -script => [
                                    { -language => 'JavaScript',
                                      -src      => '/calendar/calendar_stripped.js'
                                    },
                                    { -language => 'JavaScript',
                                      -src      => '/calendar/lang/calendar-en.js'
                                    },
                                    { -language => 'JavaScript',
                                      -src      => '/calendar/calendar-aux.js'
                                    }
                              ],
                      -marginwidth  => "0",
                      -marginheight => "0",
                      -leftmargin   => "0",
                      -topmargin    => "0",
                      -class        => $cssname."PageBODY",
                      -link         => "#000000",
                      -alink        => "#000000",
                      -vlink        => "#000000",
                      -background   => "/images/". $background
                );

}

}

# -----------------------------------------------------------
sub commify {
# -----------------------------------------------------------
    my $text = reverse $_[0];
    $text =~ s/(\d\d\d)(?=\d)(?!\d*\.)/$1,/g;
    return scalar reverse $text;
}

# -----------------------------------------------------------
sub print_extern_friendly {
# -----------------------------------------------------------
my ($link) = @_;
print header;
print <<EOF;
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"><html><head><title>Vista Preliminar</title>
<style type="text/css">
<!--
  /* avoid stupid IE6 bug with frames and scrollbars */
  body {
      voice-family: "\"}\"";
      voice-family: inherit;
      width: expression(document.documentElement.clientWidth - 30);
  }
-->
</style></head>
<frameset rows="40,*" noresize="" border="0">
<frame src="?opt=top2" name="top" scrolling="no">
<frame src="$link" name="bot">
</frameset>
</html>
EOF
}

# -----------------------------------------------------------
sub print_friendly {
# -----------------------------------------------------------
my ($link) = @_;
print header;
print <<EOF;
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"><html><head><title>Vista Preliminar</title>
<style type="text/css">
<!--
  /* avoid stupid IE6 bug with frames and scrollbars */
  body {
      voice-family: "\"}\"";
      voice-family: inherit;
      width: expression(document.documentElement.clientWidth - 30);
  }
-->
</style></head>
<frameset rows="40,*" noresize="" border="0">
<frame src="?opt=top_vistapre" name="top_frame" scrolling="no">
<frame src="$link" name="bottom_frame">
</frameset>
</html>
EOF
}

# -----------------------------------------------------------
sub top2 {
# -----------------------------------------------------------
print header;
print <<EOF;
<html><head>
<title>Vista Preliminar</title><script language="javascript" type="text/javascript">
<!--
function printPopup() {
window.inferior.frames[1].focus();
window.inferior.frames[1].print();
}
-->
</script>
<style type="text/css">
<!--
  /* avoid stupid IE6 bug with frames and scrollbars */
  body {
      voice-family: "\"}\"";
      voice-family: inherit;
      width: expression(document.documentElement.clientWidth - 30);
  }
-->
</style>
</head>
<body text='#000000' bgcolor='#DFCFBF' link='#800000' vlink='#800000' alink='#800000'>
<div align="center"><b><form target='inferior'><input type="button" value="Imprimir" onclick="window.top.print();" /> <input type="button" value="Cerrar" onclick="submit();" /><input type=hidden name=opt value=analisis><input type=hidden name=optx value=bg4></form></b></div>
</body></html>
EOF
}

# -----------------------------------------------------------
sub top_vistapre {
# -----------------------------------------------------------
print header;
print <<EOF;
<html><head>
<title>Vista Preliminar</title><script language="javascript" type="text/javascript">
<!--
function printPopup() {
parent.frames[1].focus();
parent.frames[1].print();
}
-->
</script>
<style type="text/css">
<!--
  /* avoid stupid IE6 bug with frames and scrollbars */
  body {
      voice-family: "\"}\"";
      voice-family: inherit;
      width: expression(document.documentElement.clientWidth - 30);
  }
-->
</style>
</head>
<body text='#000000' bgcolor='#DFCFBF' link='#800000' vlink='#800000' alink='#800000'>
<div align="center"><b><form><input type="button" value="Imprimir" onclick="printPopup()" /> <input type="button" value="Cerrar" onclick="window.parent.close()" /></form></b></div>
</body></html>
EOF
}

# -----------------------------------------------------------
sub top_main {
# -----------------------------------------------------------
my $perfil  = get_sessiondata('perfil');
my $style   = get_sessiondata('cssname');
my $caja    = get_sessiondata('caja');
                                                                                                                            
print "<table border=0 cellpading=1 cellspacing=1 width=100% class=".$style."FormTABLE>";
print "<tr><td width=39%>";
                                                                                                                            
# Logo
print table({-border=>"1",-width=>"100%"},Tr(td({-height=>"50",-align=>"center",-bgcolor=>"#000000"},"<font type=Verdana color=#FFCC00 size=5>". get_sessiondata('tienda'). "</font>")));
                                                                                                                            
# Titulo
print "<td align=center><h2>Contabilidad General</h2></td>";
print td({-width=>"50"},img({-src=>"/images/inventario.png",-border=>"0",-alt=>"inventario.png",-width=>"30",-height=>"30"}));
print td({-width=>"50"},a({-href=>"?opt=changepass",-title=>"Cambio de clave",-onclick=>"window.open('?opt=changepass','pass','scrollbars=yes,resizable=yes,width=220,height=150');return false;"},img({-src=>"/images/keyring.png",-border=>"0",-alt=>"keyring.png",-width=>"30",-height=>"30"})));
                                                                                                                            
print "</tr></table>";
print "</td>";
                                                                                                                            
print "</tr>";
print "</table>";
}

# -----------------------------------------------------------
sub sunat {
# -----------------------------------------------------------
my $ua = new LWP::UserAgent;
$ua->agent("AgentName/0.1 " . $ua->agent);

# Create a Header Object
my $header = HTTP::Headers->new('referer','http://www.sunat.gob.pe/cr/frameCriterioBusqueda.jsp');

# Create a request
my $req = HTTP::Request->new('POST','http://www.sunat.gob.pe/cl-ti-itmrconsruc/jcrS00Alias',$header);

my $msg = "";

$req->content_type('application/x-www-form-urlencoded');
$req->content("nroRuc=".param('ruc')."&accion=consPorRuc");
#---------------------------string original detectado con el HTTP monitor------------------------------------
# Pass request to the user agent and get a response back
my $res = $ua->request($req);
		     
# Check the outcome of the response
page_header("ridged_paper.png");
if ($res->is_success) {
    # todo -> cortar en la linea : <span id="div_estrep" style="visibility:visible">
    print $res->content;
} else {
    print "Bad luck this time\n";
}
print end_html();

}

# -----------------------------------------------------------
sub VerOrdenPorRef {
# -----------------------------------------------------------

my $style = get_sessiondata('cssname');

my ($orden_referencia) = param('orden_referencia');
my ($tipodoc)          = param('tipodoc');

#my @names = param;
#foreach (@names) { print $_ , " = ",param($_), "<br>"; }

my ($ref,$sth,$dbh);
$dbh = connectdb();

my $sql = "SELECT secuencial,usuario,estado,almacen,fecha,fecha_ingreso,referencia,proveedor,tipodoc,memo,tc_compra,moneda,guia,factura FROM almacencab WHERE tipodoc='$tipodoc' AND referencia='$orden_referencia'";
$sth = $dbh->prepare($sql);
$sth->execute();

#print $sql,"<br>";

if (!($ref = $sth->fetchrow_hashref())) {
    return;
}
my $tipodoc    = $ref->{'tipodoc'};
my $secuencial = $ref->{'secuencial'};

my $titulo;
if ($ref->{'tipodoc'} eq '0') {
    $titulo = "Salida de Almac&eacute;n";
} elsif ($ref->{'tipodoc'} eq '1') {
    $titulo = "Pedido al Almac&eacute;n";
} elsif ($ref->{'tipodoc'} eq '2') {
    $titulo = "Ajuste de Inventario";
} elsif ($ref->{'tipodoc'} eq '4') {
    $titulo = "Gasto";
} elsif ($ref->{'tipodoc'} eq '5') {
    $titulo = "Orden de Devolucion";
}

print "<br><table border=0 align=center cellspacing=2 cellpadding=2 class=".$style."FormTABLE>";
print Tr({-class=>$style."FormHeaderFont"},td({-colspan=>"11"},b($titulo."&nbsp;#&nbsp;".$ref->{'referencia'}."<br>Registro #&nbsp;".param('secuencial')."&nbsp;Fecha&nbsp;:&nbsp;".$ref->{'fecha_ingreso'}."&nbsp;T/C=".$ref->{'tc_compra'}."&nbsp;Usuario&nbsp;:&nbsp;".$ref->{'usuario'})));

if ($tipodoc eq '4' or $tipodoc eq '5') {  # Compras | Devoluciones
    print Tr(td({-colspan=>"11"},
          table({-width=>"100%",-border=>"0",-cellspacing=>"0",-cellpadding=>"0"},
               Tr(td("Proveedor&nbsp;:&nbsp;<font color=blue>".$ref->{'proveedor'}."</font>"),
                  td("&nbsp;&nbsp;"),
                  td("Raz&oacute;n&nbsp;Social&nbsp;:&nbsp;<font color=blue>".INV33::nombrerealproovedor($ref->{'proveedor'})."</font>"),
                  td("Guia&nbsp;:&nbsp;"),td({-width=>"70"},$ref->{'guia'}),
                  td("&nbsp;&nbsp;"),
                  td("Factura&nbsp;:&nbsp;"),td({-width=>"70"},$ref->{'factura'})
                ))));
    print Tr({-class=>$style."FormHeaderFont"},td("#"),td("Insumo"),td("Descripci&oacute;n"),td("Und"),td("Cant."),td("Precio"),td("%Desc"),td("%Isc"),td("Flete"),td("Igv"),td("Neto"));
} else {                # Pedidos y Ajustes
   print Tr({-class=>$style."FormHeaderFont"},td("C&oacute;digo"),td("Descripci&oacute;n"),td("Unidad"),td("Costo"),td("Cantidad"),td("Neto"));
}

my $sql="SELECT a.secuencial,a.interno,a.insumo,a.cantidad,a.costo,a.descuento,a.isc,a.flete,a.igv,b.descripcion,b.unidad,b.equivalencia,b.unidad_uso FROM almacendet a LEFT JOIN almacen b ON (a.insumo=b.insumo) WHERE a.secuencial='$secuencial'";

#print $sql,"<br>";

$sth = $dbh->prepare($sql);
$sth->execute();

my ($total,$total_igv);
while ($ref = $sth->fetchrow_hashref()) {

       if ($tipodoc eq '4' or $tipodoc eq '5') {  # Compras | Devoluciones
           my $neto = ( $ref->{"costo"} * $ref->{"cantidad"} * ( 1 - 0.01 * $ref->{"descuento"}) * (1 + 0.01 * $ref->{"isc"}) / (1 + 0.01 * $ref->{"igv"}) ) + $ref->{"flete"} * $ref->{"cantidad"};

           print Tr({-class=>$style."FieldCaptionTD",-align=>"right"},
               td ({-width=>"50",-align=>"center"},$ref->{'interno'}),
               td ({-align=>"left"},$ref->{'insumo'}),
               td ({-width=>"300",-align=>"left"},INV33::nombrearticulo($ref->{'insumo'})),
               td ({-align=>"center"},INV33::unidadarticulo($ref->{'insumo'})),
               td ($ref->{'cantidad'}),
               td ($ref->{'costo'}),
               td ($ref->{'descuento'}),
               td ($ref->{'isc'}),
               td ($ref->{'flete'}),
               td ($ref->{'igv'}),
               td (sprintf("%10.2f",$neto)));
               $total     += $neto;
               $total_igv += $neto * $ref->{"igv"} * 0.01;
       } else {  # Pedidos y ajustes
            my $costo_insumo = INV33::costo_promedio($ref->{'insumo'});
            print Tr({-class=>$style."FieldCaptionTD",-align=>"right"},
               td ({-align=>"left"},$ref->{'insumo'}),
               td ({-width=>"300",-align=>"left"},INV33::nombrearticulo($ref->{'insumo'})),
               td (INV33::unidadarticulo($ref->{'insumo'})),
               td (sprintf("%10.2f",$costo_insumo)),
               td (sprintf("%10.2f",$ref->{'cantidad'})),
               td (sprintf("%10.2f",$costo_insumo * $ref->{'cantidad'})));
               $total  += $costo_insumo * $ref->{'cantidad'};
       }
}
 
# Linea de totales
if ($tipodoc eq '4' or $tipodoc eq '5') {      # Compras
    print Tr({-class=>$style."FieldCaptionTD",-align=>"right"},td({-colspan=>"10"},b("Valor Venta ".get_sessiondata('simbolo_nac')."&nbsp")),td(b(sprintf("%10.2f",$total))));
    print Tr({-class=>$style."FieldCaptionTD",-align=>"right"},td({-colspan=>"10"},b("Impuesto General a las Ventas ".get_sessiondata('simbolo_nac')."&nbsp;")),td(b(sprintf("%10.2f",$total_igv))));
    print Tr({-class=>$style."FieldCaptionTD",-align=>"right"},td({-colspan=>"10"},b("Total Orden ". get_sessiondata('simbolo_nac')."&nbsp")),td(b(sprintf("%10.2f",$total + $total_igv))));
} elsif ($tipodoc eq '1' or $tipodoc eq '2') {  # Pedidos y ajustes
    print Tr({-class=>$style."FieldCaptionTD",-align=>"right"},td({-colspan=>"5"},b("Total Orden ".get_sessiondata('simbolo_nac')."&nbsp")),td(b(sprintf("%10.2f",$total))));
}

print "</table><br>";

}

# -------------------------------------------------------
sub topbanner {
# -------------------------------------------------------
my ($bannertitle) = @_;
my $style = get_sessiondata('cssname');
print table({-width=>"100%"},Tr({-align=>"center",-class=>$style."FieldCaptionTD"},td(INV33::getDate()),td("T/C:","C=".get_sessiondata('tc_compra')."&nbsp;V=".get_sessiondata('tc_venta')),td("Usuario&nbsp;:&nbsp;".get_sessiondata('user')."\@".cookie('database')),td({-width=>"30%"},$bannertitle)));
}

# -----------------------------------------------------------
sub ProveedorScroll {
# -----------------------------------------------------------
my ($provee)=@_;



#my @names = param;
#foreach (@names) { print $_ , " = ",param($_), "<br>"; }
#$provee = (defined(param('provee'))) ? param('provee') : $provee;

my $style  = get_sessiondata('cssname');
my $opt    = param('opt');

my $sql;
my (%labels,@names);
$labels{''} = "--------------------- SELECCIONAR --------------------";
push(@names,'');
if ($provee) {
   my ($ref,$sth,$dbh);
   $dbh = connectdb();
   $sql = "SELECT cuenta as ruc,dsc FROM cc_anexo WHERE  tipo_anexo='$provee'";
   $sth = $dbh->prepare($sql);
   $sth->execute();
   while ($ref = $sth->fetchrow_hashref()) {
         $labels{$ref->{'ruc'}} = $ref->{'ruc'}." - ".$ref->{'dsc'};
         push(@names,$ref->{'ruc'});
   }
} 
                  

                                                                                                          
if (scalar(@names) == 0) {
   return;
}

my $depstr = "<table border=0 cellspacing=0 cellpadding=0 class=".$style."FormTABLE>";
$depstr .= Tr({-class=>$style."FieldCaptionTD"},td({-align=>"center"},scrolling_list(-class=>$style."Select",-name=>"proveedor",-values=>\@names,-labels=>\%labels,-default=>get_sessiondata('proveedor'),-size=>"1",-onchange=>"document.forms[0].opt.value='$opt';document.forms[0].optx.value='set';submit();")));
$depstr .= "</table>";

}


# -----------------------------------------------------------
sub nombreproveedor {
# -----------------------------------------------------------
my ($proveedor) = @_;
my $dbh = connectdb();
my $sql = "SELECT dsc FROM cc_anexo WHERE cuenta='$proveedor' ";
my $dsc = $dbh->selectrow_array($sql);
}

# -----------------------------------------------------------
sub nombretipo {
# -----------------------------------------------------------
my ($insumo) = @_;
my $dbh = connectdb();
my $sql = "SELECT dsc FROM cc_tcuenta WHERE tcuenta='$insumo'";
my $dsc = $dbh->selectrow_array($sql);
}
# -----------------------------------------------------------
sub cuentatipo {
# -----------------------------------------------------------
my ($insumo) = @_;
my $dbh = connectdb();
my $sql = "SELECT cuenta FROM cc_tcuenta WHERE tcuenta='$insumo'";
my $dsc = $dbh->selectrow_array($sql);
}

# -----------------------------------------------------------
sub cuentamanifiesto {
	# -----------------------------------------------------------

	my ($seccion) = @_;
my $dbh = connectdb();
	my $sql = "SELECT scuenta FROM cc_tipoanexo WHERE cuenta='$seccion'";
my $scuenta = $dbh->selectrow_array($sql);
	}

# -----------------------------------------------------------
sub ArmaOrden {
# -----------------------------------------------------------
my ($banner,$pendlnk,$histlnk,$lnkmess,$optlabel,$hdrfld,$sess_array,$mensaje) = @_;

#my @names = param;
#foreach (@names) { print $_ , " = ",param($_), "<br>"; }



my $checknum  = param('checknum');
my $cantidad  = param('cantidad');     
my $costo     = param('costo');        
my $insumo    = param('insumo');       

print <<EOF;
<script type="text/javascript">
function validate(field) {
        rx = /[^0-9.-]/;
        if (rx.test(field.value)) {
           alert("Este campo acepta solamente numeros.");
           field.select();
           field.focus();
        } else {
           document.forms[1].insumo.value="$checknum";
           document.forms[1].optx.value="addcart";
           document.forms[1].submit();
        } 
}

nextfield = "cantidad"; // name of first box on page
netscape = "";
ver = navigator.appVersion; len = ver.length;
for(iln = 0; iln < len; iln++)
    if (ver.charAt(iln) == "(")
        break;
netscape = (ver.charAt(iln+1).toUpperCase() != "C");

function keyDown(DnEvents) {      // handles keypress
         // determines whether Netscape or Internet Explorer
         k = (netscape) ? DnEvents.which : window.event.keyCode;
         if (k == 13) {           // enter key pressed
            rx = /[^0-9.-]/;
            
            if (rx.test(document.forms[1].costo.value)) {
                alert("Este campo acepta solamente numeros.");
                document.forms[1].costo.value=''; 
                document.forms[1].costo.focus(); 
                return false;
            }
            if (nextfield == 'done') {
                 if ((document.forms[1].costo.value != '')) {
                    document.forms[1].insumo.value="$checknum";
                    document.forms[1].optx.value="addcart";
                    document.forms[1].submit();
                    return true;  // submit, we finished all fields
                 }
             } else               // were not done yet, send focus to next box
                 eval('document.forms[1].' + nextfield + '.focus()');
             return false;
         }
}
document.onkeydown = keyDown;     // work together to analyze keystrokes
if (netscape) document.captureEvents(Event.KEYDOWN|Event.KEYUP);

</script>
EOF

my $style  = get_sessiondata('cssname');
my $perfil = get_sessiondata('perfil');

#topbanner($banner);

if (defined(param('mensaje'))) {
   print "<center><font color=blue>".param('mensaje')."</font></center>";
}

if (defined($mensaje)) {
   print "<center><font color=blue>$mensaje</font></center>";
}

my ($sql,$start);
my ($ref,$sth,$dbh);
$dbh = connectdb();

if (param('optx') eq 'set') {
   if (defined(cookie('contab'))) {      
       if (my $sess_ref = opensession($dbh)) {
           $sess_ref->{proveedor} = param('proveedor');
           $sess_ref->{provee} = param('provee');
           $sess_ref->close();
           print "<center><font color=blue>"."RUC SELECCIONADO : ".uc(param('proveedor'))." - ". uc(nombreproveedor(param('proveedor')))."</font></center>";
       }
   }
}

if (param('optx') eq 'settipoanexo') {
   if (defined(cookie('contab'))) {      
       if (my $sess_ref = opensession($dbh)) {
           $sess_ref->{seccion} = param('seccion');
           $sess_ref->close();
           #print "<center><font color=blue>"."RUC SELECCIONADO : ".uc(param('seccion'))." - ". uc(nombreproveedor(param('proveedor')))."</font></center>";
       }
   }
}

if (param('optx') eq 'setmoneda') {
   if (defined(cookie('contab'))) {      
       if (my $sess_ref = opensession($dbh)) {
           $sess_ref->{moneda} = param('moneda');
           $sess_ref->close();
       }
   }
}

if (param('optx') eq 'addcart') {
    if ($costo != 0) {
        additem1($insumo,1,$costo,$sess_array);
        if ($perfil == 4 or $perfil <= 1) {
            if ($hdrfld eq 'Compra') { # Jefes de almacen hacen ordenes de compra y ajustan inventario
               print "<center><font color=blue>".uc("Se agrego  ".uc(nombretipo($insumo)). " X $costo " . " a tu Orden de $hdrfld")."</font></center>";
            }
        } 
       
    } 

   
}




if (defined(param('seccion'))) {
    #print "AQUI LLEGA SECCION ".param('seccion');
   $sql = "SELECT tcuenta,dsc,cuenta FROM cc_tcuenta ";
} else {
   $sql = "SELECT cuenta FROM cc_tipoanexo where scuenta!=''  ORDER BY cuenta LIMIT 1";
   $sth = $dbh->prepare($sql);
   $sth->execute();
   $ref = $sth->fetchrow_hashref();
   $start = $ref->{'cuenta'};
   $sql = "SELECT tcuenta,dsc,cuenta FROM cc_tcuenta ";
}
$sql .= " ORDER BY dsc";

#print $sql,"<br>";



# **************
# Paginador
# **************
#my $lpp = 12;   # lineas por pagina
                                                                                                                            
# Calcula el numero de paginas
#my $records   = $sth->rows();
#my $pages     = int($records/$lpp) + (($records % $lpp > 0) ? 1 : 0);
#my $firstpage = (param('param1') eq '') ? 1 : param('param1');
#my $lastpage  = ($firstpage + 15 < $pages) ?  $firstpage + 15 : $pages;
#my $offset    = (param('offset') eq '') ? 0 : param('offset');
#my $pageno    = ($offset + $lpp)  / $lpp;   # Pagina actual
# **************

#$sql .= " LIMIT $offset,$lpp";

my $seccion   = (defined(param('seccion'))) ? param('seccion') : $start;
my $memo      = param('memo');

print start_form();

# Cabecera 
print "<table align=center width=40% border=0 cellspacing=0 cellpadding=0>";
print "<tr>";

# Links Ver | Pendientes | Historicos
if ($hdrfld eq 'Compra' or $hdrfld eq 'Devolucion') {
    print "<td align=center class=".$style."lkitem><a href='?opt=view".$optlabel."&optlabel=$optlabel&seccion=$seccion&memo=".escapeHTML($memo)."' >$lnkmess</a>&nbsp;|&nbsp;<a href='?opt=".substr($pendlnk,1,length($pendlnk)-1)."&optx=".substr($pendlnk,0,1)."'>Pendientes de Gastos Varios</a>&nbsp;|&nbsp;<a href='?opt=".substr($histlnk,1,length($histlnk)-1)."&optx=".substr($histlnk,0,1)."'>Hist&oacute;ricos</a></td>";
} elsif ($hdrfld eq 'Pedido') {
  #if ($perfil <= 2) {                  # perfil hkz   : crea pedidos, ve pendientes e historicos
   if ($perfil == 5) {                  # perfil china : crea pedidos, ve pendientes e historicos
      print "<td align=center class=".$style."lkitem><a href='?opt=view".$optlabel."&optlabel=$optlabel&seccion=$seccion&memo=".escapeHTML($memo)."' >$lnkmess</a>&nbsp;|&nbsp;<a href='?opt=".substr($pendlnk,1,length($pendlnk)-1)."&optx=".substr($pendlnk,0,1)."'>Pendientes de Gastos Varios</a>&nbsp;|&nbsp;<a href='?opt=".substr($histlnk,1,length($histlnk)-1)."&optx=".substr($histlnk,0,1)."'>Hist&oacute;ricos</a>&nbsp;|&nbsp;<a href='?opt=logout' target='_top'>Salir</a>";
   } else {                             # perfiles != 5 (y los mozos ?)
      print "<td align=center class=".$style."lkitem><a href='?opt=view".$optlabel."&optlabel=$optlabel&seccion=$seccion&memo=".escapeHTML($memo)."'>$lnkmess</a>&nbsp;|&nbsp;<a href='?opt=".substr($pendlnk,1,length($pendlnk)-1)."&optx=".substr($pendlnk,0,1)."'>Pendientes de Gastos Varios</a>&nbsp;|&nbsp;<a href='?opt=".substr($histlnk,1,length($histlnk)-1)."&optx=".substr($histlnk,0,1)."'>Hist&oacute;ricos</a></td>";
   }
} else { # Ajuste
   print "<td align=center class=".$style."lkitem><a href='?opt=view".$optlabel."&optlabel=$optlabel&seccion=$seccion&memo=".escapeHTML($memo)."' >$lnkmess</a>&nbsp;|&nbsp;<a href='?opt=".substr($histlnk,1,length($histlnk)-1)."&optx=".substr($histlnk,0,1)."'>Hist&oacute;ricos</a></td>";
}

print "</tr>";
print "</table>";

# Scrolls line
my $provee = (defined(param('provee'))) ? param('provee') : get_sessiondata('provee');
print "<br><table align=center border=0 cellspacing=0 cellpadding=0>";
if ($optlabel eq 'compra' or $optlabel eq 'devolucion') {
#print "pago en gastos varios, seccion $seccion , optlabel: $optlabel";

    my %options = ("0" => "Soles", "1" => "Dolar");
    my $moneda  = get_sessiondata('moneda'); 
    print "<tr><td colspan=4>";
    print "<table align=center border=0 cellspacing=0 cellpadding=0>";
    print "<tr><td align=right>Anexos&nbsp;:&nbsp;</td><td align=left>".SeccionScroll1($seccion,$optlabel)."</td><td align=center>&nbsp;&nbsp;Moneda&nbsp;:&nbsp;</td><td align=left>". scrolling_list(-name =>"moneda",-values => ["0","1"],-labels => \%options,-size => 1,-multiple => 0,-default => ["$moneda"],-onchange=>"document.forms[0].opt.value='$optlabel';document.forms[0].optx.value='setmoneda';submit();")."</td></tr>";
    print "</table>";
    print "</td></tr>";
    print "<tr> <td>&nbsp;&nbsp;</td><td align=left >".ProveedorScroll($seccion)."</td></tr>";


} elsif ($optlabel eq 'pedido') {
    print "<tr><td align=right>Secci&oacute;n&nbsp;:&nbsp;</td><td align=left>".SeccionScroll1($seccion,$optlabel)."</td></tr>";
} elsif ($optlabel eq 'ajuste') {
    print "<tr><td align=right>Secci&oacute;n&nbsp;:&nbsp;</td><td align=left>".SeccionScroll1($seccion,$optlabel)."</td><td>&nbsp;&nbsp;</td><td><a href='?opt=view".$optlabel."&optlabel=$optlabel&seccion=$seccion&auto=si&memo=".escapeHTML($memo)."' >Ajuste a cero</a></td></tr>";
}
print "</table>";

print hidden(-name=>"opt",-value=>$optlabel,-override=>"1");
print hidden(-name=>"optx",-value=>"",-override=>"1");

print end_form();

#
# Despliega la lista de articulos para armar la orden
#

#print $sql,"<br>";

print start_form();
# Hay articulos marcados ?
if (defined(param('checknum'))) {

    my $sql = "SELECT tcuenta,dsc,cuenta FROM cc_tcuenta WHERE tcuenta = '$checknum'";
    my ($insumo,$descripcion,$unidad) = $dbh->selectrow_array($sql);

    # Titulos
    print "<table border=0 align=center cellspacing=2 cellpadding=2 class=".$style."FormTABLE>";
    if ($hdrfld eq 'Pedido') {               # pedidos
        print Tr({-class=>$style."FormHeaderFont"},td({-colspan=>"8"},b("Ingresa la cantidad")));
        print Tr({-class=>$style."FormHeaderFont"},td({-width=>"30"},"&nbsp;"),td({-width=>"60"},"Cuenta"),td({-width=>"250"},"Descripci&oacute;n"),td({-width=>"50"},"Unidad"),td({-width=>"80"},"Disponible"),td({-width=>"80"},"Cantidad"));
    } elsif ($hdrfld eq 'Compra' or $hdrfld eq 'Devolucion') {     # compras|devolucion
       print Tr({-class=>$style."FormHeaderFont"},td({-colspan=>"9"},b("Ingresa la cantidad y el precio del servicio")));
       print Tr({-class=>$style."FormHeaderFont"},td({-width=>"30"},"&nbsp;"),td({-width=>"60"},"C&oacute;digo"),td({-width=>"250"},"Descripci&oacute;n"),td({-width=>"50"},"Cuenta"),td({-width=>"80"},"Precio"));
    } elsif ($hdrfld eq 'Ajuste') {          # ajustes 
       print Tr({-class=>$style."FormHeaderFont"},td({-colspan=>"8"},b("Ajuste de Inventario")));
       print Tr({-class=>$style."FormHeaderFont"},td({-width=>"30"},"&nbsp;"),td({-width=>"60"},"C&oacute;digo"),td({-width=>"250"},"Descripci&oacute;n"),td({-width=>"50"},"Cuenta"),td({-width=>"80"},"Precio"));
    }
    print "<tr align=center class=".$style."FieldCaptionTD>";
    print "<td>&nbsp;</td>";
    print "<td>$insumo</td>";
    print "<td align=left>$descripcion</td>";
    print "<td>$unidad</td>";   

    if ($hdrfld eq 'Compra' or $hdrfld eq 'Devolucion') {         # compras|devolucion

       print "<td><input type=text name=costo value='' size=8 maxlength=10 onfocus=\"nextfield='done'\"></td>";
    } else {                                # Ajustes y Pedidos

       print "<input type=hidden name=costo value=$ref->{'costo'}>";
    }



    print "</tr>\n";
    print "</table>\n";

    print hidden(-name=>"opt",-value=>"$optlabel",-override=>"1");
    print hidden(-name=>"optx",-value=>"",-override=>"1");
    print hidden(-name=>"opty",-value=>$sess_array,-override=>"1");   # session array name
    print hidden(-name=>"memo",-value=>$memo,-override=>"1");
    print hidden(-name=>"seccion",-value=>"$seccion",-override=>1);
    print hidden(-name=>"insumo",-value=>"",-override=>"1");

    print end_form(),"\n";
    return;
}

# Titulos
print "<table border=0 align=center cellspacing=2 cellpadding=2 class=".$style."FormTABLE>";

if ($hdrfld eq 'Pedido') {          # pedidos
    print Tr({-class=>$style."FormHeaderFont"},td({-colspan=>"6"},b("Selecciona los conceptos de tu $hdrfld")));
} elsif ($hdrfld eq 'Compra') {     # compras
 #   print Tr({-class=>$style."FormHeaderFont"},td({-colspan=>"6"},b("Selecciona los conceptos de tu Orden de $hdrfld")));
print Tr({-class=>$style."FormHeaderFont"},td({-colspan=>"6"},b("Selecciona los conceptos de tus Gastos Varios")));
} elsif ($hdrfld eq 'Ajuste') {     # ajustes 
    print Tr({-class=>$style."FormHeaderFont"},td({-colspan=>"8"},b("Ajuste de Inventario")));
} elsif ($hdrfld eq 'Devolucion') { # devoluciones 
    print Tr({-class=>$style."FormHeaderFont"},td({-colspan=>"8"},b("Devoluciones")));
}

print Tr({-class=>$style."FormHeaderFont"},td({-width=>"30"},"&nbsp;"),td({-width=>"60"},"C&oacute;digo"),td({-width=>"250"},"Descripci&oacute;n"),td({-width=>"50"},"cuenta"));

# Despliega la lista de articulos
$sth = $dbh->prepare($sql);

#print $sql;

$sth->execute();
while ($ref = $sth->fetchrow_hashref()) {
    print "<tr align=center class=".$style."FieldCaptionTD>";
    print "<td><input type=checkbox name=checknum value=$ref->{'tcuenta'} onclick='submit();'></td>";
    print "<td>$ref->{'tcuenta'}</td>";
    print "<td align=left>$ref->{'dsc'}</td>";
    print "<td>$ref->{'cuenta'}</td>";   

    print "</tr>\n";
}
print "</table>\n";

#my $param1 = param('param1');

print hidden(-name=>"opt",-value=>"$optlabel",-override=>"1");
print hidden(-name=>"optx",-value=>"",-override=>"1");
print hidden(-name=>"opty",-value=>$sess_array,-override=>"1");   # session array name
print hidden(-name=>"memo",-value=>$memo,-override=>"1");   
print hidden(-name=>"seccion",-value=>"$seccion",-override=>1);
print hidden(-name=>"insumo",-value=>"",-override=>"1");

#print hidden(-name=>"offset",-value=>"$offset",-override=>"1");
#print hidden(-name=>"param1",-value=>"$param1",-override=>"1");

print end_form(),"\n";

# **************
# Paginador  (desactivado)
# **************
#talonpaginador($firstpage,$lastpage,$lpp,$pageno,$pages,"?opt=$optlabel&seccion=".param('seccion'));

}


# -----------------------------------------------------------
sub SeccionScroll1 {
# -----------------------------------------------------------
my ($default,$retorno) = @_;

my (%labels,@names);
my ($ref,$sth,$dbh);
$dbh = connectdb();
$sth = $dbh->prepare("SELECT cuenta,dsc FROM cc_tipoanexo WHERE scuenta !='' ");
$sth->execute();
while ($ref = $sth->fetchrow_hashref()) {
       $labels{$ref->{'cuenta'}} = $ref->{'dsc'};
       push(@names,$ref->{'cuenta'});
}
my $style  = get_sessiondata('cssname');
my $depstr;
$depstr = "<table border=0 cellspacing=0 cellpadding=0 class=".$style."FormTABLE>";
$depstr .= Tr({-class=>$style."FieldCaptionTD"},td({-align=>"center"},scrolling_list(-class=>$style."Select",-name=>"seccion",-values=>\@names,-labels=>\%labels,-default=>"$default",-size=>"1",-onchange=>"document.forms[0].opt.value=\"$retorno\";document.forms[0].optx.value='settipoanexo';submit();")));
$depstr .= "</table>";

return($depstr);

}
# -----------------------------------------------------------

sub previapendiente {
my $style  = get_sessiondata('cssname');
my $perfil = get_sessiondata('perfil');
my $secuencial = param('secuencial');
my $optx       = param('optx');


my $ldiario     = param('ldiario');
my $fecha_conta = param('fecha_conta');
my $fecha1 = param('fecha');
my $glosa       = param('glosa');
my $tc_compra   = param('tc_compra');
my $tipodoc     = sprintf("%02d",param('tipodoc'));
my $docid       = param('factcompra');
my $ruc         = param('ruc');
my $referencia1  = param('referencia');
my $fecha_ingreso1 = param('fecha_ingreso');

my ($tipodoc,$banner,$listtitle,$execproc); 

if (param('optx') eq 'p') {
   $tipodoc = '0';
   $banner = "Pendiente";
   $listtitle = "Orden de Pedido";
   $execproc  = "ingresapedido";
} elsif (param('optx') eq 'd') {
   $tipodoc = '5';
   $banner = "Pendiente";
   $listtitle = "Orden de Devolucion";
   $execproc  = "ingresadevolucion";
} elsif (param('optx') eq 'c') {
   $tipodoc = '4';
   $banner = "Pendiente";
   $listtitle = "<a href='?opt=cpendiente&optx=$optx&secuencial=$secuencial&defaulttipodoc=".param('tipodoc')."'  target='inferior' title='Regresar'>Gastos Varios</a>";
   $execproc  = "ingresacompra";
} 
#print "optx: $optx , titulo: $listtitle, tipodoc $tipodoc - ".sprintf("%02d",$tipodoc);
my ($ref,$sth,$dbh);
$dbh = connectdb();
my ($user,$fecha,$fecha_ingreso,$tipodoc,$proveedor,$guia,$factura,$tc_compra,$estado,$aprobado,$memo,$referencia) = $dbh->selectrow_array("SELECT usuario,fecha,fecha_ingreso,tipodoc,proveedor,guia,factura,tc_compra,estado,aprobado,memo,referencia FROM almacencab WHERE secuencial='".param('secuencial')."'");
my $totalorden;
my $total_igv;
my $neto;
my $igv = get_sessiondata('igv');
# Detalle
my $sql = "SELECT a.secuencial,a.interno,a.insumo,a.cantidad,a.descuento,a.isc,a.flete,a.igv,a.costo,b.dsc as descripcion,b.cuenta as unidad FROM almacendet a LEFT JOIN cc_tcuenta b ON (a.insumo=b.tcuenta) WHERE a.secuencial='".param('secuencial')."'";
#print $sql;

$sth = $dbh->prepare($sql);
$sth->execute();
#print "tipodoc :".$tipodoc." o :".param('tipodoc');
my $rows = $sth->rows;
	print start_form();   # forms[0]

# Titulo de cabecera
print "<br><table border=1 align=center cellspacing=2 cellpadding=2 class=".$style."FormTABLE>";

print Tr({-class=>$style."FormHeaderFont"},td({-colspan=>"11"},b($listtitle."#&nbsp;&nbsp;".$referencia."&nbsp;&nbsp; Registro #&nbsp;".param('secuencial')."")));

print Tr({-class=>$style."FieldCaptionTD"},td({-colspan=>"11"},table({-border=>"0",-cellspacing=>"0",-cellpadding=>"0"},Tr(td("RUC&nbsp;:&nbsp;"),td("<font color=blue>".$proveedor."</font>"),td("&nbsp;&nbsp;Raz&oacute;n Social&nbsp;:&nbsp;"),td("<font color=blue>".nombreproveedor($proveedor)."</font>") ))));
print Tr({-class=>$style."FieldCaptionTD"},td({-colspan=>"11"},table(Tr(td(b("Diario")),td(comp_nombrediario($ldiario)),td(b("Fecha")),td($fecha),td(b("&nbsp;&nbsp;Emisi&oacute;n,&nbsp;:&nbsp;")."$fecha1"), 
                        td("&nbsp;&nbsp;".b("Vencimiento:")."&nbsp;$fecha_ingreso1")
    ))));
print Tr({-class=>$style."FieldCaptionTD"},td({-colspan=>"11"},table(Tr(td(b("Documento")),td(comp_tipodoc(sprintf("%02d",sprintf("%02d",param('tipodoc'))))),td(b("N&uacute;mero")),td($docid),td(b("Tipo de Cambio")),td({-width=>"100"},$tc_compra),td(b("Usuario:&nbsp;")),td(get_sessiondata('user'))) )));
print Tr({-class=>$style."FieldCaptionTD"},td({-colspan=>"11"},table(Tr(td(b("Detalle")),td({-width=>"200"},$glosa ),td(b("Cheque/Ref.")),td($referencia1) ))));
print Tr({-class=>$style."FormHeaderFont"},td("Codigo"),td("Descripci&oacute;n"),td("Cuenta"),td("Cant."),td("Precio"),td("%Desc"),td("%Isc"),td("Flete"),td("%Igv"),td({-width=>"70"},"Importe"));

   while ($ref = $sth->fetchrow_hashref()) {
   $neto = + $ref->{"flete"} * $ref->{"cantidad"} + ($ref->{'cantidad'} * $ref->{'costo'} * (1 - $ref->{'descuento'} * 0.01) * (1 + $ref->{'isc'} * 0.01)) / (1 + 0.01 * $ref->{'igv'});
 print Tr({-class=>$style."FieldCaptionTD",-align=>"right"},
              td ({-align=>"center"},$ref->{'insumo'}),
                td ({-width=>"250",-align=>"left"},$ref->{'descripcion'}),
                td ({-align=>"center"},$ref->{'unidad'}),
                td ($ref->{'cantidad'}),
                td ($ref->{'costo'}),
                td ($ref->{'descuento'}),
                td ($ref->{'isc'}),
                td ($ref->{'flete'}),
                td ($ref->{'igv'}),
                td (sprintf("%10.2f",$neto)));
                
       $totalorden += $neto;
       $total_igv  += $neto * $ref->{'igv'} * 0.01;
   }
 if (param('optx') eq 'c' or param('optx') eq 'd') {   # Linea de Total para Ordenes de Compra | Devoluciones

    print Tr({-class=>$style."FieldCaptionTD",-align=>"right"},td({-colspan=>"9"},b("Valor Venta&nbsp;".get_sessiondata('simbolo_nac')."&nbsp;")),td(b(sprintf("%10.2f",$totalorden))));
    print Tr({-class=>$style."FieldCaptionTD",-align=>"right"},td({-colspan=>"9"},b("Impuesto General a las Ventas&nbsp;". get_sessiondata('igv') * 100 . "%&nbsp;".get_sessiondata('simbolo_nac')."&nbsp;")),td(b(sprintf("%10.2f",$total_igv))));
    print Tr({-class=>$style."FieldCaptionTD",-align=>"right"},td({-colspan=>"9"},b("Total Orden&nbsp;".get_sessiondata('simbolo_nac')."&nbsp;")),td(b(sprintf("%10.2f",$totalorden + $total_igv))));
}
print "</table>";
	
print end_form(),"\n";
	print br(),table({-align=>"center"},Tr(td(a({-href=>"",-title=>"Imprimir",-onclick=>"window.print();window.close();"},img({-src=>"/images/printer.png",-border=>"0",-alt=>"printer.png",-width=>"36",-height=>"36"}))) ));

	
	}














1;
