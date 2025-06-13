import os
import time
import hmac
import hashlib

from fastapi import Request, HTTPException

# Load secret key from environment variable
SECRET_KEY = os.getenv("SECRET_KEY")


async def verify_hmac(request: Request, signature: str, timestamp: str) -> None:
    """
    Verifies the authenticity and integrity of an incoming HTTP request using HMAC.

    This function performs the following:
    1. Validates the freshness of the request using a timestamp (±120 seconds).
    2. Reconstructs a message from the HTTP method, path, timestamp, and body.
    3. Computes the HMAC-SHA256 signature of this message using a shared secret key.
    4. Compares the computed signature with the one provided by the client.

    If the timestamp is expired or the signature does not match, it raises an HTTP 403 error.

    Parameters:
    ----------
    request : Request
        The FastAPI Request object containing the incoming HTTP request data.

    signature : str
        The HMAC signature provided by the client (usually via an HTTP header).

    timestamp : str
        The timestamp (in seconds) sent by the client, used to prevent replay attacks.

    Raises:
    ------
    HTTPException
        - If the timestamp is too old or too far in the future.
        - If the HMAC signature does not match the expected value.
    """

    # Prevent replay attacks: accept requests within ±120 seconds
    now = int(time.time())
    if abs(now - int(timestamp)) > 120:
        raise HTTPException(status_code=403, detail="Timestamp expired")

    # Get the request body
    body = await request.body()
    method = request.method
    path = request.url.path

    # Construct the message to sign
    message = f"{method}{path}{timestamp}{body.decode('utf-8')}"

    # Compute expected HMAC signature
    expected_signature = hmac.new(
        SECRET_KEY.encode(), message.encode(), hashlib.sha256
    ).hexdigest()

    # Securely compare signatures
    if not hmac.compare_digest(expected_signature, signature):
        raise HTTPException(status_code=403, detail="Signature mismatch")
