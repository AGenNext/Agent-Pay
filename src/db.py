"""SurrealDB connection helpers for Agent-Pay."""

from surrealdb import Surreal


async def get_db(url: str = 'ws://localhost:8000/rpc', namespace: str = 'agenext', database: str = 'agent_pay'):
    db = Surreal(url)
    await db.connect()
    await db.use(namespace, database)
    return db
