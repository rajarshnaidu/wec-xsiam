// ============================================================
// Cortex XSIAM — microsoft_windows_raw Sample Query
// Purpose: Extract one representative event per event_id
//          INCLUDING all event-specific sub-fields for
//          Cribl Stream pipeline/parsing reference
// Dataset: microsoft_windows_raw
// ============================================================
// Instructions:
//   1. Open XSIAM > Investigation > Query Builder (XQL)
//   2. Run the schema discovery query first (Query A below)
//      to confirm field names in your dataset
//   3. Then run Query B to get full per-event_id samples
//   4. Export results as CSV → xsiam_windows_raw_samples.csv
// ============================================================


// ── Query A: Schema discovery (run this first) ──────────────
// Confirms top-level field names and the structure of the
// event-specific data field in your dataset.

dataset = microsoft_windows_raw
| limit 5
| fields *


// ============================================================
// ── Query B: One sample per event_id with all sub-fields ───
// ============================================================
// XQL does not have a native bag_keys() equivalent, so we:
//   1. dedup on event_id to get one sample per event type
//   2. Pull every top-level field (fields *)
//   3. Explicitly serialize the nested event-data fields to
//      JSON strings so the parsing team can see all sub-keys
//      and values for each event_id.
//
// NOTE: Replace field names below with actual names from Query A
//       if they differ (run Query A first to verify).
// ========================================================