from fastapi import FastAPI
app = FastAPI(
    title="SIBU Cases",
    version="1.0.0",
    openapi_url="/api/cases/openapi.json",
    docs_url="/api/cases/docs",
    redoc_url="/api/cases/redoc",
)

@app.get("/api/cases/health", tags=["health"])
def health():
    return {"status":"ok","service":"cases"}

@app.get("/api/cases/ping", tags=["demo"])
def ping():
    return {"pong": True, "service":"cases"}
