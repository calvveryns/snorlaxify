import { Component, signal } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ActivatedRoute, Router, RouterModule } from '@angular/router';
import { FormsModule } from '@angular/forms';
import { TableModule } from 'primeng/table';
import { ButtonModule } from 'primeng/button';
import { CardModule } from 'primeng/card';
import { CheckboxModule } from 'primeng/checkbox';
import { InputTextModule } from 'primeng/inputtext';
import { TooltipModule } from 'primeng/tooltip';

interface DuplicateRecord {
  id: number;
  article: string;
  shelfLife: string;
  price: number;
  supplier: string;
  category: string;
}

interface DuplicateGroup {
  id: number;
  name: string;
  checked: boolean;
  proposedName: string;
  duplicatesCount: number;
  finalString: DuplicateRecord;
  duplicates: DuplicateRecord[];
}

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
})
export class DuplicatesCorrectionPage {
  protected readonly databaseName = signal<string>('');
  protected readonly duplicateGroups = signal<DuplicateGroup[]>([]);
  protected readonly selectedGroup = signal<DuplicateGroup | null>(null);

  constructor(
    private route: ActivatedRoute,
    private router: Router
  ) {
    const processId = this.route.snapshot.paramMap.get('id');
    if (processId) {
      const decodedId = decodeURIComponent(processId);
      this.databaseName.set(decodedId || 'БД_КаталогПродуктов');
      this.loadDuplicateGroups();
    }
  }

  private loadDuplicateGroups() {
    // Mock data based on the image description
    const mockGroups: DuplicateGroup[] = [
      {
        id: 1,
        name: 'Группа 1: Минеральная вода',
        checked: true,
        proposedName: 'Минеральная вода',
        duplicatesCount: 4,
        finalString: {
          id: 1,
          article: 'BORJ-05',
          shelfLife: '24 месяца',
          price: 89.5,
          supplier: 'Georgia Trade, ИмпортТрейд',
          category: 'Минеральная вода',
        },
        duplicates: [
          {
            id: 276,
            article: 'BORJ-05',
            shelfLife: '24 месяца',
            price: 89.5,
            supplier: 'ИмпортТрейд',
            category: 'Воды минеральные',
          },
          {
            id: 398,
            article: 'BORJ',
            shelfLife: '24 м',
            price: 89.5,
            supplier: 'Georgia Trade',
            category: 'Вода питьевая',
          },
          {
            id: 401,
            article: 'Borjomi',
            shelfLife: '24 мес',
            price: 89.5,
            supplier: 'ИмпортТрейд',
            category: 'Лечебные воды',
          },
          {
            id: 567,
            article: 'BORJ-0505',
            shelfLife: '24 мес.',
            price: 89.5,
            supplier: 'Georgia Trade',
            category: 'Минеральные воды',
          },
        ],
      },
      {
        id: 2,
        name: 'Группа 2: Печенье',
        checked: false,
        proposedName: 'Печенье',
        duplicatesCount: 3,
        finalString: {
          id: 1,
          article: 'COOK-01',
          shelfLife: '12 месяцев',
          price: 45.0,
          supplier: 'Кондитерская фабрика',
          category: 'Печенье',
        },
        duplicates: [],
      },
      {
        id: 3,
        name: 'Группа 3: Молоко безлактозное',
        checked: false,
        proposedName: 'Молоко безлактозное',
        duplicatesCount: 2,
        finalString: {
          id: 1,
          article: 'MILK-LF-01',
          shelfLife: '7 дней',
          price: 120.0,
          supplier: 'Молочный комбинат',
          category: 'Молоко безлактозное',
        },
        duplicates: [],
      },
    ];

    this.duplicateGroups.set(mockGroups);
    this.selectedGroup.set(mockGroups[0]);
  }

  protected onGroupSelect(group: DuplicateGroup) {
    this.selectedGroup.set(group);
  }

  protected onGroupCheck(group: DuplicateGroup, checked: boolean) {
    this.duplicateGroups.update((groups) =>
      groups.map((g) => (g.id === group.id ? { ...g, checked } : g))
    );
  }

  protected onSelect() {
    console.log('Select clicked');
    // TODO: Implement select logic
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
    this.router.navigate(['/processes']);
  }

  protected onSave() {
    console.log('Save clicked');
    // TODO: Implement save logic
  }
}

