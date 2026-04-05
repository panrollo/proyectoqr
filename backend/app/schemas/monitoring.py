from datetime import date

from pydantic import BaseModel


class FeedbackCreate(BaseModel):
    person_id: int
    created_by: int
    source: str
    title: str
    strengths: str | None = None
    opportunities: str | None = None
    action_plan: str | None = None
    status: str | None = None


class FeedbackUpdate(FeedbackCreate):
    pass


class CommitmentCreate(BaseModel):
    feedback_id: int
    person_id: int
    responsible_user_id: int | None = None
    description: str
    commitment_date: date
    due_date: date | None = None
    status: str | None = None


class CommitmentUpdate(CommitmentCreate):
    pass


class QualityMonitorCreate(BaseModel):
    person_id: int
    analyst_user_id: int
    call_id: str | None = None
    criteria: str
    score: float | None = None
    finding: str | None = None
    recommendation: str | None = None
    status: str | None = None


class QualityMonitorUpdate(QualityMonitorCreate):
    pass


class OjtFollowupCreate(BaseModel):
    person_id: int
    group_id: int
    day_number: int
    aht: str | None = None
    quality_score: float | None = None
    csat_score: float | None = None
    status: str | None = None
    notes: str | None = None


class OjtFollowupUpdate(OjtFollowupCreate):
    pass
