import { Component, Input, Output, EventEmitter } from '@angular/core';

@Component({
  selector: 'app-edit-coach',
  templateUrl: './edit-coach.component.html',
})
export class EditCoachComponent {
  @Input() coach: any; // Receives the coach to be edited
  @Output() cancel = new EventEmitter<void>(); // Event to cancel editing

  // Method to handle form submission
  updateCoach() {
    // Implement update logic here
    console.log('Updated coach:', this.coach);

    // Hide the edit form after update
    this.cancel.emit();
  }

  // Method to cancel editing
  cancelEdit() {
    this.cancel.emit();
  }
}
