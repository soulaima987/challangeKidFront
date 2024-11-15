import { Component } from "@angular/core";
import { HttpserviceService } from "../../auth/services/httpservice.service";
import { lastValueFrom } from "rxjs";
import { InlineSVGModule } from "ng-inline-svg-2";
import {
  OnInit,
  AfterViewInit,
  ElementRef,
  ViewChild,
  TemplateRef,
  inject,
} from "@angular/core";
import { ModalDismissReasons, NgbModal } from "@ng-bootstrap/ng-bootstrap";
import { Router } from "@angular/router";
declare var $: any;

@Component({
  selector: "app-lesson",

  templateUrl: "./coach-lesson.component.html",
})
export class CoachLessonComponent {
  posts: any;
  lnumber: any;
  title: any;
  description: any;
  private modalService = inject(NgbModal);
  closeResult: string;
  goToViewChapter(chapterid) {
    this.router.navigate([`/coach/widgets/viewlesson/${chapterid}`]);
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
  async savelesson() {
    try {
      const body = {
        title: this.title,
        description: this.description,
        LessonNumber: this.lnumber,
      };
      const response = await lastValueFrom(
        this.httpservice.post("/api/lesson/new", body)
      );
      window.location.reload();
      console.log("lesson added:", response);
    } catch (error) {
      console.error("Error fetching categories:", error);
    }
  }
  lessons: any;
  constructor(
    private httpservice: HttpserviceService,
    private router: Router
  ) {}
  @ViewChild("dataTable", { static: false }) tableElement: ElementRef;
  ngAfterViewInit() {
    $(this.tableElement.nativeElement).DataTable();
  }
  async assignLesson(postid, lessonId) {
    const body = {
      postId: postid,
    };
    try {
      const response = await lastValueFrom(
        this.httpservice.put(`/api/lesson/${lessonId}/assignPost`, body)
      );
      window.location.reload();
      console.log("lesson added:", response);
    } catch (error) {
      console.error("Error fetching categories:", error);
    }
  }
  onSelectChange(event: Event, lessonid) {
    const selectElement = event.target as HTMLSelectElement;
    const postId = selectElement.value;
    const lessonId = lessonid;
    this.assignLesson(postId, lessonId);
  }

  async ngOnInit() {
    try {
      const response = await lastValueFrom(
        this.httpservice.get("/api/lesson/coach")
      );
      const response2 = await lastValueFrom(
        this.httpservice.get("/api/lesson/postswithoutlessons")
      );
      this.posts = response2;
      this.lessons = response;
      console.log("Categories loaded:", this.lessons);
    } catch (error) {
      console.error("Error fetching categories:", error);
    }
  }
  async delete(id: any) {
    try {
      const response = await lastValueFrom(
        this.httpservice.delete(`/api/lesson/delete/${id}`)
      );
      window.location.reload();
    } catch (error) {
      console.error("Error fetching categories:", error);
    }
  }
}
