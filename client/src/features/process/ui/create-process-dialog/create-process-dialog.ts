import { Component, EventEmitter, Output } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { DrawerModule } from 'primeng/drawer';
import { ButtonModule } from 'primeng/button';
import { InputTextModule } from 'primeng/inputtext';
import { RadioButtonModule } from 'primeng/radiobutton';
import { SelectModule } from 'primeng/select';
import { CheckboxModule } from 'primeng/checkbox';

@Component({
  selector: 'app-create-process-dialog',
  standalone: true,
  imports: [
    CommonModule,
    FormsModule,
    DrawerModule,
    ButtonModule,
    InputTextModule,
    RadioButtonModule,
    SelectModule,
    CheckboxModule,
  ],
  templateUrl: './create-process-dialog.html',
  styleUrl: './create-process-dialog.scss',
})
export class CreateProcessDialog {
  @Output() create = new EventEmitter<ProcessFormData>();
  @Output() close = new EventEmitter<void>();

  protected visible: boolean = false;
  protected isEditMode: boolean = false;
  protected editProcessId: string | null = null;

  // Form data
  protected scheduleMode: 'daily' | 'weekdays' | 'interval' = 'daily';
  protected startTime: string = '12:00';
  protected selectedWeekdays: string[] = [];
  protected timeZone: string = 'GMT +5 (Екатеринбург)';
  protected interval: string = '4 часа(ов)';

  protected processNewRecords: 'yes' | 'no' = 'yes';
  protected recheckExisting: 'only-changed' | 'no' = 'only-changed';
  protected recordLimit: string = '10 000';
  protected autoMerge: boolean = false;
  protected autoMergeThreshold: string = '0,9';

  protected email: string = 'admin@company.com';
  protected notifications: 'errors-only' | 'always' = 'errors-only';
  protected detailedReport: 'yes' | 'no' = 'yes';

  // Dropdown options
  protected weekdayOptions = [
    { label: 'Понедельник', value: 'monday' },
    { label: 'Вторник', value: 'tuesday' },
    { label: 'Среда', value: 'wednesday' },
    { label: 'Четверг', value: 'thursday' },
    { label: 'Пятница', value: 'friday' },
    { label: 'Суббота', value: 'saturday' },
    { label: 'Воскресенье', value: 'sunday' },
  ];

  protected timeZoneOptions = [
    { label: 'GMT +3 (Москва)', value: 'GMT +3 (Москва)' },
    { label: 'GMT +4 (Самара)', value: 'GMT +4 (Самара)' },
    { label: 'GMT +5 (Екатеринбург)', value: 'GMT +5 (Екатеринбург)' },
    { label: 'GMT +6 (Омск)', value: 'GMT +6 (Омск)' },
    { label: 'GMT +7 (Красноярск)', value: 'GMT +7 (Красноярск)' },
    { label: 'GMT +8 (Иркутск)', value: 'GMT +8 (Иркутск)' },
    { label: 'GMT +9 (Якутск)', value: 'GMT +9 (Якутск)' },
    { label: 'GMT +10 (Владивосток)', value: 'GMT +10 (Владивосток)' },
  ];

  open() {
    this.isEditMode = false;
    this.editProcessId = null;
    this.resetForm();
    this.visible = true;
  }

  openForEdit(processData: ProcessFormData, processId: string) {
    this.isEditMode = true;
    this.editProcessId = processId;
    this.loadFormData(processData);
    this.visible = true;
  }

  private resetForm() {
    this.scheduleMode = 'daily';
    this.startTime = '12:00';
    this.selectedWeekdays = [];
    this.timeZone = 'GMT +5 (Екатеринбург)';
    this.interval = '4 часа(ов)';
    this.processNewRecords = 'yes';
    this.recheckExisting = 'only-changed';
    this.recordLimit = '10 000';
    this.autoMerge = false;
    this.autoMergeThreshold = '0,9';
    this.email = 'admin@company.com';
    this.notifications = 'errors-only';
    this.detailedReport = 'yes';
  }

  private loadFormData(data: ProcessFormData) {
    this.scheduleMode = data.scheduleMode;
    this.startTime = data.startTime;
    this.selectedWeekdays = data.selectedWeekdays;
    this.timeZone = data.timeZone;
    this.interval = data.interval;
    this.processNewRecords = data.processNewRecords;
    this.recheckExisting = data.recheckExisting;
    this.recordLimit = data.recordLimit;
    this.autoMerge = data.autoMerge;
    this.autoMergeThreshold = data.autoMergeThreshold;
    this.email = data.email;
    this.notifications = data.notifications;
    this.detailedReport = data.detailedReport;
  }

  closeDialog() {
    this.visible = false;
    this.close.emit();
  }

  onSave() {
    const formData: ProcessFormData = {
      scheduleMode: this.scheduleMode,
      startTime: this.startTime,
      selectedWeekdays: this.selectedWeekdays,
      timeZone: this.timeZone,
      interval: this.interval,
      processNewRecords: this.processNewRecords,
      recheckExisting: this.recheckExisting,
      recordLimit: this.recordLimit,
      autoMerge: this.autoMerge,
      autoMergeThreshold: this.autoMergeThreshold,
      email: this.email,
      notifications: this.notifications,
      detailedReport: this.detailedReport,
    };
    this.create.emit(formData);
    this.closeDialog();
  }
}

export interface ProcessFormData {
  scheduleMode: 'daily' | 'weekdays' | 'interval';
  startTime: string;
  selectedWeekdays: string[];
  timeZone: string;
  interval: string;
  processNewRecords: 'yes' | 'no';
  recheckExisting: 'only-changed' | 'no';
  recordLimit: string;
  autoMerge: boolean;
  autoMergeThreshold: string;
  email: string;
  notifications: 'errors-only' | 'always';
  detailedReport: 'yes' | 'no';
}

