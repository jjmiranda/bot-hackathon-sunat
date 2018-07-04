import { Component } from '@angular/core';
import { IonicPage, NavParams } from 'ionic-angular';

@IonicPage()
@Component({
  selector: 'page-tabs',
  templateUrl: 'tabs.html'
})
export class TabsPage {

  tab1Root = "HomePage";
  tab2Root = "SellPage";
  tab3Root = "InventoryPage";
  tab4Root = "VendorInvoicesPage";
  tab5Root = "InvoicesPage";

  tab11Root = "ClientHomePage";
  tab13Root = "ClientInvoicesPage";

  user: string;

  mySelectedIndex: number;

  constructor(navParams: NavParams) {
    this.mySelectedIndex = navParams.data.tabIndex || 0;
    this.user = navParams.get('userType');
  }
}
