from fastapi import APIRouter, Depends

from app.controllers.bootstrap_controller import bootstrap
from app.utils.auth_guard import require_session

router = APIRouter(prefix="/bootstrap", tags=["bootstrap"], dependencies=[Depends(require_session)])


@router.get("")
def get_bootstrap():
    return bootstrap()
