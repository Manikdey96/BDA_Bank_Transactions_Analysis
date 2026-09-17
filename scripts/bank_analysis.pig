records = LOAD '/user/data/bank_transactions_dataset.csv' USING PigStorage(',')
    AS (transaction_id:int, account_id:int, customer_name:chararray, transaction_type:chararray,
        amount:float, transaction_date:chararray, branch:chararray, city:chararray,
        balance_after:float, customer_age:int, account_type:chararray);

clean = FILTER records BY transaction_id IS NOT NULL AND transaction_id > 0;

row_count = FOREACH (GROUP clean ALL) GENERATE COUNT(clean) AS total_rows;
DUMP row_count;

by_city = GROUP clean BY city;
result1 = FOREACH by_city GENERATE group AS city, SUM(clean.amount) AS total_amount, COUNT(clean) AS txn_count;
result1 = ORDER result1 BY total_amount DESC;
DUMP result1;
STORE result1 INTO '/user/output/pig1_city_total' USING PigStorage(',');

by_type = GROUP clean BY transaction_type;
result2 = FOREACH by_type GENERATE group AS txn_type, COUNT(clean) AS txn_count;
DUMP result2;
STORE result2 INTO '/user/output/pig2_type_count' USING PigStorage(',');

by_account = GROUP clean BY account_type;
result3 = FOREACH by_account GENERATE group AS account_type, AVG(clean.balance_after) AS avg_balance, COUNT(clean) AS txn_count;
DUMP result3;
STORE result3 INTO '/user/output/pig3_avg_balance' USING PigStorage(',');

by_branch = GROUP clean BY branch;
total_by_branch = FOREACH by_branch GENERATE group AS branch, SUM(clean.amount) AS total_amount;
ordered_branch = ORDER total_by_branch BY total_amount DESC;
result4 = LIMIT ordered_branch 5;
DUMP result4;
STORE result4 INTO '/user/output/pig4_top5_branch' USING PigStorage(',');

big_withdrawals = FILTER clean BY (transaction_type == 'Withdrawal' OR transaction_type == 'ATM Withdrawal') AND amount > 50000;
by_city_big = GROUP big_withdrawals BY city;
summary_big = FOREACH by_city_big GENERATE group AS city, COUNT(big_withdrawals) AS big_txn_count, SUM(big_withdrawals.amount) AS total_big_amount;
result5 = ORDER summary_big BY total_big_amount DESC;
DUMP result5;
STORE result5 INTO '/user/output/pig5_big_withdrawals' USING PigStorage(',');