from contextlib import contextmanager

from fastapi import HTTPException


@contextmanager
def exception_handler(request=None):
    try:
        yield
    except HTTPException:
        raise
    except ValueError as e:
        msg = str(e)
        if msg == "Invalid Card":
            raise HTTPException(status_code=404, detail=msg)
        raise HTTPException(status_code=400, detail=msg)
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
