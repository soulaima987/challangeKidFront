import { Component, OnInit } from "@angular/core";
import { lastValueFrom } from "rxjs";
import { HttpserviceService } from "src/app/modules/auth/services/httpservice.service";

@Component({
  selector: "app-tables-widget11",
  templateUrl: "./tables-widget11.component.html",
})
export class TablesWidget11Component implements OnInit {
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
