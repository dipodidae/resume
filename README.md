# Resume

Resume as Code using [YAMLResume](https://yamlresume.dev/).

## Prerequisites

- [Node.js](https://nodejs.org/) 20+
- [pnpm](https://pnpm.io/)
- [XeTeX](https://tug.org/xetex/) or [Tectonic](https://tectonic-typesetting.github.io/) (for PDF generation)

Or just [Docker](https://www.docker.com/) — no local LaTeX needed.

## Setup

```bash
pnpm install
```

## Usage

```bash
make build          # Validate + build → dist/
make dev            # Watch mode (live rebuild on save)
make validate       # Schema validation only
make clean          # Remove all generated files
make doctor         # Check environment dependencies
```

### Docker (no local LaTeX)

```bash
make docker-build
```

### Multiple variants

```bash
make build FILE=resume.frontend
make build FILE=resume.lead
```

## Output

Build artifacts go to `dist/`:

```
dist/
├── resume.pdf
├── resume.tex
├── resume.md
└── resume.html
```

## CI

Push to `main` triggers a GitHub Actions workflow that validates, builds, and uploads artifacts automatically.
# resume
