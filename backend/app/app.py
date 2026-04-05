from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from app.config.settings import settings
from app.routes.admin_routes import router as admin_router
from app.routes.auth_routes import router as auth_router
from app.routes.bootstrap_routes import router as bootstrap_router
from app.routes.monitoring_routes import router as monitoring_router
from app.routes.operations_routes import router as operations_router
from app.routes.public_qr_routes import router as public_qr_router
from app.routes.trainer_routes import router as trainer_router

app = FastAPI(title="GroupCOS Formacion API", version="2.0.0", docs_url="/docs", redoc_url=None)

app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.cors_allowed_origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.get("/health")
def health():
    return {"status": "ok", "service": "training-module-api"}


app.include_router(auth_router, prefix="/api")
app.include_router(bootstrap_router, prefix="/api")
app.include_router(admin_router, prefix="/api")
app.include_router(operations_router, prefix="/api")
app.include_router(monitoring_router, prefix="/api")
app.include_router(trainer_router, prefix="/api")
app.include_router(public_qr_router, prefix="/api")
