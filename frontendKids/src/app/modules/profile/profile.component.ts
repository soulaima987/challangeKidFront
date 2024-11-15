import { Component, OnInit } from '@angular/core';
import { AuthService } from '../auth';

@Component({
  selector: 'app-profile',
  templateUrl: './profile.component.html',
})
export class ProfileComponent implements OnInit {
  fullname: any;
  email: any;
  points: any;
  constructor(private authService: AuthService) {}

  ngOnInit(): void {
    const currentUser = this.authService.currentUserSubject.value;
    console.log(currentUser);
    this.fullname = currentUser?.fullName;
    this.email = currentUser?.email;
    this.points = 50;
  }
}
