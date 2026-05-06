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

- Date: 2026-05-06
- `DD-060` MIT license release gate:
  - Functional test:
    - `docker compose -f ~/projects/skills/docker-compose.testing.yml run --rm perl-test bash -lc 'cd /workspace/skills/api-dashboard && cpanm --quiet --notest --installdeps . >/tmp/api-dashboard-cpanm.log 2>&1 && prove -lr t'`
    - Result: pass
    - Test count: `Files=7, Tests=50`
  - Coverage test:
    - `docker compose -f ~/projects/skills/docker-compose.testing.yml run --rm perl-test bash -lc 'cd /workspace/skills/api-dashboard && cpanm --quiet --notest --installdeps . >/tmp/api-dashboard-cpanm.log 2>&1 && prove -lr t >/tmp/api-dashboard-prove.log 2>&1; prove_rc=$?; tail -n 40 /tmp/api-dashboard-prove.log; if [ \"$prove_rc\" -ne 0 ]; then exit \"$prove_rc\"; fi; cover -delete >/dev/null 2>&1 || true; HARNESS_PERL_SWITCHES=-MDevel::Cover prove -lr t >/tmp/api-dashboard-cover-prove.log 2>&1; cover_rc=$?; tail -n 40 /tmp/api-dashboard-cover-prove.log; if [ \"$cover_rc\" -ne 0 ]; then exit \"$cover_rc\"; fi; cover -report text -select_re \"^lib/\" -coverage statement -coverage subroutine >/tmp/api-dashboard-cover.txt 2>&1; report_rc=$?; echo \"=== COVER ===\"; cat /tmp/api-dashboard-cover.txt; exit \"$report_rc\"'`
    - Result: pass
    - Coverage: `100.0%` statement and `100.0%` subroutine for `lib/ApiDashboard/Asset.pm`
  - Cleanup:
    - `docker compose -f ~/projects/skills/docker-compose.testing.yml run --rm perl-test bash -lc 'rm -rf /workspace/skills/api-dashboard/cover_db'`
    - Result: pass

- Date: 2026-04-29
- Functional test:
  - `docker compose -f ~/projects/skills/docker-compose.testing.yml run --rm perl-test bash -lc 'cd /workspace/skills/api-dashboard && cpanm --quiet --notest --installdeps . && prove -lr t'`
  - Result: pass
  - Test count: `Files=6, Tests=42`
- Coverage test:
  - `docker compose -f ~/projects/skills/docker-compose.testing.yml run --rm perl-test bash -lc 'cd /workspace/skills/api-dashboard && cpanm --quiet --notest --installdeps . && cover -delete && HARNESS_PERL_SWITCHES=-MDevel::Cover prove -lr t && cover -report text -select_re "^lib/" -coverage statement -coverage subroutine'`
  - Result: pass
  - Coverage: `100.0%` statement and `100.0%` subroutine for `lib/ApiDashboard/Asset.pm`
- Screenshot generation:
  - Result: pass
  - Method: temporary Docker-time Playwright capture against a temporary public API demo
  - Repo policy: the temporary example configuration used to capture the screenshots is not stored in the repo
  - Assets: `docs/images/api-dashboard-collections.png`, `docs/images/api-dashboard-workspace.png`, `docs/images/api-dashboard-response.png`
- Installed DD proof:
  - `dashboard skills install ~/projects/skills/skills/api-dashboard`
  - Result: pass, updated `api-dashboard` to version `0.06`
  - `dashboard restart --port 7890`
  - Result: pass, DD web returned on `127.0.0.1:7890`
  - `curl -fsS http://127.0.0.1:7890/app/api-dashboard | rg -n "Collections|Workspace|Request Token Values|Response Headers|api-response-preview"`
  - Result: pass, returned the API dashboard page with the documented workspace controls
  - `curl -fsS http://127.0.0.1:7890/ajax/api-dashboard/bootstrap?type=json`
  - Result: pass, returned the bootstrap payload JSON from the skill-prefixed ajax route
- Cleanup:
  - `docker compose -f ~/projects/skills/docker-compose.testing.yml run --rm perl-test bash -lc 'rm -rf /workspace/skills/api-dashboard/cover_db'`
  - Result: pass
