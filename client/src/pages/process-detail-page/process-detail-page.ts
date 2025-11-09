import { Component, signal } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ActivatedRoute, Router, RouterModule } from '@angular/router';
import { ProgressBarModule } from 'primeng/progressbar';
import { ButtonModule } from 'primeng/button';
import { CardModule } from 'primeng/card';
import { CheckboxModule } from 'primeng/checkbox';
import { TagModule } from 'primeng/tag';

type StepStatus = 'completed' | 'in_progress' | 'waiting' | 'failed';

interface ProcessStep {
  id: number;
  name: string;
  status: StepStatus;
  progress?: { current: number; total: number };
}

interface ProcessDetail {
  id: string;
  databaseName: string;
  overallProgress: number;
  steps: ProcessStep[];
  statistics: {
    recordsProcessed: { current: number; total: number; percentage: number };
    candidatesFound: number;
    checkedInLLM: number;
    speed: number;
  };
  logs: Array<{ time: string; message: string }>;
}

@Component({
  selector: 'app-process-detail-page',
  standalone: true,
  imports: [
    CommonModule,
    RouterModule,
    ProgressBarModule,
    ButtonModule,
    CardModule,
    CheckboxModule,
    TagModule,
  ],
  templateUrl: './process-detail-page.html',
  styleUrl: './process-detail-page.scss',
})
export class ProcessDetailPage {
  protected readonly process = signal<ProcessDetail | null>(null);

  constructor(
    private route: ActivatedRoute,
    private router: Router
  ) {
    const processId = this.route.snapshot.paramMap.get('id');
    if (processId) {
      this.loadProcessDetail(processId);
    }
  }

  private loadProcessDetail(id: string) {
    // Mock data based on the image description
    const decodedId = decodeURIComponent(id);
    const mockProcess: ProcessDetail = {
      id,
      databaseName: decodedId || 'БД_КаталогПродуктов',
      overallProgress: 45,
      steps: [
        {
          id: 1,
          name: 'Загрузка исходных данных',
          status: 'completed',
        },
        {
          id: 2,
          name: 'Векторизация записей',
          status: 'in_progress',
          progress: { current: 235, total: 500 },
        },
        {
          id: 3,
          name: 'Поиск кандидатов-дубликатов',
          status: 'waiting',
        },
        {
          id: 4,
          name: 'LLM - верификация пар',
          status: 'waiting',
        },
        {
          id: 5,
          name: 'Группировка результатов',
          status: 'waiting',
        },
      ],
      statistics: {
        recordsProcessed: { current: 235, total: 500, percentage: 47 },
        candidatesFound: 89,
        checkedInLLM: 0,
        speed: 12,
      },
      logs: [
        { time: '14:32:05', message: 'Загрузка данных завершена (500 записей)' },
        { time: '14:32:10', message: 'Векторизация: "вода мин." → успешно' },
        { time: '14:32:11', message: 'Векторизация: "минеральная вода" → успешно' },
        { time: '14:32:12', message: 'Ошибка: "сок яблчный" → повтор попытки...' },
        { time: '14:32:13', message: 'Векторизация: "сок яблочный" → успешно' },
      ],
    };

    this.process.set(mockProcess);
  }

  protected getStepStatusIcon(status: StepStatus): string {
    switch (status) {
      case 'completed':
        return 'pi-check';
      case 'in_progress':
        return 'pi-spin pi-spinner';
      case 'failed':
        return 'pi-times';
      default:
        return '';
    }
  }

  protected getStepStatusSeverity(status: StepStatus): string {
    switch (status) {
      case 'completed':
        return 'success';
      case 'in_progress':
        return 'info';
      case 'failed':
        return 'danger';
      default:
        return 'secondary';
    }
  }

  protected onPause() {
    console.log('Pause clicked');
    // TODO: Implement pause logic
  }

  protected onRestartStep() {
    console.log('Restart step clicked');
    // TODO: Implement restart step logic
  }

  protected isAllStepsCompleted(): boolean {
    //пока что пусть отображается всегда
    return true;
    // const process = this.process();
    // if (!process) return false;
    // return process.steps.every((step) => step.status === 'completed');
  }

  protected onViewResults() {
    const process = this.process();
    if (!process) return;
    const processId = encodeURIComponent(process.id);
    this.router.navigate(['/processes', processId, 'duplicates']);
  }
}

