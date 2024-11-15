import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { environment } from 'src/environments/environment';
const API_USERS_URL = `${environment.backednUrl}`;


@Injectable({
  providedIn: 'root'
})
export class CoachService {
  private apiUrl = '/api/coach'; // Adjust this URL based on your API endpoint

  constructor(private http: HttpClient) {}

  getCoaches(){
    return this.http.get(API_USERS_URL + '/api/coach');
  }
  
  deleteCoach(id: number): Observable<void> {
    return this.http.delete<void>(`${API_USERS_URL + '/api/coach/delete'}/${id}`);
  }
  
  updateCoach(coach): Observable<void> {
    return this.http.put<void>(`${API_USERS_URL}/api/coach/${coach.id}/edit`, coach);
  }

  getPendingCoaches(){
    return this.http.get(`${API_USERS_URL}/api/coach/pending`);
  }

  getAcceptedCoaches() {
    return this.http.get(`${API_USERS_URL}/api/coach/accepted`);
  }

  getRefusedCoaches(){
    return this.http.get(`${API_USERS_URL}/api/coach/refused`);
  }

  updateCoachStatus(id: number, accepted: boolean){
    return this.http.post(`${API_USERS_URL}/api/coach/${id}/status`, { accepted });
  }
}
