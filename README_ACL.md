# Proactive Memory for Event-Driven LLM Agents

This repository contains the ACL review manuscript for Proactive Memory (ProactMem).

## Build

In Overleaf, select `0HCPM.tex` as the main document and use pdfLaTeX. The existing entry-point filename is retained for compatibility with the project's settings.

For a local build with TeX Live:

```sh
latexmk -pdf -interaction=nonstopmode -halt-on-error 0HCPM.tex
```

The manuscript uses the included ACL review style and bibliography style. This completeness-first revision restores the core mechanism, model, label-review, and episode analyses to the main text, which currently reaches page twelve. The eight-page limit is intentionally deferred; limitations, ethical considerations, references, and appendices follow the complete main argument. A submission-length layout will require a subsequent compression pass.

## Naming and metrics

The method is ProactMem, a proactive memory framework. The three scopes are Sports, Home, and Code, sourced from HeartSteps, CASAS, and GH Archive, respectively. Scope renaming preserves the original event inventories and service tasks.

Event-level metrics use task-oriented names: Relevance = precision; Coverage = recall; Effectiveness = F1; Balance = balanced accuracy. Formulas, reference labels, and scores remain unchanged. Episode Coverage, Supported Relevance (SR), and Redundant Intervention Rate (RIR) are defined with the paired diagnostic in the main text; detailed matching rules and outcome counts remain in the appendix.

## Source organization

The main results table compares ProactMem with five external baselines. CSM is an in-house recursive-summary control, documented and evaluated separately in "Comparison with Recursive Summarization." Its full-scope scores and appendix diagnostics are retained. The abstract and Introduction report the strongest-external-baseline comparison, while the CSM analysis uses its separate comparison table.

- `0HCPM.tex`: ACL review entry point, title, abstract, and section ordering.
- Numbered section files: main manuscript, limitations, and ethical considerations.
- `4bResultsAndAnalysis.tex`: main comparisons, ablations, recursive-summary control, memory-construction statistics, decision timeline, retrieval/model sensitivity, paired label review, and episode diagnosis.
- `10Appendix.tex`: detailed construction accounting, source-linked case records, review sampling and confusion counts, and episode matching/boundary cases. Key results and their interpretations are in the main text.
- `11Reproducibility.tex`: implementation details, benchmark protocol, experimental settings, and complete ablation tables.
- `9Reference.bib`: bibliography.
- `Fig_Intro_Scenario.pdf`: vector motivation scene used in the Introduction (Figure 1); observations and decisions are explicitly illustrative.
- `Fig_Intro_Scenario.tex`: editable TikZ source for the motivation scene; compile separately with pdfLaTeX to regenerate its PDF.
- `Fig1_EPM_Architecture_body.tex`: editable TikZ architecture figure, included directly by the manuscript.
- `Fig1_EPM_Architecture.tex`: standalone wrapper for exporting the architecture as a vector PDF.
- `Fig2_Memory_Hierarchy_body.tex`: editable vector comparison of Effectiveness and FPR across the three memory levels, included directly in the main paper.
- `Fig3_Memory_Behavior_body.tex`: editable vector visualization of stage-specific availability and a recorded historical-event-to-decision trace.

Legacy template files or figures not referenced by `0HCPM.tex` are not used in the ACL manuscript. Compilation caches, experiment artifacts, and internal revision notes are not part of the manuscript source update.

Figure numbers are assigned automatically: the Introduction scene is Figure 1, the architecture is Figure 2, the memory-hierarchy comparison is Figure 3, and memory availability/decision behavior is Figure 4. Existing architecture/hierarchy filenames are retained for compatibility.
