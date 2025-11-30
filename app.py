# app.py
from fastapi import FastAPI
import asyncio
import asyncpg

app = FastAPI()

# Database config
DB_USER = "khang"
DB_PASSWORD = ""  # replace with your password
DB_HOST = "database"
DB_PORT = 5432
DB_NAME = "trafficdb"

# Demo query
DEMO_QUERY = "SELECT * FROM traffic_data LIMIT 10;"

# Initialize a connection pool
async def get_pool():
    return await asyncpg.create_pool(
        user=DB_USER,
        # password=DB_PASSWORD,
        database=DB_NAME,
        host=DB_HOST,
        port=DB_PORT
    )

# We will store the pool in app state
@app.on_event("startup")
async def startup():
    app.state.pool = await get_pool()

@app.on_event("shutdown")
async def shutdown():
    await app.state.pool.close()

@app.get("/traffic")
async def get_traffic():
    async with app.state.pool.acquire() as connection:
        rows = await connection.fetch(DEMO_QUERY)
        # Convert asyncpg records to dicts
        results = [dict(row) for row in rows]
    return {"data": results}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run("app:app", host="0.0.0.0", port=8000, reload=True)
