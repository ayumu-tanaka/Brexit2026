# Anchored in Uncertainty: Asymmetric Entry and Exit Responses of Japanese MNEs to the Brexit Announcement

**Date**: 05/06/2026
**Domain**: social_sciences/economics
**Taxonomy**: academic/research_paper
**Filter**: Active comments

---

## Overall Feedback

Here are some overall reactions to the document.

**Outline**

This paper studies how the Brexit referendum affected Japanese MNE entry and exit in the UK, using a sunk-cost/real-options model to motivate asymmetric predictions. The exit analysis is thorough and robust across specifications. The entry analysis, which carries the paper's main contribution, rests on weaker statistical ground. Several identification and inference issues limit the strength of the asymmetry claim.

The paper addresses an important question with well-chosen data and a sensible theoretical framework. The exit analysis is carefully executed, with multiple estimators consistently delivering a null result. The use of Wooldridge (2023) nonlinear DiD and synthetic DiD alongside standard TWFE reflects serious engagement with modern causal inference methods. The theoretical model, while stylized, generates testable predictions that discipline the empirical work.

**The asymmetry claim is never formally tested**

The paper's central contribution is that exit responds less than entry to the Brexit referendum. Yet the authors never conduct a formal statistical test of whether the entry and exit treatment effects differ from each other. The exit estimates come from affiliate-level binary models; the entry estimates come from country-industry-level Poisson models. Comparing coefficients across these specifications—estimated on different samples, at different levels of aggregation, with different functional forms—does not establish that the difference is statistically significant. A reader is left with a narrative comparison: one coefficient is near zero and the other is negative. This is insufficient for a paper whose title promises 'asymmetric' responses. The revision should either estimate both margins in a unified framework (e.g., a joint model with a formal test of coefficient equality) or at minimum provide a bootstrap-based test of the difference in treatment effects across margins, accounting for the different data structures.

**Entry effect significance depends entirely on a questionable inference method**

The SDiD point estimate for entry is -0.145 (approximately 13.5% decline), but the authors acknowledge that this is only significant under placebo-based standard errors—a method they themselves argue is inappropriate for count data because it assumes homoskedasticity and ignores cross-sectional correlation from the common treatment shock. Bootstrap and jackknife methods fail to reject zero. The paper candidly discusses this fragility (Section 6.2), but the abstract and conclusion still present '13.5% reduction' as a finding. When significance is sensitive to the SE method, and the authors' own preferred robust methods (bootstrap, jackknife) do not reject zero, the appropriate conclusion is that the entry effect is not statistically established. The framing throughout should reflect this: the entry result is suggestive and directionally consistent with the model, but the evidence is weak.

**Pre-treatment trends fail in the entry analysis and the pre-treatment window is thin**

Table 4 shows that UK × Year 2010 is negative and significant (coefficient around -0.38 to -0.42) in the PPML event-study specification for entry, indicating that UK entry was already declining relative to comparison countries well before the referendum. The authors acknowledge this and turn to SDiD to address it, but SDiD reweighting cannot resolve a fundamental identification problem if the UK was on a structurally different entry trajectory starting in the early 2010s—perhaps driven by the saturation of Japanese investment in the UK or the 2013 Cameron speech. Compounding this, the pre-treatment period contains only two observation points (2010, 2012) due to biennial data. Two leads provide minimal power to test parallel trends or to detect whether SDiD weights adequately correct for divergent pre-trends. A robustness check starting the sample in 2012 (using only 2012 and 2014 as pre-treatment) would help, as would a discussion of whether structural differences in UK entry trajectories predate any Brexit-related uncertainty.

**SUTVA likely violated through displacement to EU control countries**

If Japanese MNEs responded to Brexit uncertainty by redirecting planned UK investments toward other EU countries, then the control group's outcomes are affected by the treatment. Figure 2 shows that affiliates in other high-income EU countries continued to grow after 2016 while UK affiliate counts stagnated—a pattern consistent with displacement. Under displacement, the control group's entry counts are inflated and exit counts may be deflated, biasing the DiD estimator away from zero for entry and toward zero for exit. This means the entry effect may be overstated (part of the measured decline reflects control-group inflation rather than UK-specific deterrence), while the null exit result may partly reflect that EU affiliates became more attractive to retain, not that UK affiliates were specifically 'anchored.' The paper should test for displacement directly—for example, by examining whether new entries into specific EU countries increased disproportionately in sectors where UK entry declined, or by using non-EU control countries (which the paper does in one robustness table but without discussing the displacement mechanism).

**The 2020 endpoint confounds Brexit uncertainty with COVID-19**

The sample ends in 2020, and the largest entry effects appear precisely in that year (Table 4 shows UK × Year 2020 as the only consistently significant post-treatment coefficient across specifications). But 2020 is also the year of the COVID-19 pandemic, which severely disrupted global investment flows and hit the UK service sector—where Japanese affiliates are concentrated (75.8% of UK sample)—particularly hard. If the pandemic differentially affected UK entry relative to control countries (plausible given the UK's early and severe lockdowns), the 2020 coefficient conflates two shocks. The paper never discusses this confound. A robustness check dropping 2020 would reveal whether the entry result is driven entirely by the pandemic year. If so, the Brexit-specific interpretation weakens considerably.

**Exit measurement may systematically bias toward the null**

Exit is defined as disappearance from the Toyo Keizai OJC survey. The paper acknowledges this is the best available approach, but never discusses the measurement error this introduces. An affiliate that goes dormant, changes ownership to a non-Japanese entity, or simply fails to respond to the survey in a given year would be coded as an exit regardless of whether the affiliate actually closed. More importantly for the null result, if affiliates that are winding down operations gradually (reducing staff, shifting functions to EU entities) remain listed in the OJC until formal dissolution, then real economic exit may be occurring during 2016-2020 without registering in the binary exit variable until later. The paper's own Figure 2 shows UK affiliate counts barely changed while EU counts rose—consistent with 'functional exit' (hollowing out UK operations) rather than formal closure. The Online Appendix mentions Cox proportional hazard models, but the main text never discusses whether its binary exit measure captures the economically relevant margin of adjustment.

**No calibrated example showing the hysteresis band has empirical bite**

The theoretical model defines entry and exit thresholds implicitly through Bellman equations but never computes them for any parameterization. Footnote 10 even provides a specific profit function that could be used. Without a worked example, a reader cannot assess whether the hysteresis band is wide enough for a shock of the magnitude implied by Brexit—Dhingra and Sampson's 2–3% GDP decline, or Bloom et al.'s 6–8%—to fall inside the inaction region for incumbents while pushing potential entrants below threshold. The paper should parameterize the model using the profit function in footnote 10, choose values of entry costs, exit costs, the discount factor, and the deterioration probability consistent with available evidence (e.g., Kermani and Ma's liquidation recovery rates for exit costs, Bloom et al.'s uncertainty measures for gamma), and compute the implied thresholds. Showing that a plausible Brexit-sized shock lands inside the band for high-asset-specificity industries but outside it for low-asset-specificity industries would connect the theory to the empirical heterogeneity in Figure 8 and demonstrate the model is doing real work rather than serving as a qualitative narrative.

**Asset specificity heterogeneity not examined on the entry margin**

Section 5.5 shows that exit probabilities rise significantly in low-asset-specificity industries but remain flat in high-asset-specificity ones, which the paper interprets as evidence that sunk costs generate hysteresis. But the model predicts a specific cross-margin pattern: asset specificity should matter for exit (where sunk costs are at stake) but matter less for entry (where costs have not yet been incurred). Testing this prediction on the entry side would sharpen the mechanism story considerably. If new entries decline uniformly across asset-specificity categories—rather than showing the differential pattern seen for exits—that would be strong evidence that the asymmetry is driven by sunk costs rather than by some other difference between entering and incumbent firms. The paper should replicate the Poisson QMLE or SDiD entry analysis separately for high and low asset specificity industries, paralleling the exit exercise in Figure 8.

**EU-Japan EPA not addressed as a confounding policy shock**

The EU-Japan Economic Partnership Agreement was concluded in December 2017 and entered into force in February 2019, squarely within the post-treatment window. By reducing tariff and non-tariff barriers between Japan and EU member states, the EPA made the remaining EU countries more attractive for new Japanese investment independently of any Brexit effect. This is a distinct confound from SUTVA displacement: even without firms redirecting UK-planned investment, the EPA gave Japanese MNEs a new reason to enter EU countries rather than the UK. The paper's conclusion mentions that 'trade and investment arrangements between the UK and the EU remained uncertain,' but the EU-Japan EPA was in fact finalized and implemented during the sample period. The entry DiD estimate could partly capture the EPA's pull on Japanese investment toward EU comparison countries rather than Brexit's push away from the UK. The paper should at minimum discuss this channel and ideally test for it—for example, by checking whether the entry decline concentrates in sectors where the EPA reduced barriers most, or by using non-EU countries unaffected by the EPA (as in the robustness specification in Table 3) as the primary comparison for entry.

**Recommendation**: Major revision. The paper asks a well-motivated question and the exit analysis is solid, but the asymmetry claim—the paper's core contribution—is not established at conventional significance levels under the authors' own preferred inference methods, is never formally tested as a difference, and faces identification threats from pre-trend violations, SUTVA concerns, and the 2020 COVID confound.

**Key revision targets**:

1. Provide a formal statistical test of the entry-exit asymmetry, either through a joint estimation framework or a bootstrap test of coefficient differences across specifications, so that the central claim rests on more than narrative comparison.
2. Demonstrate that the entry result survives exclusion of 2020 data, or explicitly reframe the finding as driven by the joint Brexit+COVID period rather than Brexit uncertainty alone.
3. Address the pre-trend failure in the entry analysis more rigorously: show that SDiD weights adequately correct for the divergent 2010 trajectory, test sensitivity to starting the sample in 2012, and discuss whether pre-referendum uncertainty (Cameron speech, 2015 Referendum Act) contaminates the control period.
4. Test for displacement effects on the control group—e.g., show that the entry result is qualitatively similar when using non-EU countries as controls (this is partially done in Table 4 but not interpreted through the SUTVA lens), or directly examine whether EU control-country entry rose in the same sectors where UK entry fell.
5. Discuss measurement limitations of binary exit more carefully, acknowledging that functional exit (operational downsizing, relocation of functions) would not be captured, and showing robustness using alternative exit definitions if possible (e.g., employment-weighted exit, ownership change).

**Status**: [Pending]

---

## Detailed Comments (2)

### 1. Biennial-to-annual frequency switch biases exit measurement

**Status**: [Pending]

**Quote**:
> For this study, we combine biennial OJC survey data from 2010–2014 with annual OJC data between 2016 and 2020.

**Feedback**:
The pre-treatment surveys are biennial (2010, 2012, 2014) while the post-treatment surveys are annual (2016–2020). Since exits are detected by comparing successive surveys, the measurement window changes at exactly the treatment boundary: pre-treatment exits cumulate over 2-year intervals, while post-treatment exits are detected over 1-year intervals. This is not merely an inconvenience—it creates a mechanical difference in measured exit rates. An affiliate that exits and is replaced within a 2-year window is invisible in the biennial period but would register in the annual period. More concretely, if the per-year exit probability is p, biennial measurement detects exits at roughly rate 1-(1-p)^2 ≈ 2p per observation, while annual measurement detects at rate p. Unless the paper annualizes exit rates from biennial waves (dividing by 2) or restricts the post-treatment data to biennial frequency (2016, 2018, 2020), the DiD outcome variable is not comparable across pre- and post-treatment. This asymmetry could generate a spurious increase in measured exit rates post-treatment. Add a sentence explaining how the analysis reconciles exit rates measured over different-length inter-survey intervals—for example, 'We annualize biennial exit indicators by [method]' or 'We restrict the post-treatment sample to biennial waves for comparability.'

---

### 2. Exit dating convention ambiguous for the study's sample period

**Status**: [Pending]

**Quote**:
> Since the OJC survey takes place the year prior to its release (e.g., the OJC survey released in 1992 occurred in fall 1991), we use the year prior to the survey as the affiliate exit date.

**Feedback**:
The example uses 1992—a year far outside the 2010–2020 sample—and the phrasing 'the year prior to the survey' is ambiguous in context. A natural reading is: the survey released in year Y was conducted in year Y-1, so exits are dated to Y-1 (the data-collection year). But this leaves unresolved whether '2010–2014' and '2016–2020' in the preceding sentence refer to release years or data-collection years. If these are release years, the actual data years are 2009–2013 (biennial) and 2015–2019 (annual), meaning no data collection occurred in 2014—the year immediately before the referendum buildup. If instead these are data years, there is a gap in 2015 with no survey to detect exits between 2014 and 2016. Either interpretation raises a question the reader cannot resolve from the text alone. Rewrite the dating explanation using a year within the actual sample: e.g., 'the OJC survey released in 2017 was conducted in fall 2016; we date exits detected in this survey to 2016.' Then state explicitly whether the years 2010–2014 and 2016–2020 refer to release years or data-collection years.

---
