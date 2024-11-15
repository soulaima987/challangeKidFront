import { Component } from "@angular/core";
import { Router } from "@angular/router";
import { HttpserviceService } from "../../auth/services/httpservice.service";
import { ActivatedRoute } from "@angular/router";
import { lastValueFrom } from "rxjs";
import { environment } from "src/environments/environment";
const API_USERS_URL = `${environment.backednUrl}`;

@Component({
  selector: "app-view-lesson",
  templateUrl: "./view-lesson.component.html",
  styleUrl: "./view-lesson.component.scss",
})
export class ViewLessonComponent {
  lessonid: any;
  lessons: any;
  myLesson: any;
  backendUrl = API_USERS_URL;
  constructor(
    private httpservice: HttpserviceService,
    private route: ActivatedRoute,
    private router: Router
  ) {}
  async ngOnInit() {
    this.route.params.subscribe((params) => {
      this.lessonid = +params["id"];
    });
    try {
      const response = await lastValueFrom(
        this.httpservice.get("/api/lesson/coach")
      );
      this.lessons = response;
      console.log("my lessons", this.lessons);
      this.myLesson = this.getlessonById(this.lessonid, this.lessons);
      console.log("my lessons", this.myLesson);
    } catch (error) {
      console.error("Error fetching categories:", error);
    }
  }
  getlessonById(id: any, lessons: any): any {
    return lessons.find((lesson) => lesson.id === id);
  }
}
