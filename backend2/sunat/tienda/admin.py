# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.contrib import admin
from django.forms import TextInput, ModelForm
from tienda.models import *
from django.contrib.auth.models import User
from django.template.defaultfilters import slugify
# Register your models here.


class productoAdmin(admin.ModelAdmin):
    list_display = ('nombre', 'slug', 'marca', 'stock', 'rating', 'precioUnitario', 'seguimiento')
    list_filter = ('marca', 'rating', 'seguimiento',)
    search_fields = ('nombre', 'slug', 'marca',)
    exclude = ('microempresa', 'slug')

    def get_queryset(self, request):
        qs = super(productoAdmin, self).get_queryset(request)
        try:
            objMicroempresa = microempresa.objects.get(persona__user=request.user)
            return qs.filter(microempresa=objMicroempresa)
        except Exception as ex:
            print ex  # <- colocar logger aqui
            return qs.filter(microempresa=None)

    def save_model(self, request, obj, form, change):
        objMicroempresa = microempresa.objects.get(persona__user=request.user)
        obj.microempresa = objMicroempresa
        obj.slug = slugify(obj.nombre)
        super(productoAdmin, self).save_model(request, obj, form, change)


class categoriaProductoAdmin(admin.ModelAdmin):
    exclude = ('microempresa',)

    def get_queryset(self, request):
        qs = super(categoriaProductoAdmin, self).get_queryset(request)
        try:
            objMicroempresa = microempresa.objects.get(persona__user=request.user)
            return qs.filter(microempresa=objMicroempresa)
        except Exception as ex:
            print ex  # <- colocar logger aqui
            return qs.filter(microempresa=None)

    def save_model(self, request, obj, form, change):
        objMicroempresa = microempresa.objects.get(persona__user=request.user)
        obj.microempresa = objMicroempresa
        super(categoriaProductoAdmin, self).save_model(request, obj, form, change)


class marcaAdmin(admin.ModelAdmin):
    exclude = ('microempresa',)

    def get_queryset(self, request):
        qs = super(marcaAdmin, self).get_queryset(request)
        try:
            objMicroempresa = microempresa.objects.get(persona__user=request.user)
            return qs.filter(microempresa=objMicroempresa)
        except Exception as ex:
            print ex  # <- colocar logger aqui
            return qs.filter(microempresa=None)

    def save_model(self, request, obj, form, change):
        objMicroempresa = microempresa.objects.get(persona__user=request.user)
        obj.microempresa = objMicroempresa
        super(marcaAdmin, self).save_model(request, obj, form, change)


class ordenesAdmin(admin.ModelAdmin):
    list_display = ('id', 'estado', 'tipo', 'total', 'totalImpuesto', 'numeroDocreceptor', 'tipoDocreceptor', 'tipoComprobante', 'razonSocial', 'emailReceptor')
    list_filter = ('tipo', 'estado', 'tipoComprobante',)
    search_fields = ('numeroDocreceptor', 'razonSocial', )
    exclude = ('microempresa',)

    def get_queryset(self, request):
        qs = super(ordenesAdmin, self).get_queryset(request)
        try:
            objMicroempresa = microempresa.objects.get(persona__user=request.user)
            return qs.filter(microempresa=objMicroempresa)
        except Exception as ex:
            print ex  # <- colocar logger aqui
            return qs.filter(microempresa=None)

    def save_model(self, request, obj, form, change):
        objMicroempresa = microempresa.objects.get(persona__user=request.user)
        obj.microempresa = objMicroempresa
        super(ordenesAdmin, self).save_model(request, obj, form, change)


admin.site.register(personaNatural)
admin.site.register(microempresa)
admin.site.register(proveedor)
admin.site.register(marca, marcaAdmin)
admin.site.register(categoriaProducto, categoriaProductoAdmin)
admin.site.register(producto, productoAdmin)
admin.site.register(proveedorProducto)
admin.site.register(carrito)
admin.site.register(lineaCarrito)
admin.site.register(orden, ordenesAdmin)
admin.site.register(lineaOrden)

