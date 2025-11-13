import logging
import uvicorn
from server.src.api import create

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(message)s"
)

if __name__ == "__main__":
    app = create()
    uvicorn.run(app, host="0.0.0.0", port=8080, log_level="info")
