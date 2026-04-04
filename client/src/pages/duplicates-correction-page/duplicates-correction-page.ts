import { CommonModule } from '@angular/common';
import { HttpErrorResponse } from '@angular/common/http';
import { Component, computed, inject, signal } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { ActivatedRoute, Router, RouterModule } from '@angular/router';
import { ButtonModule } from 'primeng/button';
import { CardModule } from 'primeng/card';
import { CheckboxModule } from 'primeng/checkbox';
import { InputTextModule } from 'primeng/inputtext';
import { TableModule } from 'primeng/table';
import { TooltipModule } from 'primeng/tooltip';
import {
  DuplicateLikelihood,
  DuplicateRecommendation,
  ProcessService,
  ResolvePairPayload,
} from '../../shared/process.service';

type DecisionAction = 'merge' | 'ignore';

type DuplicateGroupItem = {
  itemId: number;
  title: string;
  distance: number;
  isAnchor: boolean;
  selected: boolean;
};

type DuplicateGroup = {
  id: number;
  anchorItemId: number;
  name: string;
  checked: boolean;
  items: DuplicateGroupItem[];
  duplicateLikelihood: DuplicateLikelihood;
  anchorTitle: string;
  duplicatesCount: number;
  maxDistance: number;
  proposedName: string;
  editedName: string;
  action: DecisionAction;
};

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
  ],
  templateUrl: './duplicates-correction-page.html',
  styleUrl: './duplicates-correction-page.scss',
  providers: [ProcessService],
})
export class DuplicatesCorrectionPage {
  private readonly route = inject(ActivatedRoute);
  private readonly router = inject(Router);
  private readonly processService = inject(ProcessService);

  protected readonly taskId = signal<string>('');
  protected readonly duplicateGroups = signal<DuplicateGroup[]>([]);
  protected readonly selectedGroupId = signal<number | null>(null);
  protected readonly loading = signal(true);
  protected readonly loadError = signal<string | null>(null);
  protected readonly saveError = signal<string | null>(null);
  protected readonly successMessage = signal<string | null>(null);
  protected readonly isSaving = signal(false);

  protected readonly selectedGroup = computed(() => {
    const selectedGroupId = this.selectedGroupId();
    return this.duplicateGroups().find((group) => group.id === selectedGroupId) ?? null;
  });

  protected readonly reviewedCount = computed(
    () => this.duplicateGroups().filter((group) => group.checked).length
  );

  constructor() {
    const taskId = this.route.snapshot.paramMap.get('id');
    if (!taskId) {
      this.loading.set(false);
      this.loadError.set('Не удалось определить task_id процесса.');
      return;
    }

    this.taskId.set(decodeURIComponent(taskId));
    this.loadDuplicateGroups();
  }

  private loadDuplicateGroups() {
    this.loading.set(true);
    this.loadError.set(null);

    this.processService.getProcessResult(this.taskId()).subscribe({
      next: (response) => {
        const groups = response.recommendations.results.map((item, index) =>
          this.mapRecommendationToGroup(item, index)
        );

        this.duplicateGroups.set(groups);
        this.selectedGroupId.set(groups[0]?.id ?? null);
        this.loading.set(false);
      },
      error: (error: HttpErrorResponse) => {
        this.loadError.set(error.error?.detail ?? 'Не удалось загрузить рекомендации.');
        this.loading.set(false);
      },
    });
  }

  private mapRecommendationToGroup(item: DuplicateRecommendation, index: number): DuplicateGroup {
    const action: DecisionAction = item.duplicate_likelihood === 'low' ? 'ignore' : 'merge';
    const items = item.items.map((groupItem) => ({
      itemId: groupItem.item_id,
      title: groupItem.title,
      distance: groupItem.distance,
      isAnchor: groupItem.is_anchor,
      selected: groupItem.is_anchor ? true : action === 'merge',
    }));
    const anchorItem = items.find((groupItem) => groupItem.isAnchor) ?? items[0];
    const proposedName = item.suggested_name?.trim() || anchorItem?.title || `Группа ${index + 1}`;

    return {
      id: index + 1,
      anchorItemId: item.anchor_item_id,
      name: `Группа ${index + 1}`,
      checked: false,
      items,
      duplicateLikelihood: item.duplicate_likelihood,
      anchorTitle: anchorItem?.title || proposedName,
      duplicatesCount: Math.max(items.length - 1, 0),
      maxDistance: items.reduce(
        (currentMax, groupItem) => Math.max(currentMax, groupItem.distance),
        0
      ),
      proposedName,
      editedName: proposedName,
      action,
    };
  }

  protected onGroupSelect(group: DuplicateGroup) {
    this.selectedGroupId.set(group.id);
  }

  protected onGroupCheck(group: DuplicateGroup, checked: boolean) {
    this.updateGroup(group.id, { checked });
  }

  protected onMerge(group: DuplicateGroup) {
    this.updateGroup(group.id, {
      action: 'merge',
      checked: true,
    });
  }

  protected onIgnore(group: DuplicateGroup) {
    this.updateGroup(group.id, {
      action: 'ignore',
      checked: true,
    });
  }

  protected onSuggestedNameChange(group: DuplicateGroup, value: string) {
    this.updateGroup(group.id, {
      editedName: value,
      checked: true,
    });
  }

  protected onItemSelectionChange(group: DuplicateGroup, itemId: number, selected: boolean) {
    this.updateGroup(group.id, {
      items: group.items.map((item) =>
        item.itemId === itemId && !item.isAnchor ? { ...item, selected } : item
      ),
      checked: true,
      action: 'merge',
    });
  }

  protected onSaveChanges() {
    this.onSave();
  }

  protected onCancel() {
    this.router.navigate(['/processes', this.taskId()]);
  }

  protected onSave() {
    const payload = this.buildResolvePayload();
    if (!payload.length) {
      this.saveError.set('Выберите хотя бы одну группу и отметьте решение как проверенное.');
      this.successMessage.set(null);
      return;
    }

    this.isSaving.set(true);
    this.saveError.set(null);
    this.successMessage.set(null);

    this.processService.resolveProcess(this.taskId(), payload).subscribe({
      next: (response) => {
        this.successMessage.set(response.message);
        this.isSaving.set(false);
      },
      error: (error: HttpErrorResponse) => {
        this.saveError.set(error.error?.detail ?? 'Не удалось применить выбранные решения.');
        this.isSaving.set(false);
      },
    });
  }

  protected getLikelihoodLabel(likelihood: DuplicateLikelihood) {
    switch (likelihood) {
      case 'high':
        return 'Высокая';
      case 'medium':
        return 'Средняя';
      default:
        return 'Низкая';
    }
  }

  protected getActionLabel(action: DecisionAction) {
    return action === 'merge' ? 'Объединить' : 'Игнорировать';
  }

  protected getSelectedDuplicatesCount(group: DuplicateGroup) {
    return group.items.filter((item) => !item.isAnchor && item.selected).length;
  }

  protected getIgnoredDuplicatesCount(group: DuplicateGroup) {
    return group.items.filter((item) => !item.isAnchor && !item.selected).length;
  }

  private updateGroup(id: number, patch: Partial<DuplicateGroup>) {
    this.duplicateGroups.update((groups) =>
      groups.map((group) => (group.id === id ? { ...group, ...patch } : group))
    );
  }

  private buildResolvePayload(): ResolvePairPayload[] {
    return this.duplicateGroups().flatMap((group) => {
      if (!group.checked) {
        return [];
      }

      if (!group.items.some((item) => item.isAnchor)) {
        return [];
      }

      const selectedItems = group.items.filter((item) => item.isAnchor || item.selected);
      const ignoredItems = group.items.filter((item) => item.isAnchor || !item.selected);
      const payload: ResolvePairPayload[] = [];

      if (group.action === 'ignore') {
        if (group.items.length < 2) {
          return [];
        }

        payload.push({
          anchor_item_id: group.anchorItemId,
          items: group.items.map((item) => ({
            item_id: item.itemId,
            title: item.title,
          })),
          action: 'ignore',
          suggested_name: null,
        });
        return payload;
      }

      if (selectedItems.length >= 2) {
        payload.push({
          anchor_item_id: group.anchorItemId,
          items: selectedItems.map((item) => ({
            item_id: item.itemId,
            title: item.title,
          })),
          action: 'merge',
          suggested_name: group.editedName.trim() || group.proposedName,
        });
      }

      if (ignoredItems.length >= 2 && this.getIgnoredDuplicatesCount(group) > 0) {
        payload.push({
          anchor_item_id: group.anchorItemId,
          items: ignoredItems.map((item) => ({
            item_id: item.itemId,
            title: item.title,
          })),
          action: 'ignore',
          suggested_name: null,
        });
      }

      return payload;
    });
  }
}
