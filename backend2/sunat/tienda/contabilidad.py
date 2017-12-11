# This is an auto-generated Django model module.
# You'll have to do the following manually to clean this up:
#   * Rearrange models' order
#   * Make sure each model has one field with primary_key=True
#   * Make sure each ForeignKey has `on_delete` set to the desired behavior.
#   * Remove `managed = False` lines if you wish to allow Django to create, modify, and delete the table
# Feel free to rename the models, but don't rename db_table values or field names.
from __future__ import unicode_literals

from django.db import models


class CcDiariocab(models.Model):
    secuencial = models.AutoField(primary_key=True)  # autogenerado
    uid = models.CharField(max_length=36, blank=True, null=True)  # autogenerado
    diario = models.IntegerField()  # 17
    tc_compra = models.FloatField()  #  3.2
    tipodoc = models.CharField(max_length=2)  # emisor
    tipodocid = models.CharField(max_length=2, blank=True, null=True)  # boleta o factura
    docid = models.CharField(max_length=14, blank=True, null=True)  # serie + correlativo
    percepcion = models.CharField(max_length=1)  # 0
    detraccion = models.CharField(max_length=1)  # 0
    ruc = models.CharField(max_length=11, blank=True, null=True)  # receptor
    glosa = models.CharField(max_length=128, blank=True, null=True)  # venta
    estado = models.CharField(max_length=1)  #  0
    fecha_conta = models.DateField(blank=True, null=True)  # fecha actual
    moneda = models.CharField(max_length=1)  # 0
    referencia = models.IntegerField()  # id orden
    consolida = models.IntegerField()  # 0
    lastupdate = models.DateTimeField()  # fecha actual
    usuario = models.CharField(max_length=12, blank=True, null=True)  # dni/ruc del logeado
    tc_compra1 = models.FloatField()  # 4.350
    tc_venta = models.FloatField()  # 4.350

    class Meta:
        managed = False
        db_table = 'cc_diariocab'


class CcDiariodet(models.Model):
    secuencial = models.IntegerField(primary_key=True)  # diariocab
    interno = models.AutoField()
    cuenta = models.CharField(max_length=60)  # 701100 | 401110 | 121200
    memo = models.CharField(max_length=24, blank=True, null=True)
    dh = models.CharField(max_length=1)  # 1
    soles = models.FloatField(blank=True, null=True)  #  total venta
    dolar = models.FloatField(blank=True, null=True)  #  venta/3.2
    pesos = models.FloatField() 

    class Meta:
        managed = False
        db_table = 'cc_diariodet'
        unique_together = (('secuencial', 'interno'),)


