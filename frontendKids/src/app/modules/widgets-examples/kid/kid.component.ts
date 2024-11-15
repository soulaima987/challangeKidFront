import { Component } from "@angular/core";
import { HttpserviceService } from "../../auth/services/httpservice.service";
import { lastValueFrom } from "rxjs";
import { ModalDismissReasons, NgbModal } from "@ng-bootstrap/ng-bootstrap";
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
  selector: "app-kid",

  templateUrl: "./kid.component.html",
})
export class KidComponent implements OnInit, AfterViewInit {
  kids: any;
  selectedkid: any;
  confirmPassword: any;
  private modalService = inject(NgbModal);
  closeResult = "";
  constructor(private httpservice: HttpserviceService) {}
  @ViewChild("dataTable", { static: false }) tableElement: ElementRef;

  ngAfterViewInit() {
    $(this.tableElement.nativeElement).DataTable();
  }

  async ngOnInit() {
    try {
      const response = await lastValueFrom(this.httpservice.get("/api/kid"));
      this.kids = response;
      console.log("Categories loaded:", this.kids);
    } catch (error) {
      console.error("Error fetching categories:", error);
    }
  }

  async delete(id: any) {
    try {
      const response = await lastValueFrom(
        this.httpservice.delete(`/api/kid/delete/${id}`)
      );
      window.location.reload();
    } catch (error) {
      console.error("Error fetching categories:", error);
    }
  }
  savekid() {}
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
  open(content: TemplateRef<any>, coach: any) {
    this.selectedkid = { ...coach };
    this.confirmPassword = "";
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
}
