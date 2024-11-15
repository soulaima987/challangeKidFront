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
declare var $: any;

@Component({
  selector: "app-lesson",

  templateUrl: "./lesson.component.html",
})
export class LessonComponent {
  selectedlesson: any;
  confirmPassword: any;
  savelesson() {
    throw new Error("Method not implemented.");
  }
  lessons: any;
  constructor(private httpservice: HttpserviceService) {}
  @ViewChild("dataTable", { static: false }) tableElement: ElementRef;
  ngAfterViewInit() {
    $(this.tableElement.nativeElement).DataTable();
  }

  async ngOnInit() {
    try {
      const response = await lastValueFrom(this.httpservice.get("/api/lesson"));
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
