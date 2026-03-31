# AGENTS.md — Coding Agent Instructions

This is a **Resume-as-Code** project. The entire resume is a single YAML file
(`resume.yml`) validated against a published JSON Schema and built into HTML,
Markdown, LaTeX, and PDF outputs by the `yamlresume` CLI tool.

There is **no application source code** — no TypeScript, no React/Vue/Next.js,
no test suite. Agents working here are editing content and configuration, not
writing software.

---

## Project Layout

```
resume.yml                  # Single source of truth — all resume content + layout config
Makefile                    # Primary task runner (Make, not npm scripts)
package.json                # Thin shim; scripts delegate to Make
pnpm-lock.yaml              # Lockfile — do not edit manually
dist/                       # Generated output (gitignored); created by `make build`
  resume.pdf
  resume.html
  resume.md
  resume.tex
.github/workflows/resume.yml  # CI: builds on push to main via yamlresume/action@v0.2.1
```

---

## Package Manager

**pnpm** — always use `pnpm` for dependency operations, never `npm` or `yarn`.

Node.js version is pinned to **20** in `.nvmrc` and enforced via
`"engines": { "node": ">=20" }` in `package.json`.

---

## Commands

All meaningful commands go through **Make**. The `pnpm run <script>` aliases
exist but are thin wrappers — prefer `make` directly.

| Task | Command |
|---|---|
| Validate YAML schema | `make validate` |
| Build all formats (PDF, HTML, MD, TeX) | `make build` |
| Watch mode (live rebuild on save) | `make dev` |
| Remove all generated files | `make clean` |
| Check environment / dependencies | `make doctor` |
| Build without local LaTeX (Docker) | `make docker-build` |

**Building a different YAML file** (e.g. a role-specific variant):

```bash
make build FILE=resume.frontend
make validate FILE=resume.frontend
```

The `FILE` variable defaults to `resume`. It strips the `.yml` extension
automatically — pass the basename only.

**There is no test command.** Validation (`make validate`) is the closest
equivalent; it runs JSON Schema validation against
`https://yamlresume.dev/schema.json`.

---

## Validation

Always run `make validate` before `make build`. The build target already calls
`validate` as a prerequisite, but running it independently gives faster
feedback on schema errors without triggering the PDF/LaTeX pipeline.

```bash
make validate          # Fast — schema-only check, no PDF generation
make build             # Slower — validates then generates all output formats
```

---

## Editing `resume.yml`

`resume.yml` is the only file that normally needs editing. Its structure:

```
# yaml-language-server: $schema=https://yamlresume.dev/schema.json
---
content:
  basics:      # Personal info, headline, summary
  location:    # City and country
  work:        # Work history (reverse chronological)
  projects:    # Side projects / open source
  education:   # Academic history
  skills:      # Skill groups with keywords
  languages:   # Spoken languages and fluency
  interests:   # Personal interests

locale:
  language: en

layouts:       # Rendering configuration per output format
  - engine: html
  - engine: markdown
  - engine: latex
```

### YAML Style Rules

- **Schema hint must stay** on line 1:
  `# yaml-language-server: $schema=https://yamlresume.dev/schema.json`
- Key names are **camelCase** (`startDate`, `endDate`, `firstName`).
- Multi-line text uses YAML **literal block scalars** (`|`), not folded (`>`).
  Each bullet within a summary block is a `- ` prefixed line.
- Dates are written in **human-readable form**: `Sep 1, 2015` (not ISO 8601).
- An **omitted/blank `endDate`** means the role is current/ongoing:
  ```yaml
  endDate:        # blank = present
  ```
- Do not quote values unless YAML requires it (special characters, reserved
  words, leading colons, etc.).
- Use 2-space indentation throughout.
- `keywords` lists are block sequences (dash-prefixed), one item per line.

### Content Guidelines

- `summary` fields under `work` entries use markdown-style bullet lists
  (`- item`) inside a YAML literal block scalar.
- Keep bullets concise — action verb + outcome/metric where possible.
- `keywords` under a work entry are rendered as a skill tag list; keep them
  short (1–3 words each).
- Skill `level` values: `Beginner`, `Intermediate`, `Advanced`, `Expert`.
- Language `fluency` values should match standard proficiency descriptors
  (e.g. `Native or Bilingual Proficiency`, `Full Professional Proficiency`).

---

## Layout Configuration (in `resume.yml`)

Rendering templates and typography are declared inside `resume.yml` under
`layouts:`, not in separate config files.

```yaml
layouts:
  - engine: html
    template: calm
    typography:
      fontSize: 16px
  - engine: markdown
  - engine: latex
    page:
      margins:
        top: 2.5cm
        left: 1.5cm
        right: 1.5cm
        bottom: 2.5cm
      showPageNumbers: true
    template: moderncv-banking
    typography:
      fontSize: 11pt
```

Consult `pnpm yamlresume --help` or `https://yamlresume.dev` for available
templates and layout options.

---

## CI / GitHub Actions

The workflow at `.github/workflows/resume.yml` runs on every push to `main`
and on manual dispatch. It uses the official `yamlresume/action@v0.2.1` action,
which bundles its own LaTeX environment — no local LaTeX installation is
needed in CI. Build artifacts (PDF, HTML, MD) are uploaded with a 7-day
retention window and are **not committed to the repository**.

Local PDF generation requires **XeTeX** or **Tectonic** to be installed.
Use `make doctor` to verify the environment, or use `make docker-build` to
avoid the requirement entirely.

---

## Installing Dependencies

```bash
pnpm install          # Install / restore node_modules from lockfile
```

Do not run `pnpm install` unless `node_modules` is missing or `package.json`
has changed. Never edit `pnpm-lock.yaml` by hand.

---

## No Linter / No Formatter

There is no ESLint, Prettier, Biome, or other code formatter configured.
YAML correctness is enforced solely by the schema validation step
(`make validate`). Maintain consistent style manually as described above.
