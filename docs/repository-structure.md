# 🗂️ Repository structure

This page describes the content that is committed to the repository. It is a point-in-time baseline (November 2026); the folders themselves are the authoritative source.

```text
.
├── .github/                    Workflows, issue and pull request templates, CODEOWNERS, Dependabot
├── .specify/
│   └── memory/
│       └── constitution.md     Project constitution
├── code/
│   └── utilities/
│       └── terraform_override.tf
├── docs/                       This documentation
├── modules/                    One folder per Azure or Microsoft service (27 modules)
├── .gitattributes
├── .gitignore
├── .pre-commit-config.yaml
├── .terraform-docs.yml
├── README.md                   Landing page with the module list
└── requirements.txt
```

## 📁 Folders

| Path | Role |
|------|------|
| `modules/` | The Terraform modules. Each module is a folder `modules/<name>/`; see [Module anatomy](module-anatomy.md) and the [Module catalog](module-catalog.md). |
| `docs/` | The documentation you are reading. See the [documentation index](README.md). |
| `code/utilities/` | Holds `terraform_override.tf`. The test workflow moves this file into the module under test before `terraform init` so that tests run with the pinned provider versions and provider configuration. |
| `.github/workflows/` | One test workflow per module (`terraform-<name>.yml`) and the reusable workflow `_terraformTestTemplate.yml` that they call. |
| `.github/` (other files) | Issue templates (`ISSUE_TEMPLATE/`), `PULL_REQUEST_TEMPLATE.md`, `CODEOWNERS`, `dependabot.yml` and `FUNDING.yml`. |
| `.specify/memory/` | Contains `constitution.md`, the project constitution with the principles and governance rules for the repository. |

## 📄 Root files

| File | Role |
|------|------|
| `README.md` | Landing page: purpose, what "secure by default" means and the list of modules. |
| `.terraform-docs.yml` | Configuration of terraform-docs, which generates the reference part of each module page. |
| `.pre-commit-config.yaml` | pre-commit hooks: file hygiene, JavaScript Object Notation (JSON) and YAML Ain't Markup Language (YAML) checks, terraform-docs regeneration and `terraform fmt`. |
| `requirements.txt` | Pins the `pre-commit` version used to run the hooks. |
| `.gitignore`, `.gitattributes` | Git ignore rules and line-ending normalization. |

> [!NOTE]
> The `archive/` folder is unmaintained and not authoritative; the constitution states that it is not governed by it. `.gitignore` excludes it (`/archive/*`), so it exists only in some local clones (where it holds old experiments, for example test configurations and a Bicep file) and is not part of the repository content.
