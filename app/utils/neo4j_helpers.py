"""Helpers for Neo4j integration."""

from datetime import datetime, timezone


def to_python_datetime(value):
    """Convert Neo4j DateTime to Python datetime for Pydantic models."""
    if value is None or isinstance(value, datetime):
        return value
    if hasattr(value, "to_native"):
        return value.to_native()
    if hasattr(value, "year") and hasattr(value, "nanosecond"):
        tz = getattr(value, "tzinfo", None) or timezone.utc
        microsecond = getattr(value, "nanosecond", 0) // 1000
        return datetime(
            value.year,
            value.month,
            value.day,
            value.hour,
            value.minute,
            value.second,
            microsecond,
            tzinfo=tz,
        )
    return value
