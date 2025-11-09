from fastapi import FastAPI
import uvicorn

app = FastAPI(title="Selar API")

@app.get("/")
def root():
    return {"message": "Welcome to Selar API - Running Successfully"}

@app.get("/health")
def health_check():
    return {"status": "healthy"}

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8080)
