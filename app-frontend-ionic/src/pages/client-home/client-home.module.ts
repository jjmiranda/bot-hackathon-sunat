import { NgModule } from '@angular/core';
import { IonicPageModule } from 'ionic-angular';
import { ClientHomePage } from './client-home';

@NgModule({
  declarations: [
    ClientHomePage,
  ],
  imports: [
    IonicPageModule.forChild(ClientHomePage),
  ],
})
export class ClientHomePageModule {}
