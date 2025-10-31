import { Component, inject, signal } from '@angular/core';
import { MenubarModule } from 'primeng/menubar';
import { MenuItem } from 'primeng/api';
import { ButtonModule } from 'primeng/button';
import { PRIME_NG_CONFIG } from 'primeng/config';

@Component({
  selector: 'app-header',
  standalone: true,
  imports: [MenubarModule, ButtonModule],
  templateUrl: './app-header.html',
  styleUrl: './app-header.scss',
})
export class AppHeader {
  isDark = signal(false);

  protected readonly items: MenuItem[] = [
    { label: 'Процессы', routerLink: ['/processes'] },
    { label: 'Подключения', routerLink: ['/connections'] },
  ];

  private readonly html = document.querySelector('html');
  private readonly darkSelector = 'dark';


  constructor() {
    this.isDark.set(!!this.html?.classList.contains(this.darkSelector));
  }

  toggleDarkMode() {
    this.html?.classList.toggle(this.darkSelector);
    this.isDark.set(!this.isDark());
  }
}


