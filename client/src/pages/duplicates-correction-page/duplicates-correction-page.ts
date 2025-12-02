import { Component, computed, DestroyRef, inject, linkedSignal, signal } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ActivatedRoute, Router, RouterModule } from '@angular/router';
import { FormControl, FormsModule, ReactiveFormsModule } from '@angular/forms';
import { TableModule } from 'primeng/table';
import { ButtonModule } from 'primeng/button';
import { CardModule } from 'primeng/card';
import { CheckboxModule } from 'primeng/checkbox';
import { InputTextModule } from 'primeng/inputtext';
import { TooltipModule } from 'primeng/tooltip';
import { ProcessService } from '../../shared/process.service';
import { takeUntilDestroyed, toSignal } from '@angular/core/rxjs-interop';
import { BehaviorSubject, tap, debounceTime, switchMap, map, take } from 'rxjs';
import { MessageService } from 'primeng/api';

@Component({
  selector: 'app-duplicates-correction-page',
  standalone: true,
  imports: [
    CommonModule,
    FormsModule,
    RouterModule,
    TableModule,
    ButtonModule,
    CardModule,
    CheckboxModule,
    InputTextModule,
    TooltipModule,
    ReactiveFormsModule,
  ],
  templateUrl: './duplicates-correction-page.html',
  styleUrl: './duplicates-correction-page.scss',
  providers: [ProcessService],
})
export class DuplicatesCorrectionPage {
  protected readonly databaseName = signal<string>('');

  processService = inject(ProcessService);
  messageService = inject(MessageService);
  router = inject(Router);
  route = inject(ActivatedRoute);
  destroyRef = inject(DestroyRef);

  update$ = new BehaviorSubject<void>(void 0);
  loading = signal(false);
  uuid = this.route.snapshot.paramMap.get('id')!;

  protected readonly duplicates = toSignal(
    this.update$.pipe(
      tap(() => this.loading.set(true)),
      debounceTime(300),
      switchMap(() => this.processService.getProcess(this.uuid)),
      tap(() => this.loading.set(false)),
      map(process => process.recommendations.results),
    ),
    { initialValue: [] }
  )

  checks = linkedSignal(() => {
    return this.duplicates().map(() => false);
  });

  saveBtnEnabled = computed(() => {
    return this.checks().some(checked => !!checked);
  });

  suggestedNames = linkedSignal(() => {
    return this.duplicates().map((dup) => ({
      editing: false,
      value: dup.suggested_name
    }));
  });

  protected onSelect() {
    console.log('Select clicked');
    // TODO: Implement select logic
  }

  onChangeCheckbox(index: number) {
    const currentControls = this.checks();
    currentControls[index] = !currentControls[index];
    this.checks.set([...currentControls]);
  }

  onEditSuggestedName(index: number) {
    const currentNames = this.suggestedNames();
    currentNames[index].editing = true;
    currentNames.forEach((name, i) => {
      if (i !== index) {
        name.editing = false;
      }
    });
    this.suggestedNames.set(currentNames);
  }

  onSaveSuggestedName(index: number, newName: string) {
    const currentNames = this.suggestedNames();
    currentNames[index].editing = false;
    currentNames[index].value = newName;
    
    this.suggestedNames.set(currentNames);
  }

  protected onMerge() {
    console.log('Merge clicked');
    // TODO: Implement merge logic
  }

  protected onSplit() {
    console.log('Split clicked');
    // TODO: Implement split logic
  }

  protected onSaveChanges() {
    console.log('Save changes clicked');
    // TODO: Implement save logic
  }

  protected onCancel() {
    this.router.navigate(['/processes', this.uuid]);
  }

  protected onSave() {
    const request = this.duplicates()
      .map((dup, index) => ({
        ...dup,
        suggested_name: this.suggestedNames()[index].value,
      }))
      .filter((_, index) => this.checks()[index]);

    this.processService.acceptRecommendations(this.uuid, request)
    .pipe(
      takeUntilDestroyed(this.destroyRef),
    )
    .subscribe(() => {
      this.messageService.add({severity:'success', summary: 'Готово!', detail: 'Дубликаты успешно исправлены'});
      this.router.navigate(['/processes', this.uuid]);
    });
  }
}

