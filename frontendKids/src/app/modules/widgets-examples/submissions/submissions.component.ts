import { Component } from "@angular/core";
import { lastValueFrom } from "rxjs";
import { HttpserviceService } from "../../auth/services/httpservice.service";
import { environment } from "src/environments/environment";
import { Router } from "@angular/router";
const API_USERS_URL = `${environment.backednUrl}`;
import {
  OnInit,
  AfterViewInit,
  ElementRef,
  ViewChild,
  TemplateRef,
  inject,
} from "@angular/core";
import { HttpClient } from "@angular/common/http";

declare var $: any;
@Component({
  selector: "app-submissions",
  templateUrl: "./submissions.component.html",
  styleUrl: "./submissions.component.scss",
})
export class SubmissionsComponent implements OnInit, AfterViewInit {
  selectedpost: any;
  confirmPassword: any;

  @ViewChild("dataTable", { static: false }) tableElement: ElementRef;
  ngAfterViewInit() {
    $(this.tableElement.nativeElement).DataTable();
  }
  open() {
    throw new Error("Method not implemented.");
  }

  savepost() {
    throw new Error("Method not implemented.");
  }
  posts: any;
  constructor(
    private httpservice: HttpserviceService,
    private http: HttpClient,
    private router: Router
  ) {}
  goToViewChallenge(postId) {
    this.router.navigate([`/coach/widgets/viewpost/${postId}`]);
  }

  async ngOnInit() {
    try {
      const response = await lastValueFrom(
        this.httpservice.get("/api/coach/all-submissions")
      );
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
  // updateStatus(post: any, event: Event): void {
  //   const selectElement = event.target as HTMLSelectElement;

  //   // Ensure selectElement is valid and has a value
  //   if (selectElement && selectElement.value !== undefined) {
  //     let approved: boolean | null = null;
  //     if (selectElement.value === 'true') {
  //       approved = true;
  //     } else if (selectElement.value === 'false') {
  //       approved = false;
  //     } else {
  //       approved = null; // For Pending
  //     }

  //     // Make an HTTP PATCH request to update the approved status on the backend
  //     this.httpservice.put(`/api/coach/submissions/${post.id}/status`, { approved })
  //       .subscribe(
  //         () => {
  //           console.log('Status updated successfully');
  //         },
  //         (error) => {
  //           console.error('Error updating status:', error);
  //         }
  //       );
  //   } else {
  //     console.error('Invalid event or select element');
  //   }
  // }
  updateStatus(post, event: Event) {
    const selectElement = event.target as HTMLSelectElement;
    const approved = selectElement.value === "true";
    this.updateStatusService(post.id, approved).subscribe(() => {
      alert("test");
    });
  }

  updateStatusService(id: number, approved: boolean) {
    return this.http.post(
      `${API_USERS_URL}/api/coach/submissions/${id}/status`,
      { approved }
    );
  }
}
