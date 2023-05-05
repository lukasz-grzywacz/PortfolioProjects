show variables like "%event%";

delimiter |
create event e_daily_log_purge
on schedule
	every 5 second
		comment "purge logs that are 5 days or older"
    do
    begin
		delete from session_logs
		where DATE(ts) < curdate() - interval 5 day
	end
delimiter ;