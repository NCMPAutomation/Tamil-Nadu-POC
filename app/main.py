from contextlib import asynccontextmanager

from fastapi import FastAPI, Request
from fastapi.responses import JSONResponse

from app.controllers.case_entry_controller import router as case_router
from app.controllers.case_type_controller import router as case_type_router
from app.controllers.form_controller import router as form_router
from app.core.exceptions import BadRequestException, NotFoundException
from app.core.logging import logger, setup_logging
from app.core.response import error_response


@asynccontextmanager
async def lifespan(app: FastAPI):
    setup_logging()
    logger.info("Starting application")
    yield
    logger.info("Stopping application")


app = FastAPI(title="Dynamic Police Case Management System", version="1.0.0", lifespan=lifespan)


@app.middleware("http")
async def request_logging_middleware(request: Request, call_next):
    logger.info("%s %s", request.method, request.url.path)
    response = await call_next(request)
    logger.info("Completed %s %s with %s", request.method, request.url.path, response.status_code)
    return response


@app.exception_handler(NotFoundException)
async def not_found_exception_handler(_: Request, exc: NotFoundException):
    return JSONResponse(status_code=exc.status_code, content=error_response(message=exc.detail))


@app.exception_handler(BadRequestException)
async def bad_request_exception_handler(_: Request, exc: BadRequestException):
    return JSONResponse(status_code=exc.status_code, content=error_response(message=exc.detail))


@app.exception_handler(Exception)
async def generic_exception_handler(_: Request, exc: Exception):
    logger.exception("Unhandled exception: %s", exc)
    return JSONResponse(status_code=500, content=error_response(message="Internal server error"))


@app.get("/health", tags=["Health"])
async def health_check():
    return {"success": True, "data": {"status": "ok"}, "message": "Healthy"}


app.include_router(case_type_router)
app.include_router(form_router)
app.include_router(case_router)
