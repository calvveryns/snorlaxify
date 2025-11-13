from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from server.src.api.routes import pipeline


def create() -> FastAPI:
    app = FastAPI(
        title="Snorlaxify",
        description="API for running identifier vectorization and duplicate detection pipeline",
        version="1.0.0"
    )

    app.add_middleware(
        CORSMiddleware,
        allow_origins=["*"],
        allow_credentials=True,
        allow_methods=["*"],
        allow_headers=["*"],
    )

    @app.get("/ping")
    async def ping():
        return {"status": "pong"}

    app.include_router(pipeline.router, prefix="/api", tags=["Pipeline"])

    return app
