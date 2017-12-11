import { Component } from '@angular/core';
import { IonicPage, NavController, NavParams } from 'ionic-angular';
import { PersonSignIn, CompanySignIn } from '../../providers/entities/entities';
import { SharingProvider } from '../../providers/sharing/sharing';
import { AlertController } from 'ionic-angular';


@IonicPage()
@Component({
  selector: 'page-register-person',
  templateUrl: 'register-person.html',
})
export class RegisterPersonPage {

  nat = new PersonSignIn();
  com = new CompanySignIn();
  passwd = '';
  passwd2 = '';

  userType = 'nat';
  isFormvalid = false;

  constructor(
    private _sharing: SharingProvider,
    public navCtrl: NavController,
    public navParams: NavParams,
    public alertCtrl: AlertController
  ) {

  }

  ionViewDidLoad() {
    console.log('ionViewDidLoad RegisterPersonPage');
  }

  back() {
    this.navCtrl.pop();
  }

  register() {
    let EMAIL_REGEXP = /^[a-z0-9!#$%&'*+\/=?^_`{|}~.-]+@[a-z0-9]([a-z0-9-]*[a-z0-9])?(\.[a-z0-9]([a-z0-9-]*[a-z0-9])?)*$/i;
    if(this.passwd === this.passwd2 ) {
      if (this.userType === 'nat') {
        if (this.nat.name.length &&
          this.nat.lastname.length &&
          this.nat.mail.length &&
          this.nat.dni.toString().length === 8 &&
          EMAIL_REGEXP.test(this.nat.mail)) {
            this.isFormvalid = true;
            this._sharing.savePerson(
              this.nat.name,
              this.nat.lastname,
              this.nat.dni,
              this.nat.mail,
              this.nat.cel,
              this.passwd
            );
            this.navCtrl.pop();
          }
      } else {
        if (this.com.razsoc.length &&
          this.com.address &&
          this.com.ruc.toString().length === 11 &&
          EMAIL_REGEXP.test(this.com.cmail)) {
            this.isFormvalid = true;
            this._sharing.saveCompany (
              this.com.razsoc,
              this.com.ruc,
              this.com.address,
              this.com.cmail,
              this.com.tel,
              this.passwd
            );
            this.navCtrl.pop();
          }
      }

      if (this.isFormvalid) {
        this.isFormvalid = false;
      } else {
        let alert = this.alertCtrl.create({
        title: 'Error',
        subTitle: 'Revisar los datos ingresados',
        buttons: ['OK']
      });
      alert.present();
      }
    } else {
      let alert = this.alertCtrl.create({
      title: 'Error',
      subTitle: 'Las contraseñas no coinciden',
      buttons: ['OK']
    });
    alert.present();
    }
  }
}
