export class AuthModel {
  authToken: string;
  refreshToken: string;
  expiresIn: Date;
  role: string;

  setAuth(auth: AuthModel) {
    this.authToken = auth.authToken;
    this.refreshToken = auth.refreshToken;
    this.expiresIn = auth.expiresIn;
    this.role = auth.role;
  }
}
