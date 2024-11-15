import {
  Component,
  OnInit,
  AfterViewInit,
  ElementRef,
  ViewChild,
  TemplateRef,
  inject,
} from "@angular/core";
import { FormBuilder, FormGroup, Validators } from "@angular/forms";
import { lastValueFrom } from "rxjs";
import { HttpserviceService } from "../../auth/services/httpservice.service";
import { AuthService } from "../../auth";
import { ModalDismissReasons, NgbModal } from "@ng-bootstrap/ng-bootstrap";
import { Router } from "@angular/router";
declare var $: any;

@Component({
  selector: "app-coaches-posts",
  templateUrl: "./coaches-posts.component.html",
  styleUrls: ["./coaches-posts.component.scss"],
})
export class CoachesPostsComponent implements AfterViewInit, OnInit {
  postForm: FormGroup;
  mediaFile: File | null = null;
  Categories: string[] = [];
  posts: any;
  closeResult = "";
  fakecategories: any;
  truecategories: any[] = [];
  confirmPassword: any;
  selectedpost: any = null;
  private modalService = inject(NgbModal);
  goToViewChallenge(postId) {
    this.router.navigate([`/coach/widgets/viewpost/${postId}`]);
  }

  constructor(
    private httpservice: HttpserviceService,
    private authservice: AuthService,
    private formBuilder: FormBuilder,
    private router: Router
  ) {
    this.postForm = this.formBuilder.group({
      title: ["", Validators.required],
      content: ["", Validators.required],
      mediaFileName: [null],
      categories: [[]],
    });
  }

  @ViewChild("dataTable", { static: false }) tableElement: ElementRef;

  ngAfterViewInit() {
    $(this.tableElement.nativeElement).DataTable();
  }

  onFileSelected(event: any) {
    this.mediaFile = event.target.files[0];
    this.postForm.patchValue({
      mediaFileName: this.mediaFile,
    });
  }

  addPost() {
    if (this.postForm.valid) {
      const formData = new FormData();
      formData.append("title", this.postForm.get("title")?.value);
      formData.append("content", this.postForm.get("content")?.value);
      if (this.mediaFile) {
        formData.append("mediaFileName", this.mediaFile, this.mediaFile.name);
      }
      formData.append("categories", JSON.stringify(this.Categories));

      this.httpservice.post("/api/post/user/new", formData).subscribe(
        (response) => {
          console.log("Post added successfully", response);
          window.location.reload();
        },
        (error) => {
          console.error("Error adding post", error);
        }
      );
    }
  }

  onCategoryChange(category: { id: number; title: string; selected: boolean }) {
    category.selected = !category.selected;

    if (category.selected) {
      if (!this.Categories.includes(category.title)) {
        this.Categories.push(category.title);
      }
    } else {
      const index = this.Categories.indexOf(category.title);
      if (index !== -1) {
        this.Categories.splice(index, 1);
      }
    }

    this.postForm.patchValue({
      categories: this.Categories,
    });
  }

  async ngOnInit() {
    try {
      const response = await lastValueFrom(
        this.httpservice.get("/api/post/user")
      );
      const response2 = await lastValueFrom(
        this.httpservice.get("/api/category")
      );
      this.fakecategories = response2;
      this.posts = response;
      for (let i = 0; i < this.fakecategories.length; i++) {
        let category = {};
        category["id"] = this.fakecategories[i]["id"];
        category["title"] = this.fakecategories[i]["title"];
        category["selected"] = false;
        this.truecategories.push(category);
      }
      console.log("Categories loaded:", this.truecategories);
    } catch (error) {
      console.error("Error fetching categories:", error);
    }
  }

  async delete(id: any) {
    try {
      const response = await lastValueFrom(
        this.httpservice.delete(`/api/post/${id}`)
      );
      window.location.reload();
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
}
