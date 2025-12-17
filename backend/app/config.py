from pydantic_settings import BaseSettings
from typing import Optional

class Settings(BaseSettings):
    DATABASE_URL: str = "postgresql://user:password@localhost:5432/arcmetric"
    PORT: int = 5000
    OPENAI_API_KEY: str = ""
    ENVIRONMENT: str = "development"
    LOG_LEVEL: str = "INFO"
    
    class Config:
        env_file = ".env"

settings = Settings()
