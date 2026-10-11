# Proactive Memory for Event-Driven LLM Agents

## Abstract

- Proactive assistance requires identifying timely service opportunities from evolving observations and accumulated history.
- Existing approaches emphasize recent context or related-memory retrieval, leaving recurring-evidence validation and current applicability as key challenges.
- Proactive Memory (ProactMem) connects source-checked temporal trajectories with replay-assessed behavioral regularities; ProactiveStream evaluates chronological decisions across three service scopes.
- ProactMem achieves 52.6% overall effectiveness (F1), a 21.4% relative improvement over the strongest of five external baselines.

## 1. Introduction

1. **Background.** LLM agents extend task execution toward proactive assistance. Activity support, smart homes, and software collaboration require recognizing new needs while tracking earlier assistance.

2. **Existing directions and research question.** Proactive-agent research studies contextual service decisions; memory research develops experience storage and retrieval. Longitudinal assistance additionally requires recovering cross-day context, validating inferred regularities, and assessing their relevance to present needs. How can accumulated history provide dependable evidence for timely, selective intervention?

3. **Benchmark and observed challenge.** Introduce ProactiveStream as a setting for studying memory accumulation and changing opportunities within isolated streams. Existing methods exhibit different trade-offs between opportunity recovery and false interventions. Figure 1 illustrates a service decision that benefits from earlier behavioral evidence.

4. **Design rationale.** Introduce ProactMem's hierarchy: recent events preserve immediate detail, temporal trajectories organize extended activity context, and behavioral regularities represent recurring conditions. Source validation grounds abstractions in observations; replay assesses recurrence.

5. **Decision process.** Explain how current conditions select applicable evidence, contextual assessment evaluates service value, and intervention control tracks prior coverage. Figure 2 connects these stages to memory construction.

**Contributions**

- ProactiveStream supports longitudinal evaluation with causal histories, entity isolation, and episode-aware opportunity labels.
- ProactMem integrates evidence validation and temporal applicability into hierarchical memory for proactive decisions.
- Long-term behavioral context supports recovery of opportunities missed by recent events alone and more selective assistance.

## 2. Problem formulation

- Define an isolated, chronologically ordered public event stream for each participant, household, or repository.
- Map the current event and prior same-entity state to `intervene` or `abstain`, with an optional evidence-grounded service message.
- Finalize each decision before committing its event and output; resulting memory updates affect subsequent decisions.
- Evaluate timely, actionable opportunities using evaluator-private reference labels.

## 3. Proactive Memory

### 3.1 Memory construction and update

- **bounded event memory:** preserve recent public observations at their original granularity, supplying immediate evidence within a bounded context.
- **fact-validated temporal trajectory memory:** summarize completed-day events into cited activity segments to retain context beyond the recent window. Validate typed facts, entity identity, intervals, and source citations before admission.
- **replay-assessed behavioral regularity memory:** consolidate completed trajectories into conditional expectations. Historical replay measures fulfillment and violation on observable days; later observations update confidence and lifecycle eligibility.

### 3.2 Memory retrieval and selection

- Prepare recent events and completed trajectories, then match eligible regularities against entity-local triggers, weekdays, temporal windows, and occurrence states.
- Rank upcoming, pending, and deviated occurrences by state, lifecycle, confidence, and temporal distance.
- Supply applicable evidence to contextual assessment, connecting historical support to current conditions.

### 3.3 Proactive decision

- For each event, combine current observations, selected memory, and observable opportunity state to assess concrete, timely, feasible, low-risk assistance.
- Compare proposed services with prior allowed interventions, suppress duplicates, and permit renewed assessment when opportunity evidence or service identity changes.
- Commit each complete event to the recent-event and open-day buffers after finalizing its decision, following the causal update order in Section 2.

## 4. ProactiveStream benchmark

### 4.1 Scopes and public events

Table 1 summarizes the benchmark.

| scope | source | entity | streams | events | reference interventions |
| --- | --- | --- | ---: | ---: | ---: |
| Sports | HeartSteps | participant | 9 | 1,456 | 365 |
| Home | CASAS | home | 4 | 1,624 | 190 |
| Code | GH Archive | repository | 4 | 1,459 | 174 |
| total | three scopes | isolated stream | 17 | 4,539 | 729 |

- Sports covers optional activity support; Home covers gentle sensor-based check-ins; Code covers low-risk triage, review, and maintenance.
- Public inputs preserve contemporaneous observations and scope-specific event granularity. Appendix A details temporal coverage, preprocessing, and availability.

### 4.2 Reference labels and causal replay

- Label the first reliable actionable window and renewed opportunities supported by stronger evidence, changed services, or reopened episodes.
- Use LLM-assisted triage followed by independent labeling, cross-review, and adjudication by three team members blinded to system outputs.
- Fix the evaluation labels and settings before main runs. Replay complete streams from empty state and join labels offline, including initial events in scoring.

## 5. Experimental evaluation

- **RQ1:** How does ProactMem compare with external methods?
- **RQ2:** How does model choice affect decision quality?
- **RQ3:** What do memory organization and validation contribute?

### 5.1 Experimental settings

#### Baselines

- Compare proactive-service methods ProactiveAgent and ContextAgent with memory systems Mem0, A-MEM, and Graphiti.
- Preserve each method's memory interface and retrieval procedure while sharing task semantics and the intervention controller policy.

#### Metrics

- Report relevance (precision), coverage (recall), effectiveness (F1), intrusion (false positive rate), and balance (balanced accuracy).
- Define frequency as `(TP + FP) / (TP + FN)`, measuring interventions per reference-positive event.
- Score one finalized decision per event; scheduled services count at their decision event. Pool confusion counts within each scope and across scopes for overall effectiveness.

#### Implementation details

- Use GPT-5.6 Luna with temperature zero and thinking disabled; ProactMem uses the official OpenAI API.
- The event-only, event and trajectory memory, and full variants share their decision prompt, output schema, and bounded event context.
- Execute contextual assessment and intervention control for each event, following Section 3.3. Appendix B specifies context bounds, interfaces, and configuration.

### 5.2 Main results (RQ1)

- **Comparisons with external methods.** Table 2 shows higher effectiveness and balance for ProactMem across all three scopes.
- **Supplementary diagnostics.** Appendix D examines reference sensitivity and episode behavior on a separate target sample.

### 5.3 Model comparison (RQ2)

- **Within-series model scaling.** Table 3 compares GPT-5.6 Luna, GPT-5.6 Terra, and GPT-5.6 Sol, changing construction and decision LLMs together while holding other settings fixed. Increasing effectiveness and decreasing intrusion are consistent with stronger detail extraction, conditional regularity induction, and temporal reasoning, exercised through both memory construction and current assessment.
- **Cross-family event-only comparison.** Figure 3 compares GPT-5.6 Luna, Gemini 3.8 Flash, DeepSeek V4 Flash, and GLM 5.3 Flash on two selected complete streams per scope. Its panels show relevance, coverage, effectiveness, specificity, and balance, with specificity equal to `1 − intrusion`.
- Gemini leads effectiveness across scopes; Luna shares the highest Sports coverage and leads coverage and balance on Home and Code. DeepSeek and GLM favor higher specificity with lower coverage than Luna in the latter two scopes.

### 5.4 Ablation study and memory analysis (RQ3)

- **Proactive agent ablation.** Figure 4 progressively adds temporal trajectories and behavioral regularities under shared Luna decision settings. Trajectories recover more opportunities, especially in Code; regularities further improve effectiveness and selectivity. Representation-dependent controller keys make this a comparison within the implemented pipeline.
- **Validation mechanisms.** Table 4 compares `w/o replay gate` and `w/o trajectory validation`. Both removals lower relevance and effectiveness, with the larger effectiveness decrease occurring when replay gating is removed. Appendix C provides expanded scores.
- **Intervention control.** The Code diagnostic scores recorded proposals before suppression with later states fixed. Suppression removes more false-positive than true-positive proposals, increasing relevance and effectiveness while lowering coverage.

## 6. Related work

- **Agent memory and long-horizon retrieval:** organize prior work by reflection, tiered context, extracted memories, linked notes, and temporal graphs. Position ProactMem through source fidelity, recurring support, and current applicability.
- **Proactive decision and memory:** discuss task proposals, contextual service, streaming demand detection, and memory-triggered reasoning. Emphasize how temporal evidence informs the timing and content of assistance.
- **Evaluation of proactive service:** connect conversational-memory benchmarks, proactive-agent evaluations, and interruption research. Motivate sequential evaluation with accumulating memory and changing service opportunities.

## 7. Conclusion

- Conclude that source-grounded temporal abstraction and recurrence assessment help agents use historical evidence selectively, supported by the main comparisons and component analyses.

## Limitations

- Evaluation covers three low-risk scopes on a jointly developed benchmark; independent populations and cross-family memory transfer remain future directions.
- Reference and episode diagnostics depend on selected streams and matching procedures; the suppression diagnostic holds later states fixed.
- Behavioral change, recipient benefit, interruption burden, end-to-end cost, and deployment safety require prospective evaluation.

## Ethical considerations

- Protect sensitive routines through stream isolation, limited data transmission, access controls, and retention safeguards.
- Require informed opt-in, inspectable and correctable memory, deletion controls, and separate authorization for consequential actions.
- Medical and high-risk services require domain-specific validation.

## References

- Include the cited work on agent memory, proactive assistance, temporal evidence, benchmark sources, and interruption timing.

## Appendices

### A. Benchmark and annotation protocol

#### A.1 Public events and availability

- Document source fields, entity isolation, and event availability: Sports decision-time observations, Home closed-interval aggregation, and native Code events.
- Report temporal coverage and evaluator-private annotation fields.

#### A.2 Reference labels and causal replay

- Detail opportunity novelty, review and adjudication, chronological ordering, empty-state initialization, and offline scoring.

### B. Implementation and experimental configuration

#### B.1 trajectory evidence and replay

- Specify open-day buffering, typed fields, scalar normalization, source checks, and seven-record consolidation cycles.
- Define observable fulfillment, violation, censoring, confidence, and lift; admission requires three fulfilled days, confidence at least 0.5, and lift at least 1.0.

#### B.2 Lifecycle and current matching

- Define candidate, active, weakening, and dormant transitions, including confidence updates and replay readmission.
- Specify top-three selection and the 30-minute lead and grace intervals.

#### B.3 Intervention control

- Detail Sports and Home opportunity keys and phases, Code service signatures, duplicate checks, and re-entry conditions.

#### B.4 Model and method interfaces

- Table 5 specifies baseline versions, embeddings, retrieval settings, and method-specific interfaces.
- Define the 72-hour context intersected with at most 100 events, including the current event; distinguish decision and construction budgets.
- Provide metric formulas and frequency interpretation.

#### B.5 Cross-family event-only configuration

- Table 6 lists the six complete streams, their event counts, and the fixed-hash selection rule.
- Give shared prompts and decoding settings, with decision limits of 256 tokens for Sports and Home and 512 for Code.

### C. Additional ablation and intervention control results

- Table 7 supplements validation ablations with frequency and coverage.
- Report memory-layer true-positive increments and the true-positive losses and false-positive reductions from Code suppression.

### D. Reference and episode diagnostics

#### D.1 Reference sensitivity

- Describe the separate team's review of 150 consecutive targets from one stream per scope, selected using public metadata and processed with complete causal prefixes.
- Table 8 scores identical diagnostic outputs against earlier and separate-team references; effectiveness remains similar on Sports and decreases on Home and Code.

#### D.2 Episode references and matching

- Define model-assisted goal-and-object episode construction, valid observations, deadlines, and proposed service-time matching.
- Table 9 distinguishes episode coverage, supported relevance, redundant follow-ups, and unmatched, late, or unresolved outputs.
- Discuss stronger episode coverage in Home and lower coverage in Code, alongside Home's greater redundant-intervention share.
