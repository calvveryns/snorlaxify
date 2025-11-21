import { Component, signal, ViewChild } from '@angular/core';
import { TableModule } from 'primeng/table';
import { TagModule } from 'primeng/tag';
import { CommonModule, DatePipe } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { Router } from '@angular/router';
import { ButtonModule } from 'primeng/button';
import { TooltipModule } from 'primeng/tooltip';
import { ConfirmDialogModule } from 'primeng/confirmdialog';
import { ConfirmationService, MessageService } from 'primeng/api';
import { CreateProcessDialog, ProcessFormData } from '@features/process';

const statuses = ['new', 'running', 'completed', 'failed'] as const;

@Component({
  selector: 'app-processes-page',
  standalone: true,
  imports: [
    CommonModule,
    FormsModule,
    TableModule,
    TagModule,
    ButtonModule,
    TooltipModule,
    ConfirmDialogModule,
    CreateProcessDialog,
  ],
  providers: [ConfirmationService, MessageService],
  templateUrl: './processes-page.html',
  styleUrl: './processes-page.scss',
})
export class ProcessesPage {
  constructor(
    private router: Router,
    private confirmationService: ConfirmationService
  ) {}

  protected readonly statuses = statuses;

  protected readonly rows = signal<{
    date: string;
    databaseName: string;
    duplicatesFound: number;
    processingTime: string;
    status: typeof statuses[number];
  }[]>([
    {
      date: new Date().toISOString(),
      databaseName: 'customers-db',
      duplicatesFound: 12,
      processingTime: '00:02:14',
      status: 'completed',
    },
    {
      date: new Date(Date.now() - 86400000).toISOString(),
      databaseName: 'orders-db',
      duplicatesFound: 5,
      processingTime: '00:01:03',
      status: 'failed',
    },
    {
      date: new Date(Date.now() - 2 * 86400000).toISOString(),
      databaseName: 'analytics-db',
      duplicatesFound: 0,
      processingTime: '00:05:27',
      status: 'completed',
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

  @ViewChild(CreateProcessDialog) createProcessDialog!: CreateProcessDialog;

  protected onRowClick(row: { date: string; databaseName: string }) {
    // Use databaseName as ID for navigation
    const processId = encodeURIComponent(row.databaseName);
    this.router.navigate(['/processes', processId]);
  }

  protected openCreateDialog() {
    this.createProcessDialog.open();
  }

  protected onSaveProcess(formData: ProcessFormData) {
    // Placeholder: integrate API call here later
    console.log('Create process:', formData);
  }


  protected openEditDialog(row: { date: string; databaseName: string }, event?: Event) {
    if (event) {
      event.stopPropagation();
    }
    // Load process data for editing (mock data for now)
    const processData: ProcessFormData = {
      scheduleMode: 'daily',
      startTime: '12:00',
      selectedWeekdays: [],
      timeZone: 'GMT +5 (Екатеринбург)',
      interval: '4 часа(ов)',
      processNewRecords: 'yes',
      recheckExisting: 'only-changed',
      recordLimit: '10 000',
      autoMerge: false,
      autoMergeThreshold: '0,9',
      email: 'admin@company.com',
      notifications: 'errors-only',
      detailedReport: 'yes',
    };
    this.createProcessDialog.openForEdit(processData, row.databaseName);
  }

  protected deleteProcess(row: { date: string; databaseName: string }, event?: Event) {
    if (event) {
      event.stopPropagation();
    }
    
    this.confirmationService.confirm({
      message: `Вы уверены, что хотите удалить процесс "${row.databaseName}"?`,
      header: 'Подтверждение удаления',
      icon: 'pi pi-exclamation-triangle',
      acceptLabel: 'Удалить',
      rejectLabel: 'Отмена',
      accept: () => {
        // Placeholder: integrate API call here later
        console.log('Delete process:', row.databaseName);
        this.rows.update((currentRows) =>
          currentRows.filter((r) => r.databaseName !== row.databaseName)
        );
      },
    });
  }
}
