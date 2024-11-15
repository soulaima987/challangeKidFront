import { Component, TemplateRef } from "@angular/core";
import { HttpserviceService } from "../../auth/services/httpservice.service";
import { lastValueFrom } from "rxjs";
import {
  OnInit,
  AfterViewInit,
  ElementRef,
  ViewChild,
  inject,
} from "@angular/core";
declare var $: any;

@Component({
  selector: "app-chapter",
  templateUrl: "./chapter.component.html",
})
export class ChapterComponent {
  selectedchapter: any;
  savechapter() {}
  open() {}
  selectedCoach: any;
  confirmPassword: any;
  saveCoach() {}
  chapters: any;
  constructor(private httpservice: HttpserviceService) {}
  ngAfterViewInit() {
    $(this.tableElement.nativeElement).DataTable();
  }
  @ViewChild("dataTable", { static: false }) tableElement: ElementRef;
  async ngOnInit() {
    try {
      const response = await lastValueFrom(
        this.httpservice.get("/api/chapter")
      );
      this.chapters = response;
      console.log("Categories loaded:", this.chapters);
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
