# Testing

## Policy

- tests run only inside Docker
- the shared test container definition lives at the workspace root
- this skill keeps its test files in `t/`
- Playwright is used for the browser-facing smoke check because this skill exposes a browser page

## Commands

```bash
docker compose -f ~/projects/skills/docker-compose.testing.yml run --rm perl-test bash -lc 'cd /workspace/skills/api-dashboard && cpanm --quiet --notest --installdeps . && prove -lr t'
docker compose -f ~/projects/skills/docker-compose.testing.yml run --rm perl-test bash -lc 'cd /workspace/skills/api-dashboard && cpanm --quiet --notest --installdeps . && cover -delete && HARNESS_PERL_SWITCHES=-MDevel::Cover prove -lr t && cover -report text -select_re "^lib/" -coverage statement -coverage subroutine'
```

## Latest Verification

- Date: 2026-04-29
- Functional test:
  - `docker compose -f ~/projects/skills/docker-compose.testing.yml run --rm perl-test bash -lc 'cd /workspace/skills/api-dashboard && cpanm --quiet --notest --installdeps . && prove -lr t'`
  - Result: pass
  - Test count: `Files=4, Tests=22`
- Coverage test:
  - `docker compose -f ~/projects/skills/docker-compose.testing.yml run --rm perl-test bash -lc 'cd /workspace/skills/api-dashboard && cpanm --quiet --notest --installdeps . && cover -delete && HARNESS_PERL_SWITCHES=-MDevel::Cover prove -lr t && cover -report text -select_re "^lib/" -coverage statement -coverage subroutine'`
  - Result: pass
  - Coverage: `100.0%` statement and `100.0%` subroutine for `lib/ApiDashboard/Asset.pm`
- Installed DD proof:
  - `dashboard skills install ~/projects/skills/skills/api-dashboard`
  - Result: pass, installed `api-dashboard` at version `0.01`
  - `dashboard restart`
  - Result: pass, DD web returned on `127.0.0.1:7890`
  - `curl -fsS http://127.0.0.1:7890/app/api-dashboard | rg -n "Collections|Workspace|Request Token Values|Response Headers|api-response-preview"`
  - Result: pass, returned the API dashboard page with the documented workspace controls
- Cleanup:
  - `docker compose -f ~/projects/skills/docker-compose.testing.yml run --rm perl-test bash -lc 'rm -rf /workspace/skills/api-dashboard/cover_db'`
  - Result: pass
