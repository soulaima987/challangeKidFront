import { Component, OnInit } from '@angular/core';
import { HttpserviceService } from 'src/app/modules/auth/services/httpservice.service';
import { lastValueFrom } from 'rxjs';

@Component({
  selector: 'app-tables-widget12',
  templateUrl: './tables-widget12.component.html',
})
export class TablesWidget12Component implements OnInit {
  challenges: any;
  constructor(private httpservice: HttpserviceService) {}

  async ngOnInit() {
    try {
      const response = await lastValueFrom(
        this.httpservice.get('/api/challenge')
      );
      this.challenges = response;
      console.log('Categories loaded:', this.challenges);
    } catch (error) {
      console.error('Error fetching challenges:', error);
    }
  }
}
