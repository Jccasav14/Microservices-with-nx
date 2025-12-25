from fastapi import FastAPI

app = FastAPI(
    title="SIBU Auth",
    version="1.0.0",
    openapi_url="/api/auth/openapi.json",
    docs_url="/api/auth/docs",
    redoc_url="/api/auth/redoc",
)

@app.get("/api/auth/health", tags=["health"])
def health():
    return {"status":"ok","service":"auth"}

@app.get("/api/auth/ping", tags=["demo"])
def ping():
    return {"pong": True, "service":"auth"}
