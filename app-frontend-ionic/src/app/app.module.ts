import { NgModule, ErrorHandler } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';
import { IonicApp, IonicModule, IonicErrorHandler } from 'ionic-angular';
import { MyApp } from './app.component';

import { StatusBar } from '@ionic-native/status-bar';
import { SplashScreen } from '@ionic-native/splash-screen';

import { SharingProvider } from '../providers/sharing/sharing';
import { PersonSignIn, CompanySignIn } from '../providers/entities/entities';

import { BarcodeScanner } from '@ionic-native/barcode-scanner';
import { DataProvider } from '../providers/data/data';

import { HttpModule } from '@angular/http';

@NgModule({
  declarations: [
    MyApp
  ],
  imports: [
    BrowserModule,
    IonicModule.forRoot(MyApp),
    HttpModule
  ],
  bootstrap: [IonicApp],
  entryComponents: [
    MyApp
  ],
  providers: [
    StatusBar,
    SplashScreen,
    {provide: ErrorHandler, useClass: IonicErrorHandler},
    PersonSignIn,
    SharingProvider,
    CompanySignIn,
    BarcodeScanner,
    DataProvider
  ]
})
export class AppModule {}
