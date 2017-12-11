from tienda.views import listaProducto, buscarProducto, registrarPersona, listaTOP10, listaTOP10Intervalo
from tienda.views import listaOrdenes, listaOrdenIntervalo, generarTXT, checkLogin, buscarUsuario
from tienda.views import ventasPendientesReceptor, actualizarVentaReceptor, montoventasMensual, generarOrden
from django.conf.urls import url

urlpatterns = [

    url(r'^listar-productos/(?P<ruc>[0-9]+)$', listaProducto.as_view(), name='listar-productos'),
    url(r'^buscar-producto/(?P<ruc>[0-9]+)/(?P<idproducto>[0-9]+)$', buscarProducto.as_view(), name='buscar-producto'),
    url(r'^registrar-persona$', registrarPersona.as_view(), name='registrar-persona'),
    url(r'^listar-top-intervalo$', listaTOP10Intervalo.as_view(), name='listar-top-intervalo'),
    url(r'^listar-top$', listaTOP10.as_view(), name='registrar-top'),
    url(r'^ordenes$', listaOrdenes.as_view(), name='ordenes'),
    url(r'^ordenes-intervalo$', listaOrdenIntervalo.as_view(), name='ordenes-intervalo'),
    url(r'^generar-txt$', generarTXT.as_view(), name='generar-txt'),
    url(r'^check-login$', checkLogin.as_view(), name='check-login'),
    url(r'^buscar-usuario$', buscarUsuario.as_view(), name='buscar-usuario'),
    url(r'^listar-ventas-pendientes$', ventasPendientesReceptor.as_view(), name='listar-ventas-pendientes'),
    url(r'^actualizar-venta-receptor$', actualizarVentaReceptor.as_view(), name='actualizar-venta-receptor'),
    url(r'^monto-ventas-mensual$', montoventasMensual.as_view(), name='monto-ventas-mensual'),
    url(r'^generar-orden$', generarOrden.as_view(), name='generar-orden'),




]