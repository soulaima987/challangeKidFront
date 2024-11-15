import { Component } from "@angular/core";
import { HttpserviceService } from "../../auth/services/httpservice.service";
import { lastValueFrom } from "rxjs";
import { environment } from "src/environments/environment";
import { Router } from "@angular/router";
import { ActivatedRoute } from "@angular/router";
const API_USERS_URL = `${environment.backednUrl}`;

@Component({
  selector: "app-viewpost",
  templateUrl: "./viewpost.component.html",
  styleUrl: "./viewpost.component.scss",
})
export class ViewpostComponent {
  constructor(
    private httpservice: HttpserviceService,
    private router: Router,
    private route: ActivatedRoute
  ) {}
  postId: any;
  backendUrl = API_USERS_URL;
  fakecategories: any;
  truecategories: any[] = [];
  challenge: any;
  myPost: any;

  async ngOnInit() {
    this.route.params.subscribe((params) => {
      this.postId = +params["id"];
    });
    try {
      const response = await lastValueFrom(
        this.httpservice.get(`/api/post/${this.postId}`)
      );
      this.myPost = response;
      const response2 = await lastValueFrom(
        this.httpservice.get(`/api/challenge/${this.myPost.challengeIdId}`)
      );
      this.challenge = response2;
      console.log("posts loaded:", this.myPost);
      console.log("Categories loaded:", this.challenge);
    } catch (error) {
      console.error("Error fetching categories:", error);
    }
  }
}
