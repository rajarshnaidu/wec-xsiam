// ============================================================
// Cortex XSIAM — microsoft_windows_raw Sample Query
// Purpose: One sample per event_id (last 2 days) with ALL
//          event-specific sub-fields expanded
// Dataset: microsoft_windows_raw
// ============================================================
// Instructions:
//   1. Run Query A first to confirm field names + EventData structure
//   2. Run Query B to get the full per-event_id samples
//   3. Export as CSV → xsiam_windows_raw_samples.csv
// ============================================================


// ── Query A: Schema + EventData structure discovery ─────────
// Run this first. Look at:
//   - The actual field names in your dataset
//   - Whether action_evtlog_data is a JSON object or flat string
//   - What raw_log looks like

dataset = microsoft_windows_raw
| limit 3
| fields *


// ── Query B: One sample per event_id, all sub-fields expanded ──
// XQL does not have bag_unpack, so we use json_extract_scalar
// to pull individual known fields out of action_evtlog_data.
//
// IMPORTANT: The json_extract_scalar lines below cover common
// Windows Security event fields. After running Query A, add any
// additional fields you see in your action_evtlog_data that
// aren't listed here.

dataset = microsoft_windows_raw
| filter _time >= to_epoch(subtract(now(), 172800000), "millis")  // last 2 days
| dedup event_id

// ── Standard columns ──
| fields
    event_id,
    _time,
    agent_hostname,
    agent_ip_addresses,
    action_evtlog_channel,
    action_evtlog_provider_name,
    action_evtlog_level,
    action_evtlog_task,
    action_evtlog_keywords,
    action_evtlog_ver