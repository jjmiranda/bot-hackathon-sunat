import { NgModule } from '@angular/core';
import { IonicPageModule } from 'ionic-angular';
import { MostSoldProductsReportPage } from './most-sold-products-report';

@NgModule({
  declarations: [
    MostSoldProductsReportPage,
  ],
  imports: [
    IonicPageModule.forChild(MostSoldProductsReportPage),
  ],
})
export class MostSoldProductsReportPageModule {}
