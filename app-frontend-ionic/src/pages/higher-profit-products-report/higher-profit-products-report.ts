import { Component, ViewChild } from '@angular/core';
import { IonicPage, NavController, NavParams } from 'ionic-angular';
import { ModalController, ViewController } from 'ionic-angular';
import { Chart } from 'chart.js';
import {DataProvider} from "../../providers/data/data";
import {SharingProvider} from "../../providers/sharing/sharing";

/**
 * Generated class for the HigherProfitProductsReportPage page.
 *
 * See https://ionicframework.com/docs/components/#navigation for more info on
 * Ionic pages and navigation.
 */

@IonicPage()
@Component({
  selector: 'page-higher-profit-products-report',
  templateUrl: 'higher-profit-products-report.html',
})
export class HigherProfitProductsReportPage {
  @ViewChild('barCanvas') barCanvas;

  barChart: any;
  chartdata = [];

  constructor(
    public navCtrl: NavController,
    public navParams: NavParams,
    public viewCtrl: ViewController,
    private data: DataProvider,
    private sharing: SharingProvider
  ) {}


  ionViewDidLoad() {
    this.getChartData();
  }

  getChartData(){/*
    this.sharing.setLoader(true);
    this.data.productsList("20532803749").toPromise().then(products => {*/
      this.data.getBestProducts(this.sharing.dniruc).toPromise().then(products => {      
      /*if(!products.isEmpty()){*/
        const data: any = {
          labels: [],
          barsData: []
        };
        products.resultado.forEach(product =>{
            data.labels.push(product.nombre);
          data.barsData.push(product.precioVenta - product.precioCompra)
        });
        this.generate_chart(data);
        this.sharing.setLoader(false);
      /*}else{
        console.log("no hay productos")
      }*/
    }, error => {console.log(error)})

  }

  generate_chart(data){
    this.barChart = new Chart(this.barCanvas.nativeElement, {

      type: 'bar',
      data: {
        labels: data.labels,
        datasets: [{
          label: 'Monto de ganancia',
          data: data.barsData,
          backgroundColor: [
            'rgba(255, 99, 132, 0.2)',
            'rgba(54, 162, 235, 0.2)',
            'rgba(255, 206, 86, 0.2)',
            'rgba(75, 192, 192, 0.2)',
            'rgba(153, 102, 255, 0.2)',
            'rgba(255, 159, 64, 0.2)',
            'rgba(255, 179, 78, 0.2)',
            'rgba(255, 119, 184, 0.2)',
            'rgba(255, 234, 220, 0.2)',
            'rgba(255, 60, 63, 0.2)'
          ],
          borderColor: [
            'rgba(255,99,132,1)',
            'rgba(54, 162, 235, 1)',
            'rgba(255, 206, 86, 1)',
            'rgba(75, 192, 192, 1)',
            'rgba(153, 102, 255, 1)',
            'rgba(255, 159, 64, 1)',
            'rgba(255, 179, 78, 1)',
            'rgba(255, 119, 184, 1)',
            'rgba(255, 234, 220, 1)',
            'rgba(255, 60, 63, 1)'
          ],
          borderWidth: 1
        }]
      },
      options: {
        scales: {
          yAxes: [{
            ticks: {
              beginAtZero: true
            }
          }]
        }
      }

    });
  }

  dismiss() {
    this.viewCtrl.dismiss();
  }


}
