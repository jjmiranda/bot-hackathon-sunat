import { Component } from '@angular/core';
import { IonicPage, NavController, NavParams } from 'ionic-angular';
import { SharingProvider } from '../../providers/sharing/sharing';

import { BarcodeScanner } from '@ionic-native/barcode-scanner';


@IonicPage()
@Component({
  selector: 'page-client-buy',
  templateUrl: 'client-buy.html',
})
export class ClientBuyPage {

  scanData: {};
  encodedData : {};
  encodeData : string;

  constructor(
    public navCtrl: NavController,
    public navParams: NavParams,
    public barcodeScanner: BarcodeScanner,
    private _sharing: SharingProvider) {
      const person = this._sharing.getPerson();
      if (person.dni !== null) {
        this.encodeData = person.dni.toString();
      }
  }

  ionViewDidLoad() {
    console.log('ionViewDidLoad ClientBuyPage');
  }

  scan() { //lee qr y barcode
    this.barcodeScanner.scan().then((barcodeData) => {
        this.scanData = barcodeData.text;
    }, (err) => {
        alert(err)
    });
  }

  encodeText(){ //genera QR
    this.barcodeScanner.encode(this.barcodeScanner.Encode.TEXT_TYPE,this.encodeData).then((encodedData) => {
        this.encodedData = encodedData;
    }, (err) => {
        alert("Error occured : " + err);
    });
  }
}
