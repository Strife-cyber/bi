from infer import inference
from auth import verify_hmac
from metrics import parse_csv_metrics, parse_yaml_config
from fastapi import FastAPI, Request, Header, UploadFile, File

app = FastAPI()


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
    request._body = await request.body()
    await verify_hmac(request, x_signature, x_timestamp)

    # Now we can run our inference
    inference(file)


