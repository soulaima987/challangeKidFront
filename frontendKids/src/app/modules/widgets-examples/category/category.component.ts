import { Component, TemplateRef, inject } from '@angular/core';
import { HttpserviceService } from '../../auth/services/httpservice.service';
import { lastValueFrom } from 'rxjs';
import { ModalDismissReasons, NgbModal } from '@ng-bootstrap/ng-bootstrap';

@Component({
  selector: 'app-category',
  templateUrl: './category.component.html',
})
export class CategoryComponent {
  showForm = false;
  title = '';
  desc = '';
  private modalService = inject(NgbModal);
	closeResult = '';

  open(content: TemplateRef<any>) {
		this.modalService.open(content, { ariaLabelledBy: 'modal-basic-title', 'centered':true, 'size':'lg' }).result.then(
			(result) => {
				this.closeResult = `Closed with: ${result}`;
			},
			(reason) => {
				this.closeResult = `Dismissed ${this.getDismissReason(reason)}`;
			},
		);
	}
  private getDismissReason(reason: any): string {
		switch (reason) {
			case ModalDismissReasons.ESC:
				return 'by pressing ESC';
			case ModalDismissReasons.BACKDROP_CLICK:
				return 'by clicking on a backdrop';
			default:
				return `with: ${reason}`;
		}
	}

  constructor(private httpservice: HttpserviceService) {}
  onAddCategory() {
    this.showForm = true;
  }
  async addCategory() {
    console.log(this.title, this.desc);
    try {
      const response = await lastValueFrom(
        this.httpservice.post('/api/category/new', {
          title: this.title,
          description: this.desc,
        })
      );
      if (response) {
        alert('The Category has been added');
        this.showForm = false;
        window.location.reload();
      }
    } catch (error) {
      console.error('Error fetching categories:', error);
    }
  }
}
