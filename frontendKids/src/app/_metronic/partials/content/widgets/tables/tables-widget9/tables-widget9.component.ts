import { Component, OnInit } from '@angular/core';
import { CoachService } from './services/coach.service';

@Component({
  selector: 'app-tables-widget9',
  templateUrl: './tables-widget9.component.html',
})
export class TablesWidget9Component implements OnInit {
  public coaches;
  public selectedCoach  = null; 
  public isEditing = false;

  constructor(private coachService: CoachService) {}

  ngOnInit() {
    this.loadCoaches();
  }

  loadCoaches() {
    this.coachService.getCoaches()
      .subscribe(
        data => {
          this.coaches = data;
          console.log('Coach data:', this.coaches); // Logs the coach data to the console
        },
        err => {
          console.log('Error fetching coaches:', err);
        }
      );
  }

  deleteCoach(id: number) {
    this.coachService.deleteCoach(id)
      .subscribe(
        () => {

          this.coaches = this.coaches.filter(coach => coach.id !== id);

          console.log(`Coach with ID ${id} deleted`);

          alert('Coach deleted successfully!');

          window.location.reload();
        },
        err => {

          console.log('Error deleting coach:', err);

          alert('Error deleting coach. Please try again later.');
        }
      );
  }

  // Set the coach to be edited
  editCoach(coach: any) {
    this.selectedCoach = { ...coach }; // Clone the coach object
    this.isEditing = true;
  }

  // Method to hide the edit form
  cancelEdit() {
    this.selectedCoach = null;
    this.isEditing = false;
  }
}
