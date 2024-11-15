import { Injectable } from "@angular/core";
import { map, Observable, of, switchMap } from "rxjs";
import { HttpClient, HttpHeaders } from "@angular/common/http";
import { UserModel } from "../../models/user.model";
import { environment } from "../../../../../environments/environment";
import { AuthModel } from "../../models/auth.model";
import { consumerAfterComputation } from "@angular/core/primitives/signals";

const API_USERS_URL = `${environment.backednUrl}/api`;

@Injectable({
  providedIn: "root",
})
export class AuthHTTPService {
  user: UserModel;
  constructor(private http: HttpClient) {}

  // public methods
  login(email: string, password: string): Observable<AuthModel> {
    return this.http
      .post<{ token: string; refresh_token: string }>(
        `${API_USERS_URL}/login_check`,
        { email, password },
        { headers: new HttpHeaders({ "Content-Type": "application/json" }) }
      )
      .pipe(
        switchMap((response) => {
          const authModel = new AuthModel();
          authModel.authToken = response.token;
          authModel.refreshToken = response.refresh_token;
          authModel.role = this.getUserRole(authModel.authToken);
  
          if (authModel.role === 'ROLE_COACH') {
            // Fetch coach details using the token
            return this.http.get<{ accepted: boolean }>(
              `${API_USERS_URL}/coach/user/details`,
              { headers: new HttpHeaders({ "Authorization": `Bearer ${authModel.authToken}` }) }
            ).pipe(
              map((coachData) => {
                if (coachData.accepted) {
                  return authModel;
                } else {
                  throw new Error('Coach not accepted');
                }
              })
            );
          } else {
            return of(authModel);
          }
        })
      );
  }
  
  

  // CREATE =>  POST: add a new user to the server
  createUser(user: UserModel) {
    const newUser = {
      fullName: user.fullName,
      email: user.email,
      plainPassword: user.password,
      confirmPassword: user.password,
      _token: "string",
    };
    console.log("we we");
    return this.http.post<any>(
      `${API_USERS_URL}/coach/register`,
      JSON.stringify(newUser)
    );
  }

  // Your server should check email => If email exists send link to the user and return true | If email doesn't exist return false
  forgotPassword(email: string): Observable<boolean> {
    return this.http.post<boolean>(`${API_USERS_URL}/forgot-password`, {
      email,
    });
  }

  getUserByToken(token: string): Observable<UserModel> {
    const httpHeaders = new HttpHeaders({
      Authorization: `Bearer ${token}`,
    });
    return this.http.get<UserModel>(`${API_USERS_URL}/profile`, {
      headers: httpHeaders,
    });
  }

  private getUser(token: string): UserModel {
    return JSON.parse(atob(token.split(".")[1])) as UserModel;
  }

  private getUserRole(token: string): string {
    const decodedToken = JSON.parse(atob(token.split(".")[1]));
    return decodedToken.roles[0]; // Assuming the role is in the 'roles' array
  }
}
