from pydantic import BaseModel, Field, field_validator


class PublicQrAttendanceSubmit(BaseModel):
    full_name: str = Field(min_length=3, max_length=150)
    document_number: str = Field(min_length=6, max_length=12)
    campaign_id: int

    @field_validator("full_name", "document_number")
    @classmethod
    def validate_required_text(cls, value: str) -> str:
        normalized = value.strip()
        if not normalized:
            raise ValueError("Este campo es obligatorio.")
        return normalized


class BotModerationAction(BaseModel):
    detail: str | None = None

    @field_validator("detail")
    @classmethod
    def normalize_detail(cls, value: str | None) -> str | None:
        if value is None:
            return None
        normalized = value.strip()
        return normalized or None
