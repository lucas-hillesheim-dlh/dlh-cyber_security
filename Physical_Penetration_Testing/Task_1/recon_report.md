# Reconnaissance Summary Report
**Target:** Meridian Technologies Inc. — 2800 Innovation Drive, Techville, ST 55100 (fictional)
**Engagement:** Physical Penetration Test, Phase 1 (Reconnaissance)
**Prepared by:** [Tester] | **Date:** 23 Oct 2026 | **Classification:** Client Confidential

---
## 1. Executive Summary
Remote OSINT and simulated passive on-site observation of Meridian Technologies' two-building campus identified five entry points and six camera positions, with the clearest gaps at the unmonitored rear employee door (EP-2), the loading-dock personnel door's camera blind spot (EP-3/CAM-4), and the single daytime guard's five 15-minute patrols plus a 30-minute lunch break, which together leave the lobby unmanned roughly 105 minutes per day. The most promising attack windows combine the 12:00 guard-lunch gap with ordinary employee tailgating behavior at EP-2, and the scheduled delivery window at EP-3. No vulnerabilities were confirmed by live, multi-day observation; all findings are drawn from the provided scenario data and typical-office inference and should be validated on-site before being relied upon operationally.

## 2. Facility Overview
| | |
|---|---|
| Company | Meridian Technologies Inc. |
| Address | 2800 Innovation Drive, Techville, ST 55100 |
| Buildings | Main Office (3 stories) + Annex (1 story), connected by an open campus gap |
| Employees | ~200 |
| Hours | Mon-Fri 07:00-18:00 |
| Security | 1 daytime guard, badge access, CCTV (6 cameras identified) |
| Parking | Employee lot (badge-gated, adjacent to EP-2), visitor lot (open, adjacent to Annex/EP-4) |

## 3. Entry Point Analysis
*(Full detail in `entry_points.md`.)*

| EP-ID | Location | Risk Rating | Why |
|---|---|---|---|
| EP-2 | Rear employee door | **High** | No human monitor, heaviest routine traffic, door-holding courtesy culture |
| EP-3 | Loading dock personnel door | **High** | Propped open during deliveries, possible camera blind spot (CAM-4) |
| EP-1 | Front lobby | Medium | Receptionist present, but peak-time queueing weakens badge checks |
| EP-4 | Annex entrance | Medium | Low traffic aids a waiting pretext but also increases visibility |
| EP-5 | Roof/mechanical access | Not recommended | Life-safety egress; out of scope without separate authorization |

## 4. Security Controls
- **Access control:** Badge readers at EP-1 through EP-4; EP-1 additionally has a staffed reception/visitor sign-in process during business hours.
- **CCTV:** Six fixed cameras observed/inferred (CAM-1 through CAM-6); coverage is strongest at building entrances and weakest at the Main Office/Annex gap and the loading-dock personnel door.
- **Guards:** One daytime guard, present 07:00-18:00, performing five 15-minute exterior patrols plus one 30-minute lunch break; no guard overnight or on weekends.
- **Alarms:** Not confirmed by available OSINT; assume standard intrusion alarm on exterior doors outside business hours pending confirmation.

## 5. Identified Vulnerabilities
1. **Unmonitored rear employee entrance (EP-2).** No receptionist or guard coverage; heaviest employee traffic of any entry point; typical office "hold the door" courtesy creates a predictable tailgating opportunity. *Evidence: entry-point traffic analysis, `behavior_summary.md`.*
2. **Camera blind spot at the loading-dock personnel door (EP-3/CAM-4).** The dock camera's framing, inferred from typical exterior-mount angles on a dock-facing bullet camera, likely does not cover the adjacent personnel door used during deliveries and by staff on breaks. *Evidence: `camera_map.md` CAM-4 analysis.*
3. **Guard coverage gaps concentrated around a predictable lunch break.** The 12:00-12:29 break is a fixed, repeatable 30-minute daily window with no human lobby coverage, coinciding with typical staff lunch movement, which also raises the volume of plausible "visitor" foot traffic during the same window. *Evidence: `patrol_timeline.md`.*

## 6. Recommended Attack Vectors
*(Full detail with rationale and counter-detection risk in `patrol_timeline.md`/Attack Windows below.)*
1. **Primary — EP-2 tailgate during guard lunch (12:00-12:29).** Highest combined opportunity: no guard, high routine traffic, courtesy-driven door-holding.
2. **Secondary — EP-3 personnel-door approach during a delivery window.** Leverages the CAM-4 blind spot and staff distraction with the truck/dock process.
3. **Tertiary — EP-1 pretext during morning peak (07:45-09:00).** Relies on queue pressure at reception reducing badge-to-face verification; lowest-confidence vector since a receptionist is actively present.

## 7. Risk Assessment
| Vector | Likelihood of Success | Impact if Successful | Overall Risk |
|---|---|---|---|
| EP-2 tailgate, lunch window | High | High (direct interior access, no visitor log) | **High** |
| EP-3 dock approach, delivery window | Medium-High | Medium (dock/ground-floor access; may require further movement to targets) | **High** |
| EP-1 pretext, morning peak | Medium | Medium (logged as a visitor, easier to trace/challenge later) | Medium |

Impact is scenario-relative (no named objective/target such as a data center was specified for Meridian; ratings assume general unauthorized-access impact). Adjust against the client's actual crown-jewel locations before finalizing.

## 8. Counter-Detection Incidents
No live observation was conducted for this exercise (simulated/desk-based recon only), so no counter-detection incidents occurred. For a real engagement, this section would log, per session: time, location, trigger (repeated guard glance, lingering vehicle, direct approach), the observation point abandoned, the secondary point used instead, and whether the session was terminated early. Analysts should still document a null result here explicitly ("no counter-detection indicators observed during this session") rather than omitting the section, since an auditable log of clean sessions is itself useful evidence for a later live-testing go/no-go decision.

## 9. Appendices
- **Appendix A — Site map:** see rendered campus diagram (entry points E1-E5, cameras C1-C6, observation points O1-O2).
- **Appendix B — Patrol timeline:** `patrol_timeline.md`.
- **Appendix C — OSINT sources:** `osint_summary.md`.
- **Appendix D — Entry point and camera detail:** `entry_points.md`, `camera_map.md`.
- **Appendix E — Employee behavior notes:** `behavior_summary.md`.

**Confidence note:** This report is built entirely from the fictional scenario data and general office-security patterns, not from live multi-day observation. Every "likely," "assume," and "inferred" above is a flag for validation on a real engagement before being used to plan live physical access attempts.
