import { Component, computed, inject, signal } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ActivatedRoute, Router, RouterModule } from '@angular/router';
import { ProgressBarModule } from 'primeng/progressbar';
import { ButtonModule } from 'primeng/button';
import { CardModule } from 'primeng/card';
import { CheckboxModule } from 'primeng/checkbox';
import { TagModule } from 'primeng/tag';
import { BehaviorSubject, debounceTime, EMPTY, interval, map, of, Subject, switchMap, takeUntil, tap, timer } from 'rxjs';
import { toSignal } from '@angular/core/rxjs-interop';
import { ProcessService } from '../../shared/process.service';

type StepStatus = 'completed' | 'in_progress' | 'waiting' | 'failed';
const getStatusFor = (step: number, currentStep: number) => {
  if (currentStep < step) {
    return 'waiting';
  }

  if (currentStep === step) {
    return 'in_progress'
  }

  return 'completed';
};

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
  providers: [ProcessService]
})
export class ProcessDetailPage {
  private route = inject(ActivatedRoute);
  private router = inject(Router);
  private processService = inject(ProcessService);


  stop$ = new Subject<void>();
  update$ = timer(0, 2000).pipe(
    takeUntil(this.stop$),
  );

  loading = signal(false);

  steps = computed(() => {
    const currentStep = this.process()?.current_step || 0;

    return [
      {
        id: 1,
        name: 'Настройка исходной базы данных',
        status: getStatusFor(0, currentStep),
      },
      {
        id: 2,
        name: 'Векторизация идентификаторов',
        status: getStatusFor(1, currentStep),
        // progress: { current: 235, total: 500 },
      },
      {
        id: 3,
        name: 'Внесение изменений',
        status: getStatusFor(2, currentStep),
      },
      {
        id: 4,
        name: 'Поиск близких пар',
        status: getStatusFor(3, currentStep),
      },
      {
        id: 5,
        name: 'Запрос рекомендаций',
        status: getStatusFor(4, currentStep),
      }
    ];
  })

  protected readonly process = toSignal(
    this.update$.pipe(
      tap(() => this.loading.set(true)),
      debounceTime(300),
      switchMap(() => this.processService.getProcess(this.route.snapshot.paramMap.get('id')!)),
      tap(() => this.loading.set(false)),
      tap(process => {
        if (process.total_steps === process.current_step) {
          this.stop$.next();
        }
      })
    ),
  )

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
    const processId = encodeURIComponent(process.task_id!);
    this.router.navigate(['/processes', processId, 'duplicates']);
  }
}

