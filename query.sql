WITH candidate_address AS (
    SELECT DISTINCT "from" AS "from_raw"
    FROM ethereum."transactions"
    WHERE "to" = '\x3666f603Cc164936C1b87e207F36BEBa4AC5f18a' -- Hop Protocol: USDC Bridge (on Ethereum)
        AND "block_time" < now() - interval '37 days'
        AND "block_time" > now() - interval '6 months'        -- Too long time interval is difficult for Dune Analytic...
), candidate_sybil_transfer AS ( 
    SELECT "from", "to", "block_time", "hash"
    FROM ethereum."transactions" e RIGHT JOIN candidate_address c2
    ON e."to" = c2."from_raw"
    WHERE "block_time" < now() - interval '37 days'
)
SELECT *
FROM candidate_sybil_transfer                                 -- Note: this is only part of the statistical data, not the full version. Because the time range are limited, and the addresses are only those who interactived with "Hop USDC Bridge".
WHERE "from" != "to"