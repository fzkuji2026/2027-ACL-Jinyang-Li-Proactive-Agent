# Proactive Memory for Event-Driven LLM Agents

This repository contains the ACL review manuscript for Proactive Memory (ProactMem).

## Build

In Overleaf, select `0EPM.tex` as the main document and use pdfLaTeX. If importing updates into an existing project, update the main-document setting to this filename.

For a local build with TeX Live that refreshes both official PDF filenames:

```powershell
powershell.exe -NoProfile -File .\build_paper.ps1
```

To refresh the HCPM paper mirror at the same time:

```powershell
powershell.exe -NoProfile -File .\build_paper.ps1 -PaperMirror 'E:\Agent论文\HCPM\paper\current'
```

The script keeps compilation files in `build/`, then updates `0EPM.pdf` and `Proactive_Memory_for_Event_Driven_LLM_Agents.pdf` from the same successful build. The main text retains the method, benchmark, main results, within-series model table, cross-family radar panels, memory-hierarchy figure, validation ablations, and their analyses. Reference and episode diagnostics are introduced briefly in the main text and detailed in the appendix. Limitations, ethical considerations, references, and appendices are additional material, so venue-specific page accounting still needs to be checked.

## Naming and metrics

The method is ProactMem, a proactive memory framework. The three scopes are Sports, Home, and Code, sourced from HeartSteps, CASAS, and GH Archive, respectively. Scope renaming preserves the original event inventories and service tasks.

Event-level metrics use task-oriented names: relevance = precision; coverage = recall; effectiveness = F1; intrusion = false positive rate; balance = balanced accuracy. The frequency metric equals intervention event count / reference-positive event count = (TP + FP) / (TP + FN), using counts pooled across streams within each scope. It uses one post-controller decision per event; immediate and scheduled services are counted at the decision event. Tables display frequency (×) to two decimal places, calculated from integer counts. A value of 1× indicates equal counts; values above and below 1× indicate more and fewer interventions, respectively. This ratio describes relative volume alongside relevance, coverage, and intrusion and has no preference arrow. For a scope with zero reference positives, report frequency as N/A and provide intervention counts separately; missing or invalid predictions require separate reporting. Reference labels, confusion counts, and the other metric formulas remain unchanged. The main text introduces the supplementary diagnostics; the appendix gives episode coverage, supported relevance (SR), redundant intervention rate (RIR), matching rules, outcome counts, and detailed interpretations.

## Source organization

The main results table compares ProactMem with five external baselines. "Model comparison" contains the within-series model table, cross-family event-only radar panels, and scope-specific analysis. "Ablation study and memory analysis" contains the controlled memory-hierarchy figure, its analysis, and the validation and Code suppression table. Appendix C contains additional frequency, coverage, and intervention-count results; Appendix D contains reference and episode diagnostics. The abstract and Introduction report the strongest-external-baseline comparison. Claims remain bounded to event-level opportunity detection; episode coverage and repetition are reported separately.

- `0EPM.tex`: ACL review entry point, title, abstract, and section ordering.
- Numbered section files: main manuscript, limitations, and ethical considerations.
- `4bResultsAndAnalysis.tex`: main comparisons, model-comparison tables and radar panels, memory-hierarchy figure and validation ablations, and a brief introduction to supplementary diagnostics.
- `11Reproducibility.tex`: Appendices A-C: benchmark/annotation protocol, implementation and experimental configuration, and additional ablation and intervention control metrics.
- `10Appendix.tex`: Appendix D: reference sensitivity and label-anchored episode diagnostics, with combined score/count tables and detailed analysis.
- `9Reference.bib`: bibliography.
- `Fig_Intro_Scenario.pdf`: vector motivation scene used in the Introduction (Figure 1); observations and decisions are explicitly illustrative.
- `Fig_Intro_Scenario.tex`: editable TikZ source for the motivation scene; compile separately with pdfLaTeX to regenerate its PDF.
- `Fig1_EPM_Architecture_body.tex`: editable TikZ architecture figure, included directly by the manuscript.
- `Fig1_EPM_Architecture.tex`: standalone wrapper for exporting the architecture as a vector PDF.
- `Fig_Model_Sensitivity_Sports.svg`, `Fig_Model_Sensitivity_Home.svg`, and `Fig_Model_Sensitivity_Code.svg`: scope-specific radar sources; the manuscript uses their PNG exports with `Fig_Model_Sensitivity_Legend.png`. `Fig_Model_Sensitivity_Radar.svg` provides a combined preview.
- `Fig2_Memory_Hierarchy_body.tex`: editable vector proactive agent ablation, included in the main-text ablation section.
- `Fig3_Memory_Behavior_body.tex`: optional editable visualization of a recorded historical-event-to-decision trace; not included in the current manuscript.

Legacy template files or figures not referenced by `0EPM.tex` are not used in the ACL manuscript. Compilation caches, experiment artifacts, and internal revision notes are not part of the manuscript source update.

Figure numbers are assigned automatically: the Introduction scene is Figure 1, the architecture is Figure 2, the cross-family event-only comparison is Figure 3, and the proactive agent ablation is Figure 4. Both experimental figures appear in the main text. Existing architecture/hierarchy filenames are retained for compatibility.

## Workspace and version policy

This Overleaf checkout is the authoritative editing location. `E:\Agent论文\HCPM\paper\current` is a synchronized mirror, not a second editing branch. Earlier manuscript snapshots, retired graphics, and the approved preview are retained under `E:\Agent论文\HCPM\paper\archive\formal_manuscript_sync_20260929`; they are not inputs to the current build. Experiment outputs, frozen labels, and historical evidence are not modified by manuscript synchronization.

The appendix cleanup removes the standalone historical trace, the intervention-rate identity subsection, and repeated hierarchy scores. Extended validation results retain frequency and coverage and the controller's true-positive losses. It does not resolve provenance reconciliation, missing baseline budgets, episode-judge reliability, or the experimental effect of representation-dependent controller keys.
