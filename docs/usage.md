# Usage

## Install

```bash
dashboard skills install git@github.mf:manif3station/api-dashboard.git
```

Local workspace install:

```bash
dashboard skills install ~/projects/skills/skills/api-dashboard
```

## Open The Page

```bash
dashboard restart
```

Then open:

```text
http://127.0.0.1:7890/app/api-dashboard
```

## What You Should See

- `Collections`
- `Workspace`
- `New Tab`
- `Request Token Values`
- `Request Credentials`
- `Response Body`
- `Response Headers`

## Runtime Notes

The workspace uses DD-backed Ajax handlers such as `/ajax/api-dashboard-bootstrap?type=json` to load saved collections, persist updates under the runtime config tree, and send HTTP requests through Perl.

Examples:

```bash
dashboard cpan LWP::Protocol::https
dashboard cpan LWP::UserAgent
dashboard cpan URI
dashboard cpan HTTP::Message
dashboard cpan MIME::Base64
```

## Practical Normal Cases

- install the skill and open `/app/api-dashboard`
- create a scratch collection and save a few reusable requests into it
- use request variables and token fields to avoid rewriting URLs and auth values across requests
- inspect response body, headers, and preview panes after sending a request

## Practical Edge Cases

- if the DD runtime cannot load the HTTP client modules used by the request sender, the page still opens but request dispatch will not be usable until those modules are installed
- if the shipped page or its ajax route contract changes, the route verification and worker-body regression tests will fail
- if DD is stopped, the route will not answer until `dashboard restart` brings it back
