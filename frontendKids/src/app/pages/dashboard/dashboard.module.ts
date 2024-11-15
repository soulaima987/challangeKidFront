import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterModule } from '@angular/router';
import { DashboardComponent } from './dashboard.component';
import { ModalsModule, WidgetsModule } from '../../_metronic/partials';
import { WidgetsExamplesModule } from 'src/app/modules/widgets-examples/widgets-examples.module';

@NgModule({
  declarations: [DashboardComponent ],
  imports: [
    CommonModule,
    RouterModule.forChild([
      {
        path: '',
        component: DashboardComponent,
      },
    ]),
    WidgetsModule,
    ModalsModule,
    WidgetsExamplesModule
  ],
})
export class DashboardModule {}
