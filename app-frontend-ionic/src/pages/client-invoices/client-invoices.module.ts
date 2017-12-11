import { NgModule } from '@angular/core';
import { IonicPageModule } from 'ionic-angular';
import { ClientInvoicesPage } from './client-invoices';

@NgModule({
  declarations: [
    ClientInvoicesPage,
  ],
  imports: [
    IonicPageModule.forChild(ClientInvoicesPage),
  ],
})
export class ClientInvoicesPageModule {}
