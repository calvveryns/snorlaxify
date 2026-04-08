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
        "--with-llm-regroup",
        action="store_true",
        help="Enable LLM-based regrouping/splitting of candidate groups before filtering",
    )
    parser.add_argument(
        "--llm-regroup-batch-size",
        type=int,
        default=None,
        help="Number of candidate groups sent to the LLM regroup step in one request",
    )
    parser.add_argument(
        "--with-llm-filter",
        action="store_true",
        help="Enable LLM-based duplicate group filtering before final metric calculation",
    )
    parser.add_argument(
        "--llm-filter-batch-size",
        type=int,
        default=None,
        help="Number of candidate groups sent to the LLM filter in one request",
    )
    parser.add_argument(
        "--llm-url",
        default=None,
        help="Override LLM API URL for local benchmark runs",
    )
    parser.add_argument(
        "--llm-model",
        default=None,
        help="Override LLM model for local benchmark runs",
    )
    parser.add_argument(
        "--llm-provider",
        default=None,
        help="Override LLM provider for local benchmark runs",
    )
    parser.add_argument(
        "--llm-api-key",
        default=None,
        help="Override LLM API key for local benchmark runs",
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
        use_llm_regroup=args.with_llm_regroup,
        llm_regroup_batch_size=args.llm_regroup_batch_size,
        use_llm_filter=args.with_llm_filter,
        llm_filter_batch_size=args.llm_filter_batch_size,
        llm_api_url=args.llm_url,
        llm_model=args.llm_model,
        llm_provider=args.llm_provider,
        llm_api_key=args.llm_api_key,
    )
    print(json.dumps(result.to_dict(), ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
