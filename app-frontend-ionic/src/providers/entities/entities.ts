import { Injectable } from '@angular/core';

@Injectable()

export class PersonSignIn {
  name: string;
  lastname: string;
  dni: number;
  mail: string;
  cel: number;
  passwd: string;

  constructor() {
    this.name = '';
    this.lastname = '';
    this.dni = null;
    this.mail = '';
    this.cel = null;
    this.passwd = '';
  }

  public set(name: string,
  lastname: string,
  dni: number,
  mail: string,
  cel: number,
  passwd: string) {
    this.name = name;
    this.lastname = lastname;
    this.dni = dni;
    this.mail = mail;
    this.cel = cel;
    this.passwd = passwd;
  }
}

export class CompanySignIn {
  razsoc: string;
  ruc: number;
  address: string;
  cmail: string;
  tel: number;
  passwd: string;

  constructor() {
    this.razsoc = '';
    this.ruc = null;
    this.address = '';
    this.cmail = '';
    this.tel = null;
    this.passwd = '';
  }

  public set(razsoc: string,
  ruc: number,
  address: string,
  cmail: string,
  tel: number,
  passwd: string) {
    this.razsoc = razsoc;
    this.ruc = ruc;
    this.address = address;
    this.cmail = cmail;
    this.tel = tel;
    this.passwd = passwd;
  }
}
