from fastapi import FastAPI
from src.api.v1.endpoints import router
import uvicorn
from src.utils.logger import setup_logging, get_logger

app = FastAPI()
app.include_router(router)


setup_logging()
log = get_logger(__name__)


log.info("Metro Card System is starting...")

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)
