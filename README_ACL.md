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

The script keeps compilation files in `build/`, then updates `0EPM.pdf` and `Proactive_Memory_for_Event_Driven_LLM_Agents.pdf` from the same successful build. The included ACL review and bibliography styles are unchanged. Core mechanism, model, reference-sensitivity, and episode analyses remain in the main text. The current main argument ends on page 8; limitations, ethical considerations, references, and appendices are additional material, so venue-specific page accounting still needs to be checked.

## Naming and metrics

The method is ProactMem, a proactive memory framework. The three scopes are Sports, Home, and Code, sourced from HeartSteps, CASAS, and GH Archive, respectively. Scope renaming preserves the original event inventories and service tasks.

Event-level metrics use task-oriented names: Relevance = precision; Coverage = recall; Effectiveness = F1; Balance = balanced accuracy. Formulas, reference labels, and retained scores remain unchanged. The main text reports ProactMem's episode-level diagnostic and its boundaries; the appendix gives Episode Coverage, Supported Relevance (SR), Redundant Intervention Rate (RIR), matching rules, and outcome counts.

## Source organization

The main results table compares ProactMem with five external baselines. "Ablation Study and Memory Analysis" reports the Event-only / Event+Daily / ProactMem memory hierarchy, daily validation, replay gating, and the Code suppression diagnostic. Figure 3 displays only the controlled memory-level variants. The abstract and Introduction report the strongest-external-baseline comparison. Claims remain bounded to event-level opportunity detection; episode coverage and repetition are reported separately.

- `0EPM.tex`: ACL review entry point, title, abstract, and section ordering.
- Numbered section files: main manuscript, limitations, and ethical considerations.
- `4bResultsAndAnalysis.tex`: main comparisons, memory and validation ablations, model sensitivity, reference sensitivity, and ProactMem episode diagnosis.
- `11Reproducibility.tex`: Appendices A-C: benchmark/annotation protocol, implementation and experimental configuration, and additional ablation/controller metrics.
- `10Appendix.tex`: Appendix D: reference sensitivity and label-anchored episode diagnostics, with combined score/count tables. Key results and interpretations remain in the main text.
- `9Reference.bib`: bibliography.
- `Fig_Intro_Scenario.pdf`: vector motivation scene used in the Introduction (Figure 1); observations and decisions are explicitly illustrative.
- `Fig_Intro_Scenario.tex`: editable TikZ source for the motivation scene; compile separately with pdfLaTeX to regenerate its PDF.
- `Fig1_EPM_Architecture_body.tex`: editable TikZ architecture figure, included directly by the manuscript.
- `Fig1_EPM_Architecture.tex`: standalone wrapper for exporting the architecture as a vector PDF.
- `Fig2_Memory_Hierarchy_body.tex`: editable vector memory-level ablation, included directly in the main paper.
- `Fig3_Memory_Behavior_body.tex`: optional editable visualization of a recorded historical-event-to-decision trace; not included in the current manuscript.

Legacy template files or figures not referenced by `0EPM.tex` are not used in the ACL manuscript. Compilation caches, experiment artifacts, and internal revision notes are not part of the manuscript source update.

Figure numbers are assigned automatically: the Introduction scene is Figure 1, the architecture is Figure 2, and the memory-level ablation is Figure 3. Existing architecture/hierarchy filenames are retained for compatibility.

## Workspace and version policy

This Overleaf checkout is the authoritative editing location. `E:\Agent论文\HCPM\paper\current` is a synchronized mirror, not a second editing branch. Earlier manuscript snapshots, retired graphics, and the approved preview are retained under `E:\Agent论文\HCPM\paper\archive\formal_manuscript_sync_20260929`; they are not inputs to the current build. Experiment outputs, frozen labels, and historical evidence are not modified by manuscript synchronization.

The appendix cleanup removes the standalone historical trace, the intervention-rate identity subsection, and repeated hierarchy scores. Extended validation results retain IR/Coverage and the controller's true-positive losses. It does not resolve provenance reconciliation, missing baseline budgets, episode-judge reliability, or the experimental effect of representation-dependent controller keys.
