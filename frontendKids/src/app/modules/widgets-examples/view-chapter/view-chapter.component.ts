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
  selector: "app-view-chapter",
  templateUrl: "./view-chapter.component.html",
  styleUrl: "./view-chapter.component.scss",
})
export class ViewChapterComponent {
  goToViewLesson(id) {
    this.router.navigate([`/coach/widgets/viewlesson/${id}`]);
  }
  showExistingLessons: any;
  addLessons: any;
  onLessonSelect(event: Event) {
    const target = event.target as HTMLInputElement;
    const lessonTitle = target.value;
    const isChecked = target.checked;

    if (isChecked) {
      if (!this.selectedLessons.includes(lessonTitle)) {
        this.selectedLessons.push(lessonTitle);
        console.log(this.selectedLessons);
      }
    } else {
      const index = this.selectedLessons.indexOf(lessonTitle);
      if (index > -1) {
        this.selectedLessons.splice(index, 1);
      }
    }
  }
  async addExistingLesson() {
    try {
      const body = {
        lessons: this.selectedLessons,
      };
      console.log(body);
      const response = await lastValueFrom(
        this.httpservice.put(`/api/chapter/${this.chapterId}/addLesson`, body)
      );
      window.location.reload();
      console.log("lesson added:", response);
    } catch (error) {
      console.error("Error fetching categories:", error);
    }
  }
  selectedLessons: string[] = [];
  showExistingChapters = false;
  title: any;
  description: any;
  lnumber: any;
  posts: any;
  showForm = false;
  backendUrl = API_USERS_URL;
  private modalService = inject(NgbModal);
  closeResult: string;
  chapterId: any;
  chapters: any;
  myChapter: any;
  myLessons: any;
  constructor(
    private httpservice: HttpserviceService,
    private route: ActivatedRoute,
    private router: Router
  ) {}
  @ViewChild("dataTable", { static: false }) tableElement: ElementRef;
  ngAfterViewInit() {
    $(this.tableElement.nativeElement).DataTable();
  }
  getChapterById(id: number, chapters: any[]): any {
    return chapters.find((chapter) => chapter.id === id);
  }
  getLessonsById(id: number): any {
    return this.myChapter.lessons;
  }

  async ngOnInit() {
    this.route.params.subscribe((params) => {
      this.chapterId = +params["id"]; // Convert to number
    });

    try {
      const response = await lastValueFrom(
        this.httpservice.get("/api/chapter/coach")
      );
      const response2 = await lastValueFrom(
        this.httpservice.get("/api/lesson/postswithoutlessons")
      );
      const response3 = await lastValueFrom(
        this.httpservice.get("/api/lesson/coach")
      );
      this.addLessons = response3;
      this.posts = response2;
      this.chapters = response;
      this.myChapter = this.getChapterById(this.chapterId, this.chapters);
      this.myLessons = this.getLessonsById(this.chapterId);
    } catch (error) {
      console.error("Error fetching chapters:", error);
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
  async savelesson() {
    try {
      const body = {
        title: this.title,
        description: this.description,
        LessonNumber: this.lnumber,
      };
      const response = await lastValueFrom(
        this.httpservice.post(
          `/api/chapter/${this.chapterId}/createLesson`,
          body
        )
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
}
