import { Component } from '@angular/core';
import { RouterOutlet } from '@angular/router';
import { AppHeader } from '../../../widgets/header/ui/app-header/app-header';

@Component({
  selector: 'app-shell-layout',
  standalone: true,
  imports: [AppHeader, RouterOutlet],
  templateUrl: './shell.layout.html',
  styleUrl: './shell.layout.scss',
})
export class ShellLayout {}


