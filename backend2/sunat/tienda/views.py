# -*- coding: utf-8 -*-
from __future__ import unicode_literals
from rest_framework.views import APIView
from rest_framework import status
from rest_framework.response import Response
from models import *
from validators import validarRegistroPersona
from django.contrib.auth.models import User
import json
import datetime
from perlfunc import perlfunc, perlreq, perl5lib
import os, errno
from django.conf import settings
import subprocess
from django.db import transaction
from decimal import *
import uuid
from contabilidad import CcDiariocab, CcDiariodet
# import json
# from django.shortcuts import render

# Create your views here.
RUTA_TXT = settings.BASE_DIR + '/txt/'
RUTA_PERL = settings.BASE_DIR + '/tienda'
TODAY = datetime.date.today()

# PRODUCTO #


class listaProducto(APIView):
    def get(self, request, ruc):

        _productos = producto.objects.filter(microempresa__ruc=ruc)

        diccionario = [obj.as_dict() for obj in _productos]

        return Response(status=status.HTTP_200_OK,
                        data={"resultado": diccionario},
                        content_type='application/json')


class buscarProducto(APIView):
    def get(self, request, ruc, idproducto):

        try:
            _producto = producto.objects.filter(microempresa__ruc=ruc, codigoBarras=idproducto)
        except Exception as ex:
            print ex
            _producto = []

        diccionario = [obj.as_dict() for obj in _producto]

        return Response(status=status.HTTP_200_OK,
                        data={"resultado": diccionario},
                        content_type='application/json')


# VENTA #


class listaTOP10(APIView):
    def post(self, request):
        try:
            _request = json.loads(request.body)
        except Exception as ex:
            print ex
            return Response(status=status.HTTP_400_BAD_REQUEST,
                            data={"Errores": "Json no válido"},
                            content_type='application/json')

        ruc = _request.get('ruc', '')

        if ruc == '':
            return Response(status=status.HTTP_400_BAD_REQUEST,
                            data={"Errores": "El ruc de la empresa es requerido"},
                            content_type='application/json')

        try:
            _ruc = int(ruc)
        except Exception as ex:
            return Response(status=status.HTTP_400_BAD_REQUEST,
                            data={"Errores": "El ruc es inválido"},
                            content_type='application/json')

        try:
            _microempresa = microempresa.objects.get(ruc=ruc)

            ordenes = orden.objects.filter(microempresa=_microempresa).values('id')

            ordenes_ids = [obj['id'] for obj in ordenes]

            productos_ids = lineaOrden.objects.filter(orden__id__in=ordenes_ids).values('producto')

            productos = producto.objects.filter(id__in=productos_ids).order_by('-rating')

            diccionario = [obj.as_top10() for obj in productos]

            return Response(status=status.HTTP_200_OK,
                            data={"resultado": diccionario},
                            content_type='application/json')

        except Exception as ex:
            return Response(status=status.HTTP_400_BAD_REQUEST,
                            data={"Errores": str(ex)},
                            content_type='application/json')


class listaTOP10Intervalo(APIView):
    def post(self, request):
        try:
            _request = json.loads(request.body)
        except Exception as ex:
            print ex
            return Response(status=status.HTTP_400_BAD_REQUEST,
                            data={"Errores": "Json no válido"},
                            content_type='application/json')

        fechaInicio = _request.get('fecha_inicio', '')
        fechaFin = _request.get('fecha_fin', '')
        ruc = _request.get('ruc', '')

        if fechaInicio == '' or fechaFin == '':
            return Response(status=status.HTTP_400_BAD_REQUEST,
                            data={"Errores": "Fecha de inicio y de fin son requeridos"},
                            content_type='application/json')

        if ruc == '':
            return Response(status=status.HTTP_400_BAD_REQUEST,
                            data={"Errores": "El ruc de la empresa es requerido"},
                            content_type='application/json')

        try:
            _ruc = int(ruc)
        except Exception as ex:
            return Response(status=status.HTTP_400_BAD_REQUEST,
                            data={"Errores": "El ruc es inválido"},
                            content_type='application/json')

        else:
            try:
                _fechaInicio = datetime.datetime.strptime(fechaInicio, "%d-%m-%Y")
                _fechaFin = datetime.datetime.strptime(fechaFin, "%d-%m-%Y")
                _microempresa = microempresa.objects.get(ruc=ruc)

                ordenes = orden.objects.filter(fechaCreacion__range=[_fechaInicio, _fechaFin], microempresa=_microempresa).values('id')

                ordenes_ids = [obj['id'] for obj in ordenes]

                productos_ids = lineaOrden.objects.filter(orden__id__in=ordenes_ids).values('producto')

                productos = producto.objects.filter(id__in=productos_ids).order_by('-rating')

                diccionario = [obj.as_top10() for obj in productos]

                return Response(status=status.HTTP_200_OK,
                                data={"resultado": diccionario},
                                content_type='application/json')

            except Exception as ex:
                return Response(status=status.HTTP_400_BAD_REQUEST,
                                data={"Errores": str(ex)},
                                content_type='application/json')


# COMPRAS #

class generarOrden(APIView):
    @transaction.atomic
    def post(self, request):
        try:
            _request = json.loads(request.body)
            print 'generar orden-------->'
            print _request
        except Exception as ex:
            print ex
            return Response(status=status.HTTP_400_BAD_REQUEST,
                            data={"Errores": "Json no válido"},
                            content_type='application/json')

        tipoDoc = _request.get('c_tipodoc', '')
        tipoCom = _request.get('c_tipocom', '')
        receptorDoc = _request.get('c_receptordoc', '')
        razonSocial = _request.get('razonsocial', '')
        email = _request.get('email', '')
        ruc = _request.get('ruc', '')
        items = _request.get('producto', [])


        _microempresa = microempresa.objects.get(ruc=ruc)

        try:
            Orden = orden(microempresa=_microempresa, estado='1', tipo='2', total=0, totalImpuesto=0,
                          numeroDocreceptor=receptorDoc, tipoDocreceptor=tipoDoc, tipoComprobante=tipoCom,
                          razonSocial=razonSocial, emailReceptor=email)

            Orden.save()
            print '1'
        except Exception as ex:
            return Response(status=status.HTTP_400_BAD_REQUEST,
                            data={"Errores": str(ex)},
                            content_type='application/json')

        try:
            total = 0
            totalImpuesto = 0
            print items
            for item in items:
                cantidad = item.get('cantidad', '')
                codigoBarras = item.get('codigobarras', '')
                _producto = producto.objects.get(codigoBarras=codigoBarras)
                subtotal = (int(cantidad) * _producto.precioUnitario)
                impuesto = subtotal * Decimal(0.18)
                total = total + (subtotal + impuesto)
                totalImpuesto = totalImpuesto + impuesto
                DetalleOrden = lineaOrden(microempresa=_microempresa, orden=Orden, producto=_producto,
                                          cantidad=cantidad, subtotal=subtotal,
                                          montoImpuesto=impuesto)
                DetalleOrden.save()
                print '2'
        except Exception as ex:
            print ex
            return Response(status=status.HTTP_400_BAD_REQUEST,
                            data={"Errores": str(ex)},
                            content_type='application/json')

        try:
            Orden.total = total
            Orden.totalImpuesto = totalImpuesto
            Orden.save()
            print '3'
        except Exception as ex:
            return Response(status=status.HTTP_400_BAD_REQUEST,
                            data={"Errores": str(ex)},
                            content_type='application/json')

        return Response(status=status.HTTP_200_OK,
                        data={"resultado": True},
                        content_type='application/json')


# ORDENES #


class montoventasMensual(APIView):
    def post(self, request):
        try:
            _request = json.loads(request.body)
        except Exception as ex:
            print ex
            return Response(status=status.HTTP_400_BAD_REQUEST,
                            data={"Errores": ex},
                            content_type='application/json')

        ruc = _request.get('ruc', '')

        if ruc == '':
            return Response(status=status.HTTP_400_BAD_REQUEST,
                            data={"Errores": "El ruc de la empresa es requerido"},
                            content_type='application/json')

        try:
            _ruc = int(ruc)
        except Exception as ex:
            return Response(status=status.HTTP_400_BAD_REQUEST,
                            data={"Errores": "El ruc es inválido"},
                            content_type='application/json')

        try:
            _microempresa = microempresa.objects.get(ruc=ruc)

            ordenes = orden.objects.filter(microempresa=_microempresa, tipo="2", estado="2", fechaCreacion__year=TODAY.year, fechaCreacion__month=TODAY.month)

            total_mes = 0

            for _orden in ordenes:
                total_mes = total_mes + _orden.total

            return Response(status=status.HTTP_200_OK,
                            data={"resultado": total_mes},
                            content_type='application/json')

        except Exception as ex:
            return Response(status=status.HTTP_400_BAD_REQUEST,
                            data={"Errores": str(ex)},
                            content_type='application/json')


class actualizarVentaReceptor(APIView):
    def post(self, request):
        try:
            _request = json.loads(request.body)
        except Exception as ex:
            print ex
            return Response(status=status.HTTP_400_BAD_REQUEST,
                            data={"Errores": ex},
                            content_type='application/json')

        ordenId = _request.get('serie', '')

        if ordenId == '':
            return Response(status=status.HTTP_400_BAD_REQUEST,
                            data={"Errores": "La serie es requerida"},
                            content_type='application/json')

        try:
            orden_ = orden.objects.get(id=ordenId)
            orden_.estado = '2'
            orden_.save()

            #estado = generarCAB(orden.microempresa.ruc, orden.tipo)
            #ejecutarExpect()

            return Response(status=status.HTTP_200_OK,
                            data={"resultado": True},
                            content_type='application/json')

        except Exception as ex:
            return Response(status=status.HTTP_400_BAD_REQUEST,
                            data={"Errores": str(ex)},
                            content_type='application/json')


class ventasPendientesReceptor(APIView):
    def post(self, request):
        try:
            _request = json.loads(request.body)
        except Exception as ex:
            print ex
            return Response(status=status.HTTP_400_BAD_REQUEST,
                            data={"Errores": ex},
                            content_type='application/json')

        documento = _request.get('documento', '')

        if documento == '':
            return Response(status=status.HTTP_400_BAD_REQUEST,
                            data={"Errores": "El documento es requerido"},
                            content_type='application/json')

        try:
            # _microempresa = microempresa.objects.get(ruc=ruc)

            # ordenes = orden.objects.filter(microempresa=_microempresa, tipo=tipo)
            ordenes = orden.objects.filter(numeroDocreceptor=documento, tipo='2', estado='1')

            diccionario = [obj.reporte_venta() for obj in ordenes]

            return Response(status=status.HTTP_200_OK,
                            data={"resultado": diccionario},
                            content_type='application/json')

        except Exception as ex:
            return Response(status=status.HTTP_400_BAD_REQUEST,
                            data={"Errores": str(ex)},
                            content_type='application/json')


class listaOrdenes(APIView):
    def post(self, request):
        try:
            _request = json.loads(request.body)
        except Exception as ex:
            print ex
            return Response(status=status.HTTP_400_BAD_REQUEST,
                            data={"Errores": "Json no válido"},
                            content_type='application/json')

        ruc = _request.get('ruc', '')
        tipo = _request.get('tipo', '')

        if ruc == '':
            return Response(status=status.HTTP_400_BAD_REQUEST,
                            data={"Errores": "El ruc de la empresa es requerido"},
                            content_type='application/json')

        if tipo == '':
            return Response(status=status.HTTP_400_BAD_REQUEST,
                            data={"Errores": "El tipo de reporte es requerido"},
                            content_type='application/json')
        elif tipo not in ['1', '2']:
            return Response(status=status.HTTP_400_BAD_REQUEST,
                            data={"Errores": "El tipo de reporte no es correcto"},
                            content_type='application/json')

        try:
            _ruc = int(ruc)
            _tipo = int(tipo)
        except Exception as ex:
            return Response(status=status.HTTP_400_BAD_REQUEST,
                            data={"Errores": "El ruc es inválido"},
                            content_type='application/json')

        try:
            _microempresa = microempresa.objects.get(ruc=ruc)

            ordenes = orden.objects.filter(microempresa=_microempresa, tipo=tipo)
            diccionario = [obj.as_dict() for obj in ordenes]

            print diccionario
            return Response(status=status.HTTP_200_OK,
                            data={"resultado": diccionario},
                            content_type='application/json')

        except Exception as ex:
            return Response(status=status.HTTP_400_BAD_REQUEST,
                            data={"Errores": str(ex)},
                            content_type='application/json')


class listaOrdenIntervalo(APIView):
    def post(self, request):
        try:
            _request = json.loads(request.body)
        except Exception as ex:
            print ex
            return Response(status=status.HTTP_400_BAD_REQUEST,
                            data={"Errores": "Json no válido"},
                            content_type='application/json')

        ruc = _request.get('ruc', '')
        tipo = _request.get('tipo', '')
        fechaInicio = _request.get('fecha_inicio', '')
        fechaFin = _request.get('fecha_fin', '')

        if fechaInicio == '' or fechaFin == '':
            return Response(status=status.HTTP_400_BAD_REQUEST,
                            data={"Errores": "Fecha de inicio y de fin son requeridos"},
                            content_type='application/json')

        if ruc == '':
            return Response(status=status.HTTP_400_BAD_REQUEST,
                            data={"Errores": "El ruc de la empresa es requerido"},
                            content_type='application/json')

        if tipo == '':
            return Response(status=status.HTTP_400_BAD_REQUEST,
                            data={"Errores": "El tipo de reporte es requerido"},
                            content_type='application/json')
        elif tipo not in ['1', '2']:
            return Response(status=status.HTTP_400_BAD_REQUEST,
                            data={"Errores": "El tipo de reporte no es correcto"},
                            content_type='application/json')

        try:
            _ruc = int(ruc)
            _tipo = int(tipo)
        except Exception as ex:
            return Response(status=status.HTTP_400_BAD_REQUEST,
                            data={"Errores": "El ruc es inválido"},
                            content_type='application/json')

        try:
            _fechaInicio = datetime.datetime.strptime(fechaInicio, "%d-%m-%Y")
            _fechaFin = datetime.datetime.strptime(fechaFin, "%d-%m-%Y")
            _microempresa = microempresa.objects.get(ruc=ruc)

            ordenes = orden.objects.filter(microempresa=_microempresa, tipo=tipo, fechaCreacion__range=[_fechaInicio, _fechaFin])
            diccionario = [obj.as_dict() for obj in ordenes]

            return Response(status=status.HTTP_200_OK,
                            data={"resultado": diccionario},
                            content_type='application/json')

        except Exception as ex:
            return Response(status=status.HTTP_400_BAD_REQUEST,
                            data={"Errores": str(ex)},
                            content_type='application/json')


@perlfunc
@perlreq(RUTA_PERL + '/conversor.pl')
def num2text(num):
    pass


class generarTXT(APIView):
    def post(self, request):
        try:
            _request = json.loads(request.body)
        except Exception as ex:
            print ex
            return Response(status=status.HTTP_400_BAD_REQUEST,
                            data={"Errores": "Json no válido"},
                            content_type='application/json')

        ruc = _request.get('ruc', '')
        tipo = _request.get('tipo', '')
        if ruc == '':
            return Response(status=status.HTTP_400_BAD_REQUEST,
                            data={"Errores": "El ruc de la empresa es requerido"},
                            content_type='application/json')

        if tipo == '':
            return Response(status=status.HTTP_400_BAD_REQUEST,
                            data={"Errores": "El tipo de reporte es requerido"},
                            content_type='application/json')
        elif tipo not in ['1', '2']:
            return Response(status=status.HTTP_400_BAD_REQUEST,
                            data={"Errores": "El tipo de reporte no es correcto"},
                            content_type='application/json')

        try:
            _ruc = int(ruc)
            _tipo = int(tipo)
        except Exception as ex:
            return Response(status=status.HTTP_400_BAD_REQUEST,
                            data={"Errores": "El ruc o el tipo de orden es inválido"},
                            content_type='application/json')

        try:
            # estado, lista = generarDET(ruc)
            # temp = orden.objects.get(id='13')
            # estado = registrarDXContables(temp)
            estado = generarCAB(ruc, tipo)
            ejecutarExpect()

            if estado:
                return Response(status=status.HTTP_200_OK,
                                data={"resultado": estado},
                                content_type='application/json')
            else:
                return Response(status=status.HTTP_400_BAD_REQUEST,
                    data={"Errores": "El ruc o el tipo de orden es inválido"},
                    content_type='application/json')

        except Exception as ex:
            return Response(status=status.HTTP_400_BAD_REQUEST,
                            data={"Errores": str(ex)},
                            content_type='application/json')


def generarCAB(ruc, tipo):
    _microempresa = microempresa.objects.get(ruc=ruc)

    try:
        ordenes = orden.objects.filter(microempresa=_microempresa, tipo=tipo)

        for _orden in ordenes:
            if _orden.tipoComprobante == '1':
                serie = 'F008'
            else:
                serie = 'B008'

            filename = RUTA_TXT + ruc + '-' + _orden.tipoComprobante.zfill(2) + '-' + serie + '-' + str(_orden.id)

            generarDET(_orden.id, filename)
            generarLEY(filename, _orden.total)

            if os.path.exists(filename + '.CAB'):
                os.remove(filename + '.CAB')

            cab = open(filename + '.CAB', 'w')
            cab.write(_orden.cab())
            cab.close()

            guardarFacturacion(serie, _orden.emailReceptor, str(_orden.id), _orden.tipoComprobante, _orden.tipoDocreceptor, _orden.numeroDocreceptor, _microempresa.razonSocial, _orden.razonSocial, _orden.total)
            
        return True

    except Exception as ex:
        print 'ERROR'
        print ex
        return False, ex


def generarDET(orden_id, filename):
    try:
        ordenes = lineaOrden.objects.filter(orden__id=orden_id)
        det = ''

        if os.path.exists(filename + '.DET'):
            os.remove(filename + '.DET')

        for _orden in ordenes:
            det = det + _orden.det() + '\n'

        cab = open(filename + '.DET', 'w')
        cab.write(det)
        cab.close()

        return True

    except Exception as ex:
        print 'ERROR'
        print ex
        return False, ex


def generarLEY(filename, numero):
    try:
        if os.path.exists(filename + '.LEY'):
            os.remove(filename + '.LEY')

        letras = num2text(numero)

        cab = open(filename + '.LEY', 'w')
        cab.write('1000|' + letras)
        cab.close()

        return True
    except Exception as ex:
        print 'ERROR'
        print ex
        return False, ex


def crearFolder():
    if not os.path.exists(directory):
        os.makedirs(directory)


def ejecutarExpect():
    subprocess.call(settings.BASE_DIR + "/transfer.sh", shell=False)


def guardarFacturacion(serie, correo, correlativo, tipoComprobante, coddocrecept, numdocrecept, emirazonSocial, receptrazonSocial, montoTotal):
    # num_ruc_emi Hardcodeado por motivos de integracion (Alonso)
    factura = Factura(num_ruc_emi='20532803749', num_serie_cpe=serie,
                      num_corre_cpe=correlativo, cod_tip_doc_cpe=tipoComprobante,
                      cod_tip_doc_ide_recep=coddocrecept, num_doc_ide_recep=numdocrecept,
                      nom_emi=emirazonSocial, nom_recep=receptrazonSocial, mto_cpe=montoTotal,
                      email='victor.brast@gmail.com')

    factura.save(using='facturacion')

# PERSONA #


class registrarPersona(APIView):
    def post(self, request):
        _request = json.loads(request.body)

        # microempresa = _request.get('microempresa', '')

        # Errores, mensaje = validarRegistroPersona(_request)
        Errores, mensaje = do_registrarPersona(_request)

        if Errores:
            return Response(status=status.HTTP_400_BAD_REQUEST,
                            data={"Errores": mensaje},
                            content_type='application/json')
        else:
            return Response(status=status.HTTP_200_OK,
                            data={"mensaje": "Registrado Correctamente"},
                            content_type='application/json')


class buscarUsuario(APIView):
    def post(self, request):
        try:
            _request = json.loads(request.body)
        except Exception as ex:
            print ex
            return Response(status=status.HTTP_400_BAD_REQUEST,
                            data={"Errores": "Json no válido"},
                            content_type='application/json')

        ruc = _request.get('ruc', '')
        dni = _request.get('dni', '')

        if ruc == '' and dni == '':
            return Response(status=status.HTTP_400_BAD_REQUEST,
                            data={"Errores": "El ruc o dni es requerido"},
                            content_type='application/json')
        elif ruc != '' and dni != '':
            return Response(status=status.HTTP_400_BAD_REQUEST,
                            data={"Errores": "Solo se permite RUC o DNI"},
                            content_type='application/json')
        elif ruc != '':
            try:
                diccionario = microempresa.objects.get(ruc=ruc).as_dict()
            except Exception as ex:
                return Response(status=status.HTTP_400_BAD_REQUEST,
                                data={"Errores": "Microempresa inexistente"},
                                content_type='application/json')
        else:
            try:
                diccionario = personaNatural.objects.get(dni=dni).as_dict()
            except Exception as ex:
                return Response(status=status.HTTP_400_BAD_REQUEST,
                                data={"Errores": "Microempresa inexistente"},
                                content_type='application/json')

        return Response(status=status.HTTP_400_BAD_REQUEST,
                        data={"resultado": diccionario},
                        content_type='application/json')


def do_registrarPersona(request):
    nombre = request.get('nombre')
    apellido = request.get('apellido')
    dni = request.get('dni')
    correo = request.get('correo')
    celular = request.get('celular')
    contrasena = request.get('contrasena')

    Mensaje = ""
    Errores = False

    try:
        user = User.objects.create_user(username=dni, email=correo, first_name=nombre, last_name=apellido)
        user.set_password(contrasena)
        user.save()
    except Exception as ex:
        Mensaje = str(ex)
        print Men
        Errores = True

    if not Errores:
        try:
            pnat = personaNatural(dni=dni, celular=celular, user=user)
            pnat.save()
        except Exception as ex:
            user.delete()
            Mensaje = str(ex)
            Errores = True

    return Errores, Mensaje


class checkLogin(APIView):
    def post(self, request):
        try:
            _request = json.loads(request.body)
        except Exception as ex:
            print ex
            return Response(status=status.HTTP_400_BAD_REQUEST,
                            data={"Errores": "Json no válido"},
                            content_type='application/json')

        username = _request.get('username', '')
        password = _request.get('password', '')

        if username == '' or password == '':
            return Response(status=status.HTTP_400_BAD_REQUEST,
                            data={"Errores": "Username y/o password no pueden ser vacíos"},
                            content_type='application/json')
        try:
            user = User.objects.get(username=username)
        except Exception as ex:
            return Response(status=status.HTTP_400_BAD_REQUEST,
                            data={"Errores": "El usuario no existe", "estado": False},
                            content_type='application/json')

        if not user.check_password(password):
            return Response(status=status.HTTP_400_BAD_REQUEST,
                            data={"Errores": "El password no es correcto", "estado": False},
                            content_type='application/json')

        return Response(status=status.HTTP_200_OK,
                        data={"resultado": "credenciales correctas", "estado": True},
                        content_type='application/json')


@transaction.atomic
def registrarDXContables(orden):
    uid = uuid.uuid4().hex
    diario = int(17)
    tc_compra = float(3.2)
    tipodoc = '6'  # emisor
    tipodocid = orden.tipoComprobante  # boleta o factura

    if orden.tipoComprobante == '3':
        docid = 'B008' + '-' + str(orden.id)  # serie b008 f008 + correlativo
    elif orden.tipoComprobante == '1':
        docid = 'F008' + '-' + str(orden.id)

    percepcion = '0'  # 0
    detraccion = '0'  # 0
    ruc = orden.numeroDocreceptor  # receptor
    glosa = 'VENTA' # venta
    estado = '0'  #  0
    fecha_conta = TODAY  # fecha actual
    moneda = '0'  # 0
    referencia = orden.id  # id orden
    consolida = 0  # 0
    lastupdate = TODAY # fecha actual
    usuario = orden.microempresa.ruc  # dni/ruc del logeado
    tc_compra1 = float(3.2)  # 4.350
    tc_venta = float(3.2)  # 4.350

    try:
        obj = CcDiariocab(uid=uid, diario=diario, tc_compra=tc_compra, tipodoc=tipodoc, tipodocid=tipodocid,
                          docid=docid, percepcion=percepcion, detraccion=detraccion, ruc=ruc, glosa=glosa,
                          estado=estado, fecha_conta=fecha_conta, moneda=moneda, referencia=referencia, 
                          consolida=consolida, lastupdate=lastupdate, usuario=usuario, tc_compra1=tc_compra1,
                          tc_venta=tc_venta)

        obj.save(using='contabilidad')
    except Exception as ex:
        print ex
        return False


    cuentas = ['701100', '401110', '121200']

    _interno = 1

    for item in cuentas:
        detalle = CcDiariodet()
        cuenta = item  # 701100 | 401110 | 121200
        dh = '1'  # 1
        
        if item == '701100':
            soles = float(orden.total)  #  total venta
            dh = '1'
        elif item == '401110':
            soles = float(orden.totalImpuesto)
            dh = '1'
        elif item == '121200':
            soles = float(orden.total - orden.totalImpuesto)
            dh = '0'

        dolar = soles / 3.20  #  venta/3.2
        pesos = 0.00                      # 0

        # try:
        detalle.interno = _interno
        detalle.secuencial = obj.secuencial
        detalle.cuenta = item
        detalle.dh = dh
        detalle.soles = soles
        detalle.dolar = dolar
        detalle.pesos = pesos
        detalle.save(using='contabilidad')
        _interno = _interno + 1 


def guardarDET(orden, _interno, item, secuencial):
    cuenta = item  # 701100 | 401110 | 121200
    dh = '1'  # 1
    
    if item == '701100':
        soles = float(orden.total)  #  total venta
        dh = '1'
    elif item == '401110':
        soles = float(orden.totalImpuesto)
        dh = '1'
    elif item == '121200':
        soles = float(orden.total - orden.totalImpuesto)
        dh = '0'

    dolar = soles / 3.20  #  venta/3.2
    pesos = 0.00                      # 0

    # try:
    print 'antes'
    detalle = CcDiariodet.objects.create(interno=_interno, secuencial=secuencial, cuenta=cuenta, dh=dh, soles=soles, dolar=dolar, pesos=pesos)
    print '-->'
    print detalle
    detalle.save(using='contabilidad')