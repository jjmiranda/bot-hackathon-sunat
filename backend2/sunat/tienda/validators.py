# -*- coding: utf-8 -*-
from django.contrib.auth.models import User
from models import *
import re
from django.core.validators import validate_email
from django.core.exceptions import ValidationError


def validarRegistroPersona(request):
    Mensaje = []
    Errores = False

    nombre = request.get('nombre', '')
    apellido = request.get('apellido', '')
    dni = request.get('dni', '')
    correo = request.get('correo', '')
    celular = request.get('celular', '')
    contrasena = request.get('contraseña', '')

    if nombre == '':
        Mensaje.add("El nombre no puede ser vacío")
    elif not validarNombre(nombre):
        Mensaje.add("El nombre debe ser solo textual")

    if apellido == '':
        Mensaje.add("El apellido no puede ser vacío")
    elif not validarNombre(apellido):
        Mensaje.add("El apellido debe ser solo textual")

    if dni == '':
        Mensaje.add("El documento de identidad no puede ser vacío")
    else:
        try:
            _dni = int(dni)
            if len(_dni) == 8:
                pass
            else:
                Mensaje.add("El documento de identidad debe ser de solo 8 dígitos")
        except Exception as ex:
            print ex
            Mensaje.add("El documento de identidad es invalido")

    if correo == '':
        Mensaje.add("El correo no puede ser vacío")
    elif validarCorreo(correo):
        Mensaje.add("El correo no es válido")

    if celular == '':
        Mensaje.add("El número de celular no puede ser vacío")
    else:
        try:
            _celular = int(celular)
            if len(_celular) == 8:
                pass
            else:
                Mensaje.add("El número de celular debe ser de solo 8 dígitos")
        except Exception as ex:
            print ex
            Mensaje.add("El número de celular es invalido")

'''
def validarRegistroMicroempresa(request):
    nombre = request.get('nombre', '')
    apellido = request.get('apellido', '')
    dni = request.get('dni', '')
    correo = request.get('correo', '')
    celular = request.get('celular', '')
    contrasena = request.get('contraseña', '')

'''    

def validarNombre(texto):
    validator = re.compile(r"[^1234567890!\"#$%&\/\()=?¡'¿´+}{\-\.,\¨*\]\\[\_:;|°¬^`~\\´<>]*$")
    if validator.match(texto.encode('utf-8')):
        return True
    else:
        return False


def validarCorreo(correo):
    try:
        validate_email(correo)
        return True
    except ValidationError:
        return False
