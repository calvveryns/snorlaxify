import { Component } from '@angular/core';
import { ButtonModule } from 'primeng/button';
import { LoginForm } from "@features/login";

@Component({
  selector: 'app-login-page',
  imports: [ButtonModule, LoginForm],
  templateUrl: './login-page.html',
  styleUrl: './login-page.scss',
})
export class LoginPage {

}
