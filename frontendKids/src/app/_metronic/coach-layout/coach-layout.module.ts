import { NgModule } from "@angular/core";
import { CommonModule } from "@angular/common";
import { InlineSVGModule } from "ng-inline-svg-2";
import { RouterModule, Routes } from "@angular/router";
import {
  NgbDropdownModule,
  NgbProgressbarModule,
  NgbTooltipModule,
} from "@ng-bootstrap/ng-bootstrap";
import { TranslateModule } from "@ngx-translate/core";
import { TranslationModule } from "../../modules/i18n";
import { LayoutComponent } from "./coach-layout.component";
import { ExtrasModule } from "../partials/layout/extras/extras.module";
import { Routing } from "../../pages/routing";
import { AsideComponent } from "./components/aside/aside.component";
import { HeaderComponent } from "./components/header/header.component";
import { ContentComponent } from "./components/content/content.component";
import { FooterComponent } from "./components/footer/footer.component";
import { ScriptsInitComponent } from "./components/scripts-init/scripts-init.component";
import { ToolbarComponent } from "./components/toolbar/toolbar.component";
import { AsideMenuComponent2 } from "./components/aside/aside-menu/aside-menu.component";
import { TopbarComponent } from "./components/topbar/topbar.component";
import { PageTitleComponent } from "./components/header/page-title/page-title.component";
import { HeaderMenuComponent } from "./components/header/header-menu/header-menu.component";
import {
  DrawersModule,
  DropdownMenusModule,
  ModalsModule,
  EngagesModule,
} from "../partials";
import { EngagesComponent } from "../partials/layout/engages/engages.component";
import { ThemeModeModule } from "../partials/layout/theme-mode-switcher/theme-mode.module";
import { AsideMenuComponent } from "../layout/components/aside/aside-menu/aside-menu.component";
const routes: Routes = [
  {
    path: "",
    component: LayoutComponent,
    children: Routing,
  },
];
@NgModule({
  declarations: [
    LayoutComponent,
    AsideMenuComponent2,
    HeaderComponent,
    ContentComponent,
    FooterComponent,
    AsideComponent,
    ScriptsInitComponent,
    ToolbarComponent,
    TopbarComponent,
    PageTitleComponent,
    HeaderMenuComponent,
  ],
  imports: [
    CommonModule,
    RouterModule.forChild(routes),
    TranslationModule,
    InlineSVGModule,
    NgbDropdownModule,
    NgbProgressbarModule,
    ExtrasModule,
    ModalsModule,
    DrawersModule,
    DropdownMenusModule,
    NgbTooltipModule,
    TranslateModule,
    ThemeModeModule,
  ],
  exports: [RouterModule],
})
export class CoachLayoutModule {}
