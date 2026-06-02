# Email 2 — Palo Alto / XSIAM Vendor

---

**To:** Palo Alto XSIAM Support / TAM  
**From:** Raj Arsh, IS Security Engineering — HCSC  
**Subject:** XSIAM Parsing Query — Windows Event Ingestion via Cribl Stream (Custom HTTP Endpoint)

---

Hi [TAM/Support Name],

We're currently in the process of migrating our Windows Event Collection (WEC) infrastructure from the Azure Monitoring Agent (AMA) to Cribl Edge + Cribl Stream. As part of this migration, Cribl Stream is configured to forward Windows events to XSIAM via a custom HTTP endpoint, landing in our `microsoft_windows_raw` dataset.

We're seeing an issue with field population and wanted to get your guidance before we go further.

---

**What We're Seeing**

Under our current AMA-based pipeline, the `microsoft_windows_raw` dataset is fully populated — XDM-normalised fields like `process_name`, `process_cmd`, `user`, `process_path`, `event_action`, and `event_result` are all coming through correctly.

After switching the data path to Cribl Stream → XSIAM custom HTTP endpoint, the raw event data is arriving correctly — `event_data` contains all the expected sub-fields (SubjectUserName, CommandLine, NewProcessName, etc.) — but the XDM-normalised fields are coming through **empty**. The data is there but XSIAM isn't mapping it into the right XDM fields the way it did under AMA.

---

**Our Questions**

1. **Expected ingestion format** — What format does XSIAM's parser expect when receiving Windows events via the custom HTTP endpoint for the `microsoft_windows_raw` dataset? AMA was likely sending raw Windows event XML. Cribl can send either XML or JSON. Does the format matter for XDM parsing to work correctly?

2. **`_raw_log` dependency** — Is the full raw event XML in `_raw_log` required for XSIAM's XDM normalisation to fire, or can XSIAM parse from the `event_data` JSON object alone? Currently `_raw_log` is populated but we want to confirm this is what's driving the XDM mapping.

3. **Parser trigger mechanism** — What determines which parsing pipeline XSIAM applies to incoming events? Is it the `_collector_type` field (currently showing as "WEC" in our samples), the dataset name, or something else? If Cribl identifies itself differently from AMA, could that cause the XDM rules to not apply?

4. **Empty XDM fields** — Given that `event_data` is correctly populated with all sub-fields, why would `process_name`, `process_cmd`, `user` etc. be empty? Is this a known behaviour when the data source changes, and is there a configuration step needed on the XSIAM side to point the XDM parser at the new source?

5. **Recommended approach for third-party forwarders** — Is there a recommended configuration or documented approach for sending Windows events from a third-party forwarder like Cribl Stream to XSIAM via custom HTTP endpoint while preserving full XDM field population?

6. **`_raw_json` field** — This field is empty in our current samples. Should Cribl be populating this, and if so, what format is expected?

---

**Our Goal**

We want the transition from AMA to Cribl to be transparent from XSIAM's perspective — same dataset, same field population, same XDM coverage. We're not looking to change anything on the XSIAM side; we just need to know what Cribl needs to send to make the existing parsing continue to work as-is.

Would it be possible to schedule a call to walk through this together? Happy to share sample event payloads from both the old AMA path and the current Cribl path to help diagnose the difference.

Thanks in advance for your help on this.

Best,  
Raj Arsh  
IS Security Engineering — HCSC

---
