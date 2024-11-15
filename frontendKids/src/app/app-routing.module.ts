import { NgModule } from "@angular/core";
import { Routes, RouterModule } from "@angular/router";
import { AuthGuard } from "./modules/auth/services/auth-http/auth.guard";

export const routes: Routes = [
  {
    path: "auth",
    loadChildren: () =>
      import("./modules/auth/auth.module").then((m) => m.AuthModule),
  },
  {
    path: "error",
    loadChildren: () =>
      import("./modules/errors/errors.module").then((m) => m.ErrorsModule),
  },
  {
    path: "admin",
    canActivate: [AuthGuard],
    loadChildren: () =>
      import("./_metronic/layout/layout.module").then((m) => m.LayoutModule),
  },
  {
    path: "coach",
    canActivate: [AuthGuard],
    loadChildren: () =>
      import("./_metronic/coach-layout/coach-layout.module").then(
        (m) => m.CoachLayoutModule
      ),
  },
  {
    path: "",
    redirectTo: "auth/login",
    pathMatch: "full",
  },
  { path: "**", redirectTo: "error/404" },
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule],
})
export class AppRoutingModule {}
