# Scope Definition Document (T1)
**Client:** Nextera Financial Group ("Client") | **Tester:** [Firm Name] ("Tester")
**Engagement ID:** NFG-PHYS-2026-01 | **Version:** 1.0 DRAFT | **Prepared:** 23 Oct 2026
**Assumed jurisdiction:** Grand Duchy of Luxembourg (time zone CET/CEST). Change if the sites are elsewhere.

> Items in [BRACKETS] are client-specific facts to be confirmed before signature.

---
## 1. Objectives
1. Assess whether an unauthorized person can gain physical access to Client premises, particularly the HQ ground-floor data center.
2. Test effectiveness of guards, badge controls, visitor management, and employee challenge behavior.
3. Test the satellite office, which has no guard, for tailgating, door hardware, and after-hours exposure.
4. Deliver prioritized, evidence-based remediation guidance.

**Success criteria:** Documented attempts and outcomes per target (see section 4). Reaching a target is a finding, not a mandate to "win" at any cost; safety limits in the ROE override objectives.

## 2. Locations
| | **Site A: HQ** | **Site B: Satellite Office** |
|---|---|---|
| Address | [HQ address] | [Business park address, unit no.] |
| Occupancy | 3 floors, ~150 employees | ~25 employees |
| Security | 24/7 guard, badge access | No guard |
| Special areas | Ground-floor data center (badge) | Shared business park |
| Building owner/landlord | [Client-owned or lessor] | [Landlord name] |
| Business hours | Mon-Fri 07:00-19:00 | Mon-Fri 07:00-19:00 |

## 3. Time Windows
| Site | Daytime window | After-hours window | Notes |
|---|---|---|---|
| HQ | Mon-Fri 07:00-19:00 | Mon-Fri 19:00-23:00 only, **two testers minimum**, guard-on-duty stays unaware | No tests 23:00-05:00 or on weekends unless amended in writing |
| Satellite | Mon-Fri 07:00-19:00 | **Not permitted** unless landlord consent explicitly covers it | Alarm/police response risk is higher with no guard |

Proposed engagement dates: [start] to [end] (max 5 business days). No testing on public holidays (Luxembourg) or during known client critical events [list].

## 4. In-Scope Activities
**Both sites:** Open-source reconnaissance; observation from public areas; tailgating/piggybacking; pretexting with client-approved pretexts; badge/credential cloning using client-provided badge samples or authorized readers; testing exit-request and door-latch bypass (non-destructive); lock bypass of **client-owned** doors listed in Annex A (non-destructive, no drilling/cutting); dumpster review of client-owned bins on client property; photographing of findings (no faces of employees, see Section 7); planting client-approved "proof" tokens (marked cards, no device that connects to client networks unless authorized separately).

**HQ only:** Attempts to reach the data center door and to enter the data center. Entry is permitted **only** with prior sign-off from the Client Sponsor and data-center operations lead [name], since tester presence in a data center may breach client and customer certifications.

**Satellite only:** Testing of reception, meeting rooms, server/comms closet **owned by the Client**.

## 5. Out-of-Scope Activities
- Violence, threats, restraining anyone, or running from guards/police
- Damaging property, forced entry (cutting, drilling, breaking glass), disabling alarms/CCTV
- Impersonating police, emergency services, or any public authority; wearing police-style uniforms
- Weapons of any kind
- Accessing, copying, or removing client data, assets, or hardware beyond approved proof tokens
- Network/Wi-Fi attacks (separate engagement) unless the ROE is amended in writing
- Testing of family members/home addresses of employees; personal social media
- Any activity that would put a tester at risk of being mistaken for an armed intruder
- Recording audio of conversations (see Legal Checklist; photo/video only if approved)

## 6. Tenant Exclusions: Shared Business Park (Site B)
**All spaces not leased by Nextera Financial Group are out of scope.** This includes without limitation: other tenants' suites, shared meeting rooms or reception not covered by landlord consent, shared storage, building-management offices, technical rooms, rooftops, parking areas other than as listed, and neighboring buildings.

Rules:
1. Testers must not enter, attempt to enter, tailgate into, or photograph any non-client tenant space.
2. If a route to a Client target passes through a common area (corridor, lift, entrance lobby), use is permitted **only** if the landlord consent letter names that common area.
3. If a tester finds themselves in a non-client space by mistake, they leave immediately, do not touch anything, and notify the handler, who informs the Client Sponsor.
4. Other tenants and their staff are **not** to be pretexted.

## 7. Landlord Consent Status (Site B)
| Item | Status |
|---|---|
| Landlord | [Name, company, contact] |
| Consent requested | [date] by [Client Sponsor] |
| Consent received | **[PENDING / RECEIVED: delete one]** |
| Consent letter ref. | [attached as Annex B] |
| Covers: common areas named | [list] |
| Covers: after-hours | [Yes/No] |
| Covers: park security/CCTV operator informed | [Yes/No] |

**Gate:** No testing at Site B starts until written landlord consent is received and Annex B is signed. If consent is not received, Site B is **removed from scope** and the engagement proceeds at HQ only. Landlord and building security operator should hold the Tester's emergency contact.

## 8. Data Handling and Privacy
Photos exclude employees' faces where possible; any incidental personal data is minimized, stored encrypted, and deleted [30] days after report acceptance (GDPR; see Legal Checklist).

## 9. Annex A: Approved Targets and Doors
| ID | Site | Location/door | Permitted technique | Notes |
|---|---|---|---|---|
| A1 | HQ | Main entrance turnstiles | Tailgating, pretext | |
| A2 | HQ | Data center door | Per Section 4 sign-off | Sponsor sign-off required |
| B1 | Satellite | Unit entrance | Tailgating, pretext, bypass | Client unit only |
*(Complete with client during kickoff.)*

## 10. Approvals
| Role | Name | Signature | Date |
|---|---|---|---|
| Client Sponsor (authorized officer) | | | |
| Tester Engagement Lead | | | |
| Landlord (Site B annex) | | | |
