from pydantic import AnyHttpUrl, BaseModel


class SessionLinkUpdate(BaseModel):
    join_url: AnyHttpUrl
