import { Component } from '@angular/core';
import { IonicPage, NavController, NavParams } from 'ionic-angular';

import { DataProvider } from '../../providers/data/data';
import { SharingProvider } from '../../providers/sharing/sharing';

@IonicPage()
@Component({
  selector: 'page-inventory',
  templateUrl: 'inventory.html',
})
export class InventoryPage {
  unaltered_data = new Array();
  inventoryData = new Array();
  searchTerm: String;

  constructor(
    public navCtrl: NavController,
    public navParams: NavParams,
    private data: DataProvider,
    private sharing: SharingProvider
  ) {
      this.data.productsList(this.sharing.dniruc).toPromise()
        .then(data => {
          this.unaltered_data = data.resultado;
          this.inventoryData = data.resultado;
        })
        .catch(err => console.log('error: ', err));
  }

  ionViewDidLoad() {
    console.log('ionViewDidLoad InventoryPage');
  }

  filterItems(){
    if(this.searchTerm != "" && this.searchTerm != " " && this.searchTerm != null){
      this.inventoryData = this.inventoryData.filter((item) => {
        return item.nombre.toLowerCase().indexOf(this.searchTerm.toLowerCase()) > -1;
      });
    }else{
      this.inventoryData =  this.unaltered_data;
    }
  }

}
