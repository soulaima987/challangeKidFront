import { Injectable } from "@angular/core";
import { environment } from "src/environments/environment";
import { HttpClient, HttpHeaders } from "@angular/common/http";
import { AuthService } from "./auth.service";
@Injectable({
  providedIn: "root",
})
export class HttpserviceService {
  constructor(private http: HttpClient, private authservice: AuthService) {}

  get(endPoint: string) {
    const auth = this.authservice.getAuthFromLocalStorage();
    const httpHeaders = new HttpHeaders({
      Authorization: `Bearer ${auth?.authToken}`,
    });
    const params = { headers: httpHeaders };
    return this.http.get(`${environment.backednUrl}${endPoint}`, params);
  }

  post(endPoint: string, body: object) {
    const auth = this.authservice.getAuthFromLocalStorage();
    const httpHeaders = new HttpHeaders({
      Authorization: `Bearer ${auth?.authToken}`,
    });
    const params = { headers: httpHeaders };
    return this.http.post(`${environment.backednUrl}${endPoint}`, body, params);
  }
  
  delete(endPoint: string) {
    return this.http.delete(`${environment.backednUrl}${endPoint}`);
  }
  put(endPoint: string, body: object) {
    const auth = this.authservice.getAuthFromLocalStorage();
    const httpHeaders = new HttpHeaders({
      Authorization: `Bearer ${auth?.authToken}`,
    });
    const params = { headers: httpHeaders };
    return this.http.put(`${environment.backednUrl}${endPoint}`, body, params);
  }
}
