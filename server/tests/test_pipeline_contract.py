import unittest

from fastapi.testclient import TestClient

from server.src.api import create
from server.src.api.routes.pipeline import get_source_db
from server.src.databases.database import SourceDatabase


class FakeSourceDatabase:
    def __init__(self):
        self.resolved_pairs = None
        self.recommendations = [
            {
                'item_one_id': 101,
                'item_two_id': 102,
                'title_one': 'Borjomi 0.5',
                'title_two': 'Borjomi 500ml',
                'distance': 0.02,
                'duplicate_likelihood': 'high',
                'suggested_name': 'Borjomi 0.5',
            },
            {
                'item_one_id': 201,
                'item_two_id': 202,
                'title_one': 'Cookie',
                'title_two': 'Cookies',
                'distance': 0.07,
                'duplicate_likelihood': 'low',
                'suggested_name': None,
            }
        ]

    def get_pipeline_task(self, task_id: str):
        return {
            'task_id': task_id,
            'status': 'completed',
            'started_at': '2026-04-01T10:00:00',
            'completed_at': '2026-04-01T10:05:00',
            'paused_at': None,
            'error': None,
            'current_step': 5,
            'total_steps': 5,
        }

    def get_pipeline_final_result(self, task_id: str):
        return self.recommendations

    def resolve_pipeline_result(self, pairs_to_resolve):
        self.resolved_pairs = pairs_to_resolve
        return len(pairs_to_resolve)

    def remove_resolved_pairs_from_result(self, task_id: str, pairs_to_resolve):
        self.recommendations = SourceDatabase.filter_unresolved_recommendations(
            self.recommendations,
            pairs_to_resolve,
        )


class PipelineContractTests(unittest.TestCase):
    def setUp(self):
        self.app = create()
        self.fake_db = FakeSourceDatabase()
        self.app.dependency_overrides[get_source_db] = lambda: self.fake_db
        self.client = TestClient(self.app)

    def tearDown(self):
        self.app.dependency_overrides.clear()

    def test_normalize_pipeline_result_wraps_legacy_list(self):
        normalized = SourceDatabase.normalize_pipeline_result(
            [
                {
                    'item_one_id': 101,
                    'item_two_id': 102,
                    'title_one': 'A',
                    'title_two': 'B',
                    'distance': 0.01,
                }
            ]
        )

        self.assertEqual(
            normalized,
            {
                'results': [
                    {
                        'item_one_id': 101,
                        'item_two_id': 102,
                        'title_one': 'A',
                        'title_two': 'B',
                        'distance': 0.01,
                    }
                ]
            },
        )

    def test_get_task_result_returns_unified_contract(self):
        response = self.client.get('/api/pipeline/task-1/result')

        self.assertEqual(response.status_code, 200)
        self.assertEqual(
            response.json(),
            {
                'task_id': 'task-1',
                'status': 'completed',
                'recommendations': {
                    'results': [
                        {
                            'item_one_id': 101,
                            'item_two_id': 102,
                            'title_one': 'Borjomi 0.5',
                            'title_two': 'Borjomi 500ml',
                            'distance': 0.02,
                            'duplicate_likelihood': 'high',
                            'suggested_name': 'Borjomi 0.5',
                        },
                        {
                            'item_one_id': 201,
                            'item_two_id': 202,
                            'title_one': 'Cookie',
                            'title_two': 'Cookies',
                            'distance': 0.07,
                            'duplicate_likelihood': 'low',
                            'suggested_name': None,
                        }
                    ]
                },
            },
        )

    def test_resolve_accepts_unified_payload(self):
        response = self.client.post(
            '/api/pipeline/task-1/resolve',
            json={
                'pairs': [
                    {
                        'item_one_id': 101,
                        'item_two_id': 102,
                        'title_one': 'Borjomi 0.5',
                        'title_two': 'Borjomi 500ml',
                        'action': 'merge',
                        'suggested_name': 'Borjomi 0.5',
                    },
                    {
                        'item_one_id': 201,
                        'item_two_id': 202,
                        'title_one': 'Cookie',
                        'title_two': 'Cookies',
                        'action': 'ignore',
                        'suggested_name': None,
                    },
                ]
            },
        )

        self.assertEqual(response.status_code, 200)
        self.assertEqual(response.json()['resolved_count'], 2)
        self.assertEqual(
            self.fake_db.resolved_pairs,
            [
                {
                    'item_one_id': 101,
                    'item_two_id': 102,
                    'title_one': 'Borjomi 0.5',
                    'title_two': 'Borjomi 500ml',
                    'action': 'merge',
                    'suggested_name': 'Borjomi 0.5',
                },
                {
                    'item_one_id': 201,
                    'item_two_id': 202,
                    'title_one': 'Cookie',
                    'title_two': 'Cookies',
                    'action': 'ignore',
                    'suggested_name': None,
                },
            ],
        )
        self.assertEqual(
            self.fake_db.recommendations,
            {'results': []},
        )


if __name__ == '__main__':
    unittest.main()
