import { Component } from '@angular/core';
import { IonicPage, NavController, NavParams } from 'ionic-angular';
import {DataProvider} from "../../providers/data/data";
import {SharingProvider} from "../../providers/sharing/sharing";
import { AlertController } from 'ionic-angular';

@IonicPage()
@Component({
  selector: 'page-client-invoices',
  templateUrl: 'client-invoices.html',
})
export class ClientInvoicesPage {

  public searchTerm: String;
  public currentDate = new Date();
  public today = this.currentDate.getTime();
  public yesterday = this.currentDate.setDate(this.currentDate.getDate() - 1);
  public data;
  public unaltered_data;
  public listing: String;
  public invoices;
  public boletas;
  detalle = [];
  dniruc: string;

  constructor(
    public navCtrl: NavController,
    public navParams: NavParams,
    public dataProvider: DataProvider,
    public  sharing: SharingProvider,
    public alertCtrl: AlertController
  ) {
    this.dniruc = this.sharing.dniruc;
    this.listing = (this.dniruc.length === 11)? 'invoices' : 'boletas';
    this.getInvoices();
  }

  ionViewDidLoad() {
    console.log('ionViewDidLoad ClientInvoicesPage');
  }

  filterItems(){
    if(this.searchTerm != "" && this.searchTerm != " " && this.searchTerm != null){
      this.data = this.data.filter((item) => {
        return item.name.toLowerCase().indexOf(this.searchTerm.toLowerCase()) > -1;
      });
    }else{
      this.data =  this.unaltered_data;
    }
  }

  setListing(type){
    switch (type){
      case "invoices":
        this.data = this.invoices;
        this.unaltered_data = this.invoices;
        break;
      case "boletas":
        this.data = this.boletas;
        this.unaltered_data = this.boletas;
        break;
    }
  }

  getInvoices(){
    var payload = {
      "ruc": this.dniruc,
      "tipo": "1"
    };
    this.dataProvider.getInvoices(payload).toPromise().then(r =>{
      this.invoices = r.resultado.filter((item) => {
        return item.tipoComprobante.toLowerCase().indexOf("factura") > -1;
      });;
      this.boletas = r.resultado.filter((item) => {
        return item.tipoComprobante.toLowerCase().indexOf("boleta") > -1;
      });
      this.setListing(this.listing);
    })
  }

  viewDetail(i) {
    console.log(this.data[i].detalle);
    this.detalle = this.data[i].detalle;

    let det = '';
    this.data[i].detalle.forEach(d => {
      det += '<div><p><strong>Producto: </strong>' + d.productoNombre + '</p>' +
        '<p><strong>Cantidad: </strong>' + d.cantidad + '</p>' +
        '<p><strong>Subtotal: </strong> S/' + d.subtotal + '</p>' +
        '<p><strong>Impuesto: </strong>' + d.montoImpuesto + '%</p></div><br/>';
    });

    let alert = this.alertCtrl.create({
    title: 'Orden ' + this.data[i].detalle[0].orden,
    message: det,
    buttons: ['OK']
  });
  alert.present();
  }

}
