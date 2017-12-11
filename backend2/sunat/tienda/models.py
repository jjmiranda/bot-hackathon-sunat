# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models
from datetime import datetime
from django.contrib.auth.models import User
# Create your models here.

ESTADO_CARRITO = ((u'1', u'abierto'), (u'2', u'congelado'), (u'3', u'pagado'),)
ESTADO_ORDEN = ((u'1', u'en espera'), (u'2', u'confirmado'), (u'3', u'entregado'),)
TIPO_ORDEN = ((u'1', u'compra'), (u'2', u'venta'), )
TIPO_DOCUMENTO = ((u'6', u'RUC'), (u'1', u'DNI'),)
TIPO_COMPROBANTE = ((u'3', u'Boleta'), (u'1', 'Factura'),)
UNIDAD_MEDIDA = ((u'1', u'Boleta'), (u'2', 'Factura'),)


class personaNatural(models.Model):
    user = models.OneToOneField(User)
    dni = models.CharField('DNI', max_length=8, blank=False, null=False)
    celular = models.CharField('Celular', max_length=15, blank=True, null=True)
    fechaCreacion = models.DateField('Fecha de creación', default=datetime.now)
    fechaActualizacion = models.DateField('Fecha de actualización', default=datetime.now)

    class Meta:
        verbose_name = 'Persona'
        verbose_name_plural = 'Personas'

    def __str__(self):
        return self.dni

    def as_dict(self):
        return {
            "id": self.id,
            "nombre": self.user.first_name,
            "apellido paterno": self.user.last_name,
            "correo": self.user.email,
            "dni": self.dni,
            "fechaCreacion": self.fechaCreacion,
            "fechaActualizacion": self.fechaActualizacion
        }


class microempresa(models.Model):
    persona = models.ForeignKey(personaNatural, blank=True, null=True)
    razonSocial = models.CharField('Razón Social', max_length=250, blank=False, null=False)
    ruc = models.CharField('RUC', max_length=15, blank=False, null=False)
    telefono = models.CharField('Telefono', max_length=15, blank=True, null=True)
    direccion = models.CharField('Dirección', max_length=250, blank=True, null=True)
    correo = models.CharField('Correo', max_length=100, blank=False, null=False)
    fechaCreacion = models.DateField('Fecha de creación', default=datetime.now)
    fechaActualizacion = models.DateField('Fecha de actualización', default=datetime.now)

    class Meta:
        verbose_name = 'Microempresa'
        verbose_name_plural = 'Microempresas'

    def __str__(self):
        return self.razonSocial.encode('utf8')

    def as_dict(self):
        return {
            "id": self.id,
            "razonSocial": self.razonSocial,
            "ruc": self.ruc,
            "telefono": self.telefono,
            "direccion": self.direccion,
            "correo": self.correo,
            "fechaCreacion": self.fechaCreacion,
            "fechaActualizacion": self.fechaActualizacion,
            "dniRepresentante": self.persona.dni,
            "nombreRepresentante": self.persona.user.first_name,
            "apepatRepresentante": self.persona.user.last_name,
            "correoRepresentante": self.persona.user.email
        }


class proveedor(models.Model):
    microempresa = models.ForeignKey(microempresa, verbose_name='Empresa')
    razonSocial = models.CharField('Razón Social', max_length=250, blank=False, null=False)
    ruc = models.CharField('RUC', max_length=15, blank=False, null=False)
    telefono = models.CharField('Telefono', max_length=15, blank=True, null=True)
    direccion = models.CharField('Dirección', max_length=250, blank=True, null=True)
    correo = models.CharField('Correo', max_length=100, blank=False, null=False)

    class Meta:
        verbose_name = 'Proveedor'
        verbose_name_plural = 'proveedores'

    def __str__(self):
        return self.razonSocial.encode('utf8')

    def as_dict(self):
        return {
            "id": self.id,
            "microempresa": self.Microempresa.ruc,
            "ruc": self.ruc,
            "telefono": self.telefono,
            "direccion": self.direccion,
            "correo": self.correo
        }


class marca(models.Model):
    microempresa = models.ForeignKey(microempresa, verbose_name='Empresa')
    nombre = models.CharField('Nombre', max_length=150, blank=False, null=False)

    class Meta:
        verbose_name = 'Marca'
        verbose_name_plural = 'Marcas'

    def __str__(self):
        return self.nombre.encode('utf8')

    def as_dict(self):
        return {
            "id": self.id,
            "microempresa": self.Microempresa.ruc,
            "nombre": self.nombre
        }


class categoriaProducto(models.Model):
    microempresa = models.ForeignKey(microempresa, verbose_name='Empresa')
    nombre = models.CharField('Nombre', max_length=150, blank=False, null=False)
    descripcion = models.TextField('Descripción', max_length=350, blank=True, null=True)

    class Meta:
        verbose_name = 'Categoria producto'
        verbose_name_plural = 'Categorias de productos'

    def __str__(self):
        return self.nombre.encode('utf8')

    def as_dict(self):
        return {
            "id": self.id,
            "microempresa": self.Microempresa.ruc,
            "nombre": self.nombre,
            "descripcion": self.descripcion
        }


class producto(models.Model):
    microempresa = models.ForeignKey(microempresa, verbose_name='Empresa', blank=False, null=False)
    nombre = models.CharField('Nombre', max_length=150, blank=False, null=False)
    slug = models.SlugField('slug', max_length=100, blank=False, null=False)
    categoria = models.ForeignKey(categoriaProducto, verbose_name='Categoria', blank=False, null=False)
    marca = models.ForeignKey(marca, verbose_name='Marca', blank=False, null=False)
    descripcion = models.TextField('Descripción', max_length=350, blank=True, null=True)
    rating = models.IntegerField('Ventas', default=0)
    stock = models.IntegerField('Stock', default=0)
    precioUnitario = models.DecimalField('Precio de venta', max_digits=6, decimal_places=2, default=0)
    precioCompra = models.DecimalField('Precio de compra', max_digits=6, decimal_places=2, default=0)
    fechaCreacion = models.DateField('Fecha de creación', default=datetime.now)
    fechaActualizacion = models.DateField('Fecha de actualización', default=datetime.now)
    seguimiento = models.BooleanField('Seguimiento', default=False)
    unidadMedida = models.CharField("Tipo", max_length=1, default="1", choices=UNIDAD_MEDIDA)
    codigoBarras = models.CharField("Codigo Barras", max_length=15, default="000000000000000")

    class Meta:
        verbose_name = 'Producto'
        verbose_name_plural = 'Productos'

    def __str__(self):
        return self.nombre.encode('utf8')

    def as_dict(self):
        return {
            "id": self.id,
            "nombre": self.nombre,
            "slug": self.slug,
            "categoria": self.categoria.nombre,
            "marca": self.marca.nombre,
            "ventas": self.rating,
            "stock": self.stock,
            "cantidad": 0,
            "descripcion": self.descripcion,
            "precioVenta": self.precioUnitario,
            "precioCompra": self.precioCompra
        }

    def as_top10(self):
        return {
            "id": self.id,
            "nombre": self.nombre,
            "categoria": self.categoria.nombre,
            "marca": self.marca.nombre,
            "stock": self.stock,
            "ventas": self.rating,
            "descripcion": self.descripcion,
            "precioVenta": self.precioUnitario,
            "precioCompra": self.precioCompra
        }


class proveedorProducto(models.Model):
    microempresa = models.ForeignKey(microempresa, verbose_name='Empresa')
    producto = models.ForeignKey(producto, verbose_name='Producto')
    proveedor = models.ForeignKey(proveedor, verbose_name='Proveedor')

    class Meta:
        verbose_name = 'Proveedor asignado'
        verbose_name_plural = 'Proveedores asignados'


class carrito(models.Model):
    microempresa = models.ForeignKey(microempresa, verbose_name='Empresa')
    persona = models.ForeignKey(personaNatural, blank=True, null=True)
    estado = models.CharField("Estado", max_length=1, default="", choices=ESTADO_CARRITO)
    total = models.DecimalField('Total', max_digits=6, decimal_places=2, default=0)
    totalImpuesto = models.DecimalField('Total impuesto', max_digits=6, decimal_places=2, default=0)
    fechaCreacion = models.DateField('Fecha de creación', default=datetime.now)
    fechaActualizacion = models.DateField('Fecha de actualización', default=datetime.now)

    class Meta:
        verbose_name = 'Carrito de compras'
        verbose_name_plural = 'Carritos de compras'

    def as_dict(self):
        return {
            "id": self.id,
            "microempresa": self.microempresa.ruc,
            "persona": self.persona.dni,
            "estado": self.estado,
            "total": self.total,
            "totalImpuesto": self.totalImpuesto,
            "fechaCreacion": self.fechaCreacion,
            "fechaActualizacion": self.fechaActualizacion,
        }


class lineaCarrito(models.Model):
    microempresa = models.ForeignKey(microempresa, verbose_name='Empresa')
    carrito = models.ForeignKey(carrito, verbose_name='Carrito')
    producto = models.ForeignKey(producto, verbose_name='Producto')
    cantidad = models.IntegerField('Cantidad', default=0)
    subtotal = models.DecimalField('Subtotal', max_digits=6, decimal_places=2, default=0)
    montoImpuesto = models.DecimalField('Impuesto', max_digits=6, decimal_places=2, default=0)

    class Meta:
        verbose_name = 'Detalle de carrito de compras'
        verbose_name_plural = 'Detalles de carritos de compras'

    def as_dict(self):
        return {
            "id": self.id,
            "microempresa": self.microempresa.ruc,
            "carrito": self.carrito.id,
            "productoId": self.producto.id,
            "productoNombre": self.producto.nombre,
            "cantidad": self.cantidad,
            "subtotal": self.subtotal,
            "montoImpuesto": self.montoImpuesto
        }


class orden(models.Model):
    microempresa = models.ForeignKey(microempresa, verbose_name='Empresa')
    persona = models.ForeignKey(personaNatural, blank=True, null=True)
    estado = models.CharField("Estado", max_length=1, default="", choices=ESTADO_ORDEN)
    tipo = models.CharField("Tipo", max_length=1, default="1", choices=TIPO_ORDEN)
    total = models.DecimalField('Total', max_digits=6, decimal_places=2, default=0)
    totalImpuesto = models.DecimalField('Total impuesto', max_digits=6, decimal_places=2, default=0)
    fechaCreacion = models.DateField('Fecha de creación', default=datetime.now)
    fechaActualizacion = models.DateField('Fecha de actualización', default=datetime.now)
    numeroDocreceptor = models.CharField('Numero de documento', max_length=25, blank=True, null=True)
    tipoDocreceptor = models.CharField('Tipo de documento', max_length=1, default="1", choices=TIPO_DOCUMENTO)
    tipoComprobante = models.CharField('Tipo de comprobante', max_length=1, default="1", choices=TIPO_COMPROBANTE)
    razonSocial = models.CharField('Razón Social', max_length=250, blank=True, null=True)
    emailReceptor = models.CharField('Email receptor', max_length=250, blank=True, null=True, default="dramos@magiadigital.com")

    class Meta:
        verbose_name = 'Orden de compra'
        verbose_name_plural = 'Ordenes de compras'

    def as_dict(self):
        tipoComprobante_text = display_TIPO_COMPROBANTE(self.tipoComprobante)
        tipodocReceptor_text = display_TIPO_DOCUMENTO(self.tipoDocreceptor)
        lineas = lineaOrden.objects.filter(orden=self)

        lineasDict = [obj.as_dict() for obj in lineas]

        if self.persona:
            dni = self.persona.dni
        else:
            dni = '70600839'

        return {
            "id": self.id,
            "microempresa": self.microempresa.ruc,
            "persona": dni,
            "estado": self.estado,
            "total": self.total,
            "totalImpuesto": self.totalImpuesto,
            "fechaCreacion": self.fechaCreacion,
            "fechaActualizacion": self.fechaActualizacion,
            "documentoReceptor": self.numeroDocreceptor,
            "razonSReceptor": self.razonSocial,
            "tipoDocreceptor": tipodocReceptor_text,
            "tipoComprobante": tipoComprobante_text,
            "emailReceptor": self.emailReceptor,
            "detalle": lineasDict
        }

    def reporte_venta(self):
        return {
            "serie": self.id,
            "emisor": self.microempresa.razonSocial,
            "total": self.total
        }

    def __str__(self):
        return str(self.id)

    def cab(self):
        return '01|' + self.fechaCreacion.strftime('%Y-%m-%d') + '|0|' + self.tipoDocreceptor + '|' + self.numeroDocreceptor + '|' + self.razonSocial + '|PEN|0.00|0.00|0.00|' + str(self.total - self.totalImpuesto) + '|0.00|0.00|' + str(self.totalImpuesto) + '|0.00|0.00|' + str(self.total) + '|'


class lineaOrden(models.Model):
    microempresa = models.ForeignKey(microempresa, verbose_name='Empresa')
    orden = models.ForeignKey(orden, verbose_name='Orden')
    producto = models.ForeignKey(producto, verbose_name='Producto')
    cantidad = models.IntegerField('Cantidad', default=0)
    subtotal = models.DecimalField('Subtotal', max_digits=6, decimal_places=2, default=0)
    montoImpuesto = models.DecimalField('Impuesto', max_digits=6, decimal_places=2, default=0)

    class Meta:
        verbose_name = 'Detalle de orden de compra'
        verbose_name_plural = 'Detalle de ordenes de compras'

    def as_dict(self):
        return {
            "id": self.id,
            "microempresa": self.microempresa.ruc,
            "orden": self.orden.id,
            "productoId": self.producto.id,
            "productoNombre": self.producto.nombre,
            "cantidad": self.cantidad,
            "subtotal": self.subtotal,
            "montoImpuesto": self.montoImpuesto
        }

    def __str__(self):
        return str(self.orden.id) + '-' + str(self.id)

    def det(self):
        return 'NIU' + '|' + "{0:.3f}".format(int(self.producto.unidadMedida)) + '|' + str(self.producto.id) + '||' + self.producto.descripcion + '|' + str(self.producto.precioCompra) + '|0.00|' + str(self.montoImpuesto) + '|10|0.00|01|' + str(self.producto.precioUnitario) + '|' + str(self.subtotal) + '|'


def display_TIPO_COMPROBANTE(q):
    for choice in TIPO_COMPROBANTE:
        if choice[0] == q:
            return choice[1]
    return ''


def display_TIPO_DOCUMENTO(q):
    for choice in TIPO_DOCUMENTO:
        if choice[0] == q:
            return choice[1]
    return ''



# SEGUNDA BASE DE DATOS



class Factura(models.Model):
    num_ruc_emi = models.CharField(max_length=11)
    num_serie_cpe = models.CharField(max_length=4, blank=True, null=True)
    num_corre_cpe = models.CharField(max_length=9, blank=True, null=True)
    cod_tip_doc_cpe = models.CharField(max_length=2, blank=True, null=True)
    cod_tip_doc_ide_recep = models.CharField(max_length=2, blank=True, null=True)
    num_doc_ide_recep = models.CharField(max_length=11, blank=True, null=True)
    nom_emi = models.CharField(max_length=100, blank=True, null=True)
    nom_recep = models.CharField(max_length=100, blank=True, null=True)
    mto_cpe = models.DecimalField(max_digits=10, decimal_places=2, blank=True, null=True)
    email = models.CharField(max_length=100)
    email_enviado = models.IntegerField(blank=True, null=True)
    respuesta_envio = models.CharField(max_length=1000, blank=True, null=True)
    fecha_envio = models.DateTimeField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'factura'
        unique_together = (('num_ruc_emi', 'num_serie_cpe', 'num_corre_cpe'),)

