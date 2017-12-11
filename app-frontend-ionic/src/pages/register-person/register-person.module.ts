import { NgModule } from '@angular/core';
import { IonicPageModule } from 'ionic-angular';
import { RegisterPersonPage } from './register-person';

@NgModule({
  declarations: [
    RegisterPersonPage,
  ],
  imports: [
    IonicPageModule.forChild(RegisterPersonPage),
  ],
})
export class RegisterPersonPageModule {}
