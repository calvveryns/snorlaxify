import { HttpClient } from "@angular/common/http";
import { inject, Injectable } from "@angular/core";
import { map, Observable } from "rxjs";

const baseUrl = 'http://localhost:8080';
const prefix = 'api'

export const statuses = ['new', 'running', 'completed', 'failed'] as const;

export enum Step {
    Setup,
    Vectorizing,
    Committing,
    Searching,
    Recommendations,
}

export type Process = {
    date: string;
    databaseName: string;
    duplicatesFound: number;
    processingTime: string;
    status: typeof statuses[number];
};

export type RecommedationDTO = {
    results: {
        "distance": number,
        "title_one": string,
        "title_two": string,
        "suggested_name": string,
        "duplicate_likelihood": string,
    }[]

}

export type ProcessDTO = {
    task_id?: string;
    "uuid": string,
    "status": string,
    "started_at": string,
    "completed_at": string,
    "paused_at": string,
    "recommendations": RecommedationDTO[],
    "current_step": number,
    "total_steps": number
};

export type ProcessesResponse = {
    count: number;
    tasks: ProcessDTO[];
};

const getProcessingTime = (start: string, stop: string): string => stop && start
    ? new Date(new Date(stop).getTime() - new Date(start).getTime())
        .toISOString().substr(11, 8)
    : 'N/A'

@Injectable()
export class ProcessService {
    private readonly http = inject(HttpClient);
    
    getProcesses(): Observable<ProcessesResponse> {
        return this.http.get<ProcessesResponse>(`${baseUrl}/${prefix}/pipeline/status`).pipe(
            map(response => ({
                ...response,
                tasks: response.tasks.map(task => ({
                    ...task,
                    processingTime: getProcessingTime(task.started_at, task.completed_at),
                }))
            }))
        );
    }

    getProcess(uuid: string): Observable<ProcessDTO> {
        return this.http.get<ProcessDTO>(`${baseUrl}/${prefix}/pipeline/${uuid}/status`).pipe(
            map(response => ({
                ...response,
                processingTime: getProcessingTime(response.started_at, response.completed_at),
            }))
        );
    }

    startProcess(): Observable<void> {
        return this.http.post<void>(`${baseUrl}/${prefix}/pipeline/start`, {});
    }

    deleteProcess(uuid: string): Observable<void> {
        return this.http.delete<void>(`${baseUrl}/${prefix}/pipeline/${uuid}`, {});
    }
}