import { Component } from '@angular/core';
import { RouterOutlet } from '@angular/router';
import { AppHeader } from '../../../widgets/header/ui/app-header/app-header';
import { ToastModule } from 'primeng/toast';
import { MessageService } from 'primeng/api';

@Component({
  selector: 'app-shell-layout',
  standalone: true,
  imports: [AppHeader, RouterOutlet, ToastModule],
  templateUrl: './shell.layout.html',
  styleUrl: './shell.layout.scss',
  providers: [MessageService]
})
export class ShellLayout {}


