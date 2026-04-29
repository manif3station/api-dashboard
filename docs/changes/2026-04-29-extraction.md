# 2026-04-29 extraction

## Summary

Created the `api-dashboard` skill by extracting the current DD API dashboard page into a new isolated skill repo.

## What changed

- copied the DD API dashboard page source into `dashboards/index`
- added a small skill-local helper module to parse and render the copied asset for tests
- added Docker-only regression tests for exact-copy integrity, bookmark structure, and browser layout smoke coverage

## Why

The API dashboard was previously only represented as a DD-core seeded page. This extraction gives it a skill-local home with its own release gate.
