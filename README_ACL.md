# Proactive Memory for Event-Driven LLM Agents

This repository contains the ACL review manuscript for Proactive Evidence Memory (ProEviMem).

## Build

In Overleaf, select `0HCPM.tex` as the main document and use pdfLaTeX. The existing entry-point filename is retained for compatibility with the project's settings.

For a local build with TeX Live:

```sh
latexmk -pdf -interaction=nonstopmode -halt-on-error 0HCPM.tex
```

The manuscript uses the included ACL review style and bibliography style. The current layout contains eight pages of main content, followed by limitations, ethical considerations, references, and appendices.

## Source organization

- `0HCPM.tex`: ACL review entry point, title, abstract, and section ordering.
- Numbered section files: main manuscript, limitations, and ethical considerations.
- `10Appendix.tex`: extended model comparisons, construction audits, and cases.
- `11Reproducibility.tex`: implementation details, benchmark protocol, experimental settings, and complete ablation tables.
- `9Reference.bib`: bibliography.
- `Fig1_EPM_Architecture_body.tex`: editable TikZ architecture figure, included directly by the manuscript.
- `Fig1_EPM_Architecture.tex`: standalone wrapper for exporting the architecture as a vector PDF.

Legacy template files or figures not referenced by `0HCPM.tex` are not used in the ACL manuscript. Compilation caches, experiment artifacts, and internal revision notes are not part of the manuscript source update.
