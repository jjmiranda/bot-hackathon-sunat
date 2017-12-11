import { NgModule } from '@angular/core';
import { IonicPageModule } from 'ionic-angular';
import { VendorInvoicesPage } from './vendor-invoices';

@NgModule({
  declarations: [
    VendorInvoicesPage,
  ],
  imports: [
    IonicPageModule.forChild(VendorInvoicesPage),
  ],
})
export class VendorInvoicesPageModule {}
