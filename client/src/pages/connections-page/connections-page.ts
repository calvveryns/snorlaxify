import { Component, signal } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { TableModule } from 'primeng/table';
import { DialogModule } from 'primeng/dialog';
import { InputTextModule } from 'primeng/inputtext';
import { ButtonModule } from 'primeng/button';

@Component({
  selector: 'app-connections-page',
  standalone: true,
  imports: [CommonModule, FormsModule, TableModule, DialogModule, InputTextModule, ButtonModule],
  templateUrl: './connections-page.html',
  styleUrl: './connections-page.scss',
})
export class ConnectionsPage {
  protected readonly rows = signal<Array<{
    databaseName: string;
    host: string;
    port: number;
  }>>([
    { databaseName: 'customers-db', host: 'db01.internal', port: 5432 },
    { databaseName: 'orders-db', host: 'db02.internal', port: 5432 },
    { databaseName: 'analytics-db', host: 'analytics.internal', port: 3306 },
  ]);

  protected showCreateDialog: boolean = false;
  protected connectionString: string = '';
  protected connectionName: string = '';

  protected openCreateDialog() {
    this.connectionName = '';
    this.connectionString = '';
    this.showCreateDialog = true;
  }

  protected closeCreateDialog() {
    this.showCreateDialog = false;
  }

  protected checkConnection() {
    // Placeholder: integrate API call here later
    // eslint-disable-next-line no-console
    console.log('Check connection for:', this.connectionString);
  }

  protected createConnection() {
    // Placeholder: integrate API call here later
    // eslint-disable-next-line no-console
    console.log('Create connection:', {
      name: this.connectionName,
      connectionString: this.connectionString,
    });
  }
}


