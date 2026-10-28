from fastapi import APIRouter

from app.deps import CurrentUser
from app.models import User
from app.schemas import UserOut

router = APIRouter(prefix="/me", tags=["profil"])


@router.get("", response_model=UserOut)
def read_me(user: CurrentUser) -> User:
    return user
