import { Component } from '@angular/core';
import { IonicPage, NavController, NavParams } from 'ionic-angular';

import { BarcodeScanner } from '@ionic-native/barcode-scanner';
import {DataProvider} from "../../providers/data/data";
import {SharingProvider} from "../../providers/sharing/sharing";

@IonicPage()
@Component({
  selector: 'page-sell',
  templateUrl: 'sell.html',
})
export class SellPage {

  scanData: {};
  public products = new Array();
  public total_sale: number = 0;
  public tax: number = 0.12; //cambiar este numero para cambiar el impuesto

  dniruc: string;
  ruccl = '';
  razonsocial = '';
  email = '';
  sell = {comp: ''};

  constructor(
    public navCtrl: NavController,
    public navParams: NavParams,
    private barcodeScanner: BarcodeScanner,
    private data: DataProvider,
    private sharing: SharingProvider
  ) {
    this.dniruc = this.sharing.dniruc;
  }

  ionViewDidLoad() {
    console.log('ionViewDidLoad SellPage');
  }
  scan() {
    this.barcodeScanner.scan().then((barcodeData) => {
      this.data.searchProduct(this.dniruc, barcodeData.text).toPromise().then(data =>{
        data.resultado[0]['codigobarras'] = barcodeData.text;
        this.products.push(data.resultado[0]);
        this.total_sale = this.total_sale + data.resultado[0].precioVenta;
      }, err =>{
        console.log(err)
      })
    }, (err) => {
        alert(err);
    });
  }
  calculateTotal(products) {
    this.total_sale = 0;
    products.forEach(product =>{
      this.total_sale = this.total_sale + product.precioVenta * product.cantidad;
    });
  }

  genCom() {
    this.data.generarComprobante(this.sharing.dniruc, 1, 1, this.ruccl, this.razonsocial, this.email, this.products).toPromise()
    .then(data => {
      alert('Comprobante generado correctamente');
    })
    .catch(err => { console.log('Error: ', err) });
  }
  add() {
    console.log('add');

  }
}
