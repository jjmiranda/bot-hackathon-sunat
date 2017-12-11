import { Http, Headers, Response } from '@angular/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs/Observable';
import 'rxjs/add/operator/map';
import 'rxjs/add/operator/catch';
import {Type} from "@angular/compiler/src/core";

@Injectable()
export class DataProvider {

  private headers: Headers;
  private url = 'https://cors-anywhere.herokuapp.com/http://190.81.160.212:8081/api/tienda/';
  //private url = 'http://190.81.160.212:8081/api/tienda/';

  constructor(private http: Http) {
    console.log('Hello DataProvider Provider');

    this.headers = new Headers();
    this.headers.append('Access-Control-Allow-Origin', '*');
  //  this.headers.append('Content-Type', 'application/x-www-form-urlencoded;charset=UTF-8');
    this.headers.append('Content-Type', 'application/json');
  }


  public productsList(ruc) {
    return this.http.get(this.url + "listar-productos/" + ruc, {headers: this.headers}).map((res: Response) => res.json());
  }

/*
  public getTopTenProductsByMonth(payload){
    payload.headers = this.headers;
    return this.http.post(this.url, payload).map((res: Response) => res.json());
  }
    */

    public generarComprobante(ruc, tipoDoc, c_tipocom, c_receptordoc, razonsocial, email, producto){
      let body = {
        ruc: ruc,
        tipoDoc: tipoDoc,
        c_tipocom: c_tipocom,
        c_receptordoc: c_receptordoc,
        razonsocial: razonsocial,
        email: email,
        producto: [{"cantidad": "2", "codigobarras": "75018204480"}]
      }
      console.log(body);
      return this.http.post(this.url + 'generar-orden/', body, {headers: this.headers}).map((res: Response) => res.json());
    }
  

    public getTopTenProductsByMonth(finicio,ftermino,ruc){
    let body = {
      ruc: ruc,
      fecha_inicio: finicio,
      fecha_fin: ftermino
    }
    console.log(body);
    return this.http.post(this.url + 'listar-top-intervalo', body, {headers: this.headers}).map((res: Response) => res.json());
  }

  public getTopTenProducts(payload){
    payload.headers = this.headers;
    return this.http.post(this.url, payload).map((res: Response) => res.json());
  }

  public getProductInfo(barcode){
    return this.http.get(this.url + "listar-productos/" + barcode, {headers: this.headers}).map((res: Response) => res.json());
  }
  public login(user){
  //  user.headers = this.headers;
    return this.http.post(this.url + "check-login", user, {headers: this.headers}).map((res: Response) => res.json());
  }


  public getBestProducts(ruc) {
    let body = {
      ruc: ruc
    }
    return this.http.post(this.url + 'listar-top', body, {headers: this.headers}).map((res: Response) => res.json());
  }

  public getVentasMensual(ruc) {
    let body = {
      ruc: ruc
    }
    return this.http.post(this.url + 'monto-ventas-mensual', body, {headers: this.headers}).map((res: Response) => res.json());
  }

  public getInvoices(payload){
    payload.headers = this.headers;
    return this.http.post(this.url + "ordenes", payload).map((res: Response) => res.json());
  }

  public postRegisterPerson(nombre, apellido, dni, correo, celular, contrasena) {
    let body = {
      nombre: nombre,
      apellido: apellido,
      dni: dni,
      correo: correo,
      celular: celular,
      contraseña: contrasena
    }
    return this.http.post(this.url + 'registrar-persona', body, {headers: this.headers}).map((res: Response) => res.json());
  }

  public searchProduct(ruc, barcode) {
      return this.http.get(this.url + 'buscar-producto/' + ruc + '/' + barcode ).map((res: Response) => res.json());
  }

  private handleError(error: any): Observable<string> {
    const errMsg = (error.message) ? error.message :
      error.status ? `${error.status} - ${error.statusText}` : 'Server error';
    console.error(errMsg);
    return Observable.throw(errMsg);
  }
}
