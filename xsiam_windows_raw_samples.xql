// ============================================================
// Cortex XSIAM — microsoft_windows_raw Sample Query
// Purpose: Extract one representative event per event_id
//          for Cribl Stream pipeline/parsing reference
// Dataset: microsoft_windows_raw
// ============================================================
// Instructions:
//   1. Open XSIAM > Investigation > Query Builder (XQL)
//   2. Paste this query and run it
//   3. Export results as CSV
//   4. Save as: xsiam_windows_raw_samples.csv
// ============================================================

// Step 1: Get all distinct event_ids with their latest event
dataset = microsoft_windows_raw
| filter _time >= to_epoch(subtract(now(), 2592000000), "millis")  // last 30 days
| dedup event_id
| fields
    event_id,
    _time,
    agent_hostname,
    agent_ip_addresses,
    actor_process_image_name,
    actor_process_image_path,
    actor_process_command_line,
    actor_process_os_pid,
    actor_primary_username,
    action_evtlog_channel,
    action_evtlog_provider_name,
    action_evtlog_level,
    action_evtlog_task,
    action_evtlog_keywords,
    action_evtlog_version,
    action_evtlog_opcode,
    action_evtlog_message,
    action_evtlog_data,         // raw EventData — key for parsing
    raw_log                     // full raw event — include for reference
| sort asc event_id

// ============================================================
// NOTE: If field names above differ in your dataset, run this
// first to discover actual schema:
//
// dataset = microsoft_windows_raw | limit 1 | fields *
//
// Then adjust the fields list above to match.
// ============================================================
