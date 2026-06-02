# WindowsEvent Schema Reference

This document captures the authoritative schema references for the WindowsEvent table used in the WEC to Cribl migration.
It covers the Microsoft official schema, Cribl's reference DCR template, and how HCSC's DCR aligns with both.

---

## 1. Microsoft — Official WindowsEvent Table Schema

**Reference:** https://learn.microsoft.com/en-us/azure/azure-monitor/reference/tables/windowsevent

The WindowsEvent table in Azure Monitor / Microsoft Sentinel has the following columns defined by Microsoft.
The 20 columns below are the schema fields. Azure auto-adds a separate set of platform columns at ingestion (TenantId, SourceSystem, Type, _ResourceId, _SubscriptionId, _IsBillable, _BilledSize) — these are workspace-managed and do not need to be defined in a DCR.

| Column | Type | Description |
|---|---|---|
| Channel | string | The channel to which the event was logged |
| Computer | string | The name of the computer on which the event occurred |
| Correlation | string | Activity identifiers used to group related events together |
| EventData | dynamic | Event data parsed to dynamic type. If parsing fails this field is null and RawEventData is populated |
| EventID | int | The identifier that the provider used to identify the event |
| EventLevel | int | Contains the severity level of the event |
| EventLevelName | string | The rendered message string of the level specified in the event |
| EventOriginId | string | VM ID obtained from the Azure Instance Metadata Service (IMDS) |
| EventRecordId | string | The record number assigned to the event when it was logged |
| Keywords | string | A bitmask of the keywords defined in the event |
| ManagementGroupName | string | Additional information based on the resource type |
| Opcode | string | The opcode element defined by the SystemPropertiesType complex type |
| Provider | string | Identifies the provider that logged the event |
| RawEventData | string | The raw event XML when parsing fails. Null when parsing is successful |
| SystemProcessId | int | Identifies the process that generated the event |
| SystemThreadId | int | Identifies the thread that generated the event |
| SystemUserId | string | The ID of the user responsible for the event |
| Task | int | The task defined in the event |
| TimeGenerated | datetime | The timestamp when the event was generated on the computer |
| Version | int | Contains the version number of the event definition |

**Total schema columns: 20**

---

## 2. Cribl — Official WindowsEvent DCR Template

**Reference:** https://github.com/criblio/Cribl-Microsoft/blob/main/Azure/CustomDeploymentTemplates/DCR-Templates/SentinelNativeTables/DataCollectionRules(NoDCE)/WindowsEvent.json

Cribl maintains official DCR templates for all supported Sentinel native tables in the `criblio/Cribl-Microsoft` GitHub repository.
Their WindowsEvent template (NoDCE — Direct ingestion without a Data Collection Endpoint) defines the following:

### Stream Declaration
Cribl's template declares the same 20 columns as the Microsoft schema above under the stream name `Custom-WindowsEvent`.

### Data Flow
```
outputStream : Microsoft-WindowsEvent   (targets the native Sentinel table)
transformKql : source                   (passthrough — no filtering applied)
kind         : Direct
```

### Key Notes from Cribl Docs
- Field names in the data sent by Cribl Stream must exactly match the schema defined in the DCR. Mismatched field names result in dropped fields.
- EventData must be sent as a dynamic JSON object, not a serialized string. If sent as a string, all sub-fields inside EventData (SubjectUserName, CommandLine, NewProcessName, etc.) will be null in Sentinel.
- For full integration guide: https://docs.cribl.io/stream/usecase-azure-sentinel/
- For Sentinel destination configuration: https://docs.cribl.io/stream/destinations-sentinel/

---

## 3. HCSC DCR vs Cribl Official Template — Comparison

| Column | Cribl Type | HCSC Type | Match |
|---|---|---|---|
| Channel | string | string | Yes |
| Computer | string | string | Yes |
| Correlation | string | string | Yes |
| EventData | dynamic | dynamic | Yes |
| EventID | int | int | Yes |
| EventLevel | int | int | Yes |
| EventLevelName | string | string | Yes |
| EventOriginId | string | string | Yes |
| EventRecordId | string | string | Yes |
| Keywords | string | string | Yes |
| ManagementGroupName | string | string | Yes |
| Opcode | string | string | Yes |
| Provider | string | string | Yes |
| RawEventData | string | string | Yes |
| SystemProcessId | int | int | Yes |
| SystemThreadId | int | int | Yes |
| SystemUserId | string | string | Yes |
| Task | int | int | Yes |
| TimeGenerated | datetime | datetime | Yes |
| Version | int | int | Yes |

**Result: 20/20 columns match. Zero type mismatches.**

### Intentional differences between HCSC DCR and Cribl's template

These are HCSC customisations — not gaps:

| Property | Cribl Official | HCSC (test) | HCSC (prod) |
|---|---|---|---|
| outputStream | Microsoft-WindowsEvent (native table) | Custom-WindowsEvent_CriblTest_CL (custom test table) | Microsoft-WindowsEvent (native table) |
| transformKql | source (passthrough) | source + 14 process exclusion filters | source + 14 process exclusion filters |
| Stream name | Custom-WindowsEvent | Custom-WindowsEvent_CriblTest_CL | Custom-WindowsEvent |
| kind | Direct | Direct | Direct |

The 14 process name exclusions in the transformKql are HCSC's cost-saving filter to drop known noisy processes before ingestion (e.g. conhost.exe, WmiPrvSE.exe, svchost variants). This is applied as a second layer on top of Cribl's passthrough default.

---

## 4. Summary

- HCSC's DCR schema is fully aligned with both Microsoft's documentation and Cribl's official reference template.
- The schema requires no changes. Work remaining is on the Cribl Stream pipeline to correctly populate all 20 fields — particularly EventData as a JSON object.
- Cribl-Microsoft repo: https://github.com/criblio/Cribl-Microsoft
- Microsoft Logs Ingestion API supported tables: https://learn.microsoft.com/en-us/azure/azure-monitor/logs/logs-ingestion-api-overview#supported-tables
