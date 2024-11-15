import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { environment } from 'src/environments/environment';
const API_USERS_URL = `${environment.backednUrl}`;
@Injectable({
    providedIn: 'root'
})
export class ChallengeService {
    private apiUrl = API_USERS_URL + '/api/challenge'; // Adjust this URL based on your API endpoint
  
    constructor(private http: HttpClient) {}
  
    getChallenges(){
      return this.http.get<any[]>(this.apiUrl);
    }

    deleteChallenge(id: number): Observable<void> {
        return this.http.delete<void>(`${API_USERS_URL + '/api/challenge/delete'}/${id}`);
    }

    getChallengeById(challengeId: number): Observable<any> {
        return this.http.get<any>(`${this.apiUrl}/${challengeId}`);
    }
}
  