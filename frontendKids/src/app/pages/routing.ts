import { Routes } from "@angular/router";
import { AuthGuard } from "../modules/auth/services/auth-http/auth.guard";

const Routing: Routes = [
  {
    path: "builder",
    loadChildren: () =>
      import("./builder/builder.module").then((m) => m.BuilderModule),
  },
  {
    path: "admindashboard/pages/profile",
    loadChildren: () =>
      import("../modules/profile/profile.module").then((m) => m.ProfileModule),
  },
  {
    path: "admindashboard/account",
    loadChildren: () =>
      import("../modules/account/account.module").then((m) => m.AccountModule),
  },
  {
    path: "admindashboard/pages/wizards",
    loadChildren: () =>
      import("../modules/wizards/wizards.module").then((m) => m.WizardsModule),
  },
  {
    path: "widgets",
    loadChildren: () =>
      import("../modules/widgets-examples/widgets-examples.module").then(
        (m) => m.WidgetsExamplesModule
      ),
  },
  {
    path: "apps/chat",
    loadChildren: () =>
      import("../modules/apps/chat/chat.module").then((m) => m.ChatModule),
  },
  {
    path: "",
    redirectTo: "admin",
    pathMatch: "full",
  },
  {
    path: "**",
    redirectTo: "error/404",
  },
];

export { Routing };
