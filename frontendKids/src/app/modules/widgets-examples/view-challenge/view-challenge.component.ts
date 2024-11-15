import { Component, ElementRef, TemplateRef, ViewChild } from "@angular/core";
import { HttpserviceService } from "../../auth/services/httpservice.service";
import { lastValueFrom, map } from "rxjs";
import { OnInit, AfterViewInit, inject } from "@angular/core";
import { ModalDismissReasons, NgbModal } from "@ng-bootstrap/ng-bootstrap";
import { ActivatedRoute } from "@angular/router";
import { environment } from "src/environments/environment";
import { Router } from "@angular/router";
const API_USERS_URL = `${environment.backednUrl}`;
declare var $: any;

@Component({
  selector: "app-view-challenge",
  templateUrl: "./view-challenge.component.html",
})
export class ViewChallengeComponent {
  goToViewChapter(chapterid) {
    this.router.navigate([`/coach/widgets/viewchapter/${chapterid}`]);
  }
  showForm = false;
  backendUrl = API_USERS_URL;
  private modalService = inject(NgbModal);
  closeResult: string;
  @ViewChild("dataTable", { static: false }) tableElement: ElementRef;
  chapters: any;
  title: any;
  desc: any = "";
  cnumber: number;
  challeneId: any;
  challenge: any;
  showExistingChapters = false;
  selectedChapters: string[] = [];
  addChapters: any;
  ngAfterViewInit() {
    $(this.tableElement.nativeElement).DataTable();
  }
  constructor(
    private httpservice: HttpserviceService,
    private route: ActivatedRoute,
    private router: Router
  ) {}
  async addExistingChapter() {
    try {
      const body = {
        chapters: this.selectedChapters,
      };
      console.log(body);
      const response = await lastValueFrom(
        this.httpservice.put(
          `/api/challenge/${this.challeneId}/addChapters`,
          body
        )
      );
      window.location.reload();
      console.log("chapter added:", response);
    } catch (error) {
      console.error("Error fetching categories:", error);
    }
  }
  onChapterSelect(event: Event) {
    const target = event.target as HTMLInputElement;
    const chapterTitle = target.value;
    const isChecked = target.checked;

    if (isChecked) {
      if (!this.selectedChapters.includes(chapterTitle)) {
        this.selectedChapters.push(chapterTitle);
        console.log(this.selectedChapters);
      }
    } else {
      const index = this.selectedChapters.indexOf(chapterTitle);
      if (index > -1) {
        this.selectedChapters.splice(index, 1);
      }
    }
  }
  async savechapter() {
    try {
      const body = {
        title: this.title,
        description: this.desc,
        chapterNumber: this.cnumber,
      };
      console.log(body);
      const response = await lastValueFrom(
        this.httpservice.post(
          `/api/challenge/${this.challeneId}/createChapter`,
          body
        )
      );
      window.location.reload();
      console.log("lesson added:", response);
    } catch (error) {
      console.error("Error fetching categories:", error);
    }
  }
  open(content: TemplateRef<any>) {
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
  async ngOnInit() {
    this.route.params.subscribe((params) => {
      this.challeneId = params["id"];
    });
    try {
      const response = await lastValueFrom(
        this.httpservice.get("/api/chapter/coach")
      );
      const response2 = await lastValueFrom(
        this.httpservice.get(`/api/challenge/${this.challeneId}`)
      );
      this.challenge = response2;
      this.addChapters = response;
      this.chapters = this.challenge.chapters;
      console.log("Chapters loaded:", this.chapters);
    } catch (error) {
      console.error("Error fetching categories:", error);
    }
  }
  async delete(id: any) {
    try {
      const response = await lastValueFrom(
        this.httpservice.delete(`/api/chapter/delete/${id}`)
      );
      window.location.reload();
    } catch (error) {
      console.error("Error fetching categories:", error);
    }
  }
}
