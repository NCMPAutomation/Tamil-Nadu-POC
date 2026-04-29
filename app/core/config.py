from urllib.parse import quote_plus

from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    app_name: str = "Dynamic Police Case Management System"
    app_env: str = "development"
    debug: bool = True

    mysql_user: str = "root"
    mysql_password: str = "password"
    mysql_host: str = "127.0.0.1"
    mysql_port: int = 3306
    mysql_db: str = "police_case_db"

    @property
    def sqlalchemy_database_uri(self) -> str:
        user = quote_plus(self.mysql_user)
        password = quote_plus(self.mysql_password)
        return (
            f"mysql+aiomysql://{user}:{password}"
            f"@{self.mysql_host}:{self.mysql_port}/{self.mysql_db}"
        )

    model_config = SettingsConfigDict(env_file=".env", env_file_encoding="utf-8", extra="ignore")


settings = Settings()
