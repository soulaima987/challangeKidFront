import { Injectable } from "@angular/core";
import {
  CanActivate,
  Router,
  ActivatedRouteSnapshot,
  RouterStateSnapshot,
} from "@angular/router";
import { AuthService } from "../auth.service";

@Injectable({
  providedIn: "root",
})
export class AuthGuard implements CanActivate {
  constructor(private authService: AuthService, private router: Router) {}

  canActivate(
    route: ActivatedRouteSnapshot,
    state: RouterStateSnapshot
  ): boolean {
    const authData = this.authService.getAuthFromLocalStorage();
    if (!authData) {
      console.log("No auth data, redirecting to login");
      this.router.navigate(["/auth/login"], {
        queryParams: { returnUrl: state.url },
      });
      return false;
    }

    if (authData && authData.role) {
      if (authData.role.includes("ROLE_ADMIN")) {
        console.log("eeeeeeeeeeeeee");
        // User has admin role, navigate to admin layout
        return true;
      } else if (authData.role.includes("ROLE_COACH")) {
        // User has coach role, navigate to coach layout
        return true;
      }
    }

    this.authService.logout();
    return false;
  }
}
