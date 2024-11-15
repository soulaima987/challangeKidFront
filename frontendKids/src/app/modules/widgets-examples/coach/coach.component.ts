import { Component, OnInit, AfterViewInit, ElementRef, ViewChild, TemplateRef, inject, } from "@angular/core";
import { CoachService } from "./services/coach.service";
import { ModalDismissReasons, NgbModal } from "@ng-bootstrap/ng-bootstrap";
declare var $: any;

@Component({
  selector: "app-coach",
  templateUrl: "./coach.component.html",
})

export class CoachComponent implements OnInit, AfterViewInit {
  public coaches: any;
  pendingCoaches: any;
  acceptedCoaches: any;
  refusedCoaches: any;
  public isEditing: boolean = false;
  public selectedCoach: any = null;
  public confirmPassword: string = "";
  private modalService = inject(NgbModal);
  closeResult = "";

  @ViewChild("dataTable", { static: false }) tableElement: ElementRef;

  constructor(private coachService: CoachService) {}

  ngOnInit() {
    this.loadCoaches();
  }

  ngAfterViewInit(): void {
    this.initializeDataTable();
  }

  initializeDataTable(): void {
    $(document).ready(() => {
      $('#pendingCoachesTable').DataTable();
      $('#acceptedCoachesTable').DataTable();
      $('#refusedCoachesTable').DataTable();
    });
  }

  loadCoaches(): void {
    this.coachService.getPendingCoaches().subscribe(data => {
      this.pendingCoaches = data;
    });

    this.coachService.getAcceptedCoaches().subscribe(data => {
      this.acceptedCoaches = data;
    });

    this.coachService.getRefusedCoaches().subscribe(data => {
      this.refusedCoaches = data;
    });
  }

  deleteCoach(id: number) {
    this.coachService.deleteCoach(id).subscribe(
      () => {
        this.coaches = this.coaches.filter((coach) => coach.id !== id);

        console.log(`Coach with ID ${id} deleted`);

        alert("Coach deleted successfully!");

        window.location.reload();
      },
      (err) => {
        console.log("Error deleting coach:", err);

        alert("Error deleting coach. Please try again later.");
      }
    );
  }

  saveCoach() {
    if (this.selectedCoach.password !== this.confirmPassword) {
      alert("Passwords do not match!");
      return;
    }

    const { confirmPassword, ...coachData } = this.selectedCoach; // Exclude confirmPassword

    this.coachService.updateCoach(coachData).subscribe(
      () => {
        const index = this.coaches.findIndex(
          (c) => c.id === this.selectedCoach.id
        );
        if (index > -1) {
          this.coaches[index] = this.selectedCoach;
        }
        this.selectedCoach = null;
        this.confirmPassword = "";
        alert("Coach updated successfully!");
        window.location.reload();
      },
      (err) => {
        console.error("Error updating coach:", err);
        alert("Error updating coach. Please try again later.");
      }
    );
  }

  open(content: TemplateRef<any>, coach: any) {
    this.selectedCoach = { ...coach };
    this.confirmPassword = "";
    this.modalService
      .open(content, {
        ariaLabelledBy: "modal-basic-title",
        centered: true,
        size: "lg",
      })
      .result.then(
        (result) => {
          this.closeResult = `Closed with: ${result}`;
        },
        (reason) => {
          this.closeResult = `Dismissed ${this.getDismissReason(reason)}`;
        }
      );
  }

  private getDismissReason(reason: any): string {
    switch (reason) {
      case ModalDismissReasons.ESC:
        return "by pressing ESC";
      case ModalDismissReasons.BACKDROP_CLICK:
        return "by clicking on a backdrop";
      default:
        return `with: ${reason}`;
    }
  }

  updateStatus(coach, event: Event): void {
    const selectElement = event.target as HTMLSelectElement;
    const accepted = selectElement.value === 'true';
    this.coachService.updateCoachStatus(coach.id, accepted).subscribe(() => {
      this.loadCoaches(); // Reload the lists after updating
    });
  }
}
