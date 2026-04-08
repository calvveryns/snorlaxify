import unittest

from server.src.databases.database import SourceDatabase


class GroupingTests(unittest.TestCase):
    def test_build_groups_merges_transitive_chain(self):
        rows = [
            (10, 100, "Borjomi Classic"),
            (20, 200, "Borjomi Classic Bottle"),
            (30, 300, "Borjomi Bottle"),
        ]
        neighbour_rows = {
            10: [(20, 200, "Borjomi Classic Bottle", 0.03)],
            20: [
                (10, 100, "Borjomi Classic", 0.03),
                (30, 300, "Borjomi Bottle", 0.02),
            ],
            30: [(20, 200, "Borjomi Classic Bottle", 0.02)],
        }

        groups = SourceDatabase._build_groups_from_neighbors(rows, neighbour_rows)

        self.assertEqual(len(groups), 1)
        self.assertEqual(groups[0]["anchor_item_id"], 200)
        self.assertEqual([item["item_id"] for item in groups[0]["items"]], [200, 300, 100])
        self.assertTrue(groups[0]["items"][0]["is_anchor"])

    def test_build_groups_rejects_obvious_numeric_conflict(self):
        rows = [
            (10, 100, "iPhone 14 128GB"),
            (20, 200, "iPhone 15 128GB"),
        ]
        neighbour_rows = {
            10: [(20, 200, "iPhone 15 128GB", 0.01)],
            20: [(10, 100, "iPhone 14 128GB", 0.01)],
        }

        groups = SourceDatabase._build_groups_from_neighbors(rows, neighbour_rows)

        self.assertEqual(groups, [])

    def test_build_groups_keeps_direct_duplicate_pair(self):
        rows = [
            (10, 100, "Cookie"),
            (20, 200, "Cookies"),
        ]
        neighbour_rows = {
            10: [(20, 200, "Cookies", 0.04)],
            20: [(10, 100, "Cookie", 0.04)],
        }

        groups = SourceDatabase._build_groups_from_neighbors(rows, neighbour_rows)

        self.assertEqual(len(groups), 1)
        self.assertEqual({item["item_id"] for item in groups[0]["items"]}, {100, 200})

    def test_build_groups_rejects_model_token_conflict(self):
        rows = [
            (10, 100, "Арматура (в мотках) №8-B500B"),
            (20, 200, "Арматура (в мотках) №8-B500C"),
        ]
        neighbour_rows = {
            10: [(20, 200, "Арматура (в мотках) №8-B500C", 0.01)],
            20: [(10, 100, "Арматура (в мотках) №8-B500B", 0.01)],
        }

        groups = SourceDatabase._build_groups_from_neighbors(rows, neighbour_rows)

        self.assertEqual(groups, [])


if __name__ == "__main__":
    unittest.main()
