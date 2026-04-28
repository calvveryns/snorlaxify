import argparse
import json
import sys
from pathlib import Path

ROOT_DIR = Path(__file__).resolve().parents[1]
if str(ROOT_DIR) not in sys.path:
    sys.path.insert(0, str(ROOT_DIR))

from server.src.evaluation.embedding_benchmark import (
    evaluate_embedding_benchmark_dataset,
    load_benchmark_dataset,
)


def main():
    parser = argparse.ArgumentParser(
        description="Measure embedding quality and runtime metrics on a labeled benchmark dataset"
    )
    parser.add_argument("dataset", help="Path to benchmark dataset JSON")
    parser.add_argument(
        "--vectorizer-url",
        default=None,
        help="Override vectorizer API URL",
    )
    parser.add_argument(
        "--vectorizer-model",
        default=None,
        help="Override vectorizer model",
    )
    parser.add_argument(
        "--model-process-name",
        default=None,
        help=(
            "Process name for RAM/VRAM measurement, for example 'ollama'. "
            "If omitted, the script tries to infer it from the vectorizer URL."
        ),
    )
    parser.add_argument(
        "--model-process-pid",
        type=int,
        default=None,
        help="Specific PID for RAM/VRAM measurement",
    )
    args = parser.parse_args()

    dataset = load_benchmark_dataset(args.dataset)
    result = evaluate_embedding_benchmark_dataset(
        dataset,
        dataset_path=args.dataset,
        vectorizer_api_url=args.vectorizer_url,
        vectorizer_model=args.vectorizer_model,
        model_process_name=args.model_process_name,
        model_process_pid=args.model_process_pid,
    )
    print(json.dumps(result.to_dict(), ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
