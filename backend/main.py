import uvicorn

from app.config.settings import settings


if __name__ == "__main__":
    uvicorn.run(
        "app.app:app",
        host=settings.api_host,
        port=settings.api_port,
        reload=settings.reload_enabled,
    )
