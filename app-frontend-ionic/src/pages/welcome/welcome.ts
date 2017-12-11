import { Component } from '@angular/core';
import { IonicPage, NavController, NavParams } from 'ionic-angular';
import { FormGroup, FormControl, Validators, FormBuilder } from '@angular/forms';

import { DataProvider } from '../../providers/data/data';
import { SharingProvider } from '../../providers/sharing/sharing';

@IonicPage()
@Component({
  selector: 'page-welcome',
  templateUrl: 'welcome.html',
})
export class WelcomePage {

  private dniruc: string;
  private clave: string;
  private userType: string;
  public user: any = {
    "username": null,
    "password": null
  };

  public myForm: FormGroup;

  constructor(
    private _fb: FormBuilder,
    public navCtrl: NavController,
    public navParams: NavParams,
    private sharing: SharingProvider,
    private data: DataProvider
  ) {
    this.myForm = this._fb.group({
        userType: this.userType,
        dniruc: new FormControl(this.dniruc, Validators.minLength(8)),
        clave: new FormControl(this.clave, Validators.required)
      });
  }

  ionViewDidLoad() {
    console.log('ionViewDidLoad WelcomePage');

  }

  login(){
    // 10706008391

    this.sharing.dniruc = this.myForm.value.dniruc;
  //  this.navCtrl.push('TabsPage', {userType: this.user.userType});

    this.data.login(this.user).toPromise().then(response => {
      if(response.estado){
        this.navCtrl.push('TabsPage', {userType: this.user.userType});
      }else{
        alert(response.estado)
      }
    })
    .catch(err => console.log(err));

  }
  signIn() {
      this.navCtrl.push('RegisterPersonPage');
  }
}
