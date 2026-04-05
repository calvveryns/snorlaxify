import argparse
import json
import logging
import sys
from pathlib import Path

ROOT_DIR = Path(__file__).resolve().parents[1]
if str(ROOT_DIR) not in sys.path:
    sys.path.insert(0, str(ROOT_DIR))

from server.src.evaluation import evaluate_benchmark_dataset, load_benchmark_dataset


def main():
    parser = argparse.ArgumentParser(description="Run candidate-stage deduplication benchmark on a labeled dataset")
    parser.add_argument("dataset", help="Path to benchmark dataset JSON")
    parser.add_argument(
        "--distance-threshold",
        type=float,
        default=None,
        help="Override duplicate distance threshold for candidate generation",
    )
    parser.add_argument(
        "--top-k",
        type=int,
        default=None,
        help="Override max neighbours per item during candidate generation",
    )
    parser.add_argument(
        "--vectorizer-url",
        default=None,
        help="Override vectorizer API URL for local benchmark runs",
    )
    parser.add_argument(
        "--vectorizer-model",
        default=None,
        help="Override vectorizer model for local benchmark runs",
    )
    parser.add_argument(
        "--verbose",
        action="store_true",
        help="Enable verbose benchmark logging",
    )
    args = parser.parse_args()
    logging.basicConfig(
        level=logging.DEBUG if args.verbose else logging.INFO,
        format="%(asctime)s [%(levelname)s] %(name)s: %(message)s",
    )

    dataset = load_benchmark_dataset(args.dataset)
    result = evaluate_benchmark_dataset(
        dataset,
        dataset_path=args.dataset,
        distance_threshold=args.distance_threshold,
        top_k=args.top_k,
        vectorizer_api_url=args.vectorizer_url,
        vectorizer_model=args.vectorizer_model,
    )
    print(json.dumps(result.to_dict(), ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
