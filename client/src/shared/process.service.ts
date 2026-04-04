import { HttpClient } from '@angular/common/http';
import { inject, Injectable } from '@angular/core';
import { map, Observable } from 'rxjs';

const baseUrl = '';
const prefix = 'api';

export const statuses = ['pending', 'running', 'paused', 'completed', 'failed'] as const;

export enum Step {
    Setup,
    Vectorizing,
    Committing,
    Searching,
    Recommendations,
}

export type DuplicateLikelihood = 'high' | 'medium' | 'low';

export type DuplicateRecommendation = {
  distance: number;
  title_one: string;
  title_two: string;
  suggested_name: string | null;
  duplicate_likelihood: DuplicateLikelihood;
};

export type PipelineRecommendationsDTO = {
  results: DuplicateRecommendation[];
  message?: string;
};

export type ResolvePairPayload = {
  title_one: string;
  title_two: string;
  action: 'merge' | 'ignore';
  suggested_name: string | null;
};

export type ProcessDTO = {
  task_id: string;
  uuid?: string;
  status: string;
  started_at: string | null;
  completed_at: string | null;
  paused_at: string | null;
  recommendations: PipelineRecommendationsDTO;
  current_step: number;
  total_steps: number;
  error?: string | null;
  processingTime?: string;
};

export type ProcessesResponse = {
  count: number;
  tasks: ProcessDTO[];
};

export type PipelineResultDTO = {
  task_id: string;
  status: string;
  recommendations: PipelineRecommendationsDTO;
};

export type PipelineResponse = {
  status: string;
  message: string;
  task_id: string;
};

export type ResolveResponse = PipelineResponse & {
  resolved_count: number;
};

const getProcessingTime = (start: string | null, stop: string | null): string =>
  stop && start
    ? new Date(new Date(stop).getTime() - new Date(start).getTime()).toISOString().substr(11, 8)
    : 'N/A';

@Injectable()
export class ProcessService {
  private readonly http = inject(HttpClient);

  getProcesses(): Observable<ProcessesResponse> {
    return this.http.get<ProcessesResponse>(`${baseUrl}/${prefix}/pipeline/status`).pipe(
      map((response) => ({
        ...response,
        tasks: response.tasks.map((task) => ({
          ...task,
          task_id: task.task_id ?? task.uuid ?? '',
          recommendations: task.recommendations ?? { results: [] },
          processingTime: getProcessingTime(task.started_at, task.completed_at),
        })),
      }))
    );
  }

  getProcess(uuid: string): Observable<ProcessDTO> {
    return this.http.get<ProcessDTO>(`${baseUrl}/${prefix}/pipeline/${uuid}/status`).pipe(
      map((response) => ({
        ...response,
        task_id: response.task_id ?? response.uuid ?? uuid,
        recommendations: response.recommendations ?? { results: [] },
        processingTime: getProcessingTime(response.started_at, response.completed_at),
      }))
    );
  }

  getProcessResult(uuid: string): Observable<PipelineResultDTO> {
    return this.http.get<PipelineResultDTO>(`${baseUrl}/${prefix}/pipeline/${uuid}/result`).pipe(
      map((response) => ({
        ...response,
        recommendations: response.recommendations ?? { results: [] },
      }))
    );
  }

  startProcess(): Observable<PipelineResponse> {
    return this.http.post<PipelineResponse>(`${baseUrl}/${prefix}/pipeline/start`, {});
  }

  deleteProcess(uuid: string): Observable<PipelineResponse> {
    return this.http.delete<PipelineResponse>(`${baseUrl}/${prefix}/pipeline/${uuid}`, {});
  }

  resolveProcess(uuid: string, pairs: ResolvePairPayload[]): Observable<ResolveResponse> {
    return this.http.post<ResolveResponse>(`${baseUrl}/${prefix}/pipeline/${uuid}/resolve`, {
      pairs,
    });
  }
}
