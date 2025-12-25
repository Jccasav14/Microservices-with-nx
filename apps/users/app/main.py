from fastapi import FastAPI
app = FastAPI(
    title="SIBU Users",
    version="1.0.0",
    openapi_url="/api/users/openapi.json",
    docs_url="/api/users/docs",
    redoc_url="/api/users/redoc",
)

@app.get("/api/users/health", tags=["health"])
def health():
    return {"status":"ok","service":"users"}

@app.get("/api/users/ping", tags=["demo"])
def ping():
    return {"pong": True, "service":"users"}
