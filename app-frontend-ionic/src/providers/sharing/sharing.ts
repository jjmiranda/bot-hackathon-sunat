import { Injectable } from '@angular/core';
import * as $ from 'jquery'
import { PersonSignIn, CompanySignIn } from '../entities/entities';
import { DataProvider } from '../data/data';
import { ToastController } from 'ionic-angular';
import { PopoverController } from 'ionic-angular';

@Injectable()
export class SharingProvider {

  private _person = new PersonSignIn();
  private _company = new CompanySignIn();
  public dniruc: string;

  constructor(
    private data: DataProvider,
    public toastCtrl: ToastController,
    public popover: PopoverController
  ) {

  }

  setLoader = function(val){
    if (val === true) {
      $('html').append('<div id="shadowBox" class="shadowBox"><div id="loader" class="sk-cube-grid centered"> <div class="sk-cube sk-cube1"></div> <div class="sk-cube sk-cube2"></div> <div class="sk-cube sk-cube3"></div> <div class="sk-cube sk-cube4"></div> <div class="sk-cube sk-cube5"></div> <div class="sk-cube sk-cube6"></div> <div class="sk-cube sk-cube7"></div> <div class="sk-cube sk-cube8"></div> <div class="sk-cube sk-cube9"></div> </div></div>').addClass('disabled');
    }else {
      $('html').removeClass('disabled');
      $('#loader').remove();
      $('#shadowBox').remove();
    }
  };

  savePerson(name, lastname, dni, mail, cel, passwd) {
    this._person.set(name, lastname, dni, mail, cel, passwd);
    this.data.postRegisterPerson(name, lastname, dni, mail, cel, passwd).toPromise()
      .then(dat => console.log(dat))
      .catch(err => { console.log('Error: ', err) });
    let toast = this.toastCtrl.create({
      message: 'El usuario se registró correctamente',
      duration: 3000
    });
    toast.present();
  }
  saveCompany(razsoc, ruc, address, cmail, tel, passwd) {
    this._company.set(razsoc, ruc, address, cmail, tel, passwd);
  }

  getPerson(): PersonSignIn {
    return this._person;
  }
  getCompany(): CompanySignIn {
    return this._company;
  }

  presentPopover(event) {
    let popover = this.popover.create('PopoverPage').present({ev: event});
  }
}
