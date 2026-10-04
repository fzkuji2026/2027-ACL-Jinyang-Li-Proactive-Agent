# Figure versions

Archived versions of Figure 1 (introduction scenario) and Figure 2 (ProactMem architecture).
Each folder holds an editable TikZ source, the compiled vector PDF, and a PNG preview.
The manuscript uses only the root-level figure files; nothing here is an input to `0EPM.tex`.

Compile any version with pdfLaTeX from inside its folder:
`pdflatex Fig_Intro_Scenario.tex` or `pdflatex Fig1_EPM_Architecture.tex`.

## Figure 1: introduction scenario (`fig1_intro/`)

| Folder | Source commit | Description |
| --- | --- | --- |
| `v0_original` | `2673fcf` | Original two-column scene: event-only agent vs. agent with ProactMem, cartoon figures. |
| `v1_original_main_update` | `6c36a7d` | The same design as revised on `main` (query / retrieve / decide steps, new terminology). |
| `v2_flat_initial` | `d59703e` | First single-column flat version for page 1 (the canvas "Before" board). |
| `v3_flat_refined_current` | current | Refined flat version with Event / Trajectory / Regularity layers; used in the paper. |

`page1_preview.png` shows the current version on page 1.

## Figure 2: architecture (`fig2_architecture/`)

| Folder | Source commit | Description |
| --- | --- | --- |
| `v0_original` | `6c36a7d` | Original outlined-box architecture from `main`. |
| `v1_simple_flat` | `6194285` | Flat three-column version (construction, memory, decision) without example insets. |
| `v2_insets_current` | current | Flat version with walking-example insets for source check, replay gate, and retrieval; used in the paper. |

Each Figure 2 folder contains the body file (`Fig1_EPM_Architecture_body.tex`), which the paper inputs directly, and the standalone wrapper (`Fig1_EPM_Architecture.tex`).
To switch the paper to another version, copy that folder's body file over the root-level `Fig1_EPM_Architecture_body.tex`.
`page3_preview.png` shows the current version on page 3.
