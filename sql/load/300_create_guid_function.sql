

SELECT
  ctl.fn_deterministic_guid('account','1') AS guid1,
  ctl.fn_deterministic_guid('account','1') AS guid1_repeat,
  ctl.fn_deterministic_guid('account','2') AS guid2;
