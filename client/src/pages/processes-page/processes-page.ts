import { Component, signal } from '@angular/core';
import { TableModule } from 'primeng/table';
import { TagModule } from 'primeng/tag';
import { CommonModule, DatePipe } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { Router } from '@angular/router';

const statuses = ['new', 'running', 'completed', 'failed'] as const;

@Component({
  selector: 'app-processes-page',
  standalone: true,
  imports: [CommonModule, FormsModule, TableModule, TagModule],
  templateUrl: './processes-page.html',
  styleUrl: './processes-page.scss',
})
export class ProcessesPage {
  constructor(private router: Router) {}

  protected readonly statuses = statuses;
  protected readonly actionOptions = [
    { label: 'Open', value: 'open' },
    { label: 'Retry', value: 'retry' },
    { label: 'Cancel', value: 'cancel' },
  ];

  protected readonly rows = signal<{
    date: string;
    databaseName: string;
    duplicatesFound: number;
    processingTime: string;
    status: typeof statuses[number];
    action?: string | null;
  }[]>([
    {
      date: new Date().toISOString(),
      databaseName: 'customers-db',
      duplicatesFound: 12,
      processingTime: '00:02:14',
      status: 'completed',
      action: null,
    },
    {
      date: new Date(Date.now() - 86400000).toISOString(),
      databaseName: 'orders-db',
      duplicatesFound: 5,
      processingTime: '00:01:03',
      status: 'failed',
      action: null,
    },
    {
      date: new Date(Date.now() - 2 * 86400000).toISOString(),
      databaseName: 'analytics-db',
      duplicatesFound: 0,
      processingTime: '00:05:27',
      status: 'completed',
      action: null,
    },
  ]);

  protected getSeverity(status: typeof this.statuses[number]) {
    switch (status) {
      case 'completed':
        return 'success';
      case 'failed':
        return 'danger';
      case 'running':
        return 'info';
      default:
        return 'warn';
    }
  }

  protected onRowClick(row: { date: string; databaseName: string }) {
    // Use databaseName as ID for navigation
    const processId = encodeURIComponent(row.databaseName);
    this.router.navigate(['/processes', processId]);
  }
}
