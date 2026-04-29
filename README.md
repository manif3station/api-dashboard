# api-dashboard

## Description

`api-dashboard` is a Developer Dashboard skill that gives users a browser-based API request workspace inside DD.

## Value

It gives testers, developers, and operators one place to organize request collections, edit calls, manage request credentials, and inspect responses without leaving Developer Dashboard.

## Problem It Solves

API work often gets split across ad hoc curl commands, external API tools, copied auth tokens, and temporary notes. That makes it harder to keep request definitions, variables, credentials, and responses together while working inside DD.

## What It Does To Solve It

This skill adds a Postman-style API workspace to DD. It lets the user:

- create and manage collections of API requests
- open multiple request tabs side by side in one workspace
- import and export Postman collection JSON
- define collection variables and per-request token values
- configure request credentials such as Basic, API Token, API Key, and OAuth2-style settings
- send HTTP requests from the browser workspace through DD
- inspect request details, response body, response headers, and previewable media responses

This repo proves the shipped skill page still loads and exposes the documented workspace controls. It does not re-run the full browser request, import, and persistence matrix inside this ticket.

## Developer Dashboard Feature Added

This skill adds a browser page at:

- `http://127.0.0.1:7890/app/api-dashboard`

## What Is Included

- an API request workspace page at `dashboards/index`
- Docker-only regression tests for copy integrity and browser layout smoke coverage
- skill-local docs describing the workspace and how to install and use it

## Installation

Install the skill from its repo:

```bash
dashboard skills install git@github.mf:manif3station/api-dashboard.git
```

For local development in this workspace:

```bash
dashboard skills install ~/projects/skills/skills/api-dashboard
```

## How To Use It

Open the page in DD after install:

```bash
dashboard restart
```

Then visit:

```text
http://127.0.0.1:7890/app/api-dashboard
```

The page provides:

- Collections
- Workspace
- request tabs
- response detail panes
- request token and credential forms
- Postman collection import and export
- browser-side response preview for supported media types

## Runtime Dependency Notes

This skill is a browser workspace. Sending requests depends on the DD runtime being able to load the Perl HTTP client modules used by the request sender.

This skill declares the embedded sender prerequisites used by the request workspace:

```bash
dashboard cpan LWP::Protocol::https
dashboard cpan LWP::UserAgent
dashboard cpan URI
dashboard cpan HTTP::Message
dashboard cpan MIME::Base64
```

## Normal Cases

```text
/app/api-dashboard opens an API workspace with Collections and Workspace sections
```

```text
The page lets the user keep reusable request definitions in collections and open individual requests in tabs
```

```text
The page sends requests, shows response metadata, and renders response body, headers, and preview output
```

## Edge Cases

```text
If DD is not running, the browser route will not load until `dashboard restart` brings the web app back.
```

```text
If the DD runtime cannot load the HTTP client modules used by the request sender, the page still opens but request dispatch will not be usable until those modules are installed.
```

```text
If a future update changes this skill page, the regression test will fail until the shipped page and docs are refreshed together.
```

## Docs

- `docs/overview.md`
- `docs/usage.md`
- `docs/changes/2026-04-29-extraction.md`
