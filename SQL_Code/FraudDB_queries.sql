-- 1. How can you isolate (or group) the transactions of each cardholder? 
-- Create an associated VIEW named cardholder_transactions.
SELECT ch.id, ch.name, cc.card, t.date, t.amount AS "amount", m.name AS "merchant", mc.name AS "category"
FROM card_holder ch
	LEFT JOIN credit_card cc
	ON ch.id = cc.cardholder_id
		LEFT JOIN transaction t
		ON cc.card = t.card
			RIGHT JOIN merchant m
			ON t.id_merchant = m.id
				RIGHT JOIN merchant_category mc
				ON m.id_merchant_category = mc.id
GROUP BY ch.id, ch.name, cc.card, t.date, t.amount, m.name, mc.name
ORDER BY ch.id;

-- 2. Count the transactions that are less than $2.00 per cardholder. Create an associated VIEW named microtransactions 
-- for transactions under $2.
SELECT COUNT(t.amount) AS "Microtransactions– Under $2.00"
FROM transaction AS t
WHERE t.amount <= 2.00;

SELECT *
FROM transaction AS t
WHERE t.amount <= 2.00
ORDER BY t.card, t.amount DESC;

-- 3. What are the top 100 highest transactions made between 7:00 am and 9:00 am?
SELECT *
FROM transaction AS t
WHERE date_part('hour', t.date) >= 7 AND date_part('hour', t.date) <= 9
ORDER BY amount DESC
LIMIT 100;


-- 4. Top 5 merchants prone to being hacked using small transactions
SELECT m.name AS merchant, mc.name AS category, COUNT(t.amount) as vulnerable_merchants
FROM transaction as t
	JOIN merchant AS m ON m.id = t.id_merchant
		JOIN merchant_category AS mc ON mc.id = m.id_merchant_category
		WHERE t.amount <= 2.00
GROUP BY m.name, mc.name
ORDER BY vulnerable_merchants DESC
LIMIT 5;


-- FRAUD DETECTION VIEWS
CREATE VIEW cardholder_transactions AS
SELECT ch.id, ch.name, cc.card, t.date, t.amount AS "amount", m.name AS "merchant", mc.name AS "category"
FROM card_holder ch
	LEFT JOIN credit_card cc
	ON ch.id = cc.cardholder_id
		LEFT JOIN transaction t
		ON cc.card = t.card
			RIGHT JOIN merchant m
			ON t.id_merchant = m.id
				RIGHT JOIN merchant_category mc
				ON m.id_merchant_category = mc.id
GROUP BY ch.id, ch.name, cc.card, t.date, t.amount, m.name, mc.name
ORDER BY ch.id;

CREATE VIEW microtransactions AS
SELECT *
FROM transaction AS t
WHERE t.amount <= 2.00
ORDER BY t.card, t.amount DESC;

CREATE VIEW top_morning_transactions AS
SELECT *
FROM transaction AS t
WHERE date_part('hour', t.date) >= 7 AND date_part('hour', t.date) <= 9
ORDER BY amount DESC
LIMIT 100;

CREATE VIEW most_vulnerable_merchants AS 
SELECT m.name AS merchant, mc.name AS category, COUNT(t.amount) as vulnerable_merchants
FROM transaction as t
	JOIN merchant AS m ON m.id = t.id_merchant
		JOIN merchant_category AS mc ON mc.id = m.id_merchant_category
		WHERE t.amount <= 2.00
GROUP BY m.name, mc.name
ORDER BY vulnerable_merchants DESC
LIMIT 5;

