import { Component, OnInit } from '@angular/core';
import { lastValueFrom } from 'rxjs';
import { HttpserviceService } from '../../auth/services/httpservice.service';

@Component({
  selector: 'app-overview',
  templateUrl: './overview.component.html',
})
export class OverviewComponent implements OnInit {
  FullName: 'hadil';
  SecondName: 'jojo';
  email: 'jhdgjqsgd';
  interests: 'ddddddddd';
  birthdDate: '';
  level: '';
  response: any;
  data: any;
  constructor(private httpservice: HttpserviceService) {}

  async ngOnInit() {
    const response = await lastValueFrom(this.httpservice.get('/api/kid/'));
    this.response = response;
    this.data = this.response[0];
    this.FullName = this.data.fullName;
    this.email = this.data.email;
    this.birthdDate = this.data.birthdDate;
    this.interests = this.data.interests;
    this.level = this.data.level;
  }
}
