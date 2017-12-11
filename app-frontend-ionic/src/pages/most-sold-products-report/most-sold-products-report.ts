import { Component, ViewChild } from '@angular/core';
import { IonicPage, NavController, NavParams } from 'ionic-angular';
import { ModalController, ViewController } from 'ionic-angular';
import { Chart } from 'chart.js';
import { DataProvider } from '../../providers/data/data';
import { SharingProvider } from '../../providers/sharing/sharing';

@IonicPage()
@Component({
  selector: 'page-most-sold-products-report',
  templateUrl: 'most-sold-products-report.html',
})
export class MostSoldProductsReportPage {

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
    /*alert(this.sharing.dniruc);*/

    /*
    this.data.getBestProducts(this.sharing.dniruc).toPromise()
      .then(data => {
        console.log(data);
      })   
      .catch(err => {console.log(err)});
      */

ionViewDidLoad() {
  this.getChartData();
}

getChartData(){
      this.data.getBestProducts(this.sharing.dniruc).toPromise().then(products => {
       /* if(!products.resultado.isEmpty()){*/
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
     /*   }else{
          console.log("no hay productos")
        }*/
      }, error => {console.log(error)})
      
      
  }


/*

    this.barChart = new Chart(this.barCanvas.nativeElement, {

      type: 'bar',
      data: {
        labels: ["Red", "Blue", "Yellow", "Green", "Purple", "Orange"],
        datasets: [{
          label: '# of Votes',
          data: [12, 19, 3, 5, 2, 3],
          backgroundColor: [
            'rgba(255, 99, 132, 0.2)',
            'rgba(54, 162, 235, 0.2)',
            'rgba(255, 206, 86, 0.2)',
            'rgba(75, 192, 192, 0.2)',
            'rgba(153, 102, 255, 0.2)',
            'rgba(255, 159, 64, 0.2)'
          ],
          borderColor: [
            'rgba(255,99,132,1)',
            'rgba(54, 162, 235, 1)',
            'rgba(255, 206, 86, 1)',
            'rgba(75, 192, 192, 1)',
            'rgba(153, 102, 255, 1)',
            'rgba(255, 159, 64, 1)'
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

*/


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
