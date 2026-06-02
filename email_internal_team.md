# Email 1 — Internal Team & Project Team

---

**To:** Project Team | IS Security Engineering  
**From:** Raj Arsh, IS Security Engineering  
**Subject:** WEC → Cribl Migration — Parsing Findings & Path Forward

---

Hi all,

Wanted to share an update on the parsing validation work for the Cribl migration. I've reviewed event samples flowing through both destinations — Azure Sentinel (via DCR) and Cortex XSIAM — and compared them against the official schema references. Here's a clear picture of where we stand and what's left to sort out.

---

**Azure / DCR Side — Ready to Move Forward**

I validated our DCR template against the official Microsoft WindowsEvent table schema and everything checks out — all 20 columns are correctly defined with the right types. Nothing is missing.

One thing worth clarifying since it comes up when you look at the Log Analytics export: when you pull events from the WindowsEvent table, you'll see **26 columns** — but our DCR only defines **20**. Here's why:

The **20 DCR columns** are the actual Windows event fields that carry event data and that Cribl is responsible for populating — things like Channel, Computer, EventID, EventData, Provider, SystemProcessId, CommandLine context via EventData, etc. These are the fields Microsoft documents as part of the WindowsEvent schema.

The **remaining 6 columns** in the export break down as follows:

- **4 are auto-injected by the Azure platform** at ingestion and require zero action from us: `TenantId`, `SourceSystem`, `Type`, and `_ResourceId`. These are workspace/platform identifiers that Log Analytics adds automatically — they're not Windows event fields and don't belong in the DCR.

- **2 are native table columns currently not populated in our pipeline:**
  - `Data` — exists for generic unnamed data elements in some Windows events. Empty across all our current samples, so not relevant to our event set today.
  - `TimeCreated` — the original event creation timestamp from the Windows event XML. Currently empty because Cribl isn't mapping this field. Worth noting: `TimeGenerated` (which we do populate) reflects ingestion time, not the actual event time. If forensic-accurate timestamps become a requirement down the road, this is the field to map.

So in summary — the DCR schema is complete and validated against Microsoft's documentation. No changes needed.

📎 Microsoft WindowsEvent Schema Reference: https://learn.microsoft.com/en-us/azure/azure-monitor/reference/tables/windowsevent

One critical note for the **Cribl pipeline team**: `EventData` must be sent as a proper JSON object — not a serialized string. All event-specific sub-fields (SubjectUserName, CommandLine, NewProcessName, LogonType, etc.) live inside EventData and they'll come through as null in Sentinel if it's sent as a string instead of a JSON object.

---

**XSIAM Side — Vendor Discussion Needed**

When comparing the same events between Azure and XSIAM, Azure shows 26 columns and XSIAM shows 48. The underlying event data is identical in both — the raw `EventData` JSON with all sub-fields is the same. The difference is that XSIAM runs its own **XDM (Cortex Data Model) normalisation** on top of every incoming event, which automatically remaps Windows event fields into XSIAM's standardised schema and adds enrichment fields:

- `NewProcessName` → `process_name`
- `CommandLine` → `process_cmd`
- `SubjectUserName` → `user`
- `event_action`, `event_result`, `process_md5`, `process_sha256` — derived/enriched by XSIAM automatically

This is expected behaviour and not a data problem. However, in our current samples several of those normalised fields are coming through **empty** — meaning the XDM parsing isn't fully firing on data coming from Cribl the way it did from AMA. The raw event data is arriving correctly but XSIAM isn't mapping it into the right XDM fields.

We're setting up a call with Palo Alto to dig into this — specifically to understand what format XSIAM expects from Cribl so the existing XDM parsing and field population continues to work the same way it did under AMA. The goal is continuity — not re-engineering anything on the XSIAM side.

---

**Next Steps**

- **DCR/Sentinel path:** proceed with Cribl pipeline configuration as planned — schema is validated and ready
- **XSIAM:** call with Palo Alto in the works — will share outcome once we have clarity on the format requirements

Let me know if you have any questions in the meantime.

Thanks,  
Raj Arsh  
IS Security Engineering

---
