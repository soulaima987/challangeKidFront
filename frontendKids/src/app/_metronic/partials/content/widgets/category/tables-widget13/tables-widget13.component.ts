import { Component, OnInit } from '@angular/core';
import { HttpserviceService } from 'src/app/modules/auth/services/httpservice.service';
import { lastValueFrom, Observable } from 'rxjs';
import { CommonModule } from '@angular/common';

@Component({
  selector: 'app-tables-widget13',
  templateUrl: './tables-widget13.component.html',
})
export class TablesWidget13Component implements OnInit {
  title = '';
  desc = '';
  categories: any;
  constructor(private httpservice: HttpserviceService) {}

  async ngOnInit() {
    try {
      const response = await lastValueFrom(
        this.httpservice.get('/api/category')
      );
      this.categories = response;
      console.log('Categories loaded:', this.categories);
    } catch (error) {
      console.error('Error fetching categories:', error);
    }
  }
  delete() {}
  async add() {
    try {
      const response = await lastValueFrom(
        this.httpservice.post('/api/category', {})
      );
      this.categories = response;
      console.log('Categories loaded:', this.categories);
    } catch (error) {
      console.error('Error fetching categories:', error);
    }
  }
}
