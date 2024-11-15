import {
  Component,
  OnInit,
  TemplateRef,
  inject,
  AfterViewInit,
  ElementRef,
  ViewChild,
} from "@angular/core";
import { ChallengeService } from "./services/challenge.service";
import { environment } from "src/environments/environment";
import { ModalDismissReasons, NgbModal } from "@ng-bootstrap/ng-bootstrap";
const API_USERS_URL = `${environment.backednUrl}`;
declare var $: any;

@Component({
  selector: "app-challenge",
  templateUrl: "./challenge.component.html",
})
export class ChallengeComponent implements OnInit, AfterViewInit {
  public challenges;
  public selectedChallenge;
  public isViewing: boolean = false;
  backendUrl = API_USERS_URL;
  private modalService = inject(NgbModal);
  closeResult = "";

  @ViewChild("dataTable", { static: false }) tableElement: ElementRef;

  constructor(private challengeService: ChallengeService) {}

  ngAfterViewInit() {
    $(this.tableElement.nativeElement).DataTable();
  }

  open(content: TemplateRef<any>, challenge: any) {
    this.selectedChallenge = { ...challenge };
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

  ngOnInit() {
    this.loadChallenges();
  }

  loadChallenges() {
    this.challengeService.getChallenges().subscribe(
      (data) => {
        this.challenges = data;
      },
      (err) => {
        console.error("Error fetching challenges:", err);
      }
    );
  }

  deleteChallenge(id: number) {
    this.challengeService.deleteChallenge(id).subscribe(
      () => {
        this.challenges = this.challenges.filter(
          (challenge) => challenge.id !== id
        );

        console.log(`Challenge with ID ${id} deleted`);

        alert("challenge deleted successfully!");

        window.location.reload();
      },
      (err) => {
        console.log("Error deleting challenge:", err);

        alert("Error deleting challenge. Please try again later.");
      }
    );
  }

  viewChallenge(challengeId: number) {
    this.challengeService.getChallengeById(challengeId).subscribe(
      (challenge) => {
        this.selectedChallenge = challenge;
        this.isViewing = true;
      },
      (err) => {
        console.error("Error fetching challenge details:", err);
      }
    );
  }
}
