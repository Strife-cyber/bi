from io import BytesIO
from auth import verify_hmac
from infer import run_analysis
from metrics import parse_csv_metrics, parse_yaml_config
from fastapi import FastAPI, Request, Header, UploadFile, File

app = FastAPI()


@app.middleware("http")
async def cache_body_middleware(request: Request, call_next):
    # Only process for /inference/ endpoint
    if request.url.path == "/inference/" and request.method == "POST":
        body = await request.body()
        request.state.body = body  # Store body in request state
        request._body = body       # Set cached body
        request.stream = BytesIO(body)  # Reset stream
    response = await call_next(request)
    return response


@app.get("/metrics/")
async def get_metrics():
    response = {}
    try:
        with open("model/results.csv", "r") as f:
            response["training_metrics"] = parse_csv_metrics(f.read())
        with open("model/args.yaml", "r") as f:
            response["model_params"] = parse_yaml_config(f.read())
    except FileNotFoundError:
        response["error"] = "results.csv not found in 'model/' directory."
    except Exception as e:
        response["error"] = str(e)

    return response

@app.post("/inference/")
async def run_inference(
    request: Request,
    x_signature: str = Header(...),
    x_timestamp: str = Header(...),
    file: UploadFile = File(...)
):
    # Use cached body from middleware
    body = request.state.body
    await verify_hmac(request, x_signature, x_timestamp, body)
    return await run_analysis(file)

if __name__ == "__main__":
    import uvicorn
    uvicorn.run("main:app", host="0.0.0.0", port=3003, reload=True)

