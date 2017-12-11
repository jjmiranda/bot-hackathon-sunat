import { NgModule } from '@angular/core';
import { IonicPageModule } from 'ionic-angular';
import { MostSoldMonthProductsReportPage } from './most-sold-month-products-report';

@NgModule({
  declarations: [
    MostSoldMonthProductsReportPage,
  ],
  imports: [
    IonicPageModule.forChild(MostSoldMonthProductsReportPage),
  ],
})
export class MostSoldMonthProductsReportPageModule {}
