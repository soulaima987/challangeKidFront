import { Component } from "@angular/core";
import { lastValueFrom } from "rxjs";
import { HttpserviceService } from "../../auth/services/httpservice.service";
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
  selector: "app-post",
  templateUrl: "./post.component.html",
})
export class PostComponent implements OnInit, AfterViewInit {
  @ViewChild("dataTable", { static: false }) tableElement: ElementRef;
  ngAfterViewInit() {
    $(this.tableElement.nativeElement).DataTable();
  }
  open() {
    throw new Error("Method not implemented.");
  }
  selectedpost: any;
  confirmPassword: any;
  savepost() {
    throw new Error("Method not implemented.");
  }
  posts: any;
  constructor(private httpservice: HttpserviceService) {}

  async ngOnInit() {
    try {
      const response = await lastValueFrom(this.httpservice.get("/api/post"));
      this.posts = response;
      console.log("Categories loaded:", this.posts);
    } catch (error) {
      console.error("Error fetching categories:", error);
    }
  }
  async delete(id: any) {
    try {
      const response = await lastValueFrom(
        this.httpservice.delete(`/api/category/delete/${id}`)
      );
      window.location.reload();
    } catch (error) {
      console.error("Error fetching categories:", error);
    }
  }
}
