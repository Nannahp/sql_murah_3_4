use ap;

-- opg6
select vendor_name, vendor_contact_last_name, vendor_contact_first_name from vendors;

select vendor_name, vendor_contact_last_name, vendor_contact_first_name 
from vendors order by vendor_contact_last_name, vendor_contact_first_name;

-- opg 7
select concat(vendor_contact_last_name, ", ", vendor_contact_first_name) as full_name 
from vendors order by vendor_contact_last_name, vendor_contact_first_name;

select * from vendors where vendor_contact_last_name like ('%A')
 OR vendor_contact_last_name LIKE  ('%B') 
 OR vendor_contact_last_name LIKE ('%C') 
 OR vendor_contact_last_name LIKE  ('%E');

-- opg 8
select invoice_due_date, 
invoice_total , 
(invoice_total*0.1) as '10% of total', 
(invoice_total*0.1 + invoice_total) as ' total+10%' 
from invoices where invoice_total BETWEEN 500 and 1000 order by invoice_due_date DESC ;  

-- opg 9 

select invoice_number,
		invoice_total,
		(payment_total + credit_total) as 'payment_credit_total',
        (invoice_total - payment_total - credit_total) as 'balance_due'
from invoices;
        
        
select 
 invoice_number,
 invoice_total, 
 (payment_total + credit_total) as 'payment_credit_total',
 (invoice_total - payment_total - credit_total) as 'balance_due' 
 from invoices
 where  (invoice_total - payment_total - credit_total)>50 
 order by (invoice_total - payment_total - credit_total) DESC limit 5;

-- self-note: same but chatgpt. How to use alias names 
WITH invoice_summary AS (
    SELECT 
        invoice_number, 
        invoice_total, 
        (payment_total + credit_total) AS payment_credit_total, 
        (invoice_total - payment_total - credit_total) AS balance_due 
    FROM invoices
)
SELECT 
    invoice_number, 
    invoice_total, 
    payment_credit_total, 
    balance_due 
FROM invoice_summary
WHERE balance_due > 50 
ORDER BY balance_due DESC 
LIMIT 5;


-- opg 10
with invoice_summary as(
select  invoice_number,
		invoice_date,
        (invoice_total - payment_total - credit_total) as balance_due,
        payment_date
	from invoices
    )
    
SELECT 
	invoice_number,
    invoice_date,
    balance_due,
    payment_date
from invoice_summary
where payment_date is NULL;
    
-- opg 11

select curdate();
SELECT DATE_FORMAT(curdate(),"%m %d %Y") as 'current_date';

-- opg 12 taget fra løsningerne
select 50000 as starting_principle,
       50000 * .065 as interest,
       (50000) + (50000 * .065) as principle_plus_interest;


-- ---------------- OPG 4 -----------------------
-- opg 1
select  * from  vendors
 join invoices on vendors.vendor_id = invoices.vendor_id;

-- opg 2
select vendor_name, 
		invoice_number, 
		invoice_date, 
		(invoice_total - payment_total - credit_total) as 'balance_due' 
	from vendors 
	join invoices on vendors.vendor_id = invoices.vendor_id
	where (invoice_total - payment_total - credit_total) != 0;

-- opg 3

select
	vendor_name,
    default_account_number as 'default_account',
    account_description as 'description' 
    
    from vendors v join general_ledger_accounts g
		on v.default_account_number = g.account_number
        order by account_description, vendor_name;

-- opg 4

select
	vendor_name,
    invoice_date, 
    invoice_number,
    invoice_sequence as 'li_sequence', 
    line_item_amount as 'li_amount'
    from  vendors v join invoices i join invoice_line_items ili
		on v.vendor_id = i.vendor_id and i.invoice_id = ili.invoice_id
        order by vendor_name, invoice_date, invoice_number, invoice_sequence;
        
-- opg 5 taget inspiration fra løsningerne
select v1.vendor_id, -- need to differentiate because it's a self-join
       v1.vendor_name,
       concat(v1.vendor_contact_first_name, ' ', v1.vendor_contact_last_name) as 'contact_name'
from vendors v1 join vendors v2
    on v1.vendor_id != v2.vendor_id and v1.vendor_contact_last_name = v2.vendor_contact_last_name  
	order by v1.vendor_contact_last_name;
    
-- opg 6
    select
		gla.account_number, -- why does it need to be specified gla.?
        account_description,
        invoice_id
	-- asked to use "outer join", tried with cross join, did not work. 
	from general_ledger_accounts gla  left join invoice_line_items ils
    on gla.account_number = ils.account_number
    where ils.invoice_id is NULL 
    order by gla.account_number;
    -- remove?
    
    -- opg 7
    
  select 
	vendor_name,
	vendor_state
    from vendors where vendor_state like "%CA"
    union
select vendor_name, 'Outside CA' -- self note: insert "oustide ca" intead of state-coloumn-data if state is not ca. 
from vendors where vendor_state != 'CA'
order by vendor_name;

    

