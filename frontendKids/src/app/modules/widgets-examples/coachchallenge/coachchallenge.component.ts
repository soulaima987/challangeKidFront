import {
  AfterViewChecked,
  AfterViewInit,
  Component,
  ElementRef,
  inject,
  OnInit,
  TemplateRef,
  ViewChild,
} from "@angular/core";
import { ModalDismissReasons, NgbModal } from "@ng-bootstrap/ng-bootstrap";
import { lastValueFrom } from "rxjs";
import { environment } from "src/environments/environment";
import { HttpserviceService } from "../../auth/services/httpservice.service";
import { FormBuilder, FormGroup, Validators } from "@angular/forms";
import { Router } from "@angular/router";
import { ActivatedRoute } from "@angular/router";
const API_USERS_URL = `${environment.backednUrl}`;
declare var $: any;

@Component({
  selector: "app-coachchallenge",
  templateUrl: "./coachchallenge.component.html",
  styleUrl: './coachchallenge.component.scss'
})
export class CoachchallengeComponent implements OnInit, AfterViewInit{
  postForm: FormGroup;
  challenges: any;
  backendUrl = API_USERS_URL;
  selectedChallenge: any;
  private modalService = inject(NgbModal);
  closeResult = "";
  truecategories: any[] = [];
  @ViewChild("dataTable", { static: false }) tableElement: ElementRef;
  selectedFile: File | null = null;
  fakecategories: any;
  Categories: string[] = [];

  quillConfig = {
    toolbar: [
      ["bold", "italic", "underline"],
      [{ header: [1, 2, false] }],
      [{ list: "ordered" }, { list: "bullet" }],
      ["link", "image"],
      ["clean"],
    ],
  };

  constructor(
    private httpservice: HttpserviceService,
    private fb: FormBuilder,
    private router: Router,
    private activatedRoute: ActivatedRoute
  ) {}

  initForm() {
    this.postForm = this.fb.group({
      title: ["", Validators.required],
      description: ["", Validators.required],
      mediaFile: [null],
      categories: this.fb.array([]),
    });
  }

  onFileSelected(event: any) {
    if (event.target.files.length > 0) {
      const file = event.target.files[0];
      this.selectedFile = file;
      this.postForm.patchValue({
        mediaFile: file,
      });
    }
  }

  onCategoryChange(category: { id: number; title: string; selected: boolean }) {
    category.selected = !category.selected; // Toggle the selected state

    console.log(
      "Category changed:",
      category.title,
      "Selected:",
      category.selected
    );

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

    console.log("Current Categories:", this.Categories);
  }

  addChallenge() {
    if (this.postForm.valid) {
      const formData = new FormData();
      formData.append("title", this.postForm.get("title")?.value);
      formData.append("description", this.postForm.get("description")?.value);
      if (this.selectedFile) {
        formData.append(
          "imageFileName",
          this.selectedFile,
          this.selectedFile.name
        );
      }
      formData.append("categories", JSON.stringify(this.Categories));
      formData.forEach((value, key) => {
        console.log(`${key}: ${value}`);
      });
      this.httpservice
        .post("/api/challenge/coach/addChallenge", formData)
        .subscribe(
          (response) => {
            console.log("Post added successfully", response);
          },
          (error) => {
            console.error("Error adding post", error);
          }
        );
    }
  }

  ngAfterViewInit() {
    $(this.tableElement.nativeElement).DataTable();
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
  goToViewChallenge(challengeId) {
    this.router.navigate([`/coach/widgets/viewchallenge/${challengeId}`]);
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
  async ngOnInit() {
    try {
      const response = await lastValueFrom(
        this.httpservice.get("/api/challenge/coach")
      );
      this.challenges = response;
      console.log("Chapters loaded:", this.challenges);
      this.getCategories();
      this.initForm();
    } catch (error) {
      console.error("Error fetching categories:", error);
    }
  }
  async deleteChallenge(id: any) {
    try {
      const response = await lastValueFrom(
        this.httpservice.delete(`/api/challenge/delete/${id}`)
      );
      window.location.reload();
    } catch (error) {
      console.error("Error fetching categories:", error);
    }
  }
  async getCategories() {
    const response2 = await lastValueFrom(
      this.httpservice.get("/api/category")
    );
    this.fakecategories = response2;
    for (let i = 0; i < this.fakecategories.length; i++) {
      let category = {};
      category["id"] = this.fakecategories[i]["id"];
      category["title"] = this.fakecategories[i]["title"];
      category["selected"] = false;
      this.truecategories.push(category);
    }
    console.log("Categories loaded:", this.truecategories);
  }
}
