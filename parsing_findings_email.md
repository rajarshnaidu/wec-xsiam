# Email Draft — WEC to Cribl Migration: Parsing Findings

---

**To:** Project Team | IS Security Engineering  
**From:** Raj Arsh, IS Security Engineering  
**Subject:** WEC → Cribl Migration — Parsing Findings & Path Forward

---

Hi all,

Quick update on the parsing validation for the Cribl migration. I've reviewed event samples from both destinations — Azure Sentinel (DCR) and Cortex XSIAM — and here's where we stand.

**Azure/DCR — Good to Move Forward**

I validated our DCR template against the official Microsoft WindowsEvent schema and all 20 columns are correctly defined with the right types — nothing missing, no mismatches. Azure auto-adds a few system columns (TenantId, _ResourceId, etc.) at ingestion so those don't need to be in the DCR.

One thing worth flagging for the Cribl pipeline team: `EventData` must be sent as a JSON object, not a string. If it's serialized as a string, all event-specific sub-fields (SubjectUserName, CommandLine, NewProcessName, etc.) will show up as null in Sentinel.

📎 Reference: https://learn.microsoft.com/en-us/azure/azure-monitor/reference/tables/windowsevent

**XSIAM — Vendor Call Needed**

XSIAM shows more columns than Azure (48 vs 26) for the same events. This isn't a data problem — the raw EventData content is identical in both. The extra columns are XSIAM's own XDM (Cortex Data Model) normalisation layer remapping Windows fields into its standardised schema (e.g. NewProcessName → process_name, CommandLine → process_cmd) plus enrichment fields like process_md5 and event_result that XSIAM derives automatically.

What I'd like to get clarity on is why some of those normalised fields are showing empty in current samples. I'd suggest we schedule a call with Palo Alto to confirm the Cribl → XSIAM field mapping is wired up correctly and that the XDM parsing is fully configured on their end.

**Next Steps**
- DCR/Sentinel path: proceed with Cribl pipeline configuration as planned
- XSIAM: set up a call with Palo Alto vendor to review XDM field mapping and confirm expected ingestion format from Cribl Stream

Let me know if anyone has questions or wants to jump on a call to walk through this.

Thanks,  
Raj Arsh  
IS Security Engineering

---
