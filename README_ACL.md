# Proactive Memory for Event-Driven LLM Agents

This repository contains the ACL review manuscript for Proactive Evidence Memory (ProEviMem).

## Build

In Overleaf, select `0HCPM.tex` as the main document and use pdfLaTeX. The existing entry-point filename is retained for compatibility with the project's settings.

For a local build with TeX Live:

```sh
latexmk -pdf -interaction=nonstopmode -halt-on-error 0HCPM.tex
```

The manuscript uses the included ACL review style and bibliography style. With the Introduction scene included at a readable full-width size, the main content currently extends to page nine; limitations, ethical considerations, references, and appendices follow. The complete PDF has 20 pages. An eight-page submission layout requires a subsequent compression pass.

## Source organization

- `0HCPM.tex`: ACL review entry point, title, abstract, and section ordering.
- Numbered section files: main manuscript, limitations, and ethical considerations.
- `10Appendix.tex`: extended model comparisons, construction audits, and cases.
- `11Reproducibility.tex`: implementation details, benchmark protocol, experimental settings, and complete ablation tables.
- `9Reference.bib`: bibliography.
- `Fig_Intro_Scenario.pdf`: vector motivation scene used in the Introduction (Figure 1); observations and decisions are explicitly illustrative.
- `Fig_Intro_Scenario.tex`: editable TikZ source for the motivation scene; compile separately with pdfLaTeX to regenerate its PDF.
- `Fig1_EPM_Architecture_body.tex`: editable TikZ architecture figure, included directly by the manuscript.
- `Fig1_EPM_Architecture.tex`: standalone wrapper for exporting the architecture as a vector PDF.
- `Fig2_Memory_Hierarchy_body.tex`: editable vector comparison of IS and FPR across the three memory levels, included directly in the main paper.

Legacy template files or figures not referenced by `0HCPM.tex` are not used in the ACL manuscript. Compilation caches, experiment artifacts, and internal revision notes are not part of the manuscript source update.

Figure numbers are assigned automatically: the Introduction scene is Figure 1, the architecture is Figure 2, and the memory-hierarchy comparison is Figure 3. Existing architecture/hierarchy filenames are retained for compatibility.
