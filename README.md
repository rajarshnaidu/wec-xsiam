# wec-xsiam

WEC to Cribl Edge/Stream migration — event sample queries, schema reference, and project communications.

## Repository Structure

```
wec-xsiam/
├── queries/
│   ├── azure_windowsevent_samples.kql   # KQL query — one sample per EventID from WindowsEvent table (last 2 days)
│   ├── xsiam_windows_raw_samples.xql    # XQL query — one sample per event_id from microsoft_windows_raw (last 2 days)
│   └── process_event_samples.py         # Python script — combines Azure + XSIAM CSV exports into Excel
├── samples/
│   ├── query_data_azure.csv             # Azure WindowsEvent sample export
│   └── XQL-QUERY-406103-2026_06_02.tsv  # XSIAM microsoft_windows_raw sample export
├── docs/
│   └── schema_reference.md              # WindowsEvent schema — Microsoft docs + Cribl official template comparison
└── emails/
    ├── email_internal_team.docx          # Internal team parsing findings update
    └── email_palo_alto.docx              # Palo Alto vendor — XSIAM parsing questions
```

## References

- [Microsoft WindowsEvent Table Schema](https://learn.microsoft.com/en-us/azure/azure-monitor/reference/tables/windowsevent)
- [Cribl Microsoft Sentinel Integration](https://docs.cribl.io/stream/usecase-azure-sentinel/)
- [Cribl-Microsoft GitHub — Official DCR Templates](https://github.com/criblio/Cribl-Microsoft)
