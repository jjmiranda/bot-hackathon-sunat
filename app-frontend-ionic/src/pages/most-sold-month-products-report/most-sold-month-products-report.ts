import { Component, ViewChild } from '@angular/core';
import { IonicPage, NavController, NavParams } from 'ionic-angular';
import { ViewController } from 'ionic-angular';
import { Chart } from 'chart.js';
import {DataProvider} from "../../providers/data/data";
import {SharingProvider} from "../../providers/sharing/sharing";

@IonicPage()
@Component({
  selector: 'page-most-sold-month-products-report',
  templateUrl: 'most-sold-month-products-report.html',
})
export class MostSoldMonthProductsReportPage {

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



getChartData(){

  var fechaactual = new Date();
  var dd = fechaactual.getDate();
  var mm = fechaactual.getMonth()+1;
  var mm2 = fechaactual.getMonth();
  var yyyy = fechaactual.getFullYear();
  var dia = dd.toString();
  var mes = mm.toString();
  var mes2 = mm2.toString();
  var fechaactualquery, fechaactualanteriorquery;

  if(dd<10) {
      dia = '0'+dd
  }

  if(mm<10) {
      mes = '0'+mm
  }
  if(mm2<10) {
    mes2 = '0'+mm2
}

fechaactualquery = dia + '-' + mes + '-' + yyyy;
fechaactualanteriorquery = dia + '-' + mes2 + '-' + yyyy;
  console.log(fechaactualquery + " " + fechaactualanteriorquery);

      this.data.getTopTenProductsByMonth(fechaactualanteriorquery, fechaactualquery, this.sharing.dniruc).toPromise().then(products => {
          const data: any = {
            labels: [],
            barsData: []
          };
          products.resultado.forEach(product =>{
            data.labels.push(product.nombre);
            data.barsData.push(product.precioVenta)
          });
          this.generate_chart(data);
          this.sharing.setLoader(false);
      }, error => {console.log(error)})


  }

generate_chart(data){
  this.barChart = new Chart(this.barCanvas.nativeElement, {

    type: 'bar',
    data: {
      labels: data.labels,
      datasets: [{
        label: 'Monto de venta',
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
