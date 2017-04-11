-- gift date conversion

-- Query 1: total gifts by year and fund. sorted by year, then fund ID. Return the year, fund ID, fund name, and total
-- gifts.
SELECT date(gift_date,'start of year') as year, fund_id, fund_name, sum(amount) AS total_gifts
From fund
  JOIN gift_fund_allocation USING (fund_id)
  JOIN gift USING (gift_id)
GROUP BY year, fund_id, fund_name
ORDER BY gift_date, fund_ID;


-- Query 2: Top donors list: 10 donors with the highest lifetime contributions across all funds.  Return their donor ID,
-- name, and total gifts.
SELECT donor_id, donor_name, coalesce(sum(amount),0) AS lifetime_contributions
From donor
JOIN gift using (donor_id)
JOIN gift_fund_allocation using (gift_id)
GROUP BY donor_id, donor_name
ORDER BY sum(amount) desc
limit 10;


-- Query 3: For 2013, donors to the 'Veterinary Assistance' fund with their total contributions to that fund for the
-- year. List donor ID, name, and funds contributed in 2013.

SELECT donor_id, donor_name, coalesce(sum(amount), 0)
FROM donor
JOIN gift USING (donor_id)
JOIN gift_fund_allocation USING (gift_id)
JOIN fund USING (fund_id)
WHERE fund_name = 'Veterinary Assistance'
  AND DATE (gift_date, 'start of year') = '2013-01-01'
GROUP BY donor_id, donor_name
ORDER BY sum(amount) DESC;


-- Query 4: The donors who have donated at least $10,000 since January 1, 2012. (with no duplicates)

SELECT DISTINCT donor_name
FROM donor
JOIN gift USING (donor_id)
JOIN gift_fund_allocation USING (gift_id)
WHERE DATE (gift_date, 'start of year') >= '2012-01-01'
GROUP BY donor_name
HAVING sum(amount) >= 10000;


-- Query 5: The names and e-mail addresses of all donors who contributed in the year 2012. (with no duplicates)

SELECT DISTINCT donor_name, donor_email
From donor
JOIN gift USING (donor_id)
WHERE DATE (gift_date, 'start of year') = '2012-01-01'
GROUP BY donor_name;

