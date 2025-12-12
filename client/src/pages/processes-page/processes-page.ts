import { Component, DestroyRef, inject, signal, ViewChild } from '@angular/core';
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
import { ProcessesResponse, ProcessService } from '../../shared/process.service';
import { takeUntilDestroyed, toSignal } from '@angular/core/rxjs-interop';
import { HttpClient } from '@angular/common/http';
import { BehaviorSubject, debounce, debounceTime, switchMap, take, tap } from 'rxjs';

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

  providers: [ConfirmationService, MessageService, ProcessService,],
  templateUrl: './processes-page.html',
  styleUrl: './processes-page.scss',
})
export class ProcessesPage {

  private readonly processService = inject(ProcessService);
  private router = inject(Router);
  private destroyRef = inject(DestroyRef);
  private confirmationService = inject(ConfirmationService);

  protected readonly statuses = statuses;

  update$ = new BehaviorSubject<void>(void 0);
  loading = signal(false);

  protected readonly rows = toSignal(
    this.update$.pipe(
      tap(() => this.loading.set(true)),
      debounceTime(300),
      switchMap(() => this.processService.getProcesses()),
      tap(() => this.loading.set(false)),
    ),
  )

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

  protected onRowClick(uuid: string) {
    this.router.navigate(['/processes', uuid]);
  }

  protected openCreateDialog() {
    this.createProcessDialog.open();
  }

  protected onSaveProcess(formData: ProcessFormData) {
    this.processService.startProcess().pipe(
      take(1),
      takeUntilDestroyed(this.destroyRef),
    ).subscribe(() => this.update$.next());
  }


  protected openEditDialog(row: { date: string; databaseName: string }, event?: Event) {
    if (event) {
      event.stopPropagation();
    }
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

  protected deleteProcess(uuid: string, event?: Event) {
    if (event) {
      event.stopPropagation();
    }
    
    this.confirmationService.confirm({
      message: `Вы уверены, что хотите удалить процесс "${uuid}"?`,
      header: 'Подтверждение удаления',
      icon: 'pi pi-exclamation-triangle',
      acceptLabel: 'Удалить',
      rejectLabel: 'Отмена',
      accept: () => {
        this.processService.deleteProcess(uuid).pipe(
          take(1),
          takeUntilDestroyed(this.destroyRef),
        ).subscribe(() => {
          this.update$.next();
        });
      },
    });
  }
}
