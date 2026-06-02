# Email Draft — WEC to Cribl Migration: Parsing Findings

---

**To:** Project Team | IS Security Engineering  
**From:** Raj Arsh, IS Security Engineering  
**Subject:** WEC → Cribl Migration — Parsing Findings & Path Forward

---

Hi all,

Quick update on the parsing validation for the Cribl migration. I've reviewed event samples from both destinations — Azure Sentinel (DCR) and Cortex XSIAM — and here's where we stand.

---

**Azure/DCR — Good to Move Forward**

I validated our DCR template against the official Microsoft WindowsEvent schema. Before I get to the result, I want to address something that might look confusing at first — when you export events from the WindowsEvent table in Log Analytics, you'll see **26 columns**. But our DCR only defines **20 columns**. Here's exactly why and where those 6 extra columns come from.

**The 20 columns in our DCR** are the actual Windows event schema fields — the fields that carry real event data and that Cribl is responsible for populating:

| Column | Type | Description |
|---|---|---|
| Channel | string | Event log channel (e.g. Security, System) |
| Computer | string | Hostname where the event occurred |
| Correlation | string | Activity ID used to correlate related events |
| EventData | dynamic | All event-specific sub-fields as a JSON object (varies per EventID) |
| EventID | int | The Windows event identifier |
| EventLevel | int | Severity level (1=Critical, 2=Error, 3=Warning, 4=Info) |
| EventLevelName | string | Human-readable level (e.g. "Information") |
| EventOriginId | string | VM ID from Azure Instance Metadata Service |
| EventRecordId | string | Sequential record number assigned when the event was logged |
| Keywords | string | Bitmask identifying the event category (e.g. Audit Success) |
| ManagementGroupName | string | Resource group context |
| Opcode | string | Operational phase when the event was logged |
| Provider | string | The Windows component that generated the event |
| RawEventData | string | Raw event XML — populated only when EventData parsing fails |
| SystemProcessId | int | PID of the process that generated the event |
| SystemThreadId | int | Thread ID of the process that generated the event |
| SystemUse