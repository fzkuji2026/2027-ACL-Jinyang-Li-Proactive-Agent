# Proactive Memory for Event-Driven LLM Agents

## Abstract

- Proactive LLM agents use ongoing observations and accumulated history to identify timely service opportunities.
- Existing approaches emphasize recent context or retrieval of related memories, providing limited support for validating recurring behavioral regularities and assessing their applicability to the current event.
- Proactive Memory (ProactMem) combines bounded recent events, source-checked temporal trajectories, and replay-assessed behavioral regularities.
- trajectory validation checks extracted facts against source events; historical replay assesses recurring support; retrieval selects regularities applicable to the current event.
- ProactiveStream evaluates chronological decisions across three service scopes with isolated streams and episode-aware opportunity labels.
- On ProactiveStream, ProactMem achieves an overall effectiveness (F1) of 52.6%, a 21.4% relative improvement over the strongest of five external baselines. Overall effectiveness pools event-level confusion counts across all streams and scopes.

---

## 1. Introduction

1. **Proactive service over event streams**
   - Agents in activity support, smart homes, and software collaboration assess whether an evolving situation warrants assistance before an explicit request.
   - Useful decisions can depend on observations beyond the recent-event window.
   - An illustrative Sports scenario shows how earlier walking observations can inform a timely activity suggestion.

2. **From historical observations to applicable evidence**
   - Agent memory systems retain observations, consolidate experience, and retrieve related information.
   - Proactive decisions require source-supported abstractions, recurring historical support, and evidence relevant to the present situation.
   - The central question is how to turn longitudinal history into reliable, currently applicable context for proactive service decisions.

3. **Proposed approach**
   - event memory preserves bounded recent observations.
   - temporal trajectory memory retains source-checked trajectory abstractions.
   - behavioral regularity memory consolidates recurring conditions and assesses their historical support through replay.
   - The decision LLM combines these representations with current observations to assess concrete, timely, feasible, low-risk assistance.
   - Intervention control tracks prior interventions and filters repeated proposals.

4. **Contributions**
   - A hierarchical framework combining trajectory source checking, replay-based regularity assessment, and current-applicability selection for proactive decisions.
   - ProactiveStream supports longitudinal evaluation of memory formation and repeated service decisions across three scopes, preserving causal history, entity isolation, and episode-aware reference opportunities.
   - ProactMem uses long-term behavioral context to identify service opportunities missed by recent events alone and support more selective intervention decisions.

---

## 2. Problem formulation

- Each participant, household, or repository defines an isolated, chronologically ordered public event stream.
- For each incoming event, the agent produces an `Intervene` or `Abstain` decision and an optional evidence-grounded service message.
- Decisions use the current public event and causally available same-entity state.
- State updates occur after the output is finalized, so maintenance incorporating the current event affects subsequent decisions.
- The objective is to identify timely, actionable service opportunities supported by current observations or prior same-entity history.
- Evaluation uses fixed reference decisions under the annotation protocol; reference labels and annotation metadata remain evaluator-private.

---

## 3. Proactive Memory (ProactMem)

### 3.1 Memory construction and update

- Service opportunities can depend on both recent changes and recurring behavior, motivating a hierarchy that preserves fine-grained evidence while validating longer-term abstractions.

1. **bounded event memory**
   - Preserve recent observations at their original granularity within bounded context, motivated by evidence-utilization limitations in long inputs (Liu et al., 2024).
   - Retains up to 99 prior events within the preceding 72 hours, alongside the current event.
   - Preserves events in their original public representation.
   - An independent daily buffer collects all committed events from the open local day for trajectory construction.

2. **fact-validated temporal trajectory memory**
   - Retain activity context beyond the recent window while keeping temporal abstractions traceable through source-level fact validation.
   - After a local day closes, a construction LLM extracts trajectory segments with intervals, typed facts, and source-event citations.
   - Validation checks entity consistency, intervals, resolved citations, and canonicalized scalar values at compatible field paths.
   - Source-consistency checks apply to typed evidence; semantic assessment of accompanying free text requires additional evaluation.
   - Accepted trajectories retain context beyond the recent-event window and remain available during the current construction cycle.

3. **replay-assessed behavioral regularity memory**
   - Ground behavioral expectations in observed recurrence through historical replay and update eligibility as evidence accumulates.
   - Consolidation operates on seven completed daily records per entity; a cycle can span more than seven calendar days.
   - Proposed regularities specify triggers, expected behavior, temporal windows, optional weekday restrictions, and source daily records.
   - Replay counts fulfilled and violated observable days, censors missing observations, and excludes inapplicable days.
   - Activation requires at least three fulfilled days, replay confidence of at least 0.5, and lift of at least 1.0.
   - Later observations update confidence and lifecycle eligibility.
   - Historical support, current applicability, and present service value are assessed separately.

### 3.2 Memory retrieval and selection

- Match accumulated regularities to the present service opportunity through trigger, temporal-applicability, and occurrence-state checks.
- event memory supplies the bounded recent sequence, and temporal trajectory memory supplies completed trajectories from the current cycle.
- Regularity selection checks entity-local trigger context, weekday restrictions, temporal applicability, and occurrence state.
- Matching uses current and previously recorded causal triggers with a 30-minute lead and grace interval.
- Fulfilled and censored occurrences are excluded from selection.
- Up to three eligible regularities are ranked by occurrence state, lifecycle priority, confidence, and temporal distance.

### 3.3 Proactive decision

- Combine current needs with historical context to assess service value and track prior coverage of the opportunity (Yang et al., 2025).
- The decision context combines the current event, recent events, temporal trajectories, selected regularities, and observable service-episode state.
- The LLM proposes assistance when current observations or historical context support a concrete, timely, feasible, low-risk service.
- A matching historical regularity supplies evidence; the LLM retains the option to abstain.
- The intervention controller compares proposed services with prior allowed interventions and suppresses duplicates.
- Changes in opportunity state, service identity, contextual regularities, or local day permit renewed assessment.
- Each method applies the controller policy to its own context and intervention history.
- Execution proceeds through prior-memory preparation, current-event staging, context selection, proposal, finalization, and event commitment.

---

## 4. ProactiveStream benchmark

### 4.1 Scopes and public events

| Scope | Primary source | Isolated entity | Streams | Public events | Temporal coverage | Reference interventions |
| --- | --- | --- | ---: | ---: | --- | ---: |
| Sports | HeartSteps | Participant | 9 | 1,456 | 367 observed participant-days | 365 |
| Home | CASAS | Home | 4 | 1,624 | 14 consecutive days per home | 190 |
| Code | GH Archive | Repository | 4 | 1,459 | Longitudinal repository histories | 174 |
| **Total** | Three scopes | Isolated stream | **17** | **4,539** | Three longitudinal settings | **729** |

- **Sports:** optional walking and everyday physical-activity assistance from participant activity and availability contexts.
- **Home:** gentle, low-risk check-ins from sensor segments available at interval closure.
- **Code:** low-risk triage, review, and maintenance from native repository events, with one decision per event.
- Public inputs contain contemporaneously available observations with the same scope-specific schema across label classes.
- Results are reported separately for each scope using event-level decisions.

### 4.2 Reference labels and causal replay

- Annotators assess each event together with its complete prior same-stream history.
- A positive label requires a concrete service opportunity supported by the current event or history, together with reference-episode novelty.
- The first reliable actionable window receives `Intervene`; covered windows receive `Abstain`. Stronger support, changed service, or a reopened episode can create a renewed opportunity.
- Reference novelty follows the reference opportunity sequence independently of model outputs.
- LLM-assisted screening prioritizes candidate opportunities. Three team members independently label every event while blinded to evaluated-system outputs, followed by cross-review and adjudication.
- Main comparisons use labels, prompts, memory bounds, and validation settings frozen before the corresponding runs.
- Each stream starts from empty method state and includes its initial events in scoring. Labels are joined after inference.

---

## 5. Experimental evaluation

- **RQ1:** How does ProactMem compare with external methods on event-level opportunity detection?
- **RQ2:** How does model choice affect proactive decision quality within and across model families?
- **RQ3:** How do memory organization, trajectory fact validation, and replay gating affect decision quality?

### 5.1 Experimental settings

#### Baselines

- **ProactiveAgent:** released evaluation prompt and proposal-or-null output contract, with causal history of events and decisions capped at 1,000 events.
- **ContextAgent:** in-context proactive-service judgment adapted to public event representations.
- **Mem0:** extraction, consolidation, and retrieval of same-entity memories.
- **A-MEM:** linked notes, association updates, and relevant-note retrieval.
- **Graphiti:** temporal relations and same-stream fact retrieval.

#### Metrics

- **relevance:** precision of interventions against reference opportunities.
- **coverage:** recall of reference opportunities.
- **effectiveness:** F1, the harmonic mean of relevance and coverage.
- **intrusion:** the fraction of reference negatives receiving interventions.
- **balance:** balanced accuracy, averaging coverage and the correct-silence rate.
- **frequency:** intervention-to-reference-positive event count ratio, `(TP + FP) / (TP + FN)`, pooling counts across streams within each scope. Reported to two decimal places as frequency (×). A value of 1× indicates equal counts; larger and smaller values indicate more and fewer interventions, respectively.
- Scores use one post-controller decision per event; immediate and scheduled services both count as `Intervene` at the decision event.
- Higher scores are preferred for relevance, coverage, effectiveness, and balance; lower intrusion is preferred. This ratio describes relative intervention volume and is interpreted alongside relevance, coverage, and intrusion.

#### Implementation

- The primary model is `gpt-5.6-luna`, with temperature zero and thinking disabled; ProactMem uses the official OpenAI API.
- Methods share task semantics, scope-specific references, and the intervention controller policy, with method-specific prompts, retrieval interfaces, and computational budgets.
- event-only, event and trajectory memory, and ProactMem share the decision prompt, output schema, and context bound of 72 hours and at most 100 events.
- A-MEM and Graphiti augment the bounded event context with their memory representations.
- ProactMem first applies semantic screening to each current event: accepted `skip` results yield `abstain`, while `escalate` results proceed to full contextual assessment followed by intervention control.
- Decision and memory-construction calls have separate roles and output budgets.

### 5.2 Main results

- Compare proactive-service and memory-based agents on ProactiveStream using the same Luna backbone and intervention controller policy.

1. **Comparisons with external methods.**
   - ProactMem achieves higher effectiveness and balance than all evaluated external methods in every scope.

2. **Supplementary diagnostics**
   - Reference-sensitivity and episode-level analyses examine label variation, opportunity coverage, and repeated interventions on a separate 450-target sample; detailed results appear in Appendix D.

### 5.3 Model comparison

1. **Within-series model scaling**
   - Construction and decision LLMs change together across GPT-5.6 Luna, GPT-5.6 Terra, and GPT-5.6 Sol, with the benchmark, architecture, role-specific prompts, decoding, validation thresholds, and controller policy fixed.
   - The comparison shows that effectiveness increases and intrusion decreases from GPT-5.6 Luna through GPT-5.6 Terra to GPT-5.6 Sol in every scope.
   - These gains are consistent with stronger abilities to extract task-relevant details, induce conditional behavioral regularities, and perform compositional reasoning over temporal evidence, supporting more accurate memory construction and more selective intervention.
   - The hierarchical memory architecture engages these abilities in both historical representation and current decision-making.
   - Controlled component ablations use GPT-5.6 Luna.

2. **Cross-family event-only comparison**
   - Compare GPT-5.6 Luna, Gemini 3.8 Flash, DeepSeek V4 Flash, and GLM 5.3 Flash on two selected complete event streams per scope under shared task instructions, bounded event context, and intervention control policy.
   - The figure caption marks selected streams; Appendix B provides stream identities, event counts, the selection rule, and shared settings.
   - Main-text radar panels report relevance, coverage, effectiveness, specificity, and balance for each scope.
   - On Sports, Gemini and Luna share the highest coverage; Gemini leads the remaining metrics.
   - On Home and Code, Gemini leads in effectiveness, while Luna recovers more opportunities and achieves higher balance.
   - DeepSeek and GLM have higher specificity and lower coverage than Luna in Home and Code.
   - The scope-specific profiles reveal different trade-offs between opportunity recovery and correct silence.

### 5.4 Ablation study and memory analysis

1. **Proactive agent ablation**
   - event-only supplies current and bounded recent events; the event and trajectory memory variant adds source-checked temporal trajectories; ProactMem further adds behavioral regularities.
   - The main-text memory-hierarchy figure compares variants sharing Luna, decision prompt, schema, event bound, and controller policy.
   - Representation-dependent controller keys make this a memory-layer comparison within the implemented pipeline.
   - Temporal trajectories recover more opportunities, most on Code, with unchanged false-positive counts on Sports and Home and more false positives on Code.
   - Behavioral regularities further improve effectiveness in every scope, recovering more opportunities with fewer false interventions.
   - Trajectory abstraction expands context; supported, currently applicable regularities improve selectivity.

2. **Validation mechanisms**
   - **w/o replay gate:** bypasses activation thresholds for well-formed, source-linked, online-reconstructable candidates while retaining current-applicability matching.
   - **w/o trajectory validation:** stores schema-valid, same-entity trajectory extractions without fact checking while retaining temporal construction and replay.
   - Both removals reduce relevance and effectiveness.
   - Replay gating yields the larger effectiveness contribution and improves coverage in all three scopes.
   - On Code, trajectory validation yields fewer false interventions while retaining the same true-positive count.

3. **Intervention control**
   - The Code diagnostic scores recorded proposals before suppression while holding subsequent states and decisions fixed.
   - Suppression removes more false-positive than true-positive proposals.
   - Suppression yields higher relevance and effectiveness alongside lower coverage.

---

## 6. Related work

1. **Agent memory and long-horizon retrieval**
   - Observation storage, reflection, tiered context management, extracted memories, linked notes, and graph-based retrieval.
   - ProactMem connects trajectory abstraction, historical regularity assessment, and current-event matching.

2. **Proactive decision and memory**
   - Task proposals, latent-need detection, context-based service judgment, and proactive memory use in reasoning and execution.
   - ProactMem focuses on constructing service-relevant temporal memory for event-driven decisions.

3. **Evaluation of proactive service**
   - Long-term conversational memory benchmarks, proactive-agent evaluations, and notification-timing research.
   - ProactiveStream evaluates sequential decisions as agents accumulate memory within isolated causal streams, using episode-aware references for intervention timing.

---

## 7. Conclusion

- ProactMem combines bounded recent events, source-checked temporal trajectories, and replay-assessed behavioral regularities.
- Across the three ProactiveStream scopes, it achieves higher event-level effectiveness and balance than the evaluated external baselines.
- Ablations support hierarchical organization, trajectory fact validation, and historical replay gating.
- The findings highlight the value of matching source-grounded, historically supported memory to current observations for service-opportunity detection.

---

## Limitations

- The benchmark covers low-risk service settings in Sports, Home, and Code under a protocol fixed after joint method and benchmark development.
- Independent held-out evaluation and cross-family model transfer require further study.
- Reference-sensitivity analysis covers three selected streams; episode diagnostics depend on reconstructed opportunities and semantic matching.
- The fixed-state Code suppression diagnostic characterizes recorded proposals. Evaluating controller-free behavior requires a sequential comparison.
- Historical replay measures observed recurrence; prospective validity under changing behavior requires further evaluation.
- Recipient benefit, interruption burden, end-to-end cost, and deployment safety require prospective measurements.

---

## Ethical considerations

- The evaluated services concern optional activity support, gentle check-ins, and low-risk repository assistance.
- Medical and high-risk safety decisions require domain-specific validation and safeguards.
- Stream isolation and evaluator-private annotations define the inference information boundary.
- Longitudinal events and derived memories require access controls, retention protections, data minimization, and respect for source permissions.
- Deployment should provide informed opt-in, memory inspection and correction, deletion, retention control, and an option to disable proactive assistance.
- Consequential actions require separate authorization; deployment safeguards require implementation and evaluation.

---

## Appendix

### A. Benchmark and annotation protocol

- Source datasets, public fields, preprocessing, event availability, and entity isolation.
- Opportunity-label semantics, independent annotation, adjudication, and chronological replay.

### B. Implementation and experimental configuration

- Daily buffering, typed-evidence checks, replay counting, and construction cycles.
- Regularity lifecycle transitions, current matching, and top-three selection.
- Intervention control: scope-specific opportunity identity, duplicate suppression, and re-entry conditions.
- External-method interfaces, model settings, role-specific budgets, and metric definitions.
- Cross-family event-only selection: two complete streams per scope, ranked by SHA256 of the fixed seed, domain, and public stream identifier. Sports uses HeartSteps participants 05 and 35 (184 and 191 events); Home uses CASAS homes 0004 and 0003 (406 events each); Code uses Unitech/pm2 and thephpleague/commonmark (365 and 347 events).
- Shared cross-family settings: chronological replay from empty state, scope-specific task prompts, the intersection of a 72-hour window and at most 100 events including the current event, intervention control, temperature zero, requested disabled thinking, and output limits of 256 tokens for Sports and Home and 512 for Code.

### C. Additional ablation and intervention control results

- Additional frequency and coverage scores for the validation ablations.
- Expanded Code suppression results and aggregate true-positive increments across memory levels.

### D. Reference and episode diagnostics

- A separate three-reviewer team reviews 450 targets: 150 consecutive events from one stream per scope, selected by a fixed SHA256 rule using public metadata.
- Each target segment has at least seven days of preceding history, and its complete causal prefix is processed.
- Reviewers independently label the targets with evaluated-system outputs hidden and discuss judgments to form consensus references.
- Fixed outputs from separate diagnostic runs are scored against earlier and reviewed references for these targets.
- Rescoring against the separate-team references yields similar effectiveness on Sports and lower effectiveness on Home and Code relative to the earlier references.
- A post-hoc, model-assisted diagnostic on the same targets reconstructs goal-and-object episodes from positive event anchors.
- Episode coverage is highest on Home and lowest on Code; the share of redundant interventions is highest on Home and lowest on Sports.
- Episode construction, matching order, follow-up classification, and intended service-time assessment.
- Episode coverage, supported relevance, redundant intervention rate, and counts of unmatched, late, and unresolved outputs.
