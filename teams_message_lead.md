# Teams Message — Lead Review Request

---

Hey [Lead Name],

Before I send this out to the wider project and security team, wanted to run the findings by you first for a quick review.

**Context**
As part of the WEC to Cribl migration, I did a deep dive into the parsing side — specifically validating our DCR schema and comparing event samples between Azure Sentinel and XSIAM. Here is a summary of what came out of it.

---

**Azure / DCR Side — We are good to go**

Validated our DCR template against both Microsoft's official WindowsEvent table schema and Cribl's own reference DCR template from their GitHub. All 20 columns are correctly defined with the right types. No gaps, no mismatches.

One thing worth knowing for context — when you look at a Log Analytics export it shows 26 columns, not 20. The extra 6 are Azure platform system columns (TenantId, Type, _ResourceId, _SubscriptionId, _IsBillable, _BilledSize) that Microsoft documents as part of the table but are auto-injected by the platform at ingestion. They are not Windows event fields, they do not carry any event data, and they cannot be defined in a DCR. So the 20 we have is exactly right.

The one thing I flagged for the Cribl pipeline team is that EventData must be sent as a JSON object and not a serialized string. If it comes in as a string, all the event-specific sub-fields like SubjectUserName, CommandLine, NewProcessName etc. will be null in Sentinel. That is the most critical mapping rule for the pipeline.

References I am including in the email:
- Microsoft WindowsEvent schema: https://learn.microsoft.com/en-us/azure/azure-monitor/reference/tables/windowsevent
- Cribl official WindowsEvent DCR template (Direct): https://github.com/criblio/Cribl-Microsoft/blob/main/Azure/CustomDeploymentTemplates/DCR-Templates/SentinelNativeTables/DataCollectionRules(NoDCE)/WindowsEvent.json
- Cribl Sentinel integration guide: https://docs.cribl.io/stream/usecase-azure-sentinel/

---

**XSIAM Side — Needs a vendor call**

XSIAM is showing 48 columns for the same events where Azure shows 26. The raw event data coming in is identical in both — same EventData, same sub-fields. The difference is XSIAM's own XDM (Cortex Data Model) normalisation layer that automatically remaps Windows event fields into its standardised schema and adds enrichment on top.

For example — NewProcessName becomes process_name, CommandLine becomes process_cmd, SubjectUserName becomes user. Fields like process_md5, event_action, event_result are enriched automatically by XSIAM using its own threat intel. None of this requires any action on our side, it is just how XSIAM works.

The issue though is that several of those normalised fields are currently coming through empty even though EventData is correctly populated. This tells me the XDM parser is not firing on Cribl-sourced data the same way it did under AMA. The raw data is there but XSIAM is not mapping it to the right XDM fields yet.

I am planning to set up a call with the Palo Alto team to sort this out. Key questions for them are around what format XSIAM expects from Cribl via the custom HTTP endpoint, whether the raw XML in _raw_log is required for XDM parsing to trigger, and what the parser trigger mechanism is (collector type, dataset name, etc). Goal is to make the switch from AMA to Cribl completely transparent from XSIAM's perspective — same dataset, same field population, nothing changes on their side.

---

**Separate email going to Palo Alto as well** covering those questions so we can get answers before the vendor call.

---

**My ask:** Does this all look good to you before I send it out to the project team and internal security? Let me know if you want to change anything or if there are gaps I am missing.

Thanks

---
