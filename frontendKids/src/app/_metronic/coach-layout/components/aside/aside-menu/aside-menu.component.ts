import { Component, OnInit } from "@angular/core";
import { environment } from "../../../../../../environments/environment";

@Component({
  selector: "app-aside-menu2",
  templateUrl: "./aside-menu.component.html",
  styleUrls: ["./aside-menu.component.scss"],
})
export class AsideMenuComponent2 implements OnInit {
  appAngularVersion: string = environment.appVersion;
  appPreviewChangelogUrl: string = environment.appPreviewChangelogUrl;

  constructor() {}

  ngOnInit(): void {}
}
