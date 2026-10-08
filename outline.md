# Proactive Memory for Event-Driven LLM Agents

## Abstract

- Proactive LLM agents use ongoing observations and accumulated history to identify timely service opportunities.
- Existing approaches emphasize recent context or retrieval of related memories, providing limited support for validating recurring behavioral regularities and assessing their applicability to the current event.
- Proactive Memory (ProactMem) combines bounded recent events, source-checked temporal trajectories, and replay-assessed behavioral regularities.
- Trajectory validation checks extracted facts against source events; historical replay assesses recurring support before regularities are matched to current events.
- ProactiveStream evaluates chronological decisions across three service scopes with isolated streams and episode-aware opportunity labels.
- On ProactiveStream, ProactMem achieves an overall effectiveness (F1) of 52.6%, a 21.4% relative improvement over the strongest of five external baselines. Overall effectiveness pools event-level confusion counts across all streams and scopes.

---

## 1. Introduction

1. **From task execution to proactive assistance**

   - LLM agents extend task execution toward identifying service opportunities from ongoing observations and accumulated history.
   - Activity support, smart homes, and software collaboration require recognizing new needs, selecting relevant historical evidence, and tracking prior assistance.

2. **Research directions and the central question**

   - ProactiveAgent and ContextAgent study task proposals and context-based service judgment; Mem0 and A-MEM organize and retrieve historical information.
   - ProactiveBench and ContextAgentBench evaluate proposals and contextual service; LoCoMo and LongMemEval assess long-term conversational memory.
   - Continuous assistance brings memory accumulation, current applicability, and changing opportunities together within an event stream.
   - The central question is how history can become source-grounded, historically supported, and currently applicable memory for timely, selective assistance.

3. **ProactiveStream and the evaluation setting**

   - Introduce a longitudinal benchmark spanning Sports, Home, and Code, with isolated participant, home, and repository streams.
   - Agents accumulate memory chronologically while assessing first actionable windows and subsequent opportunity changes.
   - Under a shared backbone and intervention control policy, existing methods exhibit different trade-offs between opportunity recovery and false interventions.
   - Figure 1 illustrates how a supported evening-walk regularity links earlier observations to current assistance.

4. **Hierarchical memory design**

   - Introduce Proactive Memory (ProactMem) and the architecture in Figure 2.
   - The event memory preserves recent evidence; temporal trajectory memory abstracts source-grounded activities; behavioral regularity memory captures supported conditional behavior.
   - The hierarchy connects immediate changes with longer-term context.

5. **Construction and decision flow**

   - Construction LLMs produce cited trajectories from completed events, followed by source validation of typed facts and historical replay of inferred regularities.
   - At decision time, memory preparation and current-condition matching precede semantic screening.
   - Screening routes events to abstention or contextual assessment using memory relevance and event-local abstention evidence.
   - Full assessment combines recent events, trajectories, and applicable regularities; intervention control filters repeated proposals.
   - Finalized decisions precede event commitment and memory updates.

**Contributions**

- ProactiveStream supports longitudinal evaluation of memory formation and repeated service decisions, preserving causal history, entity isolation, and episode-aware reference opportunities across three scopes.
- ProactMem combines source-checked trajectory abstraction, replay-based regularity assessment, and selection of currently applicable regularities to supply historical context for proactive service decisions.
- ProactMem uses long-term behavioral context to identify service opportunities missed by recent events alone and support more selective intervention decisions.

---

## 2. Problem formulation

- Each participant, household, or repository defines an isolated, chronologically ordered public event stream.
- For each incoming event, the agent produces an `intervene` or `abstain` decision and an optional evidence-grounded service message.
- Decisions use the current public event and prior same-entity observations, finalized outputs, and derived memory and intervention-control states.
- State updates occur after the output is finalized, so maintenance incorporating the current event affects subsequent decisions.
- The objective is to identify timely, actionable service opportunities supported by current observations or prior same-entity history.
- Evaluation uses fixed reference decisions under the annotation protocol; reference labels and annotation metadata remain evaluator-private.

---

## 3. Proactive Memory

- Figure 2 separates memory construction from the decision path: source validation and replay build hierarchical memory; memory preparation and matching precede screening and contextual assessment.
- Both screening routes commit the event after finalization.

### 3.1 Memory construction and update

- Service opportunities can depend on both recent changes and recurring behavior, motivating a hierarchy that preserves fine-grained evidence while validating longer-term abstractions.

1. **bounded event memory**

   - Preserve recent observations at their original granularity within bounded context, motivated by evidence-utilization limitations in long inputs (Liu et al., 2024).
   - Retains up to 99 prior events within the preceding 72 hours, alongside the current event.
   - Preserves events in their original public representation.
   - An independent open-day buffer collects all committed events for trajectory construction.

2. **fact-validated temporal trajectory memory**

   - Retain activity context beyond the recent window while keeping temporal abstractions traceable through source-level fact validation.
   - After a local day closes, a construction LLM extracts trajectory segments with intervals, typed facts, and source-event citations.
   - Validation checks entity consistency, intervals, resolved citations, and canonicalized scalar values at compatible field paths.
   - Acceptance requires source-supported typed facts and resolved citations.
   - Accepted trajectories retain context beyond the recent-event window and remain available during the current construction cycle.

3. **replay-assessed behavioral regularity memory**

   - Ground behavioral expectations in observed recurrence through historical replay and update eligibility as evidence accumulates.
   - Consolidation operates on seven completed daily records per entity; a cycle can span more than seven calendar days.
   - Proposed regularities specify triggers, expected behavior, temporal windows, optional weekday restrictions, and source daily records.
   - Replay counts fulfilled and violated observable days, censors missing observations, and excludes inapplicable days.
   - Activation requires at least three fulfilled days, replay confidence of at least 0.5, and lift of at least 1.0.
   - Consolidation resets the online trajectory view while retaining records for audit.
   - Later observations update confidence and lifecycle eligibility; repeated violations lower priority or suspend eligibility.

### 3.2 Memory retrieval and selection

- Match accumulated regularities to the present service opportunity through trigger, temporal-applicability, and occurrence-state checks.
- The event memory supplies the bounded recent sequence, and temporal trajectory memory supplies completed trajectories from the current cycle.
- Regularity selection checks entity-local trigger context, weekday restrictions, temporal applicability, and occurrence state.
- Matching uses current and previously recorded causal triggers with a 30-minute lead and grace interval.
- Fulfilled and censored occurrences are excluded from selection.
- Up to three eligible regularities are ranked by occurrence state, lifecycle priority, confidence, and temporal distance.
- Retrieval precedes screening and supplies applicable regularities and occurrence states.

### 3.3 Proactive decision

- Combine current needs with historical context to assess service value and track prior coverage of the opportunity (Yang et al., 2025).

#### Semantic screening

- Compare the current event with prior same-entity event records, validated trajectory segments, and active or weakening regularities using each layer's maximum cosine similarity and threshold `λk`.
- Pending services, timer observations, matched upcoming or unresolved regularity occurrences, incomplete memory, and any layer meeting its relevance threshold take the `escalate` route.
- When all three populated layers fall below their thresholds, a single-event LLM assesses the complete public current event.
- A valid `skip` requires explicit abstention evidence quoted from the event and confidence at least `η`. New needs, risks, ambiguity, and history-dependent judgments escalate.
- An accepted `skip` yields `abstain`; an `escalate` result proceeds to contextual assessment.

#### Contextual assessment and intervention control

- For escalated events, the decision context combines the current event, recent events, temporal trajectories, selected regularities, and observable service-episode state.
- The LLM proposes assistance when current observations or historical context support a concrete, timely, feasible, low-risk service.
- The intervention controller compares proposed services with prior allowed interventions and converts duplicates to `abstain`.
- Changes in opportunity state, service identity, contextual regularities, or local day permit renewed assessment. Each method applies the shared controller policy to its own context and intervention history.
- Execution stages the current event, retrieves prior memory and matches current conditions, screens the event, assembles full context for escalated events, finalizes the output, and commits the event.
- Both routes preserve the complete public event in the event buffer and open-day buffer, advancing trajectory construction, replay, and lifecycle updates for subsequent decisions.
- Appendix B specifies evidence handling, lifecycle transitions, intervention control, and the screening contract.

---

## 4. ProactiveStream benchmark

### 4.1 Scopes and public events

Table 1 summarizes benchmark composition and provenance.

| scope | primary source | isolated entity | streams | public events | temporal coverage | reference interventions |
| --- | --- | --- | ---: | ---: | --- | ---: |
| Sports | HeartSteps | participant | 9 | 1,456 | 367 observed participant-days | 365 |
| Home | CASAS | home | 4 | 1,624 | 14 consecutive days per home | 190 |
| Code | GH Archive | repository | 4 | 1,459 | longitudinal repository histories | 174 |
| **total** | three scopes | isolated stream | **17** | **4,539** | three longitudinal settings | **729** |

- **Sports:** optional walking and everyday physical-activity assistance from participant activity and availability contexts.
- **Home:** gentle, low-risk check-ins from sensor segments available at interval closure.
- **Code:** low-risk triage, review, and maintenance from native repository events, with one decision per event.
- Public inputs contain contemporaneously available observations with the same scope-specific schema across label classes.
- Results are reported separately for each scope using event-level decisions.

### 4.2 Reference labels and causal replay

- Annotators assess each event together with its complete prior same-stream history.
- A positive label requires a concrete service opportunity supported by the current event or history, together with reference-episode novelty.
- The first reliable actionable window receives `intervene`; covered windows receive `abstain`. Stronger support, changed service, or a reopened episode can create a renewed opportunity.
- LLM-assisted triage prioritizes candidate opportunities. Three team members independently label every event while blinded to evaluated-system outputs, followed by cross-review and adjudication.
- Main comparisons fix labels, prompts, memory bounds, and validation settings before evaluation.
- Each stream starts from empty method state and includes its initial events in scoring. Labels are joined after inference.
- Appendix A details source preprocessing and causal replay; Appendix D presents a separate-team diagnostic of reference sensitivity and episode behavior.

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
- Scoring uses one finalized decision per event after screening and any applicable intervention control; immediate and scheduled services both count as `intervene` at the decision event.
- Higher scores are preferred for relevance, coverage, effectiveness, and balance; lower intrusion is preferred. This ratio describes relative intervention volume and is interpreted alongside relevance, coverage, and intrusion.

#### Implementation details

- The primary model is `gpt-5.6-luna`, with temperature zero and thinking disabled; ProactMem uses the official OpenAI API.
- Methods share task semantics, scope-specific references, and the intervention controller policy, with method-specific prompts, retrieval interfaces, and computational budgets.
- The event-only, event and trajectory memory, and ProactMem variants share the decision prompt, output schema, and context bound of 72 hours and at most 100 events, including the current event.
- A-MEM and Graphiti augment the bounded event context with their memory representations.
- For ProactMem, memory preparation and current-condition matching precede semantic screening: accepted `skip` results yield `abstain`, while `escalate` results proceed to full contextual assessment followed by intervention control.
- Decision and memory-construction calls have separate roles and output budgets.

### 5.2 Main results (RQ1)

- Compare proactive-service and memory-based agents on ProactiveStream using the same Luna backbone and intervention controller policy.

1. **Comparisons with external methods.**

   - Table 2 compares full-scope results. ProactMem achieves higher effectiveness and balance than all evaluated external methods in every scope.

2. **Supplementary diagnostics**

   - Reference-sensitivity and episode-level analyses examine label variation, opportunity coverage, and repeated interventions on a separate 450-target sample; detailed results appear in Appendix D.

### 5.3 Model comparison (RQ2)

1. **Within-series model scaling**

   - Table 3 compares GPT-5.6 Luna, GPT-5.6 Terra, and GPT-5.6 Sol. Construction and decision LLMs change together, with the benchmark, architecture, role-specific prompts, decoding, validation thresholds, and controller policy fixed.
   - The comparison shows that effectiveness increases and intrusion decreases from GPT-5.6 Luna through GPT-5.6 Terra to GPT-5.6 Sol in every scope.
   - These gains are consistent with stronger abilities to extract task-relevant details, induce conditional behavioral regularities, and perform compositional reasoning over temporal evidence, supporting more accurate memory construction and more selective intervention.
   - The hierarchical memory architecture engages these abilities in both historical representation and current decision-making.
   - Controlled component ablations use GPT-5.6 Luna.

2. **Cross-family event-only comparison**

   - Figure 3 compares GPT-5.6 Luna, Gemini 3.8 Flash, DeepSeek V4 Flash, and GLM 5.3 Flash on two selected complete event streams per scope under shared task instructions, bounded event context, and intervention control policy.
   - Three scope-specific radar panels report relevance, coverage, effectiveness, specificity, and balance; specificity is the correct-abstention rate, `1 − intrusion`.
   - Appendix B.6 gives stream identities, event counts, the selection rule, and shared settings.
   - On Sports, Gemini and Luna share the highest coverage; Gemini leads the remaining metrics.
   - On Home and Code, Gemini leads in effectiveness, while Luna recovers more opportunities and achieves higher balance.
   - DeepSeek and GLM have higher specificity and lower coverage than Luna in Home and Code.
   - The scope-specific profiles reveal different trade-offs between opportunity recovery and correct silence.

### 5.4 Ablation study and memory analysis (RQ3)

1. **Proactive agent ablation**

   - The event-only variant supplies current and bounded recent events; the event and trajectory memory variant adds source-checked temporal trajectories; ProactMem further adds behavioral regularities.
   - Figure 4 compares variants sharing Luna, decision prompt, schema, event bound, and controller policy.
   - Representation-dependent controller keys make this a memory-layer comparison within the implemented pipeline.
   - Temporal trajectories recover more opportunities, most on Code, with unchanged false-positive counts on Sports and Home and more false positives on Code.
   - Behavioral regularities further improve effectiveness in every scope, recovering more opportunities with fewer false interventions.
   - Trajectory abstraction expands context; supported, currently applicable regularities improve selectivity.

2. **Validation mechanisms**

   - Table 4 compares validation removals under a fixed model, prompt, event bound, context capacity, and controller.
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

   - Generative Agents, MemoryBank, and MemGPT organize experience through reflection, updating, and tiered context management.
   - Mem0, A-MEM, and HippoRAG use extracted memories, linked records, and graph retrieval; Graphiti preserves temporal validity and provenance.

2. **Proactive decision and memory**

   - ProactiveAgent studies task proposals and silence; ContextAgent combines sensory contexts with historical personas; PASK links streaming demand detection with long-term memory.
   - MemCog explores memory for dialogue reasoning; Remember When It Matters supplies selected reminders for long-horizon action.
   - ProactMem grounds trajectory-derived regularities through source checks, replay, and current-event matching.

3. **Evaluation of proactive service**

   - LoCoMo and LongMemEval evaluate long-term conversational memory and reasoning; proactive benchmarks examine task proposals, latent needs, and memory triggering.
   - ProactiveStream evaluates sequential decisions as agents accumulate memory within isolated causal streams, using episode-aware references for intervention timing.
   - Notification-timing research relates interruption cost to task phase and receptivity, motivating evaluation of opportunity recovery and intrusion.

---

## 7. Conclusion

- ProactMem combines bounded recent events, source-checked temporal trajectories, and replay-assessed behavioral regularities.
- Across the three ProactiveStream scopes, it achieves higher event-level effectiveness and balance than the evaluated external baselines.
- Ablations support hierarchical organization and validation for grounding service decisions in applicable historical evidence.

---

## Limitations

- The benchmark covers low-risk service settings in Sports, Home, and Code under a protocol fixed after joint method and benchmark development.
- Independent held-out evaluation, screening calibration, and cross-family transfer of constructed memory remain future work.
- Reference labels describe opportunities under the annotation protocol; the 450-target review covers three selected streams.
- The fixed-state Code suppression diagnostic characterizes recorded proposals. Evaluating controller-free behavior requires a sequential comparison.
- Historical replay measures observed recurrence; prospective validity under changing behavior requires further evaluation.
- Recipient benefit, interruption burden, end-to-end cost, and deployment safety require prospective measurements.
- Broader generalization requires additional populations, observation conditions, and model families.

---

## Ethical considerations

- The evaluated services concern optional activity support, gentle check-ins, and low-risk repository assistance.
- Medical and high-risk safety decisions require domain-specific validation and safeguards.
- Stream isolation and evaluator-private annotations define the inference information boundary.
- Longitudinal events and derived memories require access controls, retention protections, data minimization, and respect for source permissions.
- Deployment should provide informed opt-in, memory inspection and correction, deletion, retention control, and an option to disable proactive assistance.
- Consequential actions require separate authorization; deployment safeguards require implementation and evaluation.

---

## References

- References follow the ethical considerations and precede the appendices.

---

## Appendices

### A. Benchmark and annotation protocol

#### A.1 Public events and availability

- Describe HeartSteps activity and availability fields, CASAS closed-interval sensor aggregation, and native GitHub repository events.
- Specify event availability, entity isolation, a common public schema across label classes, and evaluator-private labels and scoring metadata.
- Include early events before temporal trajectories and behavioral regularities become available.

#### A.2 Reference labels and causal replay

- Specify independent annotation, cross-review, adjudication, and the opportunity semantics introduced in Section 4.2.
- Fix event inventories and evaluation settings before main runs.
- Replay each stream chronologically from empty state; finalize decisions before event commitment and join labels offline.

### B. Implementation and experimental configuration

#### B.1 trajectory evidence and replay

- Detail the open-day buffer, interval and typed-field representation, scalar normalization, compatible field paths, and source citations.
- Describe seven-record cycles, observable fulfillment and violation, censored observations, base rates, and zero-denominator handling.

#### B.2 Lifecycle and current matching

- Combine replay and online evidence with smoothed confidence updates.
- Describe transitions among candidate, active, weakening, and dormant states, including violation-triggered transitions and replay readmission.
- Rank eligible regularities using occurrence state, lifecycle, confidence, and temporal distance, with deviated occurrences preceding pending and upcoming ones.

#### B.3 Intervention control

- Define Sports and Home keys through observable episode state, service action and target, and contextual regularity identifiers; specify Home phases and re-entry conditions.
- Define Code duplicate matching through repository-object identity and the preceding allowed intervention's mode, recipient, content, and firing condition.
- Explain how representation-dependent key evidence affects suppression across memory interfaces.

#### B.4 Model and method interfaces

- Table 5 summarizes external-method interfaces, including event-history bounds, memory representations, embedding choices, retrieval settings, and implementation versions.
- Distinguish decision and construction calls and their role-specific output budgets.
- Define confusion-count formulas, pooled scoring, and interpretation of frequency alongside relevance, coverage, and intrusion.

#### B.5 Semantic screening contract

- Prepare causal same-stream memories and current-condition matches before screening; preserve task-bearing public fields in normalized, cached embeddings.
- Describe the semantic encoder, screening LLM, three layer thresholds, and confidence threshold as configuration parameters.
- Specify `route`, `confidence`, `evidence`, `has_new_need_or_risk`, and `needs_history` in the single-event response. Skip validation requires a valid schema, both flags set to false, and an exact nonempty quotation from the event.
- Illustrate screening candidates through explicitly resolved fixes, completed walks with comfortable rest, and received deliveries. New failures, seated activity, and quiet sensor intervals receive full assessment.
- Describe escalation for unavailable inputs, uncertain timing, malformed assessments, and recoverable failures; authorization and access failures halt processing.
- Distinguish full-decision, shadow, and screening configurations and record event-level routing information.
- Describe screening evaluation through independent development-stream calibration and fresh causal replay, measuring screening rate, positive-event retention, and decision quality.

#### B.6 Cross-family event-only configuration

- Select two complete streams per scope by ranking SHA256 hashes of a fixed seed, domain, and public stream identifier.
- Table 6 lists HeartSteps participants 05 and 35 (184 and 191 events), CASAS homes 0004 and 0003 (406 events each), and Code repositories `Unitech/pm2` and `thephpleague/commonmark` (365 and 347 events).
- Share chronological replay from empty state, scope-specific task prompts, the 72-hour and 100-event context intersection, and intervention control.
- Use temperature zero, request disabled thinking, and set decision output limits to 256 tokens for Sports and Home and 512 for Code. Output-format and transport-recovery settings follow each backend's interface.
- Score finalized decisions offline against common reference labels.

### C. Additional ablation and intervention control results

- Table 7 supplements the validation results with frequency and coverage.
- Analyze true-positive losses and false-positive reductions in the fixed-state Code suppression diagnostic.
- Report aggregate true-positive increments from temporal trajectories and behavioral regularities across scopes.

### D. Reference and episode diagnostics

#### D.1 Reference sensitivity

- A separate three-reviewer team reviews 450 targets: 150 consecutive events from one stream per scope, selected by a fixed SHA256 rule using public metadata.
- The selected streams are Sports participant 35, Home home 0004, and Code repository `callstack/react-native-pager-view`. Each target segment has at least seven days of preceding history, and its complete causal prefix is processed.
- Reviewers independently label targets with evaluated-system outputs hidden, then discuss judgments to form consensus references.
- Table 8 scores identical outputs from separate diagnostic runs against earlier and separate-team references, reporting intervention counts, confusion counts, and effectiveness.
- Rescoring yields similar effectiveness on Sports and lower effectiveness on Home and Code, showing reference sensitivity in this sample.

#### D.2 Episode references and matching

- A post-hoc, model-assisted analysis reconstructs goal-and-object episodes from positive event anchors, specifying causal evidence, onset, valid observations, and deadlines or closure evidence.
- Initialize coverage from recorded prefix outputs and score target interventions through goal-and-object matching and proposed service time. Each output receives at most one credit.
- Distinguish first valid interventions, valuable follow-ups grounded in changed evidence, redundant follow-ups, and uncertain outcomes.
- Table 9 reports episode coverage over newly arising reference episodes, supported relevance, redundant intervention rate, and unmatched, late, and unresolved outcomes.
- Episode coverage is highest on Home and lowest on Code; the redundant-intervention share is highest on Home and lowest on Sports.
- Interpret these exploratory scores in relation to reference construction and semantic matching.
